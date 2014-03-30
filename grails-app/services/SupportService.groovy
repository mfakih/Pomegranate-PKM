import app.IndexCard
import app.Indicator
import app.IndicatorData
import app.Tag
import app.parameters.Blog
import cmn.Setting
import com.amazon.advertising.api.sample.SignedRequestsHelper
import com.itextpdf.text.pdf.PdfReader
import com.itextpdf.text.pdf.PdfStamper
import com.itextpdf.text.xml.xmp.XmpWriter
import ker.OperationController
import mcs.Book
import mcs.Course
import mcs.Goal
import mcs.Writing
import mcs.parameters.ResourceStatus
import mcs.parameters.WritingType
import net.bican.wordpress.CustomField
import net.bican.wordpress.Page
import net.bican.wordpress.Wordpress
import org.apache.commons.logging.LogFactory
import org.w3c.dom.Document
import org.w3c.dom.Node
import redstone.xmlrpc.XmlRpcArray

import javax.xml.parsers.DocumentBuilder
import javax.xml.parsers.DocumentBuilderFactory
import java.text.DecimalFormat
import java.text.NumberFormat

class SupportService {

    boolean transactional = false
    def grailsApplication

    private static final log = LogFactory.getLog(this)


    String getResourcePath(Long id, String type) {
        if (type == 'r') {
            def bookInstance = Book.get(id)
             return '? todo'
        } else if (type == 'w') {

            return "?"
        } else if (type == 'e') {
            return "?"
        }
    }


    String createLink(Long id, String type) {
        def path = getResourcePath(id, type)
        def i = Book.get(id)
        def course = i.course ? i.course.code + ' ' + i.course.title : '9090'

        DecimalFormat nf = new DecimalFormat("000")
        DecimalFormat nfb = new DecimalFormat("0000")

        def label = //StringUtils.abbreviate(
                "B-${nf.format(i.id)} ${i.title ? i.title.replaceAll(':', ' ').replaceAll(/\?/, ' ').replaceAll(/\!/, ' ').replaceAll(';', ' ').replaceAll('&', 'and').replaceAll('"', '') : ''}".trim()
// + ".${i.ext}"
//            , 120)


        def folder = i.type.repositoryPath
        //    grailsApplication.config.ebk.path
        +'/' + new DecimalFormat('0000').format(id).substring(0, 2)
        def initial = new DecimalFormat('0000').format(id) + 'b'
        def ant = new AntBuilder()

        new File(folder).eachFileMatch(~/${initial}[\S\s]*/) { f ->

            println """mkdir -p /todo/"${course}" && ln -f "${f.path}" "/todo/${course}/${
                label
            }${f.name.contains('-') ? ' - ' + f.name.split('-')[1] : '.' + f.name.split(/\./)[1]}" """//.execute()
//replace('.', label + '.')
        }

        //"""d:\\mcs\\scr\\linkw "d:\\mcd\\lnk\\ebk\\links\\${bookInstance.course?.code ?: '1'}\\${label}" ${FilenameUtils.separatorsToSystem(path)}""".execute()

    }


    String getResourceLabel(Long id, String type) {
        def i = Book.get(id)

        //return (bookInstance.course.code ?: '') + (bookInstance.orderNumber ?: 'x ') + ' ' + bookInstance.id + ' ' + (bookInstance.legacyTitle && bookInstance.legacyTitle != '' ? bookInstance.legacyTitle : bookInstance.title)// + (bookInstance.isbn ?: '')
    }

    String toWeekDate(Date date) {
        Calendar c = new GregorianCalendar()
        c.setLenient(false)
        c.setMinimalDaysInFirstWeek(4)
        c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
        c.time = date
        def tmp = c.get(java.util.Calendar.DAY_OF_WEEK)
        def week = c.get(java.util.Calendar.WEEK_OF_YEAR)
        return (week < 10 ? '0' + week.toString() : week) + '' + (tmp == 1 ? 7 : tmp - 1)

        //        int javaDay = (day == 7) ? 1 : (day + 1)
        //        c.set(java.util.Calendar.DAY_OF_WEEK, javaDay)
        //        c.set(java.util.Calendar.YEAR, year.toInteger())

    }


    String fromWeekDate(String weekDate) {

        def year = '20' + weekDate.substring(4, 6)
        //weekDate = weekDate.substring(0, 3)
        int week = Integer.parseInt(weekDate.substring(0, 2))
        int day = Integer.parseInt(weekDate.substring(2, 3))
        if (week == 0 || week > 53 || day < 0 || day > 7) {
            log.error "Invalid weekDate ranges"
            throw new IOException()
        }

        Calendar c = new GregorianCalendar()
        c.setLenient(false)
        c.setMinimalDaysInFirstWeek(4)
        c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
        c.set(java.util.Calendar.WEEK_OF_YEAR, week)
        int javaDay = (day == 7) ? 1 : (day + 1)
        c.set(java.util.Calendar.DAY_OF_WEEK, javaDay)
        c.set(java.util.Calendar.YEAR, year.toInteger())
        //return Date.parse("yyyy-M-d", c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE))
        return c.get(Calendar.DATE) + '.' + (c.get(Calendar.MONTH) + 1) + '.' + c.get(Calendar.YEAR)

    }

    Date fromWeekDateAsDate(String weekDate) {

        def year = '20' + weekDate.substring(4, 6)
        def time = weekDate.substring(7)
        //        weekDate = weekDate.substring(0, 3)
        int week = Integer.parseInt(weekDate.substring(0, 2))
        int day = Integer.parseInt(weekDate.substring(2, 3))
        if (week == 0 || week > 53 || day < 0 || day > 7) {
            log.warn "Invalid weekDate ranges"
            throw new IOException()
        }

        Calendar c = new GregorianCalendar()
        c.setLenient(false)
        c.setMinimalDaysInFirstWeek(4)
        c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
        c.set(java.util.Calendar.WEEK_OF_YEAR, week)
        int javaDay = (day == 7) ? 1 : (day + 1)
        c.set(java.util.Calendar.DAY_OF_WEEK, javaDay)
        c.set(java.util.Calendar.YEAR, year.toInteger())
        return Date.parse("yyyy-MM-dd HH:mm", c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE) + ' ' + time)
        //        return c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE)

    }

    Date fromWeekDateAsDateGeneral(String weekDate) {
        try {
            def year = new Date().format('yyyy')
            if (weekDate.length() == 6)
                year = '20' + weekDate.substring(4)
            def time = ' 00:00'
            if (weekDate.length() > 6)
                time = weekDate.substring(7, 9) + ':' + weekDate.substring(9)
            //        weekDate = weekDate.substring(0, 3)
            int week = Integer.parseInt(weekDate.substring(0, 2))
            int day = Integer.parseInt(weekDate.substring(2, 3))
            if (week == 0 || week > 53 || day < 0 || day > 7) {
                log.warn "Invalid weekDate ranges"
                throw new IOException()
            }

            Calendar c = new GregorianCalendar()
            c.setLenient(false)
            c.setMinimalDaysInFirstWeek(4)
            c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
            c.set(java.util.Calendar.WEEK_OF_YEAR, week)
            int javaDay = (day == 7) ? 1 : (day + 1)
            c.set(java.util.Calendar.DAY_OF_WEEK, javaDay)
            c.set(java.util.Calendar.YEAR, year.toInteger())

            Date.parse("yyyy-MM-dd HH:mm", c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE) + ' ' + time)
            //        return c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE)
        }
        catch (Exception e) {
            e.printStackTrace()
            println e.toString()

        }

    }

    Date fromWeekDateAsDateTime(String weekDate) {

        def year = '2012'// + weekDate.substring(4, 6)
        def time = weekDate.substring(4)
        //        weekDate = weekDate.substring(0, 3)
        int week = Integer.parseInt(weekDate.substring(0, 2))
        int day = Integer.parseInt(weekDate.substring(2, 3))
        if (week == 0 || week > 53 || day < 0 || day > 7) {
            log.warn "Invalid weekDate ranges"
            throw new IOException()
        }

        Calendar c = new GregorianCalendar()
        c.setLenient(false)
        c.setMinimalDaysInFirstWeek(4)
        c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
        c.set(java.util.Calendar.WEEK_OF_YEAR, week)
        int javaDay = (day == 7) ? 1 : (day + 1)
        c.set(java.util.Calendar.DAY_OF_WEEK, javaDay)
        c.set(java.util.Calendar.YEAR, year.toInteger())
        return Date.parse("yyyy-MM-dd HH:mm", c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE) + ' ' + time + ':00')
        //        return c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE)

    }


    def copyBook(Long id, String destination) {
        def b = Book.get(id)
        NumberFormat nf = new DecimalFormat("0000")
        if (b) {

            def folder = grailsApplication.config.ebk.path + '/' + new DecimalFormat('0000').format(id).substring(0, 2)
            def initial = new DecimalFormat('0000').format(id) + 'b'
            def ant = new AntBuilder()

            new File(folder).eachFileMatch(~/${initial}[\S\s]*/) { f ->

                //        if (new File(getResourcePath(id, 'b')).exists() && !new File(destination + '/' + b.course.code + '/' + (b.orderNumber ?: '') + ' ' + nf.format(b.id) + 'b.' + b.ext).exists())
                //    ant.copy(file: getResourcePath(id, 'b'), tofile: destination + '/' + b.course.code + '/' + (b.orderNumber ?: '') + ' ' + nf.format(b.id) + 'b.' + b.ext)
//            if (new File(getResourcePath(id, 'ebk')).exists() && !new File(destination + '/' + nf.format(b.id) + 'b.' + b.ext).exists())
                ant.copy(file: f.path, tofile: destination + '/' + f.name.replace('.', ' my name.'))
//            else {
//                if (!new File(getResourcePath(id, 'b')).exists())
//                log.warn ('missed file for book: ' + b.id + '\n')
//            }

            }

        }
    }


    def copyWrt(Long id, String destination) {
        def b = Writing.get(id)
        if (b) {
            def ant = new AntBuilder()
            //        if (new File(getResourcePath(id, 'b')).exists() && !new File(destination + '/' + b.course.code + '/' + (b.orderNumber ?: '') + ' ' + nf.format(b.id) + 'b.' + b.ext).exists())
            ant.copy(file: getResourcePath(id, 'w'), tofile: destination + '/' + b.course.code + '/' + (b.orderNumber ?: '') + ' ' + b.id + 'w ' + b.title + '.tex')
            //        else {
            //            if (!new File(getResourcePath(id, 'b')).exists())
            //            println 'missed file for book: ' + b.id + '\n'
            //        }
        }
    }

    //def report1(){
    //  def r = ''
    //  Task.list([sort: 'goal']).each(){
    //    r += it.goal.toString() + ': ' + it.name + '<p>'
    //  }
    //  r
    //}

    String importResources(String type) {

        def path = Setting.findByName('new.' + type + '.path')?.value//grailsApplication.config.new.art.path.toString()
        def count = 0
        def folder = new File(path)

        NumberFormat nf = new DecimalFormat("00000")

        OperationController.getPath('allowed.extensions').split(',').each() { ext ->
            folder.eachFileMatch(~/[\w\W\S\s]*.${ext}/) {
                if (count <= 100) {
                    try {
                        def b = new Book([ext: ext])
                        //Book.findByStatus(ResourceStatus.get(11), [sort: 'id', order: 'asc']) ?:

                        b.title = it.name
                        b.ext = ext
                        b.status = ResourceStatus.findByCode('Undecided')
                        b.resourceType = type

                        if (!b.hasErrors() && b.save(flush: true)) {
                            def ant = new AntBuilder()
                            ant.copy(file: path + '/' + it.name, tofile: path + '/backup/' + it.name)
                            ant.move(file: path + '/' + it.name, tofile: path + '/' + (b.id / 100).toInteger() + '/' + b.id + 'a.' + ext)
                            count++
                        } else {
                            b.errors.each() {
                                println 'error ' + it
                            }
                            println 'Error saving the resource'
                        }


                    }

                    catch (Exception e) {
                        //            render "Sth wrong happened"
                        log.error e
                    }
                }
            }
        }
        return count + " resources imported"
    }


    String importBooks() {
        //Book.get(1).nbPages = 8206
        // (8000..8009).each(){Book.get(it).delete()}
        //Book.get(1).nbPages = 8000
        //    def idg =  Book.get(1).nbPages//Book.get(1).nbPages

        def path = OperationController.getPath('new.ebk.path)//grailsApplication.config.new.ebk.path.toString(')

        //new Properties().load(new FileInputStream(System.getProperty("user.home") + "/" + ".pomegranate-pim.properties")).getProperty('new.ebk.path')


        def count = 0
        def folder = new File(path)
        OperationController.getPath('allowed.extensions').split(',').each() { ext ->
            //            folder.eachFileMatch(~/[\S ]*[0-9]{9,13}[\S ]*.${ext}/) {
            folder.eachFileMatch(~/[\w\W\S\s]*.${ext}/) {
                if (count <= 500) {

                    println 'book found ' + it.name

                    try {
                        java.util.regex.Matcher matcher = it.name =~ /(\d{13}|\d{12}X|\d{12}x|\d{9}X|\d{9}x|\d{10})[^\d]*/
                        // todo: fix it to be exact match
                        def isbn
                        try {
                            isbn = matcher[0][1]
                        } catch (Exception e) {
                            isbn = null
                        }

                        //println id
                        /*
                        sleep(400)

                        def url = new URL("http://www.ottobib.com/isbn/${id}/bibtex" )
                        def connection = url.openConnection()

                        if(connection.responseCode == 200){
                        def t = connection.content.text
                        def f = t.substring(t.indexOf('@'))
                        def ff = f.substring(f.indexOf('@'), f.indexOf('<'))
                        println ff
                        java.util.regex.Matcher matcher2 = ff =~ /[\W\w]* author = \{([\w ,]*)\}[\W\w]

                        println 'author is ' + matcher2[0]
                         */
                        // save the book record
                        NumberFormat nf = new DecimalFormat("0000")
                        def dup = isbn ? Book.findByIsbn(isbn) : null
                        if (dup && isbn) {
                            def ant = new AntBuilder()
                            ant.copy(file: path + '/' + it.name, tofile: path + '/backup/' + it.name)

                            def newPath = path + '/' + (dup.id / 100).toInteger()
                            def c = 1
                            // was path + '/' + nf.format(dup.id).substring(0, 2)
                            while (new File(newPath + '/' + dup.id + 'b-' + c + '.' + ext).exists())
                                c++

                            ant.move(file: path + '/' + it.name, tofile: newPath + '/' + dup.id + 'b-' + c + '.' + ext)
                            count++
                        } else {
                            def b = new Book([isbn: isbn, ext: ext])
                            //Book.findByStatus(ResourceStatus.get(11), [sort: 'id', order: 'asc']) ?: new Book([isbn: isbn, ext: ext])

                            //b.isbn = isbn
                            b.legacyTitle = it.name
                            b.ext = ext

                            //  println 'before assign ' + b.id

                            //  b.id = idg
                            //  println 'after assign ' + b.id

                            //  idg = idg + 1
                            b.status = ResourceStatus.get(9)
                            b.resourceType = 'ebk'

                            if (!b.hasErrors() && b.save(flush: true)) {
                                //      updateBook(b.id)
                                //      addBibtex(b.id)

                                //        if(!file.renameTo (new File(path + '/' + nf.format(Integer.parseInt(b.id)) + 'b.pdf')))// + b.ext)))
                                def ant = new AntBuilder()
                                ant.copy(file: path + '/' + it.name, tofile: path + '/backup/' + it.name)
                                ant.move(file: path + '/' + it.name, tofile: path + '/' + (b.id / 100).toInteger() + '/' + b.id + 'b.' + ext)
                                count++
                            } else {
                                b.errors.each() {
                                    println 'error ' + it
                                }
                                println 'Error saving the book'
                            }
                        }
                        //        println 'Could not rename the file. Check for file with the same name.'
                        //        else
                        //        println 'Ebook was renamed to ' + nf.format(Integer.parseInt(b.id)) //+ '.' + b.ext

                        //} else println 'not found'

                        //    Book.get(1).nbPages = idg
                        //println 'last id is ' + Book.get(1).nbPages

                    }

                    catch (Exception e) {
                        //            render "Sth wrong happened"
                        log.error e
                    }
                }
            }
        }
        return count + " books imported"
    }

    //  String amazon() {
    //      Book.findAllByIdGreaterThanAndIdLessThan(8000, 9000).each() {
    //        if (it.isbn) {
    //          updateBook(it.id)
    //          sleep(500)
    //        }
    //      }
    //    }

//    private static final String AWS_ACCESS_KEY_ID =

    /*
     * Your AWS Secret Key corresponding to the above ID, as taken from the AWS
     * Your Account page.
     */
//    private static final String AWS_SECRET_KEY =

    /*
     * The Item ID to lookup. The value below was selected for the US locale.
     * You can choose a different value if this value does not work in the
     * locale of your choice.
     */
    //    private static final String ITEM_ID = "0415064333,0415064333";

    public static void updateBook(Long id) {
        /*
         * Set up the signed requests helper
         */
        def b = Book.get(id)
        String ITEM_ID = b.isbn?.trim();
        SignedRequestsHelper helper;

        /*
         * Use one of the following end-points, according to the region you are
         * interested in:
         *
         *      US: ecs.amazonaws.com
         *      CA: ecs.amazonaws.ca
         *      UK: ecs.amazonaws.co.uk
         *      DE: ecs.amazonaws.de
         *      FR: ecs.amazonaws.fr
         *      JP: ecs.amazonaws.jp
         *
         */
        String ENDPOINT = b.isbn?.startsWith('2') ? 'ecs.amazonaws.fr' : (b.isbn?.startsWith('3') || b.language == 'de' ? "ecs.amazonaws.de" : "ecs.amazonaws.com")
        try {
            helper = SignedRequestsHelper.getInstance(ENDPOINT,
                    OperationController.getPath('aws.access.key.id'),
                    OperationController.getPath('aws.secret.key'));
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        String requestUrl = null;
        String title = null;
        String author = null;
        String publisher = null;
        String publicationDate = null;

        /* The helper can sign requests in two forms - map form and string form */

        /*
         * Here is an example in map form, where the request parameters are stored in a map.
         */
        Map<String, String> params = new HashMap<String, String>();
        params.put("Service", "AWSECommerceService");
        params.put("Version", "2009-03-31");
        params.put("Operation", "ItemLookup");
        params.put("ItemId", ITEM_ID);
        params.put("ResponseGroup", "Medium");
        params.put("AssociateTag", OperationController.getPath('aws.associate.tag'));


        requestUrl = helper.sign(params);
        System.out.println("Signed Request is \"" + requestUrl + "\"");

        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(requestUrl);
            b.title = doc.getElementsByTagName("Title")?.item(0)?.getTextContent();


            b.author = doc.getElementsByTagName("Author")?.item(0)?.getTextContent();
            b.publisher = doc.getElementsByTagName("Publisher")?.item(0)?.getTextContent();
            b.publicationDate = doc.getElementsByTagName("PublicationDate")?.item(0)?.getTextContent();
            b.nbPages = doc.getElementsByTagName("NumberOfPages")?.item(0)?.getTextContent()?.toInteger();
            b.edition = doc.getElementsByTagName("Edition")?.item(0)?.getTextContent();
            b.description = doc.getElementsByTagName("EditorialReview")?.item(0)?.getTextContent();
            b.imageUrl = doc.getElementsByTagName("LargeImage")?.item(0)?.getTextContent();

            if (b.title == null || b.title?.trim() == '')
                b.status = ResourceStatus.get(12)

            if (!b.hasErrors()) {
                b.save(flush: true)
                if (b.title == null || b.title.trim() == '')
                    log.warn('WARNING: book ' + b.id + ' with isbn ' + b.isbn + ' has no title!')
                else {
                    if (b.status == ResourceStatus.get(12))
                        b.status = ResourceStatus.get(9)
                }

            }
            println b.id + ': ' + b.dump()
            addCover(b.id)

            if (b.isbn) {
                def url = new URL("http://www.ottobib.com/isbn/${b.isbn}/bibtex")
                def connection = url.openConnection()
                try {
                    if (connection.responseCode == 200) {
                        sleep(200)
                        def t = connection.content.text
                        def f = t.substring(t.indexOf('@'))
                        def ff = f.substring(f.indexOf('@'), f.indexOf('<'))
                        //                    println ff
                        //java.util.regex.Matcher matcher2 = ff =~ /[\W\w]* author = \{([\w ,]*)\}[\W\w]
                        //      println 'author is ' + matcher2[0]
                        b.bibEntry = ff
                        //                    println it.id
                        //                       b.save(flush: true)
                    }
                }
                catch (Exception e) {
                    log.warn('problem in getting bib entry of b' + b.id) //e.printStackTrace()
                }
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    /*
     * Utility function to fetch the response from the service and extract the
     * title from the XML.
     */

    private static String fetchTitle(String requestUrl) {
        String title = null;
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(requestUrl);
            Node titleNode = doc.getElementsByTagName("Author").item(0);
            title = titleNode.getTextContent();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return title;
    }

    String updateInfo() {
        try {

            def b = Book.get(params.id)
            updateBook(b.id)
            addBibtex(b.id)

            render 'Book info updated'
        } catch (Exception e) {
            e.printStackTrace()
            render 'Sth wrong happened during updating'
        }

    }


    String addBibtex(Long id) {

        def it = Book.get(id)
        if (it.isbn) {
            def url = new URL("http://www.ottobib.com/isbn/${it.isbn}/bibtex")
            def connection = url.openConnection()
            try {
                if (connection.responseCode == 200) {
                    sleep(200)
                    def t = connection.content.text
                    def f = t.substring(t.indexOf('@'))
                    def ff = f.substring(f.indexOf('@'), f.indexOf('<'))
                    //                    println ff
                    //java.util.regex.Matcher matcher2 = ff =~ /[\W\w]* author = \{([\w ,]*)\}[\W\w]
                    //      println 'author is ' + matcher2[0]
                    it.bibEntry = ff
                    //                    println it.id
                    it.save(flush: true)
                }
            }
            catch (Exception e) {
                log.warn('problem in getting bib entry of b' + it.id) //e.printStackTrace()
            }
        }

    }

    static String addCover(Long id) {
        def b = Book.get(id)
        //def path = CH.config.covers.repository.path + '/ebk'

        def path = OperationController.getPath('covers.sandbox.path') + '/' + b.type?.code
        println '\n\n\n\n\n\ncover path is ' + path

        if (b.imageUrl) {
            def t = new File(path + '/' + id + '.jpg')
            if (t.exists()) t.renameTo(new File(path + '/' + id + '-old.jpg'))
            try {
                t << new URL(b.imageUrl.substring(0, b.imageUrl.length() - 6)).openStream()
            }
            catch (Exception e) {
                e.printStackTrace()
            }
            if (!t.exists())
                log.warn('Cover not found ' + t.path)// 'Cover is now there'
        } else
            log.warn('No image url for b' + b.id)
    }


    static Integer indicatorLastSavedValue(Long id) {
        def d = IndicatorData.findByIndicator(Indicator.get(id), [sort: 'date', order: 'desc'])
        if (d)
            return d?.value
        else return null
    }

    static Integer indicatorCurrentValue(Long id) {
        Integer result
        def i = Indicator.get(id)
        if (i.path)
            result = countFolder(i.path, i.extensions)
        else if (i.query)
            result = Goal.executeQuery("select count(*) " + i.query)[0]

        return result
    }


    static Date indicatorLastSavedDate(Long id) {
        def d = IndicatorData.findByIndicator(Indicator.get(id), [sort: 'date', order: 'desc'])
        if (d)
            return d?.date
        else return null
    }


    static Integer countFolder(String path, String extensions) {
        def count = 0
        try {
            extensions.split(';').each() { ext ->
                new File(path).eachFileRecurse { f ->
                    if (f.name.toLowerCase().matches(~/^[\s\S]*.${ext}/))
                        count++
                }
            }
            return count
        } catch (Exception e) {
            return null
        }
    }

    static IndexCard importIcard(String body) {
        try {
            def lines = body.readLines()
            def contents = ''
            (2..lines.size() - 1).each() {
                contents += lines[it] + '\n'
            }

            def icd = new IndexCard()

            def size = lines[0].substring(4).split(/[ ]+/).size()

            def type = WritingType.findByCode(lines[0].substring(4).split(/[ ]+/)[0])
            if (!type)
                println 'Type not found'
            else icd.type = type


            def course = Course.findBycode(lines[0].substring(4).split(/[ ]+/)[1])
            if (!course)
                println 'Course not found'
            else icd.course = course

            if (size > 2) {
//                def sourceType = WordType.findByName(lines[0].substring(4).split(/[ ]+/)[2])
//                if (!sourceType)
//                    println 'Source type not found'
//                icd.sourceType = sourceType
                ;
            }

            if (size > 3) {
                String source = lines[0].substring(4).split(/[ ]+/)[3]
                if (source.startsWith('b'))
                    icd.book = Book.findById(source.substring(1).toLong())
                else if (app.parameters.WordSource.findByCode(source))
                    icd.source = source
                else
                    icd.sourceFree = source
            }


            icd.description = contents
            icd.writtenOn = new Date()
            icd.summary = lines[1]

            def i = icd.save(flush: true)
            println i.dump()
            return i

        } catch (Exception exception) {
            log.error('Problem during importing. Icd may be wrong format: ' + body)
            log.error exception.toString()
            println exception.toString()

            //  return null
        }

        /*     def writtenOn

        try {
        writtenOn = supportService.fromWeekDateAsDate((n =~ /icd On: (\d\d\d)/)[0][1] + '.11')
        } catch (Exception e) {
        println 'No date for the icd ' + f.name
        }

        def context

        try {
        context = (n =~ /icd [\S\s]* Context: \[([\S\s]*)\]\n/)[0][1]
        } catch (Exception e) {
        println 'No context for the icd ' + f.name
        }

        //                def topic = (n =~ /nws \d\d\d [\w]* ([\d]*)/)[0][1]
        def contents = (n =~ /icd [\S ]*\n([\S\s]+)/)[0][1].trim()
        //                def contents = n.split('---')[1].trim()

        def icd = new IndexCard([contents: contents, writtenOn: writtenOn, context: context, priority: priority])
        println icd.dump()
        if (!icd.hasErrors() && icd.save(flush: true)) {
        f.renameTo("/todo/icd/icd-${icd.id}.txt")
        render "one icd imported with id ${icd.id} <br/>"
        } else render "A icd could not be saved, but no exception"

        } catch (Exception e) {
        render 'Icd of wrong format' + f.path
        e.printStackTrace()
        }

         */

    }


    int postToBlog(Long blogId, String title, String categoriesString, String tags, String fullText, Integer publishedNodeId) {
        try {
            def username
            def password
            def link

            ArrayList<String> categories = categoriesString.split(',')
            Blog blog = Blog.get(blogId)
            username = blog.username
            password = blog.password
            link = blog.link



            Wordpress wp = new Wordpress(username, password, link)

            Page post
//        println 'all cat ' + wp.getCategories().categoryName
//        wp.getCategories().categoryName.each(){
//            println 'blog cat ' + ' vale ' + it
//        }

            categories.each() {
                if (it?.trim() != '') {
                    if (!wp.getCategories().categoryName*.toLowerCase()?.contains(it?.toString()?.toLowerCase()?.trim())) {
                        wp.newCategory(it?.toString(), it?.toString()?.toLowerCase(), 1)
                    }

                }
            }

            if (publishedNodeId)
                post = wp.getPost(publishedNodeId)
            else
                post = new Page()

            //n.language == 'ar' ?
            //  ('<span style="direction: rtl; text-align: right">' + n.title + ' (' + n.source.name + ', //' + n.publishedOn.format('dd.MM.yyyy') + ')</span>') :

            post.setTitle(title)

            post.setDescription(fullText)
            //recentPost.setExcerpt(StringUtils.abbreviate(content, 250))

            XmlRpcArray array = categories as String[]
            post.setCategories(array)



            XmlRpcArray custom_fields = new XmlRpcArray();
            CustomField cf = new CustomField();
            cf.setKey("use_blogtext");
            cf.setValue("on");
            custom_fields.add(cf);

            //  post.setCustom_fields(custom_fields) // to enable BlogIt syntax

            post.setMt_keywords(tags)

            def result


            if (!publishedNodeId)
                result = wp.newPost(post, true)
            else
                result = wp.editPost(publishedNodeId.intValue(), post, "")

            if (!publishedNodeId && Integer.parseInt(result) > 0) {
                return Integer.parseInt(result)
            } else if (publishedNodeId && result) {
                return publishedNodeId
            }
        }
        catch (Exception e) {
            e.printStackTrace()
            println e.toString()
            log.error(e.printStackTrace())
            println("Record could NOT be posted")
            log.error(e.toString())
            return 0
        }

    }

    Long post2xcd(String  blogCode, Integer postId) {

        def username
        def password
        def link


        Blog blog = Blog.findByCode(blogCode)
        username = blog.username
        password = blog.password
        link = blog.link



        Wordpress wp = new Wordpress(username, password, link)

        Page post = wp.getPost(postId)


        println 'Title:' + post.title
        println 'Desc:' + post.description
        println 'Cat:' + post.categories
        println 'Date:' + post.dateCreated
        println 'Tags:' + post.mt_keywords

        def n = new IndexCard()
        n.summary = post.title
        n.description  = post.description
        n.blogCode = blogId
        n.publishedOn = post.dateCreated
        n.publishedNodeId = post.postid
        n.save(flush: true)
        if (post.mt_keywords) {
            post.mt_keywords.split(',').each() {
                n.addToTags(Tag.findByName(it) ?: new Tag([name: it]).save(flush: true))
            }
        }

        post.categories.each() {
            n.addToTags(Tag.findByName(it) ?: new Tag([name: it, isKeyword: true]).save(flush: true))
        }

        return n.id

    }


    void pdfTitleUpdate(String path, String filename, String title) {
        PdfReader reader = new PdfReader(path + '/' + filename)
        def tempFile = new File(path + '/_' + filename)
        println ' now doing ' + tempFile.path
        PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(tempFile))

        HashMap info = reader.getInfo()
        info.put("Title", title)
        stamper.setMoreInfo(info)

        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        XmpWriter xmp = new XmpWriter(baos, info)
        xmp.close()
        stamper.setXmpMetadata(baos.toByteArray())
        stamper.close()

//        File f1 = new File(path)
        //f1.delete()
//        if (f1.exists())
//            println 'f1 exiss'
//        f1.renameTo(new File('~' + path))

//        tempFile.renameTo(new File('_' + path))

    } // end of method

    // this is the method to use - mcs notation implementation
    static Date fromWeekDateAsDateTimeFullSyntax(String weekDate) {

        def year = new Date().format('yyyy')
        if (weekDate.contains('.'))
            year = '20' + weekDate.substring(4, 6)
        def time = '00:00'

        if (weekDate.contains('_')) {
            def chunk = weekDate.split('_')[1].trim()

            if (chunk.length() > 2) {

                if (chunk.length() == 3)
                    chunk = '0' + chunk

                time = chunk.substring(0, 2) + ':' + chunk.substring(2, 4)
            } else {
                time = weekDate.split('_')[1] + ':00'
            }
        }

        int week = Integer.parseInt(weekDate.substring(0, 2))
        int day = Integer.parseInt(weekDate.substring(2, 3))
        if (week == 0 || week > 53 || day < 0 || day > 7) {
            //    log.warn "Invalid weekDate ranges"
            throw new IOException()
        }

        Calendar c = new GregorianCalendar()
        c.setLenient(false)
        c.setMinimalDaysInFirstWeek(4)
        c.setFirstDayOfWeek(java.util.Calendar.MONDAY)
        c.set(java.util.Calendar.WEEK_OF_YEAR, week)
        int javaDay = (day == 7) ? 1 : (day + 1)
        c.set(java.util.Calendar.DAY_OF_WEEK, javaDay)
        c.set(java.util.Calendar.YEAR, year.toInteger())

        Date.parse("yyyy-MM-dd HH:mm", c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE) + ' ' + time)
        //        return c.get(Calendar.YEAR) + '-' + (c.get(Calendar.MONTH) + 1) + '-' + c.get(Calendar.DATE)

    }


}
