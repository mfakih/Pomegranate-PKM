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

import org.scribe.model.Response
import org.scribe.model.Token
import uk.co.desirableobjects.oauth.scribe.OauthService
import app.IndexCard
import grails.converters.XML
import app.Indicator
import app.IndicatorData
import app.Payment
import grails.converters.JSON
import grails.plugins.rest.client.RestBuilder
import jxl.write.NumberFormat
import mcs.*
import mcs.parameters.ResourceStatus
import mcs.parameters.WritingType
import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.WordUtils
import org.asciidoctor.Attributes
import org.asciidoctor.Options
import org.eclipse.mylyn.wikitext.core.parser.MarkupParser
import org.eclipse.mylyn.wikitext.markdown.core.MarkdownLanguage

import static org.asciidoctor.AttributesBuilder.attributes;
import static org.asciidoctor.OptionsBuilder.options;

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import java.text.DecimalFormat
import java.text.SimpleDateFormat

class ExportController {

    def supportService

    def textbooks2Bib() {
        def nf = new DecimalFormat("0000")
        def f = new File('/todo/exp/bib/tbk.bib')
        f.text = ''
        def t = ''
        Book.findAllByBibEntryIsNotNullAndStatus(ResourceStatus.get(1)).each() {
            if (it.status?.id <= 4)
                if (it.bibEntry.count(/\{/) % 2 == 0 && it.bibEntry.count(/\}/) % 2 == 0 && it.bibEntry.contains('isbn = ')) {
                    def e = (it.bibEntry.replace('author = ', 'bid = {' + nf.format(it.id) + '},\n file = {:' + nf.format(it.id) + 'b.' + (it.ext ?: 'pdf') + ':' + (it.ext ? it.ext?.toUpperCase() : 'PDF') + '},\n' + ' author = ') + '\n\n')
                    e = e.replaceAll(/%/, '\\%').replaceAll(/#/, '\\#').replaceAll(/&/, '\\&').replaceAll(/_/, '\\_')
                    t += e
                } else log.warn 'textbook withouth bib entry ' + it.id
        }

        f.text = t
    }

    def exportIndicators() {
        def data = 'date'

        Indicator.executeQuery("from Indicator where category != null order by category, code").each() { i ->
            data += ';' + i.code
        }

        data += '\n'

        (Date.parse('dd.MM.yyyy', '29.10.2011')..new Date()).each() { d ->
            data += supportService.toWeekDate(d) + ';'
            Indicator.executeQuery("from Indicator where category != null order by category, code").each() { i ->
                def value = IndicatorData.executeQuery("from IndicatorData where indicator = ? and date(date) = ? ", [i, d])
                data += value ? value[0] : ''
                data += ';'
            }
            data += '\n'
        }
        new File('/todo/exp/ind.csv').text = data
        render 'Indicators exported'
    }


    def exportPayments() {
        def data = ''
        Payment.list().each() {
            data += it.date.format('dd/MM/yyyy') + ';' + it.reality + ';;' + it.description + ';' + it.amount + ';' + it.category.name + '\n'
        }
        new File('/todo/exp/exp.cvs').text = data
        render 'Payments exported'
    }


    def exportIcal() {
        def items = Journal.executeQuery("from Journal")// where type.category = ?", [params.id.toInteger()]) //findAllByLevelLike('m')
        //  def eventsList = []
        render(contentType: 'text/calendar') {
            calendar {
                events {
                    items.each() {
                        event(start: it.startDate, end: new Date(it.startDate.time + 30 * 60000),
                                description: it.description?.replaceAll("\r", '')?.replaceAll("\n", ''), //StringUtils.abbreviate(it.body, 10),
                                summary: (it.level ?: '? ') + it.type?.name.toUpperCase() + ': ' + StringUtils.abbreviate(it.description, 250),
                                category: it.type?.name, location: it.type.category)
                    }
                }
            }
        } // end of render
        // new File('l:/jm.ical').text = t
    }


    def calendarEvents() {
        def events = []

        if (params.jp == 'J') {
            Journal.executeQuery("from Journal where startDate >=? and startDate <= ? and type.id = ?",
                    [new Date(Long.parseLong(params.start) * 1000),
                            new Date(Long.parseLong(params.end) * 1000), params.id.toLong()]).each() {

                events.add([id: it.id, start: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.startDate),
                        //end: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.endDate ?: it.startDate),
                        //it.type?.name +
                        'title': (it.summary ? it.summary + ' / ' : '') +
                                (it.description ? StringUtils.abbreviate(it.description, 40) : ' ') +
                                (it.task ? 'T-' + StringUtils.abbreviate(it.task?.summary, 80) : ''),
                        color: it.type?.color ?: 'blue',
                        url: 'page/record/' + it.id + '?entityCode=J',
                        allDay: (it.level != 'm' || it.startDate.hours < 6 ? true : false)
                ])
            }

        }
//        Planner.executeQuery("from Planner where level = ? and startDate != endDate", ['m']).each() {
        if (params.jp == 'P') {
            Planner.executeQuery("from Planner p where  p.startDate >=? and p.startDate <= ? and p.type.id = ?",
                    [new Date(Long.parseLong(params.start) * 1000), new Date(Long.parseLong(params.end) * 1000), params.id.toLong()]).each() {

                def title = (it.summary ? it.summary + ' / ' : '') + // it.type?.name +
                        (it.description ? StringUtils.abbreviate(it.description, 40) : ' ') +
                        (it.goal ? 'G-' + it.goal?.code + ' ' + StringUtils.abbreviate(it.goal?.summary, 80) : '') +
                        (it.task ? (it.task.goal ? it.task?.goal?.code?.toUpperCase() : '')
                                + 'T-' + StringUtils.abbreviate(it.task?.summary, 80) : '')


                events.add([id: it.id, start: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.startDate),
                        //   end: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.endDate ?: it.startDate),
                        'title': title, color: it.type?.color ?: 'green',
                        url: 'page/record/' + it.id + '?entityCode=P',
                        allDay: (it.level != 'm' || it.startDate.hours < 6 ? true : false)
                ])
            }
        }

        render events as JSON
    }

    def calendarEvents2() {
        def events = []

//        if (params.jp == 'J') {
//        Journal.executeQuery("from Journal j where j.startDate between ? and ? order by j.type.category asc",
        Journal.executeQuery("from Journal j where j.startDate between ? and ?",
                [new Date(Long.parseLong(params.start) * 1000), new Date(Long.parseLong(params.end) * 1000)]).each() {

            def title = //' [' + it.type?.code + '] ' +
                    (it.task ? 'T-' + StringUtils.abbreviate(it.task?.summary, 60) : '') +
                    (it.goal ? 'G-' + it.goal?.code + ' ' + StringUtils.abbreviate(it.goal?.summary, 80) : '') +
                    (it.summary ? it.summary + ' / ' : '') +
                    (it.description ? StringUtils.abbreviate(it.description, 40) : ' ')

            events.add([id: it.id,
                    start: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.startDate),
                    end: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.endDate ?: it.startDate),
                    //it.type?.name +
                    title: title,
                    backgroundColor: it.type?.color ?: '#3A87AD',
                    textColor: '#ffffff',
                    url: OperationController.getPath('app.URL') + '/page/record/' + it.id + '?entityCode=J',
                    allDay: (it.level != 'm' || it.startDate.hours < 6 ? true : false)])
        }

//        }
//        Planner.executeQuery("from Planner where level = ? and startDate != endDate", ['m']).each() {
//        if (params.jp == 'P') {
        Planner.executeQuery("from Planner p where  p.startDate >=? and p.startDate <= ? ",
                [new Date(Long.parseLong(params.start) * 1000), new Date(Long.parseLong(params.end) * 1000)]).each() {

            def title = ' [' + it.type?.code + '] ' +
                    (it.goal ? 'G-' + it.goal?.code + ' ' + StringUtils.abbreviate(it.goal?.summary, 80) : '') +
                    (it.task ? (it.task.goal ? it.task?.goal?.code?.toUpperCase() : '') +
                            'T-' + StringUtils.abbreviate(it.task?.summary, 80) : '') +
                    (it.summary ? it.summary + ' ' : '') + // it.type?.name +
                    (it.description ? StringUtils.abbreviate(it.description, 40) : ' ')




            events.add([id: it.id,
                    start: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.startDate),
                    end: new SimpleDateFormat("yyyy-MM-dd'T'HH:mm':00'").format(it.endDate ?: it.startDate),
                    title: title, backgroundColor: it.type?.color ?: '#88AD75',
                    borderColor: it.type?.color ?: '#88AD75',
                    textColor: '#ffffff',
                    url: 'page/record/' + it.id + '?entityCode=P',
                    allDay: (it.level != 'm' || it.startDate.hours == 0 ? true : false)])
//            }
        }

        render events as JSON
    }


    def timelineEvents() {

        def events = []

        Planner.executeQuery("from Planner where type.category = 2 and dateCreated > ?", new Date() - 50).each() {
            events.add(['start': new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(it.startDate),
                    'end': new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(it.endDate),
                    'title': it.type.toString() + ': ' + (it?.goal ? it.goal.title + ' ' : '') + (it?.description ? ' ; ' + it?.description : ''), wikiID: "${it.id}",
                    'description': it.description, 'color': 'green'])
        }
        Journal.executeQuery("from Journal where type.category = 2").each() {
            events.add(['start': new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(it.startDate),
                    'end': new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(it.endDate),
                    'title': it.type.toString() + ': ' + it.body, wikiID: "${it.id}",
                    'description': it.description, 'color': 'green'])
        }
        (new Date()..new Date() - 30).each() { d ->
            Writing.findAllByLastUpdatedGreaterThanAndLastUpdatedLessThan(d, d + 1, [max: 6]).each() {
                events.add(['start': new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(it.lastUpdated),
                        'end': new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(it.lastUpdated),
                        'title': 'writing: ' + it.title, wikiID: "${it.id}",
                        'description': it.body, 'color': 'green'])
            }
        }


        def data = ['dateTimeFormat': 'iso8601',
                'wikiURL': "${CH.config.grails.serverURL}/task/",
                'wikiSection': "show",
                'events': events]
        render data as JSON

    }



    def goals2kindle() {
        render(view: '/reports/goals2kindle')
    }



    def genExrBibtex() {
        NumberFormat nf = new DecimalFormat("000")
        def c = new File(CH.config.hom.path + '/exr.bib')
        c.text = ''
        def t = ''
        Excerpt.executeQuery("from Excerpt order by id asc").each() {
            def b = it.book
            if (b.bibEntry && b.bibEntry.count(/\{/) % 2 == 0 && b.bibEntry.count(/\}/) % 2 == 0 && b.bibEntry.contains('isbn = ')) {
                def e = (b.bibEntry.replace('author = ', 'bid = {' + nf.format(it.id) + '},\n file = {:exr\\\\' + nf.format(it.id) + 'e.pdf:PDF' + '},\n' + ' author = ') + '\n\n')
                e = e.replaceAll(/%/, '\\%').replaceAll(/#/, '\\#').replaceAll(/&/, '\\&').replaceAll(/_/, '\\_')
                t += e
            } else log.warn(b.id + ' has no bib entry')
        }

        c.text = t
    }



    def exportAllBooksByCourseAsLinks() {
        Book.findAllByCourseIsNotNull().each() {
            supportService.createLink(it.id, 'b')
        }
        render 'ok'
    }



    def hardLinkFiles() {
        def type = 'exr'

        def result = ''
        DecimalFormat nf = new DecimalFormat("000")
        DecimalFormat nfb = new DecimalFormat("0000")


        try {
            switch (type) {
                case 'exr':

                    def bookName
                    def courseName
                    for (i in Excerpt.findAllByDeletedOnIsNull()) {
                        courseName = "${i.book?.course?.code} ${i.book.course.title}"
                        bookName = "B-${nf.format(i.book.id)} ${i.book.title ? i.book.title.replaceAll(/\?/, ' ').replaceAll(/\!/, ' ').replaceAll(':', ' ').replaceAll(';', ' ').replaceAll('&', 'and').replaceAll('"', '') : ''}".trim()
                        result += "mkdir -p \"/todo/dvs/exr/${courseName}/${bookName}\"" + " && "
                        result += """ln -f /todo/exr/${nf.format(i.id)}e.pdf "/todo/dvs/exr/${courseName}/${bookName}/E-${nf.format(i.id)} ${i.title.replaceAll(/\?/, ' ').replaceAll(/\!/, ' ').replaceAll(':', ' ').replaceAll(';', ' ').replaceAll('&', 'and').replaceAll('"', '')}""".trim() + ".pdf\"\n"//.execute()
                    }
                    break

                case 'tbk':

                    def bookName
                    def courseName
                    for (i in Book.findAllByStatus(ResourceStatus.get(1))) {
                        bookName = "B-${nf.format(i.id)} ${i.title ? i.title.replaceAll(':', ' ').replaceAll(';', ' ').replaceAll('&', 'and').replaceAll('"', '') : ''}".trim()
                        //  result += "mkdir -p \"/todo/lnk/tbk/${courseName}\"" + " && "
                        result += supportService.createLink(i.id, 'ebk') + "\n" //"""ln -f /todo/tbk/${nf.format(i.id)}e.pdf "/todo/dvs/tbk/${bookName}/E-${nf.format(i.id)} ${i.title}""".trim() + ".pdf\"\n"//.execute()
                    }
                    break
            }

            new File("/todo/dvs/${type}.sh").text = result
            render 'Script file updated on /todo/dvs'
        }
        catch (Exception e) {
            render 'Problem creating the script' + e
        }

    }

    def copyTextbookCovers() {
        def ant = new AntBuilder()
        Book.findAllByStatusOrStatus(ResourceStatus.get(1), ResourceStatus.get(3)).each() {
            if (new File("/todo/cvr/ebk/" + it.id + '.jpg').exists() && !new File('/todo/cvr/ebk/' + it.id + '.jpg').exists()) {
                ant.copy(file: '/todo/cvr/ebk/' + it.id + '.jpg', tofile: '/todo/cvr/ebk/' + it.id + '.jpg')
            }
            //    supportService.copyBook(it.id, '/todo/exp/tbk')
        }
        render Book.countByStatus(ResourceStatus.get(1)) + ' textbook cover copied'

    }

    def exportTextbookFiles() {
        Book.findAllByStatus(ResourceStatus.get(1)).each() {
            supportService.copyBook(it.id, '/todo/exp/tbk')
        }

        Book.findAllByStatus(ResourceStatus.get(3)).each() {
            supportService.copyBook(it.id, '/todo/exp/tbk')
        }
        render Book.countByStatus(ResourceStatus.get(1)) + ' textbooks copied'
        render Book.countByStatus(ResourceStatus.get(3)) + ' references copied'
    }

    def copyRefs() {
        Book.findAllByCourseIsNotNullAndStatus(ResourceStatus.get(4)).each() {
            supportService.copyBook(it.id, 'r:/him/ref/copy')
        }
        render Book.countByCourseIsNotNullAndStatus(ResourceStatus.get(1)) + ' reference books copied'
    }


    def exportWritingsToOneFile() {
        if (params.id)
            render(view: '/reports/wrt2html', model: [courses: Course.findAllByDepartment(Department.get(params.id), [sort: 'code']),
                    department: Department.get(params.id)])
        else
            render(view: '/reports/wrt2html', model: [courses: Course.findAll([sort: 'code'])])

    }

    def checkoutWritings() {

        def text =  ''
        def prefix = 'chapter'
        def field = 'slug'
        def extension = '.txt'
        def body
        for (w in Writing.list()) {
            //new OutputStreamWriter(new FileOutputStream("r:/hom/tex/wrt/${it.id}.tex"), 'UTF8').append(it.body).close()
            // new File("r:/hom/tex/wrt/${it.id}.tex").write(it.body, 'utf-8')

            if (w.description){
                body = '# ' + w.summary + '\n\n' + w.description.replaceAll('=', '#')
            text += body
                new File(OperationController.getPath('writings.export.path') + "/" + prefix + w[field].replace('chp', '') + extension).write(body, 'utf-8')
            }

            //_${it.title.trim().replaceAll(' ', '-')}
            //println it.id
        }
        render 'Writings have been checked out'


        MarkupParser markupParser = new MarkupParser();
        markupParser.setMarkupLanguage(new MarkdownLanguage());
        String htmlContent = markupParser.parseToHtml(text);

        render htmlContent
    }

    def checkoutWritingsToOneFile() {

        def text =  ''
        def prefix = 'W_all'
        def field = 'id'
        def extension = '.txt'
        def body
        for (w in Writing.list([sort: 'orderInCourse', order: 'asc'])) {
            //new OutputStreamWriter(new FileOutputStream("r:/hom/tex/wrt/${it.id}.tex"), 'UTF8').append(it.body).close()
            // new File("r:/hom/tex/wrt/${it.id}.tex").write(it.body, 'utf-8')

            if (w.description){
                body = '# ' + w.summary + '\n\n' + w.description.replaceAll('=', '#')
            text += body

            }

            //_${it.title.trim().replaceAll(' ', '-')}
            //println it.id
        }
        render 'Writings have been checked out'

        new File(OperationController.getPath('writings.export.path') + "/" + prefix + extension).write(text, 'utf-8')

        MarkupParser markupParser = new MarkupParser();
        markupParser.setMarkupLanguage(new MarkdownLanguage());
        String htmlContent = markupParser.parseToHtml(text);

        render htmlContent
    }

    def genOthers() {
        Journal.list().each() {
            new OutputStreamWriter(new FileOutputStream(CH.config.hom.path.toString() + "/mcs/${it.id}j.txt"), 'UTF8').append(it.level + ' ' + it.startDate.format('dd.MM.yyyy HH:mm') + ' - ' + it.startDate.format('dd.MM.yyyy HH:mm') + it.type + '\n ' + it.body).close()
        }

        Planner.list().each() {
            new OutputStreamWriter(new FileOutputStream(CH.config.hom.path.toString() + "/mcs/${it.id}p.txt"), 'UTF8').append(it.planLevel + ' ' + it.startDate.format('dd.MM.yyyy HH:mm') + ' - ' + it.startDate.format('dd.MM.yyyy HH:mm') + it.type + '\n ' + it.description).close()
        }

        render 'Mcs writings have been checked out'
    }

    def generateTexFile() {
        def path = "/todo/tmp/${new Date().format('yyMMddHHmmss')}"
        def file = new File(path)

        def textt = ""
        def text = ""

        // 1 - By course

        Department.findAll([sort: 'departmentCode']).each() {
            text += "\n\n\n\\part{${it.departmentCode + ' - ' + it.name}}\n"

            text += "\n\n\n\\chapter{Department writings}\n"

            textt += "\n[${it.departmentCode + ' ' + it.name}]\n"

            Writing.findAllByDepartment(it, [sort: 'orderNumber']).each() {
                text += "\n\n\n\\section{${(it.orderNumber != 99 ? it.orderNumber + ' ' : '')}${WordUtils.capitalize(it.title.replaceAll('\n', ' '))}}\n"
                textt += '    ' + WordUtils.capitalize(it.title.replaceAll('\n', ' ')) + ' ' + it.id + '\n'

            }

            Course.findAllByDepartment(it, [sort: 'code']).each() {
                def c = it
                text += "\n\n\n\\chapter{${c}}\n"
                textt += "  {${c.code + ' ' + c.title}}\n"

                if (Writing.findByCourseAndType(c, WritingType.get(35), [sort: 'orderNumber'])) {
                    text += "\n\n\n\\section{Syllabus ${Writing.findByCourseAndType(c, WritingType.get(35))?.id}}\n"
                    textt += "    syllabus ${Writing.findByCourseAndType(c, WritingType.get(35))?.id}\n"
                    text += ("\\input{wrt/${Writing.findByCourseAndType(c, WritingType.get(35))?.id}}")
                } else
                    text += "\n\n\nNo syllabus!\n"


                Writing.findAllByCourseAndIsLatex(c, true, [sort: 'orderNumber', order: 'asc']).each() {
                    if (it.body?.length() > 12 && it.type != WritingType.get(35)) {
                        //                        text += "\n\n\n\\section{${WordUtils.capitalize(it.title.replaceAll('\n', ' '))} \\emph{${it.id}w} (${it.body.length()})}\n"
                        text += "\n\n\n\\section{${(it.orderNumber != 99 ? it.orderNumber + ' ' : '')}${WordUtils.capitalize(it.title.replaceAll('\n', ' '))}}\n"
                        //def tabs = it.orderNumber.toString().replaceAll(/\./, '').length()
                        def tabs
                        if (it.orderNumber != Math.floor(it.orderNumber))
                            tabs = '  '
                        else tabs = ''
                        textt += "    ${tabs + (it.orderNumber != 99 ? it.orderNumber + ' ' : '') + WordUtils.capitalize(it.title.replaceAll('\n', ' ')) + ' ' + it.id + ''}\n"
                        text += ("\\input{wrt/${it.id}}")
                    }
                }
            }
        }

        //        text += "\n\n\n\\part{Writings A-Z}\n"
        //        text += "\n\n\n\\chapter{Writings A-Z}\n"
        //        Writing.findAllByIsLatex(true, [sort: 'title', order: 'asc']).each() {
        //            if (it.body?.length() > 12 && it.type != WritingType.get(35)) {
        //                text += "\n\n\n\\section{${WordUtils.capitalize(it.title.replaceAll('\n', ' '))}}\n"
        //                text += ("\\input{wrt/${it.id}}")
        //            }
        //        }
        //        text += "\n\n\n\\part{Course notes}\n"
        //        text += "\n\n\n\\chapter{Course notes}\n"
        //        Writing.findAllByIsLatex(true, [sort: 'course', order: 'asc']).each() {
        //            if (it.body?.length() > 12 && it.type == WritingType.get(35)) {
        //                text += "\n\n\n\\section{${WordUtils.capitalize(it.title.replaceAll('ln ', ''))}}\n"
        //                text += ("\\input{wrt/${it.id}}")
        //            }
        //        }

        //        file.text = text
        //        new File('/todo/txt/wrt-ordered.gen').text = textt
        //        text = ''
        /*  // 2 - By front
        text += "\n\n\n\\part{By front}\n"

        Front.list().each(){
        def f = it
        text += "\n\n\n\\chapter{${f}}\n"
        Writing.findAllByFrontAndIsLatex(f, true).each(){
        text += "\n\n\n\\section{${it.title} ${it.body.length()}}\n"
        text += ("\\input{${it.id}_${it.title.trim().replaceAll(' ', '-')}}")
        }
        }

        // 3 - By type
        text += "\n\n\n\\part{By type}\n"

        WritingType.list().each(){
        def f = it
        text += "\n\n\n\\chapter{${f}}\n"
        Writing.findAllByTypeAndIsLatex(f, true).each(){
        text += "\n\n\n\\section{${it.title} ${it?.body?.length()}}\n"
        text += ("\\input{${it.id}_${it.title.trim().replaceAll(' ', '-')}}")
        }
        }

        // 4 - By status
        text += "\n\n\n\\part{By status}\n"

        WritingStatus.list().each(){
        def f = it
        text += "\n\n\n\\chapter{${f}}\n"
        Writing.findAllByWritingStatusAndIsLatex(f, true).each(){
        text += "\n\n\n\\section{${it.title} ${it?.body?.length()}}\n"
        text += ("\\input{${it.id}_${it.title.trim().replaceAll(' ', '-')}}")
        }
        }

        // 5 - By length
        text += "\n\n\n\\part{By type}\n"
        // greater than 300 words

        text += "\n\n\n\\chapter{Greater than 500}\n"
        Writing.findAllByIsLatex(true).each() {
        if (it?.body?.size() > 500){
        text += "\n\n\n\\section{${it.title} ${it?.body?.length()}}\n"
        text += ("\\input{${it.id}_${it.title.trim().replaceAll(' ', '-')}}")
        }
        }

        text += "\n\n\n\\chapter{Between 300 and 500}\n"
        Writing.findAllByIsLatex(true).each() {
        if (it?.body?.size() < 500 && it?.body?.size() > 300){
        text += "\n\n\n\\section{${it.title} ${it?.body?.length()}}\n"
        text += ("\\input{${it.id}_${it.title.trim().replaceAll(' ', '-')}}")
        }
        }

         */

        //        file.text += text
        //        def title = file.text
        //          title = title.replaceAll('\\$', '\\$')
        //          title = title.replaceAll('_', '\\_')
        //          title = title.replaceAll('%', '\\%')
        //          title = title.replaceAll('#', '\\#')
        //        title = title.replaceAll('\', '\\')
        //     		  title = title.replaceAll('&', '\\&')

        //        title += '\n\\end{document}'
        file.text = text + '\n\\end{document}'

        response.setHeader("Content-disposition", "attachment; filename='toc-generated.tex'")
        //    		   response.contentType = "application/vnd.ms-word"
        response.outputStream << new FileInputStream(path)

    }


    def exportAllBooksToTextold() {
        def f = new File("r:/lib/ebk/ebk-list-${new Date().format('yyyy-MM-dd')}.txt")
        def books = ''
        Book.findAllByStatusNotEqual(ResourceStatus.get(11)).each() {
            books += (it.id + 'b ' + it.title + ' --- ' + it.legacyTitle + ' by ' + it.author + ' pub: ' + it.publisher + ' ' + it.publicationDate + ' isbn: ' + (it.isbn ?: '') + '\n')//  it.summary + '\n\n'
        }
        f.setText(books, 'UTF-8')
        render 'ebk > txt'
    }

    def exportAllBooksToText() {
        def path = "/todo/tmp/ebk-list-${new Date().format('yyyy-MM-dd')}.txt"
        def f = new File(path)
        def books = ''
        Book.findAllByStatusNotEqual(ResourceStatus.get(11)).each() {
            books += (it.id + 'b ' + it.title + (it.legacyTitle ?: '') + ' by ' + it.author + ' pub: ' + it.publisher + ' ' + it.publicationDate + ' isbn: ' + (it.isbn ?: '') + '\n')//  it.summary + '\n\n'
        }
        f.setText(books, 'UTF-8')

        response.setHeader("Content-disposition", "attachment; filename=ebk-list.txt")
        //    		   response.contentType = "application/vnd.ms-word"
        response.outputStream << new FileInputStream(path)
    }


    def exportAllCourseChildren() {
        def f = new File("/todo/exp/crs-centric-dump.csv") //-${new Date().format('yyyy-MM-dd_HH-mm-ss')}
        def results = 'crs;id;type;title;status\n'
        Course.findAll([sort: 'code', order: 'asc']).each() { c ->

            Goal.findAllByCourse(c).each() {
                results += (c.toString() + ';' + it.id + ';Goals;' + it.goalType + ': ' + it.title.replaceAll('"', '') + ';' + it.goalStatus + '\n')
            }
            Task.findAllByCourse(c).each() {
                results += (c.toString() + ';' + it.id + ';Tasks;' + (it.location ?: '') + ': ' + it.name.replaceAll('"', '') + ';' + it.taskStatus + '\n')
            }
            Writing.findAllByCourse(c).each() {
                results += (c.toString() + ';' + it.id + ';Writings;' + (it.type ?: '') + ': ' + it.title.replaceAll('"', '') + ';' + it.writingStatus + '\n')
            }

            Book.findAllByCourse(c).each() {
                results += (c.toString() + ';' + it.id + ';Books;' + it.status + ': ' + (it.title ? it.title.replaceAll('"', '') : '') + (it.legacyTitle ? it.legacyTitle.replaceAll('"', '') : '') + ';' + (it.publicationDate ?: '') + '\n')
            }

        }
        f.setText(results, 'UTF-8')

        render(template: '/layouts/achtung', model: [message: '/todo/exp/crs-centric-dump.csv created'])
    }


    def exportToIcal() {
        def items = Course.list()
        def eventsList = []
        render(contentType: 'text/calendar') {
            calendar {
                events {
                    items.each() {
                        event(start: it.dateCreated, end: it.dateCreated, descrition: it.fullString(), summary: it.toString())
                    }
                }
            }
        } // end of render

    }


    def rss() {
        render(template: '/reports/rss', model: [])
    }



    def generateCourseWritingsAsHtml() {
        def path = "/host/new/C/9155/book.adoc"
        def file = new File(path)
        def c = Course.get(params.id)

        def text = """
= ${c.summary}
Mohamad Fakih <mail@mfakih.org>
v0.3, 12.03.2014:
:imagesdir: .
:homepage: http://get-pkm.org
:toc:

"""


                Writing.findAllByCourseAndDeletedOnIsNull(c, [sort: 'orderInCourse', order: 'asc']).each() {
                        text += "\n== " + it.summary + '\n'
                        text += it.description.replaceAll(';; ' , '').replaceAll(';;--' , '')
                    }
        file.text = text + '\n'

//        response.setHeader("Content-disposition", "attachment; filename='toc-generated.tex'")
//        response.outputStream << new FileInputStream(path)

        org.asciidoctor.Asciidoctor asciidoctor = org.asciidoctor.Asciidoctor.Factory.create();

        def header = new File("/host/todo/new/C/9155/header.txt").text
        def footer = new File("/host/todo/new/C/9155/footer.txt").text

        Attributes attributes = attributes().tableOfContents(true).sectionNumbers(true).get();

        Options options = options().attributes(attributes).get();

        render header + '\n' + asciidoctor.render(file.text, options) + '\n' + footer
    }

    def generateCourseWritingsAsIs() {
      //  def path = "/host/new/C/9155/book.md"
        //def file = new File(path)
        def c = Course.get(params.id)
        def text = """
"""
                Writing.findAllByCourseAndDeletedOnIsNull(c, [sort: 'orderInCourse', order: 'asc']).each() {
                        //text += "\n## " + it.summary + '\n'
                        text += it.description//.replaceAll(';; ' , '').replaceAll(';;--' , '')
                    }
       // file.text = text + '\n'
//        response.setHeader("Content-disposition", "attachment; filename='toc-generated.tex'")
//        response.outputStream << new FileInputStream(path)
        render '<pre>' + text + '</pre>'
    }
    def generateCoursePresentation() {
        // todo if !.adoc generate else leave
        def path = "/host/todo/new/C/9155/prs.gen" // /mdd/tmp/${new Date().format('yyMMddHHmmss')}"
        def file = new File(path)
        def c = Course.get(params.id)

        def text = """
= ${c.summary}
:title: Integrating Work and Knowledge Management using Pomegranate PKM
:description: Integrating Work and Knowledge Management using Pomegranate PKM
:keywords:  Integrating Work and Knowledge Management using Pomegranate PKM
:author: Mohamad F. Fakih <mail at mfakih.org>
:copyright: Mohamad F. Fakih
:Date:   14th March, 2014
:Email:  mail at mfakih.org
:max-width!: 25em
:slidebackground:

:backend:   slidy2
:max-width: 45em
:data-uri:
:icons:


This presentation aims to give an overview of Pomegranate PKM system.


"""

        def frag
        for (w in Writing.findAllByCourseAndDeletedOnIsNull(c, [sort: 'orderInCourse', order: 'asc'])){
                    text += "\n== " + w.summary + '\n\n'

                    w.description?.trim()?.eachLine(){
                        if (it.startsWith(';;--'))
                            text += "\n\n\nifdef::backend-slidy2[<<<]\n\n\n"
                        else if (it.startsWith(/\/\//) || it.startsWith(';;')){
                            frag = it.substring(3)
                            text += (frag.startsWith('*') ? '' : '') + frag + '\n\n'
                        }
                        else if (it.startsWith('=')){
                            frag = it//.substring(3)
                            text += frag + '\n\n'
                        }
                     }


                    }
        file.text = text + '\n'

//        response.setHeader("Content-disposition", "attachment; filename='toc-generated.tex'")
//        response.outputStream << new FileInputStream(path)

        org.asciidoctor.Asciidoctor asciidoctor = org.asciidoctor.Asciidoctor.Factory.create();

         Attributes attributes = attributes().tableOfContents(true).sectionNumbers(true).get();

        Options options = options().attributes(attributes).get();

        render asciidoctor.render(file.text, options)
    }


    def syncNote(){
        def n = IndexCard.get(params.id)
        def url = n.pomegranate?.link + '/sync'
        def p
        if (params.id && IndexCard.exists(params.id)) {
            p = IndexCard.get(params.id)
        }
      try{
        def rest = new RestBuilder()
        def resp = rest.put(url){
            auth n.pomegranate?.username, n.pomegranate?.password
            contentType "application/json"
            json p
        }
//            contentType "application/xml"
//            xml {
//                name = "test-group"
//                description = "A temporary test group"
//            }
//            [name: 'moh']
//        }
          render  resp.xml//.name == 'acegi'
      }
      catch(Exception e){
          println e.printStackTrace()
      }
    }
    OauthService oauthService
    def googleCalendar(){
        Token token = (Token) session[oauthService.findSessionKeyForAccessToken('google')]
//        Token token = new Token(
//                '384961145713-81j9daaqq9pus3uek9tp1ba4edb5frtn.apps.googleusercontent.com',
//                'MW-xzcvpEkyRg9oTDyJQPLsB')
//
        println 'token ' + token.dump()
        def text = "Test Data".encodeAsURL()
        def calendarId = "1e1cgt5h3mf263idugc8kq47e0@group.calendar.google.com"//.encodeAsURL()
        def  event = [
                'summary': 'Appointment',
                'description': 'description of the event',
                'location': 'Somewhere']
//                'start': ['date': new Date().format('yyyy-MM.dd')],
//                'end': ['date':(new Date() +2).format('yyyy-MM.dd')]]
        //Response accessResource(String serviceName, Token accessToken, String verbName, String url, Map body) {
      try{
        def calendars = oauthService.accessResource('google', token,'POST',
                "https://www.googleapis.com/calendar/v3/calendars/1e1cgt5h3mf263idugc8kq47e0%40group.calendar.google.com/events?fields=description%2Cend%2Clocation%2Cstart%2Csummary", event)
          def calendarsJSON = JSON.parse(calendars.body)
          render calendarsJSON.toString()
          println calendarsJSON.toString()
      }
      catch (Exception e){
          println e.printStackTrace()
      }
        //String serviceName, Token accessToken, String verbName, String url, Map body) {
        //def response = oauthService.accessResource(url:grailsApplication.config.oauth.providers.google.api,consumer:'consumer_name',token:[key:'accesskey',secret:'accesssecret'], method:'POST')
    }
} // end of class