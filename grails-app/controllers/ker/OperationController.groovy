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

import app.*
import app.parameters.Blog
import app.parameters.Pomegranate
import app.parameters.ResourceType
import cmn.Setting
import grails.converters.JSON
import mcs.*
import mcs.parameters.*
import org.apache.pdfbox.PDFToImage
import org.asciidoctor.Asciidoctor
import security.User
import security.UserRole

import static org.asciidoctor.Asciidoctor.Factory.create

class OperationController {

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
    def supportService
    def searchableService
    private java.lang.Object object

    def actions() {
        render(template: '/import/importLocalFiles')
    }

    def updateAllWithoutTitle() {
        def count = 0
        Book.findAllByIsbnIsNotNullAndTitleIsNull().each() {
            supportService.updateBook(it.id)
            supportService.addBibtex(it.id)
            count++
        }
        render(template: '/layouts/achtung', model: [message: count + ' books updated'])
    }

    def toggleState() {
        def course = Course.get(params.id)
        def field = 'bookmarked' // isActive
        if (course[field] == true)
            course[field] = false
        else
            course[field] = true

        render("<span class='" + course[field] ? 'activeCourse' : '' + "'>" + course.title + "</span>")
    }

    def addInBatch() {

        def count = 0
        def message = ''

        if (params.input == '')
            render ''
        else {
            render "<b>Processed input:</b> " + params.input.replaceAll('\n', '<br/>') + '<br/><br/>'

            if (params.input.startsWith('icd')) {
                params.input.split(/\*/).each() {
//                render(template: "/indexCard/card", model: [indexCardInstance:supportService.importIcard(it)])
                    render(template: "/gTemplates/recordSummary", model: [record: supportService.importIcard(it)])
                    count++
                }
            } else {
                params.input.eachLine() {
                    count++
                    def input = it.trim()

                    try {

                        if (input && (input.startsWith('jrn') || input.startsWith('pln')) &&
                                input ==~ /(jrn|pln) [\w-]* \d{3}\.\d\d [\S\s]* ; [\S\s]*/) {

                            def isJournal = input.substring(0, 3) == 'jrn'

                            // fields always present
                            def type

                            if (isJournal)
                                type = JournalType.findByNameLike(input.split(/ /)[1])
                            else
                                type = PlannerType.findByNameLike(input.split(/ /)[1])

                            Date startDate
                            String startDateString = supportService.fromWeekDate(input.split(/ /)[2])
                            def description = input.substring(input.indexOf(';') + 2)

                            def tail = input.substring(4, input.length())

                            def rest = tail.substring(
                                    tail.indexOf(/ /) + 8,
                                    tail.length()
                            )

                            def goal = null
                            def task = null
                            def course = null
                            def writing = null

                            Date endDate

                            def level

                            // minute-level record, with or without a parent record (goal/task/course)
                            if (rest ==~ /\d{4} \d{4} [\S\s]*/) {

                                def startTime = rest.split(/ /)[0].substring(0, 2) + ':' + rest.split(/ /)[0].substring(2, 4)
                                def endTime = rest.split(/ /)[1].substring(0, 2) + ':' + rest.split(/ /)[1].substring(2, 4)

                                startDate = Date.parse('yyyy-MM-dd HH:mm', startDateString + ' ' + startTime)
                                endDate = Date.parse('yyyy-MM-dd HH:mm', startDateString + ' ' + endTime)
                                level = 'm'

                            }
                            // range-level record
                            else if (rest ==~ /\d{3}\.\d\d [\S\s]*/) {
                                startDate = Date.parse('yyyy-MM-dd', startDateString)

                                def endDateString = supportService.fromWeekDate(rest.split(/ /)[0])
                                endDate = Date.parse('yyyy-MM-dd', endDateString)

                                level = 'r'
                            }
                            // legacy journal format
                            else if (rest ==~ /\S [\S\s]*/) {
                                startDate = Date.parse('yyyy-MM-dd', startDateString)
                                endDate = startDate
                                level = rest.split(/ /)[0]
                            }
                            // instant journal format
                            else if (rest ==~ /\d{4} [\S\s]*/) {
                                level = 'i'
                                def startTime = rest.split(/ /)[0].substring(0, 2) + ':' + rest.split(/ /)[0].substring(2, 4)
                                startDate = Date.parse('yyyy-MM-dd HH:mm', startDateString + ' ' + startTime)
                                endDate = startDate
                            } else render "Input didn't matching any JP format!"

                            if (rest ==~ /[\S\s]* \d{4}[gctw] ; [\S\s]*/) { // there is a parent record for it.

                                def matcher = (rest =~ /[\S\s]* (\d{4})([gctw]) ; [\S\s]*/)
                                def parentType = matcher[0][2]
                                def parentId = matcher[0][1]

                                if (parentType == 'g')
                                    goal = Goal.get(parentId)
                                else if (parentType == 't')
                                    task = Task.get(parentId)
                                else if (parentType == 'c')
                                    course = Course.findBycode(parentId)
                                else if (parentType == 'w')
                                    writing = Writing.get(parentId)
                            }

                            // finally we save the record, of all types
                            if (isJournal) {
                                def j = new Journal([description: description, startDate: startDate, endDate: endDate, type: type, task: task, goal: goal, writing: writing, course: course, level: level])
                                if (!j.hasErrors() && j.save(flush: true))
//                          render(template: '/journal/line', model: [journalInstance: j])
                                    render(template: "/gTemplates/recordSummary", model: [record: j])
                                else render "J could not be saved"
                            } else {
                                def p = new Planner([description: description, startDate: startDate, endDate: endDate, type: type, task: task, goal: goal, writing: writing, course: course, level: level])
                                if (!p.hasErrors() && p.save(flush: true))
//                            render(template: '/planner/line', model: [plannerInstance: p])
                                    render(template: "/gTemplates/recordSummary", model: [record: p])
                                else render "P could not be saved"
                            }

                        } else if (input && input.startsWith('task ')) {
                            if (input ==~ /task [\w] [\S\s]*/) {// = [\S\s]*/) {
                                def body = input.substring(7)//input.indexOf(';') + 2)
//                        def deliverable = input.substring(input.indexOf('=') + 2)
                                def t = new Task([name: body,
                                        department: Department.findByCodeLike(input.split(/ /)[1]), status:
                                        WorkStatus.get(2), isTodo: false//, deliverable: deliverable
                                ])
                                if (!t.hasErrors() && t.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: t])
                                else render 'Task could not be saved'

                            } else render 'Format not matching'
                        } else if (input && input.startsWith('todo ')) {
                            if (input ==~ /todo [\w] [\S\s]*/) {// = [\S\s]*/) {
                                def body = input.substring(7)//input.indexOf(';') + 2)
//                        def deliverable = input.substring(input.indexOf('=') + 2)
                                def t = new Task([summary: body,
                                        department: Department.findByCodeLike(input.split(/ /)[1]), status:
                                        WorkStatus.get(2), isTodo: true//, deliverable: deliverable
                                ])
                                if (!t.hasErrors() && t.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: t])
                                else render 'Task could not be saved'

                            } else render 'Format not matching <br/>'
                        } else if (input && input.startsWith('topic ')) {
                            if (input ==~ /topic [\w] [\S\s]*/) {// = [\S\s]*/) {
                                def body = input.substring(7)//input.indexOf(';') + 2)
//                        def deliverable = input.substring(input.indexOf('=') + 2)
                                def t = new Task([summary: body,
                                        department: Department.findByCodeLike(input.split(/ /)[1]), status:
                                        WorkStatus.get(2), isTopic: true//, deliverable: deliverable
                                ])
                                if (!t.hasErrors() && t.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: t])
                                else render 'Task could not be saved'

                            } else render 'format not matching <br/>'
                        } else if (input && input.startsWith('goal ')) {
                            if (input ==~ /goal [\w]* [\w] ; [\S\s]*/) {
                                def goalType = GoalType.findByCode(input.split(/ /)[1])
                                def department = Department.findByCodeLike(input.split(/ /)[2])
                                //      def writing = Writing.get(input.split(/ /)[2])
                                //                        def department = writing.course?.department//
                                def title = input.substring(input.indexOf(';') + 2)//, input.indexOf('='))
                                //   def body = input.substring(input.indexOf('=') + 2)
                                //                        def g = new Goal([title: title, description: body, writing: writing, department: department,
                                //                                goalType: goalType, goalStatus: WorkStatus.get(1)])
                                def g = new Goal([summary: title, department: department,
                                        type: goalType, status: WorkStatus.get(1)])
//                        println g.dump()
                                if (!g.hasErrors() && g.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: g])
                                else {
                                    render 'Goal could not be saved'
                                    g.errors.each() {
                                        println it
                                    }
                                }

                            } else render 'format not matching <br/>'
                        } else if (input && input.startsWith('> ')) {
                            if (input ==~ /> [\w]* ; [\S\s]*/) {
                                def body = input.substring(input.indexOf(';') + 2).trim()
                                def id = input.split(/ /)[1]
                                Writing.get(id).description += '\n\n' + body + ' (' + new Date().format('dd.MM.yyyy HH:mm') + ')'
                                render(template: "/gTemplates/recordSummary", model: [record: Writing.get(id)])

                            } else render 'format not matching <br/>'
                        } else if (input && input.startsWith('wrt ')) {
                            if (input ==~ /wrt \d\d\d\d [\S\s]* = [\S\s]*/) {
                                def n = Writing.findByType(WritingType.get(22))
//                        n.title = input.substring(input.indexOf(';') + 2).trim()
                                n.summary = input.substring(9, input.indexOf('=') - 1).trim()
                                n.type = WritingType.get(10)
                                n.status = WritingStatus.get(1)
                                n.description = input.substring(input.indexOf('=') + 2).trim()
                                n.orderNumber = 9//input.split(/ /)[2].toFloat()
                                n.course = Course.findBycode(input.split(/ /)[1])

                                n.save(flush: true)
                                render(template: "/gTemplates/recordSummary", model: [record: n])

                            } else render 'format not matching <br/>'
                        }

                        // new writing with new id (for future use)
                        //                else if (input && input.startsWith('w')) {
                        //                    def type = WritingType.findByNameLike(input.split(/ /)[1])
                        //                    def course = Course.findBycodeLike(input.split(/ /)[2])
                        //                    def title = input.substring(input.indexOf(';') + 2, input.indexOf('|'))
                        //                    def body = input.substring(input.indexOf('|') + 2)
                        //                    def j = new Writing([title: title, body: body, type: type, course: course, writingStatus: WritingStatus.get(1)]).save(flush: true)
                        //                    render(template: '/writing/line', model: [writingInstance: j])
                        //                }
                        //                else if (input && input.startsWith('exr ')) {
                        //                    if (input ==~ /exr \d\d\d\d ; [\S\s]*/) {
                        //                        def book = Book.get(input.split(/ /)[1])
                        //                        def chapter = input.split(/ /)[2]
                        //                        def title = input.substring(input.indexOf(';') + 2)
                        //                        def j = new Excerpt([title: title, book: book]).save(flush: true)
                        //                        render(template: '/excerpt/line', model: [excerptInstance: j])
                        //                    } else render 'format not matching <br/>'
                        //                }
                        else if (input && input.startsWith('ind ')) {
                            if (input ==~ /ind \d{3}\.\d\d [\d]* [\d\.]*/) {
                                Date date = Date.parse('yyyy-MM-dd', supportService.fromWeekDate(input.split(/ /)[1]))
                                def indicator = Indicator.findByCode(input.split(/ /)[2])
                                def value = input.split(/ /)[3]
                                def d = new IndicatorData([indicator: indicator, date: date, value: value])
                                if (!d.hasErrors() && d.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: d])
                                else "Ind could not be saved"
                            } else if (input ==~ /ind \d{3}\.\d\d [\d]* [\d\.]* ; [\S\s]*/) {
                                Date date = Date.parse('yyyy-MM-dd', supportService.fromWeekDate(input.split(/ /)[1]))
                                def indicator = Indicator.findByCode(input.split(/ /)[2])
                                def value = input.split(/ /)[3]
                                def notes = null
                                if (input.indexOf(';') > 0)
                                    notes = input.substring(input.indexOf(';') + 2)?.trim()
                                def d = new IndicatorData([indicator: indicator, date: date, value: value, notes: notes])
                                if (!d.hasErrors() && d.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: d])
                                else "Ind could not be saved"
                            } else render 'format not matching <br/>'

                        } else if (input && input.startsWith('exp ')) {
                            if (input ==~ /exp \d{3}\.\d\d [\d]* [\d]*/) {
                                Date date = Date.parse('yyyy-MM-dd', supportService.fromWeekDate(input.split(/ /)[1]))
                                def category = PaymentCategory.findByCode(input.split(/ /)[2])
                                def value = input.split(/ /)[3]
                                def d = new Payment([category: category, date: date, amount: value])
                                if (!d.hasErrors() && d.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: d])
                                else "exp could not be saved"
                            } else if (input ==~ /exp \d{3}\.\d\d [\d]* [\d]* ; [\S\s]*/) {
                                Date date = Date.parse('yyyy-MM-dd', supportService.fromWeekDate(input.split(/ /)[1]))
                                def category = PaymentCategory.findByCode(input.split(/ /)[2])
                                def value = input.split(/ /)[3]
                                def notes = null
                                if (input.indexOf(';') > 0)
                                    notes = input.substring(input.indexOf(';') + 2)?.trim()
                                def d = new Payment([category: category, date: date, amount: value, description: notes])
                                if (!d.hasErrors() && d.save(flush: true))
                                    render(template: "/gTemplates/recordSummary", model: [record: d])
                                else "exp could not be saved"

                            } else render 'format not matching <br/>'

                        } else render '<br/><b>Line format not matching any defined format!</b>'
                    } catch (Exception e) {
                        render "An error has happened. See the logs."
                        e.printStackTrace()
                    }

                }

            }
            render '<br/> ' + count + ' lines were processed.'
        }

    }



    def fixWritingOrder() {
        Course.list().each() { c ->
            def o = 1
            Writing.findAllByCourse(c, [sort: 'orderNumber']).each() {
                println c.code + ' ' + it.orderNumber + ' - > ' + o
                it.orderNumber = o
                it.save(flush: true)
                println '            after ' + it.orderNumber + ' - > ' + o

                o++
            }
        }
    }



    def reindex() {
        searchableService.reindexAll()
//        searchableService.reindex()

        render(template: '/layouts/achtung', model: [message: 'Indexing completed'])
    }



    def lookup() {
        def q = params.q
        try {
            switch (params.entity) {
                case 'book':
                    if (Book.get(q.toLong()))
                        render(template: "/book/line", model: [bookInstance: Book.get(q.toLong())])
                    break
                case 'writing':
                    if (Writing.get(q.toLong()))
                        render(template: "/writing/line", model: [writingInstance: Writing.get(q.toLong())])
                    break
                case 'goal':
                    if (Goal.get(q.toLong()))
                        render(template: "/goal/line", model: [goalInstance: Goal.get(q.toLong())])
                    break
                case 'task':
                    if (q ==~ /\d\d\d\d/ && Book.get(q.toLong()))
                        render(template: "/task/line", model: [taskInstance: Task.get(q.toLong())])
                    break
            }
        } catch (Exception e) {
            render '?'
        }

    }


    def changedIndicatorData() {
        render(template: '/reports/changedIndicatorData')
    }

    def moveFile() {

        def path = session[params.id]

        def filename = path.split('/').last()
        def ant = new AntBuilder()
        ant.move(file: path, tofile: '/todo/ebk/' + filename)

    }

    def download() {

        def path = session[params.id]

          // todo to make it smarter!

        def f = new File(path)

        def corename = f.getName().split(/\./)[0]
        def entityCode = corename.substring(corename.length() - 1, corename.length())
        def id = corename.substring(0, corename.length() - 1)

        def title = ''
 /*       try {
            switch (entityCode) {
                case 'a':
                    title = Book.findById(id.toLong()).title
                    break
                case 'r':
                    title = (Book.findById(id.toLong()).title ?: '') + ' ' + (Book.findById(id.toLong()).legacyTitle ?: '')
                    break
                case 'n':
                    title = Book.findById(id.toLong()).title
                    break
                case 'e':
                    title = Excerpt.findById(id.toLong()).chapters + ' ' + Excerpt.findById(id.toLong()).summary
                    break

                case 'd':
                    title = IndexCard.findById(id.toLong()).summary
                    break
                case 'c':
                    title = IndexCard.findById(id.toLong()).summary
                    break

            }
            title = title.split(/\./)[0]

        }
        catch (Exception e) {
            title = ''
        }
    */

        def fileName = f.getName().split(/\./)[0]?.replaceAll(/\./, '-') + '_' + '.' + f.getName().split(/\./)[1]
        //+ new Date().format('yy') + 'y-' + getSupportService().toWeekDate(new Date())
		// + ' _ ' + title

//        println title + '  sad ' + entityCode + ' 2nd  ' + URLEncoder.encode(filename, "UTF-8")

        def finaln = fileName//.replaceAll(' ', '-')//URLDecoder.decode(fileName, 'UTF-8')
//        println URLEncoder.encode(finaln, 'UTF-8')

        if (f.exists()) {
            response.setCharacterEncoding("UTF-8");
            //response.setContentType("application/octet-stream")
//            response.setHeader("Content-disposition", "attachment; filename=\"" + finaln + "\"")
//            response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + finaln);

            response.setHeader("Content-Disposition",
                    "inline;filename*=UTF-8''${URLEncoder.encode(finaln, 'UTF-8').replaceAll(/\+/, '%20')}")

            // todo post
//                response.setHeader("Content-disposition", "attachment; filename=\"${filename}\"")
            response.outputStream << new FileInputStream(path)
        }

    }

    def openFile() {
        def path = session[params.id.toString()]

        def extension = path.split(/\./).last()
        def program
        switch (extension) {
            case 'pdf': program = "okular"
                break;

            case 'mobi': program = "calibre"
                break;

            case 'epub': program = "okular"
                break

            case 'djvu': program = "okular"
                break;
            case 'djv': program = "okular"
                break;

            case 'zip': program = "ark"
                break;

            case 'rar': program = "ark"
                break;

            case 'doc': program = "okular"
                break;

            case 'chm': program = "kchmviewer"
                break;
            case 'htm': program = "firefox"
                break;
            case 'txt': program = "kate"
                break;
        }
        try {
            println "${program} ${path}"
            "${program} ${path}".execute()

            render 'Book opened'
        } catch (Exception e) {
            render 'File CANNOT be opened'
            log.error e
        }

    }

    def test = {
        supportService.createLink(616, 'b')
    }




    def orderIcdInWrt() {

        def listtemp = params.table1

        def paramList = []
        if (listtemp && listtemp != 'null') {
            (listtemp?.class?.isArray()) ? paramList << (listtemp as List) : paramList << (listtemp)
            paramList = paramList.flatten()
        }
        def list = paramList


        def type = params.type
        def child = params.child
        def i = 1

        def lastId // id of last non-letter row
        params['table' + params.tableId].each() {

            try {
                def j = Integer.parseInt(it)
                def f

//                    if (child == 'C')
//                        f = IndexCard.get(j)
//                    else if (child == 'T')
//                        f = Task.get(j)
//                   else if (child == 'B')
//                        f = Book.get(j)
//                   else if (child == 'G')
//                        f = Goal.get(j)

                f = grailsApplication.classLoader.loadClass(entityMapping[child]).get(j)

                if (type == 'W')
                    f.orderInWriting = i
                else if (type == 'B')
                    f.orderInBook = i
                else if (type == 'G')
                    f.orderInGoal = i
                else if (type == 'C')
                    f.orderInCourse = i


                i++
            } catch (Exception e) {
                println 'Problem in sorting the records'
                println e.printStackTrace()
            }
        }

        render('Cards ordered')

    }


    def folderPdfMetadataTitleUpdate() {
        def path = OperationController.getPath('onyx.path')
        new File(path).eachFileMatch(~/[\w\W\S\s]*\.pdf/) { file ->
            supportService.pdfTitleUpdate(path, file.name, '')
        }
    }


    def editBoxShow() {
        render(template: '/reports/editBoxShow', model: [])
    }

    def editBoxCheckout(){
        if (new File(OperationController.getPath('editBox.path')).listFiles().size() > 0){
            render 'Edit folder is not empty. Delete all files before checking out.'
            render(template: '/reports/editBoxShow', model: [])
        }
        for (r in IndexCard.findAllByBookmarked(true) + Writing.findAllByBookmarked(true)){
            def filename = r?.summary ?: 'Untitled'
            for (c in '?"/\\*:<>' + '!$^&{}|'){
                filename = filename.replace(c, ' ')
            }
            new File(OperationController.getPath('editBox.path') + '/' + r.entityCode() +'_' + r.id  + ' ' + filename + '.txt').text = r?.description ?: '...'
        }
        render(template: '/reports/editBoxShow', model: [])

    }
 def editBoxCommit(){

     for (f in new File(OperationController.getPath('editBox.path')).listFiles()){

         def ID = f.name.split(' ')[0].split('_')
         def record
             if (ID[0] == 'N')
                 record = IndexCard.get(ID[1])
     else
    record =  Writing.get(ID[1])

         record.description = f.text


     }



     render(template: '/reports/editBoxShow', model: [])
    }

    def backupH2DB = {
        def dbdir = "./data/pkm-database.h2.db"
        render org.h2.tools.Script.execute("jdbc:h2:file:${dbdir};MVCC=TRUE;LOCK_TIMEOUT=10000;MODE=MySQL;IGNORECASE=TRUE;",
                'admin', 'admin',
                './data/pkm.sql')
    }

    static def getPath(String code){
        if (Setting.findByName('appFolder'))
        return Setting.findByName(code)?.value?.replace(/[appFolder]/, Setting.findByName('appFolder')?.value)
        //System.properties['catalina.base'] ?: '.')
        else
            return Setting.findByName(code)?.value?.replace(/[appFolder]/, '.')
    }


    static def getFileListing(String code){
        return new File(OperationController.getPath('editBox.path')?.replace(/[appFolder]/, System.properties['catalina.base'] ?: '.')).listFiles()

    }

    def asciidoc = {

        Asciidoctor asciidoctor = create();
def code= """
= Introduction to AsciiDoc
Doc Writer <doc@example.com>

A preface about http://asciidoc.org[AsciiDoc].

== First Section

* item 1
* item 2

[source,ruby]
puts "Hello, World!"
"""
        String rendered = asciidoctor.render(
                code, [:]);
        render(rendered);

    }



    def addBibtex(Long id) {

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
                    //object
                    render ff
//                    render(template: '/gTemplates/recordDetails', model: [record:
//                            it
//                    ])

                }
            }
            catch (Exception e) {
                render(template: '/layouts/achtung', model: [message: "Problem..."])
                log.warn('problem in getting bib entry of b' + it.id) //e.printStackTrace()
            }
        }

    }

//    static org.asciidoctor.Asciidoctor asciidoctor = org.asciidoctor.Asciidoctor.Factory.create();
//    static String convertAsciiDocToHtml (Long id) {
//        return asciidoctor.render(Writing.get(id).description, [:])
//    }
    org.asciidoctor.Asciidoctor asciidoctor = org.asciidoctor.Asciidoctor.Factory.create();
    def convertAsciiDocToHtml () {

        render asciidoctor.render(Writing.get(params.id).description, [:])
    }

    def autoCompleteTagsJSON() {
        def responce = []

//        if (params.query && params.query.trim() != '') {
//            Tag.findAllByNameLike(params.query + '%', [sort: 'id']).each() {
//                println 'here'
//                responce += [
//                        id: it.id,
//                        value: it.value,
//                        text: it.name]
//            }
//        } else {
        Tag.findAll([sort: 'id']).each() {
                responce += [
                        id: it.id,
                    value: it.name,
                        text: it.name]
            }
//    }
        render responce as JSON
    }
    def autoCompleteContactsJSON() {
        def responce = []
//        if (params.query && params.query.trim() != '') {
//            Tag.findAllByNameLike(params.query + '%', [sort: 'id']).each() {
//                println 'here'
//                responce += [
//                        id: it.id,
//                        value: it.value,
//                        text: it.name]
//            }
//        } else {
        Contact.findAll([sort: 'id']).each() {
                responce += [
                        id: it.id,
                    value: it.summary,
                    text: it.summary]
            }
//    }
        render responce as JSON
    }

    def autoCompleteBlogsJSON() {
        def responce = []

//        if (params.term && params.term.trim() != '') {
//            Tag.findAllByNameLike(params.term + '%', [sort: 'name']).each() {
//                responce += it.name + '\n'
//            }
//        } else {
            Blog.findAll([sort: 'code']).each() {
                responce += [
                        value: it.id,
                        text: it.code]
            }
//        }
        render responce as JSON
    }

    def autoCompleteTags() {
        def responce = ''

        if (params.term && params.term.trim() != '') {
            Tag.findAllByNameLike(params.term + '%', [sort: 'name']).each() {
                responce += it.name + '\n'
            }
        } else {
            Tag.findAll([sort: 'name']).each() {
                responce += it.name + '\n'
            }
        }
        render responce
    }
 def autoCompleteContacts() {
        def responce = ''

        if (params.q && params.q.trim() != '') {
            Contact.findAllBySummaryLike('%' + params.q + '%', true, [sort: 'summary']).each() {
                responce += it.summary + '\n'
            }
        } else {
            Contact.findAll([sort: 'summary']).each() {
                responce += it.summary + '\n'
            }
        }
        render responce
    }


    def addUser (Long id) {

        def c = Contact.get(id)
        def role = c.role

        def user = new User(username: c.username, enabled: true, password: c.initialPassword)

        user.save(flush: true)
        UserRole.create(user, role, true)

        render 'User account created'

    }

    def downloadNoteFile = {
        def file = IndexCard.get(params.id)

        if (new File(OperationController.getPath('module.sandbox.N.path') + '/' + file.id).exists()) {
            response.setHeader("Content-disposition", "attachment; filename=\"${file.fileName}\"")
            //   response.contentType = "application/vnd.ms-word"
            response.outputStream << new FileInputStream(OperationController.getPath('module.sandbox.N.path')+ '/' + file.id)
        } else if (new File(OperationController.getPath('module.repository.N.path') + '/' + file.id).exists()) {
            response.outputStream << new FileInputStream(OperationController.getPath('module.repository.N.path') + '/' + file.id)
        } else {
            render "Document was not found."
        }

    }


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


    def getQuickEditValues() {
        def entity = params.entity
        def field = params.field
        def responce = []
        if(entity == 'N' && field == 'blog'){
            Blog.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
        else if (field == 'pomegranate') {
            Pomegranate.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
        else if (field == 'department') {
            Department.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.summary]
            }
        }
         else if (field == 'course') {
            Course.findAll([sort: 'summary']).each() {
                responce += [value: it.id,
                        text: it.summary]
            }
        }
        else if (field == 'markdown') {
            Markdown.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.summary]
            }
        }
        else if (entity == 'T' && field == 'context') {
            Context.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
        else if (entity == 'G' && field == 'type') {
            GoalType.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
        else if ('WN'.contains(entity) && field == 'type') {
            WritingType.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
        else if ('R'.contains(entity) && field == 'type') {
            ResourceType.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
      else if ('R'.contains(entity) && field == 'status') {
            ResourceStatus.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
        else if('GTP'.contains(entity) && field == 'status') {
            WorkStatus.findAll([sort: 'code']).each() {
                responce += [value: it.id,
                        text: it.code]
            }
        }
        else if('TPJ'.contains(entity) && field == 'goal') {
            Goal.findAll([sort: 'summary']).each() {
                responce += [value: it.id,
                        text: it.summary]
            }
        }
        else if('NJ'.contains(entity) && field == 'writing') {
            Writing.findAll([sort: 'summary']).each() {
                responce += [value: it.id,
                        text: it.summary]
            }
        }
        else if (field == 'plannedDuration') {
            (1..10).each() {
                responce += [value: it,
                        text: it]
            }
        }
        else if (field == 'priority') {
            (1..4).each() {
                responce += [value: it,
                        text: it]
            }
        }
        else if (field == 'percentCompleted') {
            (1..10).each() {
                responce += [value: it * 10,
                        text: it * 10]
            }
        }
        render responce as JSON
    }

    def quickSave2() {
        def id = params.pk
        def newValue = params.value
        def field = params.name.split('-')[0]
        def entity = params.name.split('-')[1]

        def record = grailsApplication.classLoader.loadClass(entityMapping[entity]).get(id)

        if (field == 'blog')
            record[field] = Blog.get(newValue)

        else if (field == 'pomegranate')
            record[field] = Pomegranate.get(newValue)
        else if (field == 'course')
            record[field] = Course.get(newValue)
        else if (field == 'goal')
            record[field] = Goal.get(newValue)
        else if (field == 'writing')
            record[field] = Writing.get(newValue)
        else if (field == 'context')
            record[field] = Context.get(newValue)

        else if (field == 'location')
            record[field] = Location.get(newValue)

        else if (entity == 'G' && field == 'type')
            record[field] = GoalType.get(newValue)
        else if (entity == 'P' && field == 'type')
            record[field] = PlannerType.get(newValue)
        else if (entity == 'J' && field == 'type')
            record[field] = JournalType.get(newValue)
        else if (entity == 'R' && field == 'type')
            record[field] = ResourceType.get(newValue)

        else if ('GTP'.contains(entity) && field == 'status')
            record[field] = WorkStatus.get(newValue)
   else if ('R'.contains(entity) && field == 'status'){
            record[field] = ResourceStatus.get(newValue)
     
        }


        else if (field == 'plannedDuration')
            record[field] = newValue.toInteger()
        else if (field == 'priority')
            record[field] = newValue.toInteger()
        else if (field == 'percentCompleted')
            record[field] = newValue.toInteger()

        render(['ok'] as JSON)
    }

    
    
    def generateCover(){

        String pdfPath = params.path

        if (params.module == 'E')
            params.type = 'exr'

        //config option 2:convert page 1 in pdf to image
        String [] args_2 = new String[7];
        args_2[0] = "-startPage";
        args_2[1] = "1"
        args_2[2] = "-endPage";
        args_2[3] = "1";
        args_2[4] = "-outputPrefix"
        args_2[5] = OperationController.getPath('covers.sandbox.path') + '/' + (params.type ? '/' + params.type : '') + '/' + params.id;
        args_2[6] = pdfPath;

               try {
           // will output "my_image_2.jpg"
           PDFToImage.main(args_2);
                   def ant = new AntBuilder()
                   ant.move(file: args_2[5] + '1.jpg', tofile: (args_2[5] + '.jpg'))

            }
        catch (Exception e) { 
            e.printStackTrace()
        }
    }

} // end of class