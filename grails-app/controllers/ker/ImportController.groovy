/*
 * Copyright (c) 2014. Mohamad F. Fakih (mail@mfakih.org)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */



package ker

import app.IndexCard
import app.Indicator
import app.parameters.ResourceType
import com.gravity.goose.Article
import com.gravity.goose.Configuration
import com.gravity.goose.Goose
import de.undercouch.citeproc.CSL
import de.undercouch.citeproc.bibtex.BibTeXConverter
import de.undercouch.citeproc.bibtex.BibTeXItemDataProvider
import de.undercouch.citeproc.output.Bibliography
import grails.converters.JSON
import mcs.Book
import mcs.Excerpt
import mcs.Writing
import mcs.parameters.WritingType
import org.jbibtex.BibTeXDatabase

class ImportController {

    def supportService

    static entityMapping = [
            'G': 'mcs.Goal',
            'T': 'mcs.Task',
            'P': 'mcs.Planner',

            'W': 'mcs.Writing',
            'N': 'app.IndexCard',

            'J': 'mcs.Journal',
            'I': 'app.IndicatorData',
            'K': 'app.Indicator',

            'Q': 'app.Payment',
            'L': 'app.PaymentCategory',

            'R': 'mcs.Book',
            'C': 'mcs.Course',
            'D': 'mcs.Department',
            'E': 'mcs.Excerpt',
            'S': 'app.Contact',

            'Y': 'cmn.Setting',
            'X': 'mcs.parameters.SavedSearch'
    ]


    def importExcerpts() {
        try {
            def path = OperationController.getPath('excerpts.sandbox.path')
            def count = 0
            def folder = new File(path)
            folder.eachFileMatch(~/r [0-9]* [\S- ]*.pdf/) {
                log.info 'Current processing exr: ' + it.path
                java.util.regex.Matcher matcher = it.name =~ /r ([0-9]*) ([\w\W\S\s- ]*).pdf/
                def id = matcher[0][1]
                def title = matcher[0][2]
//                println id + ' ' + title
                def b = new Excerpt()//findByStatus(ResourceStatus.get(11))//new Book([isbn: id, ext: ext])
                if (Book.get(id) && title && title.length() > 2) {
                    b.book = Book.get(id)
                    try {
                        b.chapters = title.split(' ')[0] //Integer.parseInt(title.split(' ')[0])
                        b.summary = title.substring(title.indexOf(' ')).trim()
                    } catch (Exception e) {
                        b.summary = title
                        println 'exr without chapter number'
                    }


                    if (!b.hasErrors() && b.save(flush: true)) {
                        def ant = new AntBuilder()
                        ant.move(file: path + '/' + it.name, tofile: path + '/' + b.id + 'r.pdf')
                        count++
                        println 'exr' + b.dump()
                    }
                } else
                    log.error "Exr cannot be imported"
            }
            render(template: '/layouts/achtung', model: [message: count + " files imported"])
        } catch (Exception e) {
            render "Sth wrong happened"
            e.printStackTrace()
        }
    }

    def importSmartFiles() {
        println 'Current processing file: '
        try {
            def path = OperationController.getPath('smartFiles.newFiles.path')
            def count = 0
            def folder = new File(path)
            folder.eachFile() {//Match(~/(?i)([\s]) [\S\s\W\w-;_ ]*.[\S]*/) {
                try {

                    log.info 'Current processing exe: ' + it.path
//                java.util.regex.Matcher matcher = it.name =~ /r b([0-9]*) ; ([\S- ]*).([\S- ]*)/
                    java.util.regex.Matcher matcher = it.name =~ /(?i)([a-z]) ([\S\s ;-_]*)\.([\S]*)/
//                def id = matcher[0][1]
                    def entityCode = matcher[0][1]
                    def title = matcher[0][2]
                    def ext = matcher[0][3]
                    println 'entity ' + entityCode
                    def b = grailsApplication.classLoader.loadClass(entityMapping[entityCode.toUpperCase()]).newInstance()

                    b.properties = GenericsController.transformMcsNotation(entityCode + ' ' + title.trim())['properties']
                    if (ext == 'txt') {
                        if (entityCode.toLowerCase() == 'b')
                            b.fullText = it.text
                        else
                            b.description = it.text
                    } else {
                        def ant = new AntBuilder()
//                        if (entityCode.toUpperCase() == 'N') {
                            def sandboxPath = OperationController.getPath('module.' + entityCode.toUpperCase() + '.sandbox.path')
                            ant.move(file: path + '/' + it.name, tofile: sandboxPath + '/' + b.id + entityCode + '.' + ext)
                    }
//                    println b.dump()
//                if (Book.get(id) && title && title.length() > 2) {
//                    b.book = Book.get(id)

//                        b.title = title//.substring(title.indexOf(' ')).trim()

//                }

                    if (!b.hasErrors() && b.save(flush: true)) {

                        count++
                    } else {
                        println 'Record saving problem'
                    }

                } catch (Exception e) {
                    println 'File import problem ' + e.printStackTrace()

                }
            }
            render(template: '/layouts/achtung', model: [message: count + " files imported"])
        } catch (Exception e) {
            render "Sth wrong happened"
            e.printStackTrace()
        }
    }

    def importSmartFilesAjax() {
        println 'Current processing exe: ' + params.qqfile
        try {
            try {
                java.util.regex.Matcher matcher = params.qqfile =~ /(?i)([\S]) ([\S\s ;-_]*)\.([\S]*)/
                def entityCode = matcher[0][1]

                def title = matcher[0][2]
                def ext = matcher[0][3]

                def b = grailsApplication.classLoader.loadClass(entityMapping[entityCode.toUpperCase()]).newInstance()

                def tmpFilename = new Date().format('ddMMyyyyHHmmss') + Math.random() * 1000
                def f = new File(OperationController.getPath('tmp.path') + '/' + tmpFilename) << request.inputStream

                b.properties = GenericsController.transformMcsNotation(entityCode + ' ' + title.trim())['properties']

                if (ext == 'txt') {
                    if (entityCode.toLowerCase() == 'r')
                        b.fullText = f.text
                    else
                        b.description = f.text
                }
                else {
                    def ant = new AntBuilder()
//                        if (entityCode.toUpperCase() == 'N') {
                    def sandboxPath = OperationController.getPath('module.' + entityCode.toUpperCase() + '.sandbox.path')
                    ant.move(file: f.path, tofile: sandboxPath + '/' + b.id + entityCode + '.' + ext)

                }


                if (entityCode.toLowerCase() == 'b')
                    b.fullText = f.text
                else
                    b.description = f.text

                if (!b.hasErrors() && b.save(flush: true)) {
//                        render(template: '/gTemplates/recordSummary', model: [record: b])
                    return render(text: [id: b.id, entityCode: entityCode.toUpperCase()] as JSON, contentType: 'text/json')

                } else {
                    println 'Record saving problem'
                }

            } catch (Exception e) {
                println 'File import problem' + e.printStackTrace()

            }
//            render(template: '/layouts/achtung', model: [message: count + " files imported"])
        } catch (Exception e) {
            render "Sth wrong happened"
            e.printStackTrace()
        }
    }


    def importSmartFilesAjaxUpdate() {
        println 'Current processing exe: ' + params.qqfile
        try {
            try {

                def entityCode
                def id
                def title = ''
                def ext
                  try {
                java.util.regex.Matcher matcher = params.qqfile =~ /(?i)([\S])_([0-9]+) ([\S\s ;-_]*)\.([\S]*)/
                 entityCode = matcher[0][1]
                 id = matcher[0][2]
                 title = matcher[0][3]
                 ext = matcher[0][4]
                  }
                  catch (Exception e){
                      java.util.regex.Matcher matcher = params.qqfile =~ /(?i)([\S])_([0-9]+)\.([\S]*)/
                      entityCode = matcher[0][1]
                      id = matcher[0][2]
                      ext = matcher[0][4]
                  }

                def b = grailsApplication.classLoader.loadClass(entityMapping[entityCode.toUpperCase()]).get(id)

                def tmpFilename = new Date().format('ddMMyyyyHHmmss') + Math.random() * 1000
                def f = new File(OperationController.getPath('tmp.path') + '/' + tmpFilename) << request.inputStream

                b.properties = GenericsController.transformMcsNotation(entityCode + ' ' + title.trim())['properties']
                if (entityCode.toLowerCase() == 'b')
                    b.fullText = f.text
                else
                    b.description = f.text

                if (!b.hasErrors() && b.save(flush: true)) {
//                        render(template: '/gTemplates/recordSummary', model: [record: b])
                    return render(text: [id: b.id, entityCode: entityCode.toUpperCase()] as JSON, contentType: 'text/json')

                } else {
                    println 'Record saving problem'
                }

            } catch (Exception e) {
                println 'File import problem' + e.printStackTrace()

            }
//            render(template: '/layouts/achtung', model: [message: count + " files imported"])
        } catch (Exception e) {
            render "Sth wrong happened"
            e.printStackTrace()
        }
    }


    def importExcercises() {
        try {
            def path = OperationController.getPath('new.exe.path')
            def count = 0
            def folder = new File(path)
            println 'path ' + path
            folder.eachFileMatch(~/(?i)C[\S\s\W\w-;_ ]*.[\S]*/) {
                try {
                    log.info 'Current processing exe: ' + it.path
//                java.util.regex.Matcher matcher = it.name =~ /r b([0-9]*) ; ([\S- ]*).([\S- ]*)/
                    java.util.regex.Matcher matcher = it.name =~ /(?i)C ([\S\s ;-_]*)\.([\S]*)/
//                def id = matcher[0][1]
                    def title = matcher[0][1]
                    def ext = matcher[0][2]
//                println id + ' ' + title
                    def b = new IndexCard()//findByStatus(ResourceStatus.get(11))//new Book([isbn: id, ext: ext])
//                    println 'title ' + title
                    b.properties = GenericsController.transformMcsNotation('c ' + title.trim())['properties']
                    if (!b.type)
                        b.type = WritingType.findByCode('hgl')

                    b.description = '...'
//                    println b.dump()
//                if (Book.get(id) && title && title.length() > 2) {
//                    b.book = Book.get(id)

//                        b.title = title//.substring(title.indexOf(' ')).trim()

//                }

                    if (!b.hasErrors() && b.save(flush: true)) {
                        def ant = new AntBuilder()
                        ant.move(file: path + '/' + it.name, tofile: path + '/' + b.id + 'c.' + ext)
                        count++
                    } else {
                        println 'exe saving problem'
                    }

                } catch (Exception e) {
                    println 'exe import problem' + e.toString()

                }
            }
            render(template: '/layouts/achtung', model: [message: count + " files imported"])
        } catch (Exception e) {
            render "Sth wrong happened"
            e.printStackTrace()
        }
    }

    def importNews() {
        def path = OperationController.getPath('new.nws.path')
        def count = 0
        new File(path + '/').eachFileMatch(~/(?i)n[\S\s]*.txt/) { f -> //Match(~/.*.txt/)
            def n = f.text
            try {

                def lines = n.readLines()
                def contents = ''//lines[0] + '\n'
                (1..lines.size() - 1).each() {
                    contents += lines[it] + '\n'
                }

                def title = lines[0]?.trim()
                //    def url = lines[2]?.trim()

                //  def date = lines[0].trim().split(/[ ]+/)[1]//n =~ /nws (\d\d\d)/)[0][1] + '.12' // Todo: parametric, year required
//                def source = lines[0].trim().split(/[ ]+/)[2]// (n =~ /nws \d\d\d ([\w]*)/)[0][1]
//                def topic = (n =~ /nws \d\d\d [\w]* ([\d]*)/)[0][1]
//                def title = (n =~ /nws [\S ]*\n([\S\s]+)\n---/)[0][1].trim()
//                def contents = n.split('---')[1].trim()
//                def scope = NewsScope.get(topic.toLong())
                def news = new Book([title: title, fullText: contents?.trim(),
                        //source: NewsSource.findByCode(source),
                        //     url: url,
                        language: 'ar',
                        resourceType: 'nws'
//                        ,
//                        scope: NewsScope.findByCode('usr')
                        //        publishedOn: supportService.fromWeekDateAsDateGeneral(date)
                ])

                if (!news.hasErrors() && news.save(flush: true)) {
//                    f.renameTo(path + '/imported/' + "n${news.id}.txt")
                    def ant = new AntBuilder()
                    ant.move(file: f.path, tofile: path + '/' + "${news.id}n.txt")
                    count++

//                    render(template: '/layouts/achtung', model: [message:  "A news file imported with id ${news.id}"])
                } else
                    render(template: '/layouts/achtung', model: [message: "A news file could not be saved"])

            }
            catch (Exception e) {

                render(template: '/layouts/achtung', model: [message: 'News of wrong format' + f.path])
                e.printStackTrace()
            }
        }
        render(template: '/layouts/achtung', model: [message: count + ' news files imported'])
    }

    def importIcards() {
        def path = OperationController.getPath('attachments.sandbox.path')
        def count = 0
        new File(path).eachFileMatch(~/C[\S\s]*.txt/) { f -> //Match(~/.*.txt/)
            def ant = new AntBuilder()
            ant.move(file: f.path, tofile: path + '/' + "${news.id}c.txt")

            render(template: "/indexCard/card", model: [indexCardInstance: supportService.importIcard(f.text)])
            count++
        }
        render(template: '/layouts/achtung', model: [message: count + 'iCards imported'])
    }

    def commitWritings() {
        // should be the same as the checkout folder, to avoid commiting editor changes, without merging, and so destroy web changes
        new File(OperationController.getPath('wrt.path')).eachFileRecurse() {

            if (it.path.endsWith('.tex') && !it.path.endsWith('wrt.tex')) {
                try {
                    def w = Writing.get(it.name.split(/\./)[0].toInteger())
//          println w.id
                    //    w.title = StringUtils.remove(it.name.split('_')[1], '.tex')//.trim()
                    if (w.description != new File(it.path).text)
                        w.description = new File(it.path).text//.trim()

                } catch (Exception e) {
                    log.warn 'Non-compliant tex file found'
                }
            }
        }
//         searchableService.reindex()
        render 'Your writings have been committed'
    }


    def upload() {

//        if (new File(CH.config.data.location + '/' + params.name).exists())
//            new File(CH.config.data.location + '/' + params.name).renameTo(
//                    CH.config.data.location + '/' + params.name + '-' + new Date().format('dd.MM.yyyy-hh.mm'))

        def status = ''
//        try {
//
//            new File(CH.config.data.location + '/' + a.id) << request.inputStream
//
//            if (new File(CH.config.data.location + '/' + a.id).exists())
//                status = 'File uploaded successfully'
//        } catch (Exception e) {
//            status = 'File could not be saved!'
//            println e.printStackTrace()
//        }
//        render(contentType: "text/json") {
//            [status]
//        }

        return render(text: [success: true] as JSON, contentType: 'text/json')

    }


    def chooseImportType() {
        session['import-type'] = params.id
        render 'ok ' + params.id
    }

    def importIndicators() {
        new File('/todo/indicators-import.csv').text.eachLine() { line, number ->

            if (number > 0) {
                def i = new Indicator()
                i.code = line.split(',')[1]
                i.name = line.split(',')[1]
                i.frequency = 'r'
                i.startDate = new Date()
                i.query = line.split(',')[3]
                i.path = line.split(',')[4]
                i.extensions = line.split(',')[5]
                i.category = line.split(',')[0].toInteger()
                i.save()

            }
        }
        render 'Indicators imported'
    }




    def generateCitation(Long id) {

        def r = Book.get(id)
        def f = new File(OperationController.getPath('tmp.path') + "/" + r.id + '.bib')
        f.text = r.bibEntry

        f = new FileInputStream(OperationController.getPath('tmp.path') + '/' + r.id + '.bib')

//        f.print(r.bibEntry)
//        f.close()

        BibTeXConverter dc = new BibTeXConverter()
        BibTeXDatabase db = dc.loadDatabase(f);

        BibTeXItemDataProvider provider = new BibTeXItemDataProvider();
        provider.addDatabase(db);

        CSL citeproc = new CSL(provider, "ieee");
        provider.registerCitationItems(citeproc);

//        citeproc.setOutputFormat("text");
//        render 'cite' +  citeproc.makeCitation('beazley2013python').dump()//[0].getText()

//       println 'citation ' + provider.dump()//retrieveItem('beazley2013python')
//        print '' + citeproc.makeAdhocBibliography("ieee", provider.retrieveItem('beazley2013python')).entries[0].replace('[1]', '')//()//.makeString()
//        citeproc.setOutputFormat("text")
//        print '' + citeproc.makeAdhocBibliography("ieee", provider.retrieveItem('beazley2013python')).entries?.dump()//[0].replace('[1]', '')//()//.makeString()

//        print '' + citeproc.makeAdhocBibliography("ieee",
//                provider.retrieveItem('beazley2013python')).makeString()//entries[0].replace('[1]', '')//()//.makeString()
//        render 'final' + citeproc.makeAdhocBibliography("ieee", provider.retrieveItem('beazley2013python')).entries[0]//.makeString()
        citeproc.setOutputFormat("asciidoc")
        Bibliography bibl = citeproc.makeBibliography();
        String entry = bibl.getEntries()[0]
        r.citationAsciicode = entry


        citeproc.setOutputFormat("text")
        bibl = citeproc.makeBibliography();
        entry = bibl.getEntries()[0]
        r.citationText = entry
        citeproc.setOutputFormat("html")
        bibl = citeproc.makeBibliography();
        entry = bibl.getEntries()[0].replace('[1]', '')
        r.citationHtml = entry

           render entry
//        render(template: '/gTemplates/recordSummary', model: [record:
//                r
//        ])
//        render(template: '/gTemplates/recordDetails', model: [record:
//                r
//        ])
//                render(template: '/layouts/achtung', model: [message: entry])


}


String importModuleFiles(String entityCode) {

    def type = entityCode
    def path = '/todo/new/N'
    def count = 0
    def folder = new File(path)


    OperationController.getPath('allowed.extensions').split(',').each() { ext ->
        folder.eachFileMatch(~/[\w\W\S\s]*.${ext}/) {
            try {

                def b
                    b = new IndexCard([ext: ext])

//                    b.type = type
                    b.summary = it.name

//                }

                if (!b.hasErrors() && b.save(flush: true)) {
                    def ant = new AntBuilder()
                    ant.copy(file: path + '/' + it.name, tofile: path + '/backup/' + it.name)
                    ant.move(file: path + '/' + it.name, tofile: path + '/N_' + b.id +  '.' + ext)
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
    render(template: '/layouts/achtung', model: [message: count + " resources imported"])
}

def importIndividualFile() {

    def entityCode = params.entityCode
    def path = params.path
    def count = 0
    def folder = new File(path)
   def name = params.name

    def b = grailsApplication.classLoader.loadClass(entityMapping[entityCode.toUpperCase()]).newInstance()
    b.summary = name

    b.description = 'Imported on ' + new Date().format(OperationController.getPath('date.format') ?: 'dd.MM.yyyy')

//    b.properties = GenericsController.transformMcsNotation(entityCode + ' ' + title.trim())['properties']

                if (!b.hasErrors() && b.save(flush: true)) {
                    render(template: '/gTemplates/recordSummary', model: [record: b])
                    def ant = new AntBuilder()
                    ant.move(file: path, tofile: OperationController.getPath('module.' + entityCode + '.sandbox.path') + '/' + b.id + ' '  + name)

                }
                else {
                    b.errors.each() {
                        println 'error ' + it
                    }
                    println 'Error saving the resource'
                }

}

String importResources(Long typeId) {

    def type = ResourceType.get(params.type)
    def path = type.newFilesPath
    def count = 0
    def folder = new File(path)


    OperationController.getPath('allowed.extensions').split(',').each() { ext ->
        folder.eachFileMatch(~/[\w\W\S\s]*.${ext}/) {
            try {

                def b
                if (type.captureIsbn == true) {
                    try {
                        java.util.regex.Matcher matcher = it.name =~ /(\d{13}|\d{12}X|\d{12}x|\d{9}X|\d{9}x|\d{10})[^\d]*/
                        // todo: fix it to be exact match
                        def isbn
                        try {
                            isbn = matcher[0][1]
                        } catch (Exception e) {
                            isbn = null
                        }

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
                            b = new Book([isbn: isbn, ext: ext])
                            b.legacyTitle = it.name

                        }
                    }
                    catch (Exception e) {
                        ; // no isbn
                    }
                } else {
                    b = new Book([ext: ext])

                    b.type = type
                    b.title = it.name

                }

                if (!b.hasErrors() && b.save(flush: true)) {
                    def ant = new AntBuilder()
                    ant.copy(file: path + '/' + it.name, tofile: path + '/backup/' + it.name)
                    ant.move(file: path + '/' + it.name, tofile: path + '/' + (b.id / 100).toInteger() + '/' + b.id + type.code + '.' + ext)
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
    render(template: '/layouts/achtung', model: [message: count + " resources imported"])
}

def uploadFiles() {
    render(template: '/import/uploadFiles', model: [])
}

def importLocalFiles() {
    render(template: '/import/importLocalFiles', model: [])
}

    def scrapHtmlPage (){
        def r = Book.get(params.id)
        String url = r.url
        Configuration configuration = new Configuration()
        configuration.setMinBytesForImages(4500)
        configuration.setLocalStoragePath("/tmp/goose")
        // i don't care about the image, just want text, this is much faster!
        configuration.setEnableImageFetching(false);
     //   configuration.setImagemagickConvertPath("/opt/local/bin/convert");
        Goose goose = new Goose(configuration);
        Article article = goose.extractContent(url)
        r.fullText = article.rawHtml()
        println ('text ' + article.rawHtml())
        r.publishedOn = article.publishDate()
        r.title = article.title()
        r.description = article.metaDescription()
        r.textTags = article.metaKeywords()
        r.imageUrl = article.topImage().getImageSrc()
        render(template: '/gTemplates/recordSummary', model: [record: r, expandedView: true])
    }
    def upload = {
//        if (new File(CH.config.data.location + '/' + params.name).exists())
//            new File(CH.config.data.location + '/' + params.name).renameTo(
//                    CH.config.data.location + '/' + params.name + '-' + new Date().format('dd.MM.yyyy-hh.mm'))
        def status = ''
        try {
            def a = new IndexCard([recordId: params.recordId, entityCode: params.entityCode, fileName: params.qqfile])
            a.type = WritingType.findByCode('doc')
            a.summary = 'Doc'//params.qqfile//'File'
            a.description = '?'
            a.save(flush: true)
            new File(OperationController.getPath('module.N.sandbox.path') + '/' + a.id) << request.inputStream
            if (new File(OperationController.getPath('module.N.sandbox.path') + '/' + a.id).exists()){
                status = 'File uploaded successfully'
            }
        } catch (Exception e) {
            println 'problem uploading the file ' + params.qqfile
            status = 'File could not be saved!'
            e.printStackTrace()
        }
//        render(contentType: "text/json") {
//            [status]
//        }
        //render(text: [success: true] as JSON, contentType: 'text/json')
        render(template: '/layouts/achtung', model: [message: 'Document deleted'])
    }
} // end of class