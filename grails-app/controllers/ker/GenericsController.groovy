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

import app.Contact
import app.IndexCard
import app.Indicator
import app.PaymentCategory
import app.Tag
import app.parameters.CommandPrefix
import app.parameters.Pomegranate
import app.parameters.WordSource
import app.parameters.ResourceType
import app.parameters.Blog
import cmn.Setting
import mcs.*
import mcs.parameters.*
import org.apache.commons.lang.StringUtils
import grails.converters.JSON

class GenericsController {

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
            'X': 'mcs.parameters.SavedSearch',
            'A': 'app.parameters.CommandPrefix',
//todo for all params
            'ResourceType': 'app.parameters.ResourceType'
    ]

    static allClasses = [
            mcs.Goal,
            mcs.Task,
            mcs.Planner,

            mcs.Journal,
            app.IndicatorData,
            app.Payment,

            mcs.Writing,
            app.IndexCard,
            mcs.Course,

            mcs.Book,
            mcs.Excerpt,

//            app.parameters.WordSource,
            app.Indicator,
            app.PaymentCategory,
            app.Contact,
            mcs.parameters.SavedSearch
    ]

    static allClassesWithCourses = allClasses -
            [mcs.Excerpt, mcs.Course,
                    app.IndicatorData, app.Payment, app.PaymentCategory, app.Indicator]

    static allClassesWithCoursesMinusBW = allClasses -
            [mcs.Excerpt, mcs.Course, mcs.Book, mcs.Writing,
                    app.IndicatorData, app.Payment, app.PaymentCategory, app.Indicator, mcs.parameters.SavedSearch]

    // Todo for what?
    static mainClasses = allClasses - [mcs.Course]
    static nonResourceClasses = [
            mcs.Goal,
            mcs.Task,
            mcs.Planner,

            mcs.Journal,
            app.IndicatorData,
            app.Payment,


            mcs.Writing,
            app.IndexCard,
            app.Contact,

            mcs.Excerpt
    ]


    static selectedRecords = [:]

    def supportService
    def searchableService


    def actionDispatcher(String input) {
        try {
            if (input && input.trim() != '') {

                if (input == '?')
                    render(template: '/page/help')

//                def file = new File("/log/mcs/${new Date().format('dd.MM.yyyy')}.mcs")

                def commandType = input.trim().split(/[ ]+/)[0]
                def commandBody
                if (input.contains(' ')) {
                    commandBody = input.substring(input.indexOf(' ')).trim()
                    switch (commandType) {
                        case 'a':
//                            try {
//                                if (file.exists())
//                                    file.text += input + '\n'
//                                else
//                                    file.text = input + '\n'
//                            } catch (Exception e) {
//                                println 'Could not write to Pomegranate log file'
//                            }

                            quickAdd(commandBody)

                            break
                        case 'f': findRecords(commandBody)
                            break
                        case 'i': importPost(commandBody)
                            break
                        case 'q': queryRecords(commandBody)
                            break
                        case 'h': adHocQuery(commandBody)
                            break
                        case 's': luceneSearch(commandBody)
                            break
                        case 'p': assignCommand(commandBody)
                            break
                        case 't': batchAddTagToRecords(commandBody)
                            break
                        case 'b': repostRecords(commandBody)
                            break
                         case 'x': batchLogicallyDeleteRecords(commandBody)
                            break
                         
                        case 'X': batchPhysicallyDeleteRecords(commandBody)
                            break

                        case 'u': updateCommand(commandBody)
                            break
                        case 'U': updateCommandWithId(commandBody)
                            break
                        case 'l': lookup(commandBody)
                            break
                        case 'v': convertDate(commandBody)
                            break
                        default:
                            render '<br/>Wrong input!'
                    }
                }
            }
        } catch (Exception e) {
            render('Exception occurred: ' + e.toString())
        }
    }

    // this now the used action dispatcher
    def batchAddPreprocessor(Long commandPrefix, String block) {

        def prefixRecord = CommandPrefix.get(commandPrefix)
        def prefix = prefixRecord.description ?: ''

        if (prefixRecord.multiLine){
             block.eachLine(){
                 batchAdd(prefix + it)
             }
        }
        else
        batchAdd(prefix + block.trim())

      render ''
    }
    def batchAdd(String block) {
        def metaType = block.trim().split(/[ ]+/)[0]
        if (metaType == 'A') {
            block.split(/\*\*\*/).each(){region ->
            addWithDescription(region?.trim())
            }
        }
        else {

            block.eachLine { input ->
                input = input.trim()
                if (input && input != '') {

//                    def file = new File("/todo/new/${new Date().format('dd.MM.yyyy')}.mcs") //todo


                    def commandType = input.trim().split(/[ ]+/)[0]
                    def commandBody
                    if (input.contains(' ')) {
                        commandBody = input.substring(input.indexOf(' ')).trim()
                       // println 'command ' + commandBody
                        switch (commandType) {
                            case 'a':
//                                try {
//                                    if (file.exists())
//                                        file.text += input + '\n'
//                                    else
//                                        file.text = input + '\n'
//                                } catch (Exception e) {
//                                    println 'cound not write to mcs-dev-actions.txt'
//                                }
                                quickAdd(commandBody)

                                break
                            case 'f': findRecords(commandBody)
                                break
                            case 'h': adHocQuery(commandBody)
                                break
                            case 'g': importPost(commandBody)
                                break
                            case 's': luceneSearch(commandBody)
                                break
                            case 'p': assignCommand(commandBody)
                                break
                            case 'q': queryRecords(commandBody)
                                break

                            case '!': updateRecordsByQuery(commandBody)
                                break
                            case 't': batchAddTagToRecords(commandBody)
                                break
                                case 'b': repostRecords(commandBody)
                            break
                            case 'x': batchLogicallyDeleteRecords(commandBody)
                                break

                            case 'X': batchPhysicallyDeleteRecords(commandBody)
                                break

                            case 'r': randomGet(commandBody)
                                break
                            case '+': parameterAdd(commandBody)
                                break

                            case 'u': updateCommand(commandBody)
                                break
                            case 'U': updateCommandWithId(commandBody)
                                break
                            case 'l': lookup(commandBody)
                                break
                            case 'v': convertDate(commandBody)
                                break
                            default:
                                render '<br/>Wrong input!'
                        }
                    }
                }
            }
        }
    }


    def commandBarAutocomplete() {

        def input = params.q.trim()
        def entityCode
        def hintResponce = ' '
        def responce = ' '
        def hint = (params.hint == '1')

        if (!input || input?.trim() == '') {
            hintResponce = ''''''
        } else if (input && input?.trim() == '?') {
            hintResponce = '''
a : Add new records
g : Import posts as notes
f : HQL query in Pomegranate syntax
s : Full-text search
h : Ad hoc query e.g. select id, title from Book
u : Update selected records of type
U : Update record with ID
p : Assign selected tasks or goals to days
q : Query records using HQL code
v : Convert dates yyyy-MM-dd / WWd[.yy]
'''
        } else {

            try {
                if (input.length() < 4) {
                    switch (input.substring(0, 1)) {
                        case 'a': hintResponce = "[type] p? c???? #type @status/location b???? !ind <startDate  >endDate (<>ddd[.yy][_HH[mm]] or <>-+dd) ; summary ;; description".encodeAsHTML()
                            break
                        case 's': hintResponce = 'c | w | m | b <lucene query>'
                            break
                        case 'f': hintResponce = "<type> <Pomegranate syntax>".encodeAsHTML()
                            break
                        case 'g': hintResponce = "<blogId> <postId>".encodeAsHTML()
                            break
                        case 'u': hintResponce = '<type> <Pomegranate syntax>'
                            break
                        case 'U': hintResponce = '<type> ID <Pomegranate syntax>'
                            break
                        case 'p': hintResponce = '<type> <t|g> <Pomegranate syntax to add plans>'
                            break
//                        case '=': hintResponce = '<type><id>'
//                            break
//                    case 'q': hintResponce = '<type> ??? p? c???? #type @location b???? <startDate >endDate'
//                        break
//                    case 'p': hintResponce = 'assign <type> to days'
//                        break
                        case 'h': hintResponce = 'ad hoc query e.g. h select id, description from Planner'
                            break
                    }
                }

//                if (input.substring(0, 1) == '!')
//                    entityCode = input.split(/[ ]+/)[2].toUpperCase()
//                else
                entityCode = input.split(/[ ]+/)[1].toUpperCase()

                def lastCharacter = input.split(/[ ]+/).last().substring(0, 1)



                def filter
                if (input.split(/[ ]+/).last().length() > 1)
                    filter = input.split(/[ ]+/).last().substring(1) + '%'
                else
                    filter = '%'

                def finalPart = input.substring(0, input.length() - filter.length())





                if (input.contains('###') || input.length() == 1)
                    return ' '
                else {
                    switch (lastCharacter) {
                        case 'p': responce = """1|p1
2|p2
3|p3
4|p4"""
                            hintResponce = """p1
p2
p3
p4"""
                            break
                        case 'c': Course.findAllByCodeLike(filter, [sort: 'code']).each() {
                            responce += (it.toString() + '|' + finalPart + ' c' + it.code + '\n')
                            hintResponce += (it.toString() + '\n')
                        }
                            break
                        case 'C': Course.findAllByCodeLike(filter, [sort: 'code']).each() {
                            responce += (it.toString() + '|' + finalPart + ' C' + it.code + '\n')
                            hintResponce += (it.toString() + '\n')
                        }
                            break
                        case '#': switch (entityCode) {
                            case 'W': WritingType.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' #' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'N': WritingType.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' #' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'J': JournalType.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' #' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'P': PlannerType.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' #' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'G': GoalType.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' #' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                        }
                            break
                        case '?': switch (entityCode) {

                            case 'W': WritingStatus.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' ?' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                                 break
                            case 'I': WritingStatus.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' ?' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'P': WorkStatus.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' ?' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'G': WorkStatus.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' ?' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'T': WorkStatus.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' ?' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'R': ResourceStatus.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' ?' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break

                        }
                            break

                        case '!': switch (entityCode) {
                            case 'I': Indicator.findAllByCodeLike(filter, [sort: 'summary']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' @' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'Q': PaymentCategory.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' @' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                        }
                            break
                        case 'g':
                            if (filter.length() > 2) {
                                switch (entityCode) {
                                    case 'G': Goal.findAllBySummaryLike('%' + filter, [sort: 'summary']).each() {
                                        responce += ('' + it.summary + '|' + finalPart + ' @' + it.summary + '\n')
                                        hintResponce += (it.id + ' ' + it.summary + '\n')
                                    }
                                        break
                                    case 'T': Goal.findAllBySummaryLike('%' + filter, [sort: 'summary']).each() {
                                        responce += ('' + it.summary + '|' + finalPart + ' @' + it.summary + '\n')
                                        hintResponce += (it.id + ' ' + it.summary + '\n')
                                    }
                                        break
                                }
                            }
                            break
                        case 'w':
                            if (filter.length() > 2) {
                                switch (entityCode) {
                                    case 'G': Writing.findAllBySummaryLike('%' + filter, [sort: 'summary']).each() {
                                        responce += ('' + it.summary + '|' + it.id + ' @' + it.summary + '\n')
                                        hintResponce += (it.id + ' ' + it.summary + '\n')
                                    }
                                        break
                                    case 'N': Writing.findAllBySummaryLike('%' + filter, [sort: 'summary']).each() {
                                        responce += ('' + it.summary + '|' + it.id + ' @' + it.summary + '\n')
                                        hintResponce += (it.id + ' ' + it.summary + '\n')
                                    }
                                        break
                                }
                            }
                            break
                        case 'r':

//                            if (filter.length() > 1){
                            Book.findAllById(filter.replace('%', ''), [sort: 'title']).each() {

                                responce += ('' + it.title + '|' + it.id + ' @' + it.title + '\n')
                                hintResponce += (it.id + ' ' + it.title + '\n')
                            }
//                            }
                            break
                        case '@': switch (entityCode) {
                            case 'T': Context.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.name + '|' + finalPart + ' @' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break
                            case 'N': Contact.findAllByCodeLike(filter, [sort: 'name']).each() {
                                responce += ('' + it.summary + '|' + finalPart + ' @' + it.code + '\n')
                                hintResponce += ('' + it.code + '\n')
                            }
                                break

                        }
                            break
                        case 'l': responce = """i|li
h|lh
d|ld
w|lw
M|lM
r|lr
y|ly
e|le
l|ll
"""
                            hintResponce = """li
lh
ld
lw
lM
lr
ly
le
ll
"""
                            break
                        case 'd': Department.findAllByCodeLike(filter, [sort: 'code']).each() {
                            responce += (it.toString() + '|' + finalPart + ' d' + it.code + ' ; \n')
                            hintResponce += (it.toString() + '|' + finalPart + ' d' + it.code + ' ; \n')
                        }
                            break

                    }
                }
            } catch (Exception e) {
                responce = 'Error occurred'
            }
        }

        //////////// validation
        /* bandwidth consuming checks
        input.eachLine() { line, i ->

            if (line && line.substring(0, 1).toLowerCase() == 'a') {
                def properties
                try {
                    properties = transformMcsNotation(line.substring(line.indexOf(' ')).trim())['properties']
                } catch (Exception) {
                    render("<span style='color: red'>Error parsing line $i</span><br/>")
                    println 'Error parsing line' + i
                }

                def n = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).newInstance()
                if (!properties) {
                    render("<span style='color: red'>Error parsing properties $i</span><br/>")
                    println 'Error parsing properties' + i
                } else {
                    n.properties = properties

                    if (n.hasErrors()) {

                        render("<span style='color: red'>Record has error $i</span><br/>")
                        println('record has error')
                    }
                }

            }


             }

*/

        if (hint)
            render(hintResponce?.replaceAll('\n', '<br/>'))
        else
            render(responce)

    }



    def showDetails(Long id, String entityCode) {
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

        render(template: '/gTemplates/recordDetails', model: [record: record])
        //  render(template: "/${record.entityController()}/edit", model: ["${record.entityController()}Instance": record, update: '${record.entityCode()}Record${record.id}'])
    }

    def showIndexCards(Long id, String entityCode) {

//        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
        if ('R'.contains(entityCode)) {
            render(template: '/indexCard/add', model:
                    [bookId: id, recordEntityCode: 'R', recordId: id])
        } else if ('W'.contains(entityCode)) {
            render(template: '/indexCard/add', model:
                    [writingId: id, recordEntityCode: 'W', recordId: id])
        } else {
            render(template: '/indexCard/add', model:
                    [recordId: id, recordEntityCode: entityCode])
        }

        //  render(template: "/${record.entityController()}/edit", model: ["${record.entityController()}Instance": record, update: '${record.entityCode()}Record${record.id}'])
    }

    def showSummary(Long id, String entityCode) {
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
        render(template: '/gTemplates/recordSummary', model: [record: record])
    }

    def logicalDelete(Long id, String entityCode) {
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
        try {
//        record.delete()
            record.deletedOn = new Date()
//        render(template: '/layouts/achtung', model: [message: "Record with ID ${id} deleted"])
            render(template: '/gTemplates/recordSummary', model: [record: record])
        }
        catch (Exception) {
//            render(template: '/layouts/achtung', model: [message: "Record with ID ${id} could not be deleted"])
        }
    }

    def physicalDelete(Long id, String entityCode) {
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
        try {
        record.delete()
        render(template: '/layouts/achtung', model: [message: "Record with ID ${id} deleted"])
//            render(template: '/gTemplates/recordSummary', model: [record: record])
        }
        catch (Exception) {
            render(template: '/layouts/achtung', model: [message: "Record with ID ${id} could not be deleted"])
        }
    }
 def convertNoteToRecord() {
        def oldRecord = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
        try {
            def newRecord
        if (params.type == 'J'){
            newRecord = new Journal()
            newRecord.title = oldRecord.title
            newRecord.description = oldRecord.description
            newRecord.startDate = oldRecord.writtenOn
            newRecord.priority = oldRecord.priority
            newRecord.bookmarked = oldRecord.bookmarked
            newRecord.save()
//            newRecord.dateCreated = oldRecord.dateCreated

        }
//        render(template: '/layouts/achtung', model: [message: "Record with ID ${id} deleted"])
            render(template: '/gTemplates/recordSummary', model: [record: newRecord])
        }
        catch (Exception) {
            render(template: '/layouts/achtung', model: [message: "Record with ID ${id} could not be deleted"])
        }
    }

    def logicalUndelete(Long id, String entityCode) {
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
        try {
//        record.delete()
            record.deletedOn = null
//        render(template: '/layouts/achtung', model: [message: "Record with ID ${id} deleted"])
            render(template: '/gTemplates/recordSummary', model: [record: record])
        }
        catch (Exception) {
//            render(template: '/layouts/achtung', model: [message: "Record with ID ${id} could not be deleted"])
        }
    }

    def bookmark(Long id, String entityCode) {
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

        if (!record.bookmarked) {
            record.bookmarked = true
        } else
            record.bookmarked = false

        render(template: '/gTemplates/recordSummary', model: [record: record])
    }

    def togglePrivacy() {
        def entityCode = params.id.split('-')[0]//substring(0, 1)
        def id = params.id.split('-')[1].toLong()

        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
        if ('GTJPBWC'.contains(entityCode)) {

            if (record.isPrivate == true) {
                record.isPrivate = false
            } else {
                record.isPrivate = true
            }

            render(template: '/gTemplates/recordSummary', model: [record: record])
        }

    }


    def markCompleted(Long id, String entityCode) {

        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

        if ('GTP'.contains(entityCode)) {
            record.completedOn = new Date()
//        record.percentComplete = new Date()
            record.status = WorkStatus.findByCode('completed')
        }
      else  if ('RE'.contains(entityCode)) {
            record.lastReviewed = new Date()
            if (!record.reviewCount)
                record.reviewCount = 1
            else
            record.reviewCount++

            if (!record.readOn){
                record.readOn = new Date()
            }
        }
            else if ('JN'.contains(entityCode)) {
            record.lastReviewed = new Date()
        }


        render(template: '/gTemplates/recordSummary', model: [record: record])
        render(template: '/layouts/achtung', model: [message: 'Record marked as completed'])
    }




    def markReady(Long id, String entityCode) {

        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

        if (!'BR'.contains(entityCode)) {
            //    record.completedOn = new Date()
//        record.percentComplete = new Date()
            record.status = WorkStatus.findByCode('ready')
        }
        //  else {
        //      record.readOn = new Date()
        //  }

        render(template: '/gTemplates/recordSummary', model: [record: record])
        render(template: '/layouts/achtung', model: [message: 'Record marked as ready'])
    }



    def quickBookmark() {
        def entityCode = params.id.split('-')[0]//substring(0, 1)
        def id = params.id.split('-')[1].toLong()
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

        if (!record.bookmarked) {
            record.bookmarked = true
        } else
            record.bookmarked = false

        render(template: '/gTemplates/recordSummary', model: [record: record])
    }

    def increasePriority() {
        def entityCode = params.id.substring(0, 1)
        def id = params.id.substring(1).toLong()
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

        if (!record.priority) {
            record.priority = 3
        } else if (record.priority != 4) {
            record.priority = record.priority + 1
        } else if (record.priority == 4) {
            record.priority = 3
        }


        render(template: '/gTemplates/recordSummary', model: [record: record])
    }

    def setEndDateToday() {
        def entityCode = params.id.substring(0, 1)
        def id = params.id.substring(1).toLong()
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

       record.endDate = new Date()
        render(template: '/gTemplates/recordSummary', model: [record: record])
    }
  def increasePercentCompleted() {
        def entityCode = params.id.substring(0, 1)
        def id = params.id.substring(1).toLong()
        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)

        if (!record.percentCompleted) {
            record.percentCompleted = 10
        } else if (record.percentCompleted != 100) {
            record.percentCompleted = record.percentCompleted + 10
        } else{
            record.percentCompleted = 90
        }
        render(template: '/gTemplates/recordSummary', model: [record: record])
    }



    def setRecordBlog() { //Long id, String entityCode, String blogCode
        def record = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)

        record.blogCode = params.blogCode
        record.publishedNodeId = params.publishedNodeId ?: null
        record.publishedOn = params.publishedOn ? Date.parse('dd.MM.yyyy', params.publishedOn) : null

        render(template: '/layouts/achtung', model: [message: 'Record blog set to ' + record.blogCode])
    }

    /* 2012-09-30: First usage of Grails power and the generic record template to reduce repetitive code */

    def showBookmarkedRecords() {
        def results = []
        allClasses.each() {
            results += it.findAllByBookmarked(true, [max: 10])
        }
        render(template: '/gTemplates/recordListing', model: [list: results, title: 'Bookmarked records'])
    }

    def recordsByCourse() {

        def course = Course.get(params.id)
        def results = [course]

        allClassesWithCoursesMinusBW.each() {
            results += it.findAllByCourse(course)
        }

        results += Writing.findAllByCourse(course, [sort: 'orderInCourse', order: 'asc'])
        results += Book.findAllByCourse(course, [sort: 'orderInCourse', order: 'asc'])


        render(template: '/gTemplates/recordListing', model: [list: results, title: 'Records with course ' + course])
    }

    def dotTextDump() {
        def results = []


        def f, csv
        def contents, csvContents
        def path = OperationController.getPath('export.recordsToText.path')
        csv = new File(path + '/all.csv')
        csvContents = ''
        csvContents += "Tb,ID,Version,Priority,Created,Updated,Summary,Description,Notes,Course,Type,Status,Location,Start,End,Level,Reality,Indicator,Date,Value,Title,Published,Book\n"

        for (C in ['G', 'T', 'P', 'W', 'N', 'J', 'E']) {

            def c = grailsApplication.classLoader.loadClass(entityMapping[C])
            f = new File(path + '/' + C + '.txt')

            def array, csvArray


            contents = ''



            def none = "-"
            for (r in c.findAll([sort: 'id'])) {
                array = []
                csvArray = [C]
                array.add('ID: ' + r.id)
                array.add('Version: ' + r.version)

                array.add('Priority: ' + r.priority)
                array.add('Date created:' + r.dateCreated?.format('dd.MM.yyyy')) //HH:mm:ss
                array.add('Last updated:' + r.lastUpdated?.format('dd.MM.yyyy'))

                array.add('Summary: ' + r.summary)
                array.add('Description: ' + r.description)
                array.add('Notes: ' + r.notes)


                csvArray.add(r.id)
                csvArray.add(r.version)

                csvArray.add(r.priority)
                csvArray.add(r.dateCreated?.format('dd.MM.yyyy HH:mm:ss'))
                csvArray.add(r.lastUpdated?.format('dd.MM.yyyy HH:mm:ss'))

                csvArray.add(StringUtils.abbreviate(r.summary, 120)) //r.summary?.replaceAll('\n',' -- ')
                csvArray.add(StringUtils.abbreviate(r.description, 120))
                csvArray.add(StringUtils.abbreviate(r.notes, 120))


                if ('GTJPWINR'.contains(C)) {
                    array.add('Course: ' + r.course.toString())
                    csvArray.add(r.course.toString())
                } else
                    csvArray.add(none)

                if ('GJPWNR'.contains(C)) {
                    array.add('Type: ' + r.type)
                    csvArray.add(r.type)
                } else
                    csvArray.add(none)


                if ('GWRTP'.contains(C)) {
                    array.add('Status: ' + r.status)
                    csvArray.add(r.status)
                } else
                    csvArray.add(none)



                if ('T'.contains(C)) {
                    array.add('Location:' + r.location)
                    csvArray.add(r.location)
                } else
                    csvArray.add(none)

//                if (''.contains(C)) {
//                  //  array.add('Status:' + r.status)
//                }

                if ('JP'.contains(C)) {
                    array.add('Start date:' + r.startDate?.format('dd.MM.yyyy HH:mm'))
                    array.add('End date:' + r.endDate?.format('dd.MM.yyyy HH:mm'))
                    array.add('Level:' + r.level)

                    csvArray.add(r.startDate?.format('dd.MM.yyyy HH:mm'))
                    csvArray.add(r.endDate?.format('dd.MM.yyyy HH:mm'))
                    csvArray.add(r.level)

                } else {
                    csvArray.add(none)
                    csvArray.add(none)
                    csvArray.add(none)
                }




                if ('P'.contains(C)) {
                    array.add('Reality:' + r.reality)
                    csvArray.add(r.reality)
                } else
                    csvArray.add(none)

                if ('I'.contains(C)) {
                    array.add('Indicator:' + r.indicator)
                    array.add('Date:' + r.date?.format('dd.MM.yyyy'))
                    array.add('Value:' + r.value)
                    csvArray.add(r.indicator)
                    csvArray.add(r.date?.format('dd.MM.yyyy'))
                    csvArray.add(r.value)

                } else {
                    csvArray.add(none)
                    csvArray.add(none)
                    csvArray.add(none)
                }



                if ('RE'.contains(C)) {
                    array.add('Title:' + r.title)
                    csvArray.add(StringUtils.abbreviate(r.title, 120))
                } else {
                    csvArray.add(none)
                }


                if ('N'.contains(C)) {
//                    array.add('Category:' + r.category)
//                    array.add('Source:' + r.source)
//                    array.add('Scope:' + r.scope)
                    array.add('Published on:' + r.publishedOn?.format('dd.MM.yyyy'))

//                    csvArray.add(r.category)
//                    csvArray.add(r.source)
//                    csvArray.add(r.scope)
                    csvArray.add(r.publishedOn?.format('dd.MM.yyyy'))

                } else {
//                    csvArray.add(none)
//                    csvArray.add(none)
//                    csvArray.add(none)
                    csvArray.add(none)
                }



                if ('E'.contains(C)) {
//                    array.add('Source type:' + r.sourceType)
//                    array.add('Source:' + r.source)
                    array.add('Book:' + r.book?.id)

//                    csvArray.add(r.sourceType)
//                    csvArray.add(r.source)
                    csvArray.add(r.book?.id)

                } else {
//                    csvArray.add(none)
//                    csvArray.add(none)
                    csvArray.add(none)
                }

                if ('R'.contains(C)) {
                    array.add('Legacy title:' + r.legacyTitle)
                    array.add('Status:' + r.status)
                    array.add('Author:' + r.author)
                    array.add('ISBN:' + r.isbn)
                    array.add('Publication date:' + r.publicationDate)
                    array.add('Publisher:' + r.publisher)
                }

                contents += array.join('\n') + '\n\n\n'
                csvContents += csvArray*.toString()*.replace(',', ' ')*.replace('null', '?')*.replace('\r', '\n')*.replace('\n', ' -- ').join(',') + '\n'
            }
            f.write(contents, 'UTF8')
        }
        csv.write(csvContents, 'UTF8')

        render(template: '/layouts/achtung', model: [message: "All text files has been dumped to " + path])
    }

    def showSelectedRecords() {
        def list = []
        selectedRecords.each() {
            if (it.value == 1) {
                def record = grailsApplication.classLoader.loadClass(entityMapping[it.key.substring(0, 1)]).get(it.key.substring(1))
                list.add(record)
            }
        }
        render(template: '/gTemplates/recordListing', model: [list: list, title: 'Selected records'])
    }

    def showTopPriority() {
        def results
        allClasses.each() {
            results = it.findAllByPriority(4)
        }
        render(template: '/gTemplates/recordListing', model: [list: results, title: 'Priority 4 records'])
    }


    def removeTagFromRecord() {

        def instance = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)


        if (Tag.get(params.tagId)) {
            instance.removeFromTags(Tag.get(params.tagId))
            render(template: '/tag/tags', model: [instance: instance, entity: params.entityCode])
        } else render 'Tag not found'
    }
 def removeContactFromRecord() {
        def instance = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
     def contact = Contact.get(params.tagId)
        if (contact) {
            instance.removeFromContacts(contact)
            render(template: '/tag/', model: [instance: instance, entity: params.entityCode])
        } else render 'Tag not found'
    }

    def addTagToRecord() {

        def instance = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)

        if (Tag.findByName(params.tag?.trim())) {
            instance.addToTags(Tag.findByName(params.tag?.trim()))
            render(template: '/tag/tags', model: [instance: instance, entity: params.entityCode])
        } else if (params.tag != '') {
            def newTag = new Tag([name: params.tag]).save(flush: true)
            instance.addToTags(newTag)
            render('<b>' + params.tag + ' added </b>')
            render(template: '/tag/tags', model: [instance: instance, entity: params.entityCode])
        } else render(template: '/tag/tags', model: [instance: instance, entity: params.entityCode])
    }

def addContactToRecord() {

        def instance = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)

    def contact = Contact.findBySummary(params.contact?.trim())
        if (contact) {
            instance.addToContacts(contact)
            render(template: '/tag/contacts', model: [instance: instance, entity: params.entityCode])

    }
    else render ''
}


    def batchAddTagToRecords(String tag) {

        def list = []
        def type = tag.split(' ')[0]
        tag = tag.split(' ')[1]

        selectedRecords.each() {
            if (it.value == 1 && it.key.substring(0, 1).toLowerCase() == type.toLowerCase()) {
                def record = grailsApplication.classLoader.loadClass(entityMapping[it.key.substring(0, 1)]).get(it.key.substring(1))

                if (Tag.findByName(tag?.trim())) {
                    record.addToTags(Tag.findByName(tag?.trim()))
                } else if (params.tag != '') {
                    def newTag = new Tag([name: tag]).save(flush: true)
                    record.addToTags(newTag)
                }

                list.add(record)
            }
        }

        render(template: '/gTemplates/recordListing', model: [
                list: list,
                title: 'Updated records'])
    }

   def batchLogicallyDeleteRecords(String type) {

        def list = []

        selectedRecords.each() {
            if (it.value == 1 && it.key.substring(0, 1).toLowerCase() == type.toLowerCase()) {
                def record = grailsApplication.classLoader.loadClass(entityMapping[it.key.substring(0, 1)]).get(it.key.substring(1))

               record.deletedOn = new Date()

                list.add(record)
            }
        }

        render(template: '/gTemplates/recordListing', model: [
                list: list,
                title: 'Trashed records'])
    }
    
       def repostRecords(String choice) {

        def list = []

        selectedRecords.each() {
            if (it.value == 1 && it.key.substring(0, 1).toLowerCase() == choice.toLowerCase()) {
                def record = grailsApplication.classLoader.loadClass(entityMapping[it.key.substring(0, 1)]).get(it.key.substring(1))

               
		  def tags = ''
        record.tags.each() {
            if (!it.isKeyword)
                tags += it.name + ', '
        }
        def categories = record?.type?.name + ','
        record.tags.each() {
            if (it.isKeyword)
                categories += it.name + ', '
        }

        String summary, contents, type

        switch (record.entityCode()) {
            case 'W': summary = record.summary
                contents = ys.wikiparser.WikiParser.renderXHTML(record.description)?.decodeHTML()
                type = record.type?.name
                break
            case 'N': summary = record.summary
                contents =  (record.language == 'ar' ? ('<div style="direction: rtl; text-align: right">' + record.description?.encodeAsHTML() + '</div>') :  record.description?.encodeAsHTML())

                //ys.wikiparser.WikiParser.renderXHTML(record.description)?.decodeHTML()
                //record.description//?.encodeAsHTML()
                type = record.type?.name
                break
             case 'J': summary = record.summary
                contents = ys.wikiparser.WikiParser.renderXHTML(record.description)?.decodeHTML()
                //record.description//?.encodeAsHTML()
                type = record.type?.name
                break
        }

        // postToBlog(String blogId, String title, String categoriesString, String tags, String fullText) {
        sleep(2000)
        int r = supportService.postToBlog(record.blog.id, summary, categories, tags, contents, record.publishedNodeId)

        if (r) {
            record.publishedNodeId = r
            record.publishedOn = new Date()
            //render r
            render(template: '/layouts/achtung', model: [message: "Record published with id " + r])
        } else "Problem posting the record"

	  
	  
	  
		
		
		

                list.add(record)
            }
        }

        render(template: '/gTemplates/recordListing', model: [
                list: list,
                title: 'Posted records'])
    }
    
    

  def batchPhysicallyDeleteRecords(String type) {

        selectedRecords.each() {
            if (it.value == 1 && it.key.substring(0, 1).toLowerCase() == type.toLowerCase()) {
                def record = grailsApplication.classLoader.loadClass(entityMapping[it.key.substring(0, 1)]).get(it.key.substring(1))

               record.delete()
            }
        }

        render(template: '/layouts/achtung', model: [message: 'Records physically deleted'])
    }



    def luceneSearch(String input) {

//        if (params.offset) {
//            iput = session.q
//        }
//        else {
//            session.q = params.q
//        }

        def q = input ? input.trim() : null
        params.escape = false
        params.max = 100

        if (q == '?')
            render(template: '/info/searchSyntax')
        else if (q.length() > 2) {
            try {
                def queryType = q.split(/[ ]+/)[0]
                def query = q.substring(q.indexOf(' ')).trim()
                def results

                switch (queryType) {
                    case '?': render(template: '/info/searchSyntax')
                        break

                    case '=':
//                        if (query ==~ /\d\d\d\d/) {
                        def entityCode = query.substring(0, 1).toUpperCase()
                        def id = query.substring(1)
                        def instance = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
//                        }
                        if (instance)
                            render(template: "/gTemplates/recordSummary", model: [record: instance])
                        else render 'Record not found'
                        break

//                    case 'x': results = searchableService.search(query, params)
//                        render(template: "/gTemplates/recordListing", model: [list: results.results,
//                                total: searchableService.countHits(q + '*'), title: query])
//                        break

                    case 'm': results = []
                        nonResourceClasses.each() { results += it.search(query + '*', params).results }
                        def total = 0
                        nonResourceClasses.each() { total += it.countHits(query + '*') }
                        render(template: "/gTemplates/recordListing", model: [list: results,
                                total: total, title: query])
                        break

                    case 'w': params.withHighlighter = { highlighter, index, sr ->
                        if (!sr.highlights) {
                            sr.highlights = []
                        }
                        sr.highlights[index] = "..." + highlighter.fragmentsWithSeparator("summary") + " - " + highlighter.fragmentsWithSeparator("description")
                    }
                        results = Writing.search(query, params)
                        render(template: "/gTemplates/recordListing", model: [list: results.results,
                                highlights: results.highlights,
                                total: Writing.countHits(q), title: query])
                        break
                    case 'c': params.withHighlighter = { highlighter, index, sr ->
                        if (!sr.highlights) {
                            sr.highlights = []
                        }
                        sr.highlights[index] = "..." + highlighter.fragmentsWithSeparator("description") + '...'
                    }
                        results = IndexCard.search(query, params)
                        render(template: "/gTemplates/recordListing", model: [list: results.results,
                                highlights: results.highlights,
                                total: IndexCard.countHits(q), title: query])
                        break
                    case 'r':
                        params.withHighlighter = { highlighter, index, sr ->
                            if (!sr.highlights) {
                                sr.highlights = []
                            }
                            sr.highlights[index] = "..." + highlighter.fragmentsWithSeparator("title") + " - " + highlighter.fragmentsWithSeparator("description")
                        }
                        results = Book.search(query, params)
                        render(template: "/gTemplates/recordListing", model: [list: results.results,
                                highlights: results.highlights,
                                total: Book.countHits(q), title: query])
                        break
                }

            } catch (Exception e) {
                log.error e
            }
        }

    }

    def quickSearch() {

//        if (params.offset) {
//            iput = session.q
//        }
//        else {
//            session.q = params.q
//        }

        def q = params.q  ? params.q?.trim() : null
        params.escape = false
        params.max = 100

       if (q.length() > 2) {
            try {
                def query = q.trim()
                def results

//                    params.withHighlighter = { highlighter, index, sr ->
//                        if (!sr.highlights) {
//                            sr.highlights = []
//                        }
//                        sr.highlights[index] = "..." + highlighter.fragmentsWithSeparator("summary") + " - " + highlighter.fragmentsWithSeparator("description")
//                    }
                        results = searchableService.search(query, params)
                        render(template: "/gTemplates/recordListing", model: [list: results.results,
                              //  highlights: results.highlights,
                                total: searchableService.countHits(q), title: query])

            } catch (Exception e) {
                log.error e
            }
        }

    }

    def hqlSearchForm(Long id) {
        def types = []
        def statuses = []
        def topics = []
        def priorities = []
        def sources = []
        def departments = []
        def courses = []
        def locations = []
        def categories = []
//        def resourceTypes = []
        try {
            switch (params.id) {
                case 'T': WorkStatus.list([sort: 'name']).each() {
                    statuses.add([id: it.id, value: it.name + ' (' + Task.countByStatus(it) + ')'])
                }
                    Location.list([sort: 'name']).each() {
                        locations.add([id: it.id, value: it.name + ' (' + Task.countByLocation(it) + ')'])
                    }
                    Task.executeQuery("select count(*), t.course from Task t group by t.course order by t.course.code asc").each() {
                        courses.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }
                    Task.executeQuery("select count(*), t.department from Task t group by t.department order by t.department.code asc").each() {
                        departments.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }
                    break
                case 'G':
                    WorkStatus.list([sort: 'name']).each() {
                        statuses.add([id: it.id, value: it.name + ' (' + Goal.countByStatus(it) + ')'])
                    }
                    GoalType.list([sort: 'name']).each() {
                        types.add([id: it.id, value: it.name + ' (' + Goal.countByType(it) + ')'])
                    }
                    Goal.executeQuery("select count(*), t.course from Goal t group by t.course order by t.course.code asc").each() {
                        courses.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }

                    Goal.executeQuery("select count(*), t.department from Goal t group by t.department order by t.department.code asc").each() {
                        departments.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }
                    break
                case 'P': WorkStatus.list([sort: 'name']).each() {
                    statuses.add([id: it.id, value: it.name + ' (' + Planner.countByStatus(it) + ')'])
                }
                    PlannerType.list([sort: 'name']).each() {
                        types.add([id: it.id, value: it.name + ' (' + Planner.countByType(it) + ')'])
                    }
//                 Planner.executeQuery("select count(*), t.course from Goal t group by t.course order by t.course.code asc").each() {
//                     courses.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
//                 }
// 
//                 Planner.executeQuery("select count(*), t.department from Planner t group by t.department order by t.department.code asc").each() {
//                     departments.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
//                 }
                    break

                case 'J':
//WorkStatus.list([sort: 'name']).each() {
//                 statuses.add([id: it.id, value: it.name + ' (' + Journal.countByStatus(it) + ')'])
//             }
                    JournalType.list([sort: 'name']).each() {
                        types.add([id: it.id, value: it.name + ' (' + Journal.countByType(it) + ')'])
                    }
//                 Planner.executeQuery("select count(*), t.course from Goal t group by t.course").each() {
//                     courses.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
//                 }
// 
//                 Task.executeQuery("select count(*), t.department from Journal t group by t.department order by t.department.code asc").each() {
//                     departments.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
//                 }
                    break

                case 'W': WritingStatus.list([sort: 'name']).each() {
                    statuses.add([id: it.id, value: it.name + ' (' + Writing.countByStatus(it) + ')'])
                }
                    WritingType.list([sort: 'code']).each() {
                        types.add([id: it.id, value: it.code + ' - ' + it.name + ' (' + Writing.countByType(it) + ')'])
                    }

                    Task.executeQuery("select count(*), t.course from Writing t group by t.course order by t.course.code asc").each() {
                        courses.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }

                    Task.executeQuery("select count(*), t.course.department from Writing t group by t.course.department order by t.course.department.code asc").each() {
                        departments.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }

                    break

                case 'N': WritingStatus.list([sort: 'name']).each() {
                    statuses.add([id: it.id, value: it.name + ' (' + IndexCard.countByStatus(it) + ')'])
                }
                    WritingType.list([sort: 'code']).each() {
                        types.add([id: it.id, value: it.code + ' - ' + it.name + ' (' + IndexCard.countByType(it) + ')'])
                    }

                    IndexCard.executeQuery("select count(*), t.course from IndexCard t group by t.course order by t.course.code asc").each() {
                        courses.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }

                    IndexCard.executeQuery("select count(*), t.department from IndexCard t group by t.department order by t.department.code asc").each() {
                        departments.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }

                    break


                case 'R': ResourceStatus.list([sort: 'name']).each() {
                    statuses.add([id: it.id, value: it.name + ' (' + Book.countByStatus(it) + ')'])
                }
                    Book.executeQuery("select count(*), t.course from Book t where t.course is not null group by t.course order by t.course.code asc").each() {
                        courses.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }
                    Book.executeQuery("select count(*), t.course.department from Book t group by t.course.department order by t.department.code asc").each() {
                        departments.add([id: it[1].id, value: it[1].toString() + ' (' + it[0] + ')'])
                    }
                    types = ResourceType.list([sort: 'code'])

//                    Book.executeQuery("select count(*), t.resourceType from Book t where t.resourceType is not null group by t.resourceType").each() {
//                        resourceTypes.add([id: it[1], value: it[1].toString() + ' (' + it[0] + ')'])
//                    }

                    break

            }


            render(template: '/gTemplates/searchForm', model: [entityCode: params.id,
                    types: types,
                    statuses: statuses,
                    topcis: topics,
                    priorities: priorities,
                    sources: sources,
                    departments: departments,
                    courses: courses,
                    locations: locations,
                    categories: categories

            ])
        }
        catch (Exception e) {
            render "Exception " + e
            print "Exception " + e.printStackTrace()
        }
    }


    def getAddForm = {

        def types = []
        def statuses = []
        def topics = []
        def priorities = []
        def sources = []
        def departments = []
        def courses = []
        def locations = []
        def contexts = []
        def categories = []
        def resourceTypes = []
        def writings = []

        def indicators = app.Indicator.executeQuery('from Indicator  order by code')
        //where category != null

        courses = Course.list()
        departments = Department.list()


        try {
            switch (params.entityController) {
                case 'mcs.Task':
                    statuses = WorkStatus.list([sort: 'name'])
                    locations = Location.list([sort: 'name'])
                    contexts = Context.list([sort: 'name'])
                    break
                case 'mcs.Goal':
                    statuses = WorkStatus.list([sort: 'name'])
                    types = GoalType.list([sort: 'name'])

                    break
                case 'mcs.Planner':
                    statuses = WorkStatus.list([sort: 'name'])

                    types = PlannerType.list([sort: 'name'])

                    break

                case 'mcs.Journal':
                    types = JournalType.list([sort: 'name'])
                    break
                case 'mcs.Writing':
                    statuses = WritingStatus.list([sort: 'name'])
                    types = WritingType.list([sort: 'code'])

                    break
                case 'app.IndexCard':
                    statuses = WritingStatus.list([sort: 'name'])
                    types = WritingType.list([sort: 'code'])
                    writings = Writing.list([sort: 'summary'])
                    break
                case 'mcs.Book':
                    statuses = ResourceStatus.list([sort: 'name'])
                    types = ResourceType.list([sort: 'code'])
//                    Book.executeQuery("select count(*), t.resourceType from Book t where t.resourceType is not null group by t.resourceType").each() {
//                        resourceTypes.add([id: it[1], value: it[1].toString() + ' (' + it[0] + ')'])
                    break
            }

            def record
            if (params.id)
                record = grailsApplication.classLoader.loadClass(params.entityController).get(params.id)

            render(template: '/gTemplates/addForm', model: [entityController: params.entityController,
                    fields: grailsApplication.classLoader.loadClass(params.entityController).declaredFields.name,
                    updateRegion: params.updateRegion,
                    record: record,
                    types: types,
                    statuses: statuses,
                    writings: writings,
                    topcis: topics,
                    priorities: priorities,
                    sources: sources,
                    indicators: indicators,
                    departments: departments,
                    courses: courses,
                    locations: locations,
                    contexts: contexts,
                    categories: categories
            ])
            if (params.isParameter)
                render(template: '/gTemplates/recordListing', model: [list: grailsApplication.classLoader.loadClass(params.entityController).list()])

        }
        catch (Exception e) {
            render "Exception " + e
            print "Exception " + e
        }
    }

    def hqlSearch = {

        def list = null

        def query = []
        def count = 0

        def c = params.isTodo

        ['entityCode', 'isTodo', 'location', 'status', 'type',
                'fullText', 'department', 'course', 'priority',
                'sortBy', 'order', 'max', 'dateField', 'dateA', 'dateB'].each() {
            if (params.offset)
                params[it] = session[it]
            else session[it] = params[it]
        }

//        if (c == 'on'){
//            queryWhere += 'isTodo = ? and '
//            queryParams.add(true)
//        } else {
//            queryWhere += 'isTodo = ? and '
//            queryParams.add(false)
//        }

        c = params.location
        if (c && c != 'null')
            query += ('location.id = ' + c)

//        c = params['location.id']
//        if (c != 'null'){
//            queryWhere += 'location = ? and '
//            query += 'location.id = ' + c
//            queryParams.add(Location.get(c.toLong()))
//        }

        c = params.status
        if (c && c != 'null') {
            query += 'status.id = ' + c
        }

        c = params.type
        if (c && c != 'null') {
            query += 'type.id = ' + c
        }

        c = params.fullText
        if (c != '') {
            if (params.entityCode != 'R')
                query += "(summary like '%" + c + "%' or description like  '%" + c + "%' or notes like '%" + c + "%')"
            else
                query += "(title like '%" + c + "%' or description like  '%" + c + "%' or legacyTitle like '%" + c + "%' or notes like '%" + c + "%')"
        }

        c = params.course
        if (c && c != 'null') {
            query += 'course.id = ' + c
        }

        c = params.department
        if (c && c != 'null') {
            query += 'course.department.id = ' + c
        }
        c = params.priority
        if (c && c != 'null') {
            query += 'priority = ' + c
        }
//        c = params.resourceType
//        if (c && c != 'null') {
//            query += "resourceType = '" + c + "'"
//        }

        c = params.dateField
        if (c != 'null' && params.dateA && params.dateB) {
            query += ("datediff($c, current_date()) >= " + params.dateA + ' and ' + "datediff($c , current_date()) <= " + params.dateB)
        }

//        query += ' order by department.departmentCode desc'
//        queryWhere = StringUtils.removeEnd(queryWhere, ' and ')
//        query = StringUtils.removeEnd(queryWhere, ' and ')

//        results = Task.executeQuery('from Task ' + (queryWhere != '' ? ' where ' : '') + queryWhere + '  order by department.departmentCode desc', queryParams, params)
        def fullQuery = 'from ' + entityMapping[params.entityCode] + ' ' +
                (query.size == 0 ? '' : ' where ' + query.join(' and ')) +
                ' order by ' + params.sortBy + ' ' + params.order.toLowerCase()

        if (!params.groupBy || params.groupBy == 'null') {

            list = Task.executeQuery(fullQuery, [], params)



            if (OperationController.getPath('enable.autoselectResults') == 'yes'){
                selectedRecords.keySet().each() {
                    session[it] = 0
                }
                selectedRecords = [:]
                for (r in list) {
                selectedRecords[r.entityCode() + r.id] = 1
                session[r.entityCode() + r.id] = 1
            }
            }


            count = Task.executeQuery('select count(*) from ' + entityMapping[params.entityCode] + ' ' +
                    (query.size == 0 ? '' : ' where ' + query.join(' and ')))[0]


            render(template: '/gTemplates/recordListing', model: [list: list, searchResultsTotal: count,
                    title: 'Total: ' + count + ' - Query : ' + fullQuery
            ])
        } else {
            def groups

            def input = fullQuery

            def groupBy = params.groupBy

            switch (groupBy) {
                case 'department':
                    groups = Department.list([sort: 'code'])
                    break
                case 'course':
                    groups = Course.list([sort: 'title'])
                    break
                case 'type':
                    if (input.contains('from mcs.Goal')) {
                        groups = GoalType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Journal')) {
                        groups = JournalType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Planner')) {
                        groups = PlannerType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Journal')) {
                        groups = PlannerType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Writing') || input.contains('from mcs.IndexCard')) {
                        groups = WritingType.list([sort: 'name'])
                    }
                    break
                case 'status':
                    if (input.contains('from mcs.Goal')) {
                        groups = WorkStatus.list([sort: 'name'])
                    } else if (input.contains('from mcs.Journal')) {
                        groups = JournalType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Writing')) {
                        groups = WritingStatus.list([sort: 'name'])
                    } else if (input.contains('from mcs.Book')) {
                        groups = ResourceStatus.list([sort: 'name'])
                    } else if (input.contains('from mcs.Goal') || input.contains('from mcs.Task') || input.contains('from mcs.Planner')) {
                        groups = WorkStatus.list([sort: 'name'])
                    }
                    break
                case 'location':
                    groups = Location.list([sort: 'name'])
                    break
            }
            params.max = 500


            selectedRecords.keySet().each() {
                session[it] = 0
            }
            selectedRecords = [:]



            def list2 = Task.executeQuery(fullQuery, [], params)
            for (r in list2) {
                selectedRecords[r.entityCode() + r.id] = 1
                session[r.entityCode() + r.id] = 1
            }


            render(template: '/reports/genericGrouping', model: [groups: groups, groupBy: params.groupBy,
                    title: 'Generic grouping: ' + fullQuery,
                    items: list2])
        }

    }

    def findRecords(String input) {
        if (input.contains(' {')) {

            def groupBy = input.split(/ \{/)[1]

            def groups

            switch (groupBy) {
                case 'department':
                    groups = Department.list([sort: 'code'])
                    break
                case 'course':
                    groups = Course.list([sort: 'summary'])
                    break
                case 'type':
                    if (input.contains('from mcs.Goal')) {
                        groups = GoalType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Journal')) {
                        groups = JournalType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Planner')) {
                        groups = PlannerType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Journal')) {
                        groups = PlannerType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Writing') || input.contains('from app.IndexCard')) {
                        groups = WritingType.list([sort: 'name'])
                    }
                    break
                case 'status':
                    if (input.contains('from mcs.Goal')) {
                        groups = WorkStatus.list([sort: 'name'])
                    } else if (input.contains('from mcs.Journal')) {
                        groups = JournalType.list([sort: 'name'])
                    } else if (input.contains('from mcs.Writing')) {
                        groups = WritingStatus.list([sort: 'name'])
                    } else if (input.contains('from mcs.Book')) {
                        groups = ResourceStatus.list([sort: 'name'])
                    } else if (input.contains('from mcs.Goal') || input.contains('from mcs.Task') || input.contains('from mcs.Planner')) {
                        groups = WorkStatus.list([sort: 'name'])
                    }
                    break
                case 'location':
                    groups = Location.list([sort: 'name'])
                    break
            }

            def entityCode = input.split(/[ ]+/)[0]?.toUpperCase()

//        input = params.input.substring(params.input.indexOf(' '))

            def queryHead = 'from ' + entityMapping[entityCode]
            def queryCriteria = transformMcsNotation(input)['queryCriteria']

            def queryParams = ''


            render(template: '/reports/genericGrouping', model: [
                    items: Task.executeQuery(queryHead + (queryCriteria ? ' where ' + queryCriteria : '') + ' order by lastUpdated desc', []),
                    groups: groups, groupBy: groupBy,
                    title: 'HQL Query: ' + input]
            )
        } else {
            def fullquery
            def fullquerySort
            def queryKey
           if (input.startsWith('_')){
               fullquery = session[input]
               fullquerySort = 'select count(*) ' + fullquery
               queryKey = input
           }  else{
            def entityCode = input.split(/[ ]+/)[0]?.toUpperCase()

//        input = params.input.substring(params.input.indexOf(' '))

            def queryHead = 'from ' + entityMapping[entityCode]
            def queryCriteria = transformMcsNotation(input)['queryCriteria']

            def queryParams = ''

            fullquery = queryHead + (queryCriteria ? ' where ' + queryCriteria : '')
            fullquerySort = 'select count(*) ' + queryHead + (queryCriteria ? ' where ' + queryCriteria : '')
            queryKey = '_' + new Date().format('ddMMyyHHmmss')
             session[queryKey] = fullquery

           }
            params.max = Setting.findByNameLike('savedSearch.pagination.max.link') ? Setting.findByNameLike('savedSearch.pagination.max.link').value.toInteger() : 5
            def list = Task.executeQuery(fullquery  + ' order by lastUpdated desc', [], params)
//            if (OperationController.getPath('enable.autoselectResults') == 'yes'){
//                selectedRecords.keySet().each() {
//                    session[it] = 0
//                }
//                selectedRecords = [:]
//
//                for (r in list) {
//                selectedRecords[r.entityCode() + r.id] = 1
//                session[r.entityCode() + r.id] = 1
//            }
//            }

            render(template: '/gTemplates/recordListing', model: [
                    totalHits: Task.executeQuery(fullquerySort)[0], //.size(),
                    list: list,    queryKey: queryKey, fullquery: fullquery,
                    title: fullquery
            ])

        }

    }

    def queryRecords(String input) {


            if (input.contains(' {')) {

                def groupBy = input.split(/ \{/)[1]

                def groups

                switch (groupBy) {
                    case 'department':
                        groups = Department.list([sort: 'code'])
                        break
                    case 'course':
                        groups = Course.list([sort: 'summary'])
                        break
                    case 'type':
                        if (input.contains('from mcs.Goal')) {
                            groups = GoalType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Journal')) {
                            groups = JournalType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Planner')) {
                            groups = PlannerType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Journal')) {
                            groups = PlannerType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Writing') || input.contains('from app.IndexCard')) {
                            groups = WritingType.list([sort: 'name'])
                        }
                        break
                    case 'status':
                        if (input.contains('from mcs.Goal')) {
                            groups = WorkStatus.list([sort: 'name'])
                        } else if (input.contains('from mcs.Journal')) {
                            groups = JournalType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Writing')) {
                            groups = WritingStatus.list([sort: 'name'])
                        } else if (input.contains('from mcs.Book')) {
                            groups = ResourceStatus.list([sort: 'name'])
                        } else if (input.contains('from mcs.Goal') || input.contains('from mcs.Task') || input.contains('from mcs.Planner')) {
                            groups = WorkStatus.list([sort: 'name'])
                        }
                        break
                    case 'location':
                        groups = Location.list([sort: 'name'])
                        break
                }
                def query = input.split(/ \{/)[0]




                render(template: '/reports/genericGrouping', model: [
                        items: Task.executeQuery(query, []),
                        groups: groups, groupBy: groupBy,
                        title: 'HQL Query: ' + input]
                )
            }
            else {


              def fullquery
            def fullquerySort
            def queryKey
           if (input.startsWith('_')){
               fullquery = session[input]
               fullquerySort = 'select count(*) ' + fullquery
               queryKey = input
           }
           else{

            fullquery = input
            fullquerySort = 'select count(*) ' + input
            queryKey = '_' + new Date().format('ddMMyyHHmmss')
             session[queryKey] = fullquery
	   }
             
                params.max = Setting.findByNameLike('savedSearch.pagination.max.link') ? Setting.findByNameLike('savedSearch.pagination.max.link').value.toInteger() : 5
                def list = Task.executeQuery(fullquery, [], params)
                if (OperationController.getPath('enable.autoselectResults') == 'yes'){
                    selectedRecords.keySet().each() {
                        session[it] = 0
                    }
                    selectedRecords = [:]

                    for (r in list) {
                    selectedRecords[r.entityCode() + r.id] = 1
                    session[r.entityCode() + r.id] = 1
               
                }
	    } 

                render(template: '/gTemplates/recordListing', model: [
                        list: Task.executeQuery(fullquery, [], params),
                        totalHits: Task.executeQuery(fullquerySort)[0],
                        queryKey2: queryKey, fullquery: fullquery,
                        title: 'HQL Query ' + (!input.contains('select') ? '(' + Task.executeQuery(fullquerySort)[0] + ')' : '') + ' : ' + fullquery
                ])
            
        }

    }

    def randomGet(String input, String queryName) {

        try {
            def results = Task.executeQuery(input)

            def list = [:]
            def randomRecords = []
            results.eachWithIndex() { b, i ->
                list[i] = b.id
            }
            def total = results.size()
            def record
            def randomNumber
            for (t in (1..3)){
                randomNumber = Math.floor(Math.random() * total).toInteger()
                record = results[randomNumber]
                randomRecords.add(record)
            }

            render(template: '/gTemplates/recordListing',
                    model: [list: randomRecords,
                            title: 'Random records' + (queryName ? ' from ' + queryName : '')])
        }
        catch (Exception e) {

            println 'Problem ' + e
            render 'Problem occurred ' + e
        }
    }

    def updateRecordsByQuery(String input) {

        try {


                render(Task.executeUpdate(input, []))//    title: 'HQL Query ' + input

        } catch (Exception e) {
            println 'here ' + e
            render 'Problem occurred ' + e
        }

    }

    def importPost(String input) {

        render(template: '/gTemplates/recordSummary', model: [record:
                IndexCard.get(supportService.post2xcd(input.split(/ /)[0], input.split(/ /)[1].toInteger()))
        ])

    }

    def adHocQuery(String input) {

        def list = mcs.Task.executeQuery(input)

        render(template: '/reports/adHocQueryResults', model: [
                list: list,
                title: 'Ad hoc query / ' + list.size() + ' : ' + input
        ])

    }

    // Todo: what's its use over query?
    def lookup(String input) {

        def entityCode = input.split(/[ ]+/)[0]?.toUpperCase()

//        def input = params.input.substring(params.input.indexOf(' '))

        def queryCriteria = transformMcsNotation(input)['queryCriteria']
        def queryHead = 'from ' + entityMapping[entityCode] + ' where '
        def queryParams = ''

        render(template: '/gTemplates/recordListing', model: [
                list: Task.executeQuery(queryHead + queryCriteria),
                title: queryHead + queryCriteria
        ])

    }

    def quickAdd(String input) {

        def entityCode = input.trim().split(/[ ]+/)[0]?.toUpperCase()

//        def input = params.input.substring(params.input.indexOf(' '))
        def properties
        try {
            properties = transformMcsNotation(input)['properties']
//        def queryCriteria = transformMcsNotation(input)['queryCriteria']
//        def queryHead = 'from ' + entityMapping[entityCode] + ' where '
//        def queryParams = ''
        } catch (Exception e) {
            //          render 'Exception in quick add' + e
                  print 'Exception in quick add' + e
        }

        def n = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).newInstance()
        if (!properties) {
            render 'Error parsing command'

        } else {
            n.properties = properties

            if (!n.hasErrors() && n.save()) {
                render(template: '/gTemplates/recordSummary', model: [
                        record: n, expandedView: true])
            } else {
                render 'Errors when saving the record<br/>'
                render(template: '/gTemplates/recordSummary', model: [
                        record: n, expandedView: true])
//            n.errors.each() {
//                render it
//            }

            }

        }
    }
  def parameterAdd(String input) {

        def entityCode = input.trim().split(/[ ]+/)[0]

//        def input = params.input.substring(params.input.indexOf(' '))
        def properties
        try {
            properties = transformMcsNotation(input)['properties']
//        def queryCriteria = transformMcsNotation(input)['queryCriteria']
//        def queryHead = 'from ' + entityMapping[entityCode] + ' where '
//        def queryParams = ''
//            def entityCode = notation?.trim()?.split(/[ ]+/)[0]?.toUpperCase()//substring(0, 1).toUpperCase()
//            println 'code ' + entityCode
//            println 'notation ' + notation
//            def input = StringUtils.removeStart(notation?.trim(), entityCode.toLowerCase())?.trim()
//            println 'input ' + input


        } catch (Exception) {
            ;//          render 'Exception in quick add' + e
            //       print 'Exception in quick add' + e
        }

        def n = grailsApplication.classLoader.loadClass(entityCode).newInstance()
        if (!properties) {
            render 'Error parsing command'
        } else {
            n.properties = properties

            if (!n.hasErrors() && n.save()) {
                render(template: '/gTemplates/recordSummary', model: [
                        record: n])
            } else {
                render 'Errors when saving the record<br/>'
                render(template: '/gTemplates/recordSummary', model: [
                        record: n])
//            n.errors.each() {
//                render it
//            }

            }

        }
    }

    def saveViaForm() {

        def entityCode = params.entityCode

        def entityController = params.entityController

        def n
        def savedOk
        if (!params.id) {
            n = grailsApplication.classLoader.loadClass(entityController).newInstance(params)

        } else {
            n = grailsApplication.classLoader.loadClass(entityController).get(params.id)
            n.properties = params
            savedOk = true
        }


        def types = []
        def statuses = []
        def topics = []
        def priorities = []
        def sources = []
        def departments = []
        def courses = []
        def locations = []
        def categories = []

        def indicators = app.Indicator.executeQuery('from Indicator  order by code')
        //where category != null

        courses = Course.list()
        departments = Department.list()



        switch (params.entityController) {
            case 'mcs.Task':
                statuses = WorkStatus.list([sort: 'name'])
                locations = Location.list([sort: 'name'])
                break
            case 'mcs.Goal':
                statuses = WorkStatus.list([sort: 'name'])
                types = GoalType.list([sort: 'name'])

                break
            case 'mcs.Planner':
                statuses = WorkStatus.list([sort: 'name'])

                types = PlannerType.list([sort: 'name'])

                break

            case 'mcs.Journal':
                types = JournalType.list([sort: 'name'])
                break
            case 'mcs.Writing':
                statuses = WritingStatus.list([sort: 'name'])
                types = WritingType.list([sort: 'code'])
                break
            case 'app.IndexCard':
                statuses = WritingStatus.list([sort: 'name'])
                types = WritingType.list([sort: 'code'])
                break
            case 'mcs.Book':
                statuses = ResourceStatus.list([sort: 'name'])
                types = ResourceType.list([sort: 'code'])

//                Book.executeQuery("select count(*), t.resourceType from Book t where t.resourceType is not null group by t.resourceType").each() {
//                    resourceTypes.add([id: it[1], value: it[1].toString() + ' (' + it[0] + ')'])
//                }
                break
        }

        if (!n.hasErrors() && n.save() && !params.id) {
            render(template: '/gTemplates/addForm', model: [
                    fields: n.class.declaredFields.name,
                    hideForm: false,
                    updateRegion: params.updateRegion,
                    entityController: entityController,
                    savedRecord: n,

                    types: types,
                    statuses: statuses,
                    topcis: topics,
                    priorities: priorities,
                    sources: sources,
                    indicators: indicators,
                    departments: departments,
                    courses: courses,
                    locations: locations,
                    categories: categories
            ])
        } else if (!n.hasErrors() && params.id && n.save()) {
            render(template: '/gTemplates/recordSummary', model: [savedOk: true, justUpdated: 1,
                    record: n])

        } else {
            render(template: '/gTemplates/addForm', model: [
                    entityController: entityController,
                    updateRegion: params.updateRegion,
                    fields: n.class.declaredFields.name,
                    record: n,
                    savedRecord: n,

                    types: types,
                    statuses: statuses,
                    topcis: topics,
                    priorities: priorities,
                    sources: sources,
                    indicators: indicators,
                    departments: departments,
                    courses: courses,
                    locations: locations,
                    categories: categories
            ])
//            n.errors.each() {
//                render it
//            }

        }

    }


    def autoCompleteMainEntities() {
//        println params.dump()
        def input = params.q
        def responce = []
		def filter = '%'
		

        Writing.findAllBySummaryLike(filter, [sort: 'summary']).each() {
            responce += [value: 'w ' + it.id + ' ' + it.summary]
        }
        Goal.findAllBySummaryLike(filter, [sort: 'summary']).each() {
            responce += [value: 'g ' + it.id + ' ' + it.summary]
        }
        Task.findAllBySummaryLike(filter, [sort: 'summary']).each() {
//            responce += (it.summary + '|t' + '' + it.id + '\n')
            responce += [value: 't ' + it.id + ' ' + it.summary]
        }



        if (1 == 2 && input && input.contains(' ') && input.split(/[ ]+/).size() >= 2) {
            def entityCode = input.split(/[ ]+/)[0].toUpperCase()
            def lastCharacter = input.split(/[ ]+/).last().substring(0, 1)

        //    def filter
            if (input.length() > 2)
                filter = '%' + input.substring(2) + '%'
            else
                filter = '%'

            switch (entityCode) {
                case 'W': Writing.findAllBySummaryLike(filter, [sort: 'summary']).each() {
                    responce += (it.summary + '|w' + '' + it.id + '\n')
                }
                    break
                case 'G': Goal.findAllBySummaryLike(filter, [sort: 'summary']).each() {
                    responce += (it.summary + '|g' + '' + it.id + '\n')
                }
                    break

                case 'T': Task.findAllBySummaryLike(filter, [sort: 'summary']).each() {
                    responce += (it.summary + '|t' + '' + it.id + '\n')
                }
                    break
//                case 'L': WordSource.findAllByNameLike(filter, [sort: 'name']).each() {
//                    responce += (it.name + '|l' + '' + it.id + '\n')
//                }
//                    break
                case 'R': Book.findAllByTitleLike(filter, [sort: 'title']).each() {
                    responce += (it.title + ' ' + it.id + '|b' + '' + it.id + '\n')
                }
                    break
                case 'U': WordSource.findAllBySummaryLikeOrDescriptionLike(filter, filter, [sort: 'summary']).each() {
                    responce += (it.summary + ': ' + it.description + '|u' + '' + it.id + '\n')
                }
                    break
            }


        }
        Book.findAllByStatus(ResourceStatus.get(1), [sort: 'title']).each() { // only textbooks
            responce += [id: it.id, value: 'r ' + it.id + ' ' + it.title, text:  'r ' + '' + it.id + '\n']
        }
//
        render responce as JSON
    }

    def addRelationship = {

        def r = new Relationship()

        // the child
        r.entityA = entityMapping[params.entityCode]
        r.recordA = params.id.toLong()
        def child = grailsApplication.classLoader.loadClass(r.entityA).get(r.recordA)

        // the parent
        def parentEntityCode = params.recordB.substring(0, 1).toUpperCase()
        r.entityB = entityMapping[parentEntityCode]
        r.recordB = params.recordB.split(' ')[1].toLong()

        def parent = grailsApplication.classLoader.loadClass(r.entityB).get(r.recordB)


        r.type = RelationshipType.get(params.type)

        if (params.type == '5') {
            if (params.entityCode == 'T' && parentEntityCode == 'G') {
                child.parentGoal = parent
            } else if (params.entityCode == 'G' && parentEntityCode == 'W') {
                child.writing = parent
            } else if (params.entityCode == 'J' && parentEntityCode == 'G') {
                child.goal = parent
            } else if (params.entityCode == 'P' && parentEntityCode == 'G') {
                child.goal = parent
            }
        } else
            r.save(flush: true)

        render(template: '/gTemplates/relationships', model: [record: child])

    }

    def quickAddRecord(String block) {

        if (block && block.trim() != '') {


//        def lines = block.readLines()

//            def line1 = lines[0]?.trim()

            def entityCode = params.recordType

            def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).newInstance()

            def summary
            def description


            if (entityCode == 'T'){
                summary = block
                description = ''
            }
            else {
                summary = 'Untitled ' + new Date().format('dd.MM.yyyy HH:mm')
                description = block
            }




//        if (lines.size() > 1) {

//            if (!line1.contains(';'))
//                summary = lines[0]?.trim()
//            else {
            //      record.properties = transformMcsNotation(line1.substring(line1.indexOf(' ')).trim())['properties']
//                }

//            description = ''
//            (1..lines.size() - 1).each() {
//                description += lines[it] + '\n'
//            }
//        }
//        else


            //    record.type = WritingType.findByCode('note')
            //    record.summary = summary
            //   if (entityCode != 'B')
            record.summary = summary
            record.description = description
            //    else
            //    record.fullText = description

            if (!record.hasErrors() && record.save()) {
                render(template: '/gTemplates/recordSummary', model: [
                        expandedView: true,
                        record: record])
            } else {
                render 'Errors when saving the record<br/>'
                render(template: '/gTemplates/recordSummary', model: [
                        expandedView: true,
                        record: record])
                record.errors.each() {
                    render it
                }

            }

//            render(template: '/gTemplates/recordSummary', model: [record: record, expandedView: true])
//        render(template: '/gTemplates/recordDetails', model: [record: record])
        } else render 'Empty block'

    }


    def addWithDescription(String block) {
        if (block && block.trim() != '') {

            def summary = '?'
            def description = '?'

            def lines = block.readLines()

            def line1 = lines[0]?.trim()
            def entityCode = line1.trim().split(/[ ]+/)[1]?.toUpperCase()
            //    println 'entitycode ' + entityCode

            def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).newInstance()

            if (lines.size() > 1) {

//            if (!line1.contains(';'))
//                summary = lines[0]?.trim()
//            else {
                record.properties = transformMcsNotation(line1.substring(line1.indexOf(' ')).trim())['properties']
//                }

                description = ''
                (1..lines.size() - 1).each() {
                    description += lines[it] + '\n'
                }
            } else description = block

            //record.type = WritingType.findByCode('note')
            //   record.summary = summary
            if (entityCode == 'X'){
                record.countQuery = description
        } else  if (entityCode == 'R')
                record.fullText = description
            else
                record.description = description


            if (!record.hasErrors() && record.save()) {
                render(template: '/gTemplates/recordSummary', model: [
                        expandedView: true,
                        record: record])
            } else {
                render 'Errors when saving the record<br/>'
                render(template: '/gTemplates/recordSummary', model: [
                        expandedView: true,
                        record: record])
                record.errors.each() {
                    render it
                }

            }

//            render(template: '/gTemplates/recordSummary', model: [record: record, expandedView: true])
//        render(template: '/gTemplates/recordDetails', model: [record: record])
        } else render 'Empty block'

    }

    def addNote = {
        def record = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
        if (!record.notes)
            record.notes = ''

        record.notes += ('  ' + new Date().format('dd.MM.yyyy HH:mm') + ': ' + params.note + '||')

        render(template: '/gTemplates/recordNotes', model: [record: record])

    }

    def appendText = {
        def record = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)
        if (!record.description)
            record.description = ''

        record.description += ('\n' + params.text + ' (' + new Date().format('dd.MM.yyyy') + ')')

        render(template: '/gTemplates/recordSummary', model: [record: record])
        render(template: '/gTemplates/recordDetails', model: [record: record])

    }

//    def quickAddAutoHint(String input) {
//        if (!input){
//            render '''
//a               : Add new records
//s (=, m, x, w)  : Full-text search
//u <type>        : Update selected records of type <type>
//p <date>        : Assign selected records to days
//'''
//    }
//        else if(input.length() > 0) {
//            switch(input.substring(0,1)){
//                case 'a' : render "p? c???? #type @location b???? <startDate >endDate"
//                    break
//                case 's' : render '~ ???'
//                    break
//            }
//        }
//    }

    static Map transformMcsNotation(String notation) {

        try {
//            def entityCode = notation?.trim()?.split(/[ ]+/)[0]?.toUpperCase()//substring(0, 1).toUpperCase()
//            println 'code ' + entityCode
//            println 'notation ' + notation
//            def input = StringUtils.removeStart(notation?.trim(), entityCode.toLowerCase())?.trim()
//            println 'input ' + input

            def entityCode = notation?.trim()?.split(/[ ]+/)[0]?.toUpperCase()//notation.trim().substring(0, 1).toUpperCase()


            def input = StringUtils.removeStart(notation?.trim(), entityCode.toLowerCase())?.trim()

            def result = [:]
            def properties = [:]
            def queryCriteria = []

            def endParametersEncountered = false

            input = ' ' + input.trim()
            input.split(/[ ]+/).each() {

                if (it.contains(';'))
                    endParametersEncountered = true
                if (!endParametersEncountered) {
                    if (it.startsWith('i') && it.length() > 1) {
                        properties['id'] = it.substring(1).toLong()
                        queryCriteria.add('id = ' + it.substring(1))
                    }
                    if (it.startsWith('p')) {

                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("priority = null")
                        } else {

                            properties['priority'] = it.substring(1, 2).toInteger()
                            queryCriteria.add('priority = ' + it.substring(1, 2))
                        }
                    }
                    if (it.startsWith(',')) {
                        properties['pages'] = it.substring(1)
                        queryCriteria.add('pages = ' + it.substring(1))
                    }

                    if (it.startsWith('_') && 'NE'.contains(entityCode)) {
                        properties['chapters'] = it.substring(1)
                        queryCriteria.add('chapters = ' + it.substring(1))
                    }

                    if (it.startsWith(':')) {
                        properties['language'] = it.substring(1)
                        queryCriteria.add("language = '" + it.substring(1) + "'")
                    }
                    if (it.startsWith('e')) {
                        properties['energyLevel'] = it.substring(1).toInteger()
//                        queryCriteria.add('priority = ' + it.substring(1, 2))
                    }
                    if (it.startsWith('c')) { // && it.length() == 5) {

                        if (it.trim().length() == 2) {
                            properties['course'] = null
                            queryCriteria.add("course is null")
                        } else {
                            def crsId = Course.findByCode(it.substring(1)).id
                            properties['course.id'] = crsId
                            queryCriteria.add('course.id = ' + crsId)
                        }

                    }
                    if (it.startsWith('C')) {
                        if (it.trim().length() == 2) {
                            properties['course'] = null
                            queryCriteria.add("course is null")
                        } else {
                            def crsId = Course.findByNumberCode(it.substring(1)).id
                            properties['course.id'] = crsId
                            queryCriteria.add('course.id = ' + crsId)
                        }

                    }
                    if (it.startsWith('r') && it.length() > 1) {
                        properties['book.id'] = Book.get(it.substring(1).toInteger()).id
                        queryCriteria.add('book.id = ' + it.substring(1))
                    }
                    if (it.startsWith('w') && it.length() > 1) {
                        properties['writing.id'] = Writing.get(it.substring(1).toInteger()).id
                        queryCriteria.add('writing.id = ' + it.substring(1))
                    }

                    if (it.startsWith('"') && it.length() > 1) {
                        properties['plannedDuration'] = it.substring(1).toInteger()
                        queryCriteria.add('plannedDuration = ' + it.substring(1))
                    }

                    /*       if (it.startsWith('s')) {
                               properties['pages'] = it.substring(1)
                               queryCriteria.add('pages = ' + it.substring(1))
                           }
                           */
                    if (it.startsWith('d')) {

                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("department = null")
                        } else {

                            if ('X'.contains(entityCode)) {

                                properties['entity'] = it.substring(1)
                                queryCriteria.add("entity = '" + it.substring(1) + "'")
                            } else {

                                if (it.substring(1) != 'x') {
                                    properties['department.id'] = Department.findByCode(it.substring(1)).id
                                    queryCriteria.add("department.code = '" + it.substring(1) + "'")
                                } else {
                                    properties['department'] = null
                                    queryCriteria.add("department = null")
                                }
                            }
                        }
                    }

                    if (it.startsWith('D')) {

                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("department = null")
                        } else {



                                if (it.substring(1) != 'x') {
                                    properties['department.id'] = Department.findByCode(it.substring(1)).id
                                    queryCriteria.add("course.department.code =  '" + it.substring(1) + "'")
                                } else {
                                    properties['department'] = null
                                    queryCriteria.add("department = null")
                                }
                            }

                    }
                    if (it.startsWith('g')) {
                        if ('T'.contains(entityCode)) {
                            properties['parentGoal.id'] = Goal.findById(it.substring(1)).id
                            queryCriteria.add("parentGoal.id = '" + it.substring(1) + "'")
                        }
                        if ('JP'.contains(entityCode)) {
                            properties['goal.id'] = it.substring(1)
                            queryCriteria.add("goal.id = '" + it.substring(1) + "'")
                        }

                    }
                    if (it.startsWith('=')) {
                            properties['code'] = it.substring(1)
                            queryCriteria.add("code = '" + it.substring(1) + "'")
                        }
  if (it.startsWith('!')) {
                        if ('I'.contains(entityCode)) {
                            properties['indicator.id'] = Indicator.findByCode(it.substring(1)).id
                            queryCriteria.add("indicator.code = '" + it.substring(1) + "'")
                        }

                        if ('Q'.contains(entityCode)) {
                            properties['category.id'] = PaymentCategory.findByCode(it.substring(1)).id
                            queryCriteria.add("category.code = '" + it.substring(1) + "'")
                        }
                        if ('X'.contains(entityCode)) {
                            properties['queryType'] = it.substring(1)
                            queryCriteria.add("queryType= '" + it.substring(1) + "'")
                        }
                        if ('CD'.contains(entityCode)) {
                            properties['code'] = it.substring(1)
                            queryCriteria.add("code = '" + it.substring(1) + "'")
                        }

                    }

                    if (it.startsWith('l')) {
                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("level = null")
                        } else {
                            properties['level'] = it.substring(1)
                            queryCriteria.add("level = '" + it.substring(1) + "'")
                        }
                    }
     if (it.startsWith('^')) {
                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("orderNumber = null")
                        } else {
                            properties['orderNumber'] = it.substring(1)
                            queryCriteria.add("orderNumber = '" + it.substring(1) + "'")
                        }
                    }

                    if (it.startsWith('?') && entityCode == 'N') {
                        def id = WordType.findByCode(it.substring(1)).id
                        properties['sourceType.id'] = id

                        queryCriteria.add("sourceType.code = '" + it.substring(1) + "'")
                    } else if (it.startsWith('?')) {

                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("status = null")
                        } else {

                            def statusId
                            if ('TGP'.contains(entityCode))
                                statusId = WorkStatus.findByCode(it.substring(1)).id
                            else if ('WC'.contains(entityCode))
                                statusId = WritingStatus.findByCode(it.substring(1)).id
                            else if ('R'.contains(entityCode))
                                statusId = ResourceStatus.findByCode(it.substring(1)).id

                            properties['status.id'] = statusId
                            queryCriteria.add("status.code = '" + it.substring(1) + "'")
                        }

                    }
                    if (it.startsWith('@') && 'T'.contains(entityCode)) {

                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("context = null")
                        } else {
                            println ' it is no w' + it
                            def id = Context.findByCode(it.substring(1)).id

                            properties['context.id'] = id
                            queryCriteria.add("context.code = '" + it.substring(1) + "'")
                        }
                    }
                    if (it.startsWith('{') && 'I'.contains(entityCode)) {
                        properties['trackSequence'] = it.substring(1)
                        queryCriteria.add("trackSequence = '" + it.substring(1) + "'")
                    }

                    if (it.startsWith('%') && 'MGTB'.contains(entityCode)) {

                        properties['percentCompleted'] = it.substring(1)
                        queryCriteria.add("percentCompleted = '" + it.substring(1) + "'")
                    }

//                    if (it.startsWith('@') && 'N'.contains(entityCode)) {
//                        def id = NewsSource.findByCode(it.substring(1)).id
//
//                        properties['source.id'] = id
//                        queryCriteria.add("source.code = '" + it.substring(1) + "'")
//                    }
                    if (it.startsWith('@') && 'N'.contains(entityCode)) {

                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("source = null")
                        } else {

                            def id = WordSource.findBySummary(it.substring(1)).id

                            properties['source.id'] = id
                            queryCriteria.add("source.code = '" + it.substring(1) + "'")
                        }
                    }

//                    if (it.startsWith('#') && entityCode == 'N') {
//                        def id = NewsScope.findByCode(it.substring(1)).id
//
//
//                        properties['scope.id'] = id
//                        queryCriteria.add("scope.code = '" + it.substring(1) + "'")

//                    }
                    else if (it.startsWith('#')) {
                        if (it.trim().length() == 1) {
//                              properties['type'] = null
                            queryCriteria.add("type = null")
                        } else {
                            def id
                            if ('WN'.contains(entityCode))
                                id = WritingType.findByCode(it.substring(1)).id
                            else if ('G'.contains(entityCode))
                                id = GoalType.findByCode(it.substring(1)).id
                            else if ('J'.contains(entityCode))
                                id = JournalType.findByCode(it.substring(1)).id
                            else if ('P'.contains(entityCode))
                                id = PlannerType.findByCode(it.substring(1)).id
                            else if ('R'.contains(entityCode))
                                id = ResourceType.findByCode(it.substring(1)).id


                            properties['type.id'] = id
                            queryCriteria.add("type.code = '" + it.substring(1) + "'")
                        }
                    }

                    //Todo: note there the detail
                    if (it.startsWith('<') || it.startsWith('(')) {
                        def dateField = 'startDate'
                        if ('I'.contains(entityCode))
                            dateField = 'date'
                        if ('Q'.contains(entityCode))
                            dateField = 'date'
	   if ('R'.contains(entityCode))
                            dateField = 'publicationDate'
       if ('N'.contains(entityCode))
                            dateField = 'writtenOn'

                        def core = it.substring(1)
                        if (it.startsWith('<+') || it.startsWith('<-') || it.startsWith('(+') || it.startsWith('(-')) {
                            properties[dateField] = new Date() + core.toInteger()
                            queryCriteria.add(dateField + " >= (current_date() " + core + ')')
                        } else {

                            if (core.matches(/^\d\d\d$/) ||
                                    core.matches(/^\d\d\d\.[0-9]{2}/)||
                                    core.matches(/^\d\d\d[\_][0-9]{1,4}$/)||
                                    core.matches(/^\d\d\d[\_][0-9]{1,4}[\.][0-9]{2}$/)){
                                properties[dateField] = OperationController.fromWeekDateAsDateTimeFullSyntax(core)
                            }
                            else if (core.contains('_')){
                                def format = Setting.findByName('datetime.add.format')
                                properties[dateField] = Date.parse(format ? format.value : 'dd.MM.yyyy_HHmm', core)
                            } else {
                            def format = Setting.findByName('date.format')
                            properties[dateField] = Date.parse(format ? format.value: 'dd.MM.yyyy', core)
                            }
                        }
                    }
                    if (it.startsWith('>') || it.startsWith(')')) {
                        def dateField = 'endDate'
                        def core = it.substring(1)
                        if (it.startsWith('>+') || it.startsWith('>-') || it.startsWith(')+') || it.startsWith(')-')) {
                            properties['endDate'] = new Date() + core.toInteger()
                            queryCriteria.add("endDate <= (current_date() " + core + ')')
                        } else {
                            if (core.matches(/^\d\d\d$/) ||
                                    core.matches(/^\d\d\d\.[0-9]{2}/) ||
                                    core.matches(/^\d\d\d[\_][0-9]{1,4}$/) ||
                                    core.matches(/^\d\d\d[\_][0-9]{1,4}[\.][0-9]{2}$/)) {
                                properties[dateField] = OperationController.fromWeekDateAsDateTimeFullSyntax(core)
                            } else {
                                def format = Setting.findByName('date.format')
                                properties[dateField] = Date.parse(format ? format.value : 'dd.MM.yyyy', core)
                            }
                        }
                    }



                    if (it.startsWith('.')) {
                        properties['blog.id'] = Blog.findByCode(it.substring(1)).id
                        queryCriteria.add("blog.code = '" + it.substring(1) + "'")
                    }
                    if (it.startsWith('/')) {
                        properties['url'] = it.substring(1)
                        queryCriteria.add("url like '%" + it.substring(1) + "%'")
                    }
                    if ((it.startsWith('*') || it.startsWith('x')) && it.length() == 1) {
                        properties['bookmarked'] = true
                        queryCriteria.add("bookmarked = true")
                    }
                    if (it.startsWith('*-')) {
                        properties['bookmarked'] = false
                        queryCriteria.add("bookmarked = false")
                    }
                    if (it.startsWith('[')) {
                        properties['isbn'] = it.substring(1)
                        queryCriteria.add("isbn = '" + it.substring(1) + "'")
                    }

//                    if (it.startsWith(']')) {
//                        properties['resourceType'] = it.substring(1)
//                        queryCriteria.add("resourceType = '" + it.substring(1) + "'")
//                    }

//		    if (it.startsWith('b')) {
//                        properties['book.id'] = it.substring(1)
//                        queryCriteria.add("book.id = '" + it.substring(1) + "'")
//                    }

                }
            }

            def summary
            def description
//            if (input.contains(';')) {
//                if (input.contains(';;')) {
//                    summary = input.substring(input.indexOf(';') + 1, input.indexOf(';;')).trim()
//                }
//                else {
//                    summary = input.substring(input.indexOf(';') + 1).trim()
//                }
//
//                properties['summary'] = summary
//                queryCriteria.add("summary like '%" + summary + "%'")
//            }

            def summaryFieldName = 'summary'
            def descriptionFieldName = 'description'
            if ('R'.contains(entityCode)){
                summaryFieldName = 'title'
	descriptionFieldName = 'fullText'
	    }
            if ('I'.contains(entityCode))
                summaryFieldName = 'value'
            if ('Q'.contains(entityCode))
                summaryFieldName = 'amount'
            if ('X'.contains(entityCode)){ // for saved search - gallery vision
                descriptionFieldName = 'query'

            }
              if ('Y' == entityCode.toUpperCase()){ // for settings
              //    println 'here in ST'
                  summaryFieldName = 'name'
                  descriptionFieldName = 'value'
              }
                if (entityCode.length() > 1){ // for settings
                  println 'here in ST'
                  summaryFieldName = 'name'
                  descriptionFieldName = 'notes'
              }

            if (input.contains(';;')) {
                description = input.substring(input.indexOf(';;') + 2).trim()
                properties[descriptionFieldName] = description
                queryCriteria.add("description like '%" + description + "%'")

                if (input.contains(' ; ')) {
                    summary = input.substring(input.indexOf(';') + 1, input.indexOf(';;')).trim().replaceAll("'", " ")
                    properties[summaryFieldName] = summary
                    if (entityCode == 'R')
                        queryCriteria.add('(' + summaryFieldName + " like '%" + summary + "%' or legacyTitle like '%" + summary + "%')")
                    else
                        queryCriteria.add(summaryFieldName + " like '%" + summary + "%'")
                }

            } else if (input.contains(' ; ')) {
                summary = input.substring(input.indexOf(';') + 1).trim().replaceAll("'", " ")
                properties[summaryFieldName] = summary


                if (entityCode == 'R')
                    queryCriteria.add('(' + summaryFieldName + " like '%" + summary + "%' or legacyTitle like '%" + summary + "%')")
                else
                    queryCriteria.add(summaryFieldName + " like '%" + summary + "%'")

            }

            result['queryCriteria'] = queryCriteria.join(' and ')
            result['properties'] = properties

            return result
        }
        catch (Exception e) {
            println 'Exception while transforming Pomegranate syntax: ' + e
            return null
        }
    }


    def assignCommand(String input) {
        def list = []
        def command = input.trim()//.substring(2).trim()
        def type = command.split(/[ ]+/)[0].toLowerCase()
//        def summary = '?'
//                    if (command.contains(';'))
//                    summary = command.substring(command.indexOf(';') + 1)?.trim()

        //  def level = command.split(/[ ]+/)[1]

//        def startDate = supportService.fromWeekDateAsDateTime(command.split(/[ ]+/)[2] + '.12')

        selectedRecords.each() {
            if (it.value == 1) {
//                        def type = it.key.substring(0, 1).toLowerCase()
                def record = grailsApplication.classLoader.loadClass(entityMapping[it.key.substring(0, 1)]).get(it.key.substring(1))

                def p
                if (type == 't' && it.key.substring(0, 1).toLowerCase() == 't') {
//                            p = new Planner([summary: summary, startDate: startDate, status: WorkStatus.get(2), type: PlannerType.get(7), endDate: startDate, level: level, task: record]).save()
                    p = new Planner([type: PlannerType.findByCode('assign'), status: WorkStatus.findByCode('pending'), task: record])

                    def properties = transformMcsNotation(command)['properties']
                    p.properties = properties
                    p.save()
                    p.errors.each() {
                        println it
                    }
                } else if (type == 'g' && it.key.substring(0, 1).toLowerCase() == 'g') {
                    p = new Planner([type: PlannerType.findByCode('assign'), status: WorkStatus.findByCode('pending'), goal: record])
                    def properties = transformMcsNotation(command)['properties']
                    p.properties = properties
                    p.save()
                    p.errors.each() {
                        println it
                    }
                }

                list.add(p)
            }
        }
//                        println p.dump()

        render(template: '/gTemplates/recordListing', model: [
                list: list,
                title: 'Updated records'])

    }

    def updateCommand(String input) {
        def properties = [:]
        def list = []
        def command = input.trim()

        def updatedInfo = command//.substring(1)
        def type = command.substring(0, 1)
        properties = transformMcsNotation(updatedInfo)['properties']

        selectedRecords.each() {
            if (it.value == 1 && it.key.substring(0, 1).toLowerCase() == type.toLowerCase()) {
                def record = grailsApplication.classLoader.loadClass(entityMapping[it.key.substring(0, 1)]).get(it.key.substring(1))
                record.properties = properties
                list.add(record)
            }
        }

        render(template: '/gTemplates/recordListing', model: [
                list: list,
                title: 'Updated records'])

    }

    def updateCommandWithId(String input) {
        def properties = [:]
        def list = []

        def command = input.trim()

        def updatedInfo = command//.substring(input.indexOf(' ')).trim()
        def type = command.substring(0, 1).toUpperCase()
        def recordId = command.split(/[ ]+/)[1].toLong()

        properties = transformMcsNotation(updatedInfo)['properties']

        def record = grailsApplication.classLoader.loadClass(entityMapping[type]).get(recordId)
        record.properties = properties

        render(template: '/gTemplates/recordSummary', model: [
                record: record,
                title: 'Updated record'])

    }

    def select = {

        if (!selectedRecords[params.id] || selectedRecords[params.id] == 0) {
            selectedRecords[params.id] = 1
            session[params.id] = 1
        } else {
            selectedRecords[params.id] = 0
            session[params.id] = 0
        }
        render ''
    }

    def selectOnly = {

            selectedRecords[params.id] = 1
            session[params.id] = 1
        render ''
    }
   def deselectOnly = {

            selectedRecords[params.id] = 0
            session[params.id] = 0
        render ''
    }

    def deselectAll = {
        selectedRecords.keySet().each() {
            session[it] = 0
        }
        selectedRecords = [:]

        render ''
    }

    /*

        def autoCompleteCourse() {
            if (params.q && params.q != '') {
                def responce = ''
                Course.findByNameLike(filter, [sort: 'code']).each() {
                    responce += (it.code + ' ' + it.title + '|' + it.code + ' ; \n')
                }
                def fresponce = ''
    //    if (params.q && params.q != '' && params.q.length() < 14) {
                responce.eachLine() {
                    if (it.startsWith(params.q))
                        fresponce += it + '\n'
                }
                render fresponce
            }

        }

        def autoCompleteLookup() {
            def responce = ''

            if (params.q && params.q != '' && params.q.length() < 12 && params.q.length() > 2) {
    //            responce += """
                //jrm type ddd time1 time2 ; ...
                //plm type ddd time1 time2 ; ...
                //jrn type date level ; ...
                //pln type date level ; ...
                //t front ; ...
                //g writingId front type ; ... / descrip
                //"""

                //            Department.findAll([sort: 'departmentCode']).each() {d ->
                //            Course.findAll([sort: 'code']).each() { c ->
                //                Writing.findAllByCourse(c, [sort: 'orderNumber']).each() {
                //                    responce += ('> ' + c.code + ' ' + c.title + ' : ' + it.orderNumber + ' ' + it.title + '   ' + it.id + " ; |> ${it.id} ; \n")
                //                }
                //            }

                Writing.findAll([sort: 'title']).each() {
                    responce += ('w ' + it.title + '   ' + it.id + " ; |${it.id} ${it.title} ; \n")
                }


                Goal.findAll([sort: 'title']).each() {
                    responce += ('g ' + it.title + '   ' + it.id + ' ; \n')
                }
                Task.findAll([sort: 'name']).each() {
                    responce += ('t ' + it.name + '   ' + it.id + ' ; \n')
                }
                Course.findAll([sort: 'code']).each() {
                    responce += ('c ' + it.code + ' ' + it.title + '\n')
                }

                JournalType.findAll([sort: 'name']).each() {
                    responce += ('jt ' + it.name + ' \n')
                }
                PlannerType.findAll([sort: 'name']).each() {
                    responce += ('pt ' + it.name + ' \n')
                }
                GoalType.findAll([sort: 'name']).each() {
                    responce += ('gt ' + it.name + ' \n')
                }

            }

            def fresponce = ''
            if (params.q && params.q != '' && params.q.length() < 12 && params.q.length() > 2) {
                responce.eachLine() {
                    if (it.toLowerCase().startsWith(params.q.toLowerCase()) ||
                            it.toLowerCase().contains(params.q.substring(2).toLowerCase()))
                        fresponce += it + '\n'
                }

            }
            render fresponce
        }
    */


    def updateTagCount() {
        Tag.list().each() { t ->
            def count = 0
            allClasses.each() {
                count += it.createCriteria().count() { tags { idEq(t.id) } }
            }
            t.occurrence = count
        }
        render(template: '/layouts/achtung', model: [message: 'Tag occurrence count completed'])
    }

    def executeSavedSearch(Long id) {

//        render(template: '/savedSearch/actions', model: [recordId: id])

        def savedSearch = SavedSearch.get(id)
        if (savedSearch.queryType == 'random' || params.reportType == 'random') {

            randomGet(savedSearch.query, savedSearch.summary)

        }
        else if (savedSearch.queryType == 'hql') {
            //queryRecords(savedSearch.query)
            params.max =  Setting.findByNameLike('savedSearch.pagination.max.link') ? Setting.findByNameLike('savedSearch.pagination.max.link').value.toInteger() : 5




            if (savedSearch.query?.contains('{')) {

                def groups

                def input = savedSearch.query.split(/ \{/)[0]

                def groupBy = savedSearch.query.split(/ \{/)[1]

                switch (groupBy) {
                    case 'department':
                        groups = Department.list([sort: 'code'])
                        break
                    case 'course':
                        groups = Course.list([sort: 'summary'])
                        break
                    case 'type':
                        if (input.contains('from mcs.Goal')) {
                            groups = GoalType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Journal')) {
                            groups = JournalType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Planner')) {
                            groups = PlannerType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Journal')) {
                            groups = PlannerType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Writing') || input.contains('from mcs.IndexCard')) {
                            groups = WritingType.list([sort: 'name'])
                        }
                        break
                    case 'status':
                        if (input.contains('from mcs.Goal')) {
                            groups = WorkStatus.list([sort: 'name'])
                        } else if (input.contains('from mcs.Journal')) {
                            groups = JournalType.list([sort: 'name'])
                        } else if (input.contains('from mcs.Writing')) {
                            groups = WritingStatus.list([sort: 'name'])
                        } else if (input.contains('from mcs.Book')) {
                            groups = ResourceStatus.list([sort: 'name'])
                        } else if (input.contains('from mcs.Goal') || input.contains('from mcs.Task') || input.contains('from mcs.Planner')) {
                            groups = WorkStatus.list([sort: 'name'])
                        }
                        break
                    case 'location':
                        groups = Location.list([sort: 'name'])
                        break
                }
                params.max = 100



                def list2 = Task.executeQuery(input, [], params)


                 if (params.reportType == 'tab'){
					params.max = null
                     render(view: '/page/kanbanCrs', model: [groups: groups, groupBy: groupBy,
                             title: savedSearch.summary,
                             items:  Task.executeQuery(input, [])])
            }

                else
                {
                render(template: '/reports/genericGrouping', model: [groups: groups, groupBy: groupBy,
                        title: savedSearch.summary,
                        items: list2])
                }

            }
        else {


                 /*

                if (OperationController.getPath('enable.autoselectResults') == 'yes'){
                    selectedRecords.keySet().each() {
                        session[it] = 0
                    }
                    selectedRecords = [:]
                    for (r in list) {
                        selectedRecords[r.entityCode() + r.id] = 1
                        session[r.entityCode() + r.id] = 1
                    }

                }
                */

                if (params.reportType == 'cal')
                    render(view: '/reports/calendar', model: [
                            id: id,
                            savedSearchId: id,
                            title: savedSearch.summary])
            else if (params.reportType == 'tab'){
			params.max = null
                    render(view: '/page/kanbanCrs', model: [
                            ssId: id,
                            searchResultsTotal: savedSearch.countQuery ? Task.executeQuery( savedSearch.countQuery)[0] : '',
                            totalHits: savedSearch.countQuery ? Task.executeQuery( savedSearch.countQuery)[0] : '',
                            list: Task.executeQuery(savedSearch.query, []),
                            title: savedSearch.summary]
                    )
            }
            else {
                    def list = Task.executeQuery(savedSearch.query, [], params)

                    render(template: '/gTemplates/recordListing', model: [
                        ssId: id,
                        searchResultsTotal: savedSearch.countQuery ? Task.executeQuery( savedSearch.countQuery)[0] : '',
                        totalHits: savedSearch.countQuery ? Task.executeQuery( savedSearch.countQuery)[0] : '',
                        list: list,
                        title: savedSearch.summary
                ])
                }
        }

            //  + (! savedSearch.query.contains('select') ? '(' + Task.executeQuery('select count(*) ' +  savedSearch.query)[0] + ')' : '') + ' : ' +  savedSearch.query

//            render(template: '/gTemplates/recordListing', model: [
//                    list: Task.executeQuery(savedSearch.query, [max: 100]),
//                    title: savedSearch.summary + " (" + savedSearch.query + ")"
//            ])
        }
        else if (savedSearch.queryType == 'lucene'){
            render(template: '/gTemplates/recordListing', model: [
                    list: searchableService.search(savedSearch.query, [max: 100]),
                    title: savedSearch.summary + " (" + savedSearch.query + ")"])
        }
        else if (savedSearch.queryType == 'adhoc') {
            render(template: '/reports/adHocQueryResults', model: [
                    list: mcs.Task.executeQuery(savedSearch.query),
                    title: '' + savedSearch.summary + " (" + savedSearch.query + ")"
            ])
        }
        else
            render(template: '/layouts/achtung', model: [message: 'Unknown query type'])

    }

    def publish() {

        def record = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)

        def tags = ''
        record.tags.each() {
            if (!it.isKeyword)
                tags += it.name + ', '
        }
        def categories = record?.type?.name + ','
        record.tags.each() {
            if (it.isKeyword)
                categories += it.name + ', '
        }

        String summary, contents, type

        switch (params.entityCode) {
            case 'W': summary = record.summary
                contents = ys.wikiparser.WikiParser.renderXHTML(record.description)?.decodeHTML()
                type = record.type?.name
                break
            case 'N': summary = record.summary
                contents = (record.language == 'ar' ? ('<div style="direction: rtl; text-align: right">' + record.description?.encodeAsHTML() + '</div>') :  record.description?.encodeAsHTML())
                //record.description//?.encodeAsHTML()
                type = record.type?.name
                break
             case 'J': summary = record.summary
                contents = ys.wikiparser.WikiParser.renderXHTML(record.description)?.decodeHTML()
                //record.description//?.encodeAsHTML()
                type = record.type?.name
                break
        }

        // postToBlog(String blogId, String title, String categoriesString, String tags, String fullText) {
        int r = supportService.postToBlog(record.blog.id, summary, categories, tags, contents, record.publishedNodeId)

        if (r) {
            record.publishedNodeId = r
            record.publishedOn = new Date()
            //render r
            render(template: '/layouts/achtung', model: [message: "Record published with id " + r])
        } else "Problem posting the record"

    }


    def recentRecords() {

        def recentRecords = []

        allClasses.each() {
            recentRecords += it.findAll([sort: 'lastUpdated', order: 'desc', max: 7])
	//    recentRecords += it.findAllByLastUpdatedGreaterThan(new Date() - 7, [max: 12])
        }
        
        recentRecords = recentRecords.sort({it.lastUpdated}).reverse()
	//recentRecords.unique()

        render(template: '/gTemplates/recordListing', model: [
                title: 'Timeline',
                list: recentRecords
        ])
    }

    def logicallyDeletedRecords() {

        def recentRecords = []

        allClasses.each() {
            recentRecords += it.findAllByDeletedOnIsNotNull([sort: 'lastUpdated', order: 'desc'])
        }

        render(template: '/gTemplates/recordListing', model: [
                title: 'Logically deleted records',
                list: recentRecords
        ])
    }

    def physicallyDeleteRecords() {

        def recentRecords = []

        allClasses.each() {
            recentRecords += it.findAllByDeletedOnIsNotNull()
        }

        def c = 0
        def d = 0
        for (r in recentRecords) {
            try {
                r.delete()
//                if ('N' == r.entityCode()) {
//                    def file = new File((OperationController.getPath('attachments.repository.path') ?: null) + '/' + r.id)
//
//                    if (file?.exists())
//                        file?.delete()
//                }
                c++
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                d++
            }
        }

        render(template: '/layouts/achtung', model: [
                message: c + ' records were deleted, ' + d + ' not deleted'
        ])
    }

    def convertDate(String input) {
        if (input.length() == 10) {
//            try {
            render supportService.toWeekDate(Date.parse("dd.MM.yyyy", input))
//            } catch (Exception e) {
//                render 'A problem has occurred: ' + e.toString()
//            }
        } else {
//            try {
            render supportService.fromWeekDate(input)
//            }
//            catch (Exception e) {
//                render  'A problem has occurred: ' + e.toString()
//            }

        }
    }

    def tagReport() {

        def list = []

        allClasses.each() {
            list += it.createCriteria().list() { tags { idEq(params.id.toLong()) } }
        }
        render(template: '/gTemplates/recordListing', model: [list: list, title: 'Tag: ' + Tag.get(params.id).name])
    }

  def contactReport() {

        def list = []

        allClasses.each() {
            list += it.createCriteria().list() { contacts { idEq(params.id.toLong()) } }
        }
        render(template: '/gTemplates/recordListing', model: [list: list, title: 'Contact: ' + Contact.get(params.id).summary])
    }


    def quickEdit = {
        render(template: '/forms/quickEdit', model:
                [id: params.id, entityCode: params.entityCode,
                        field: params.field, valueId: params.valueId, updateDiv: params.updateDiv])
    }

    def quickSave = {
        def id, entityCode, field, valueId
        def values = params.id.split('-')
        id = values[0].toLong()
        entityCode = values[1]
        field = values[2]
        valueId = values[3]//.toLong()

        def record = grailsApplication.classLoader.loadClass(entityMapping[entityCode]).get(id)
        if (field == 'department') {
            def department = Department.get(valueId)
            record.department = department
            render 'd' + department.code

        }

        if (field == 'course') {
            def course = Course.get(valueId)
            record.course = course
            render 'N' + course.code

        }


        if (field == 'resourceStatus') {
            def status = ResourceStatus.get(valueId)
            record.status = status
            render '?' + status.code
        }
        if (field == 'workStatus') {
            def status = WorkStatus.get(valueId)
            record.status = status
            render '?' + status.code
        }
        if (field == 'writingStatus') {
            def status = WritingStatus.get(valueId)
            record.status = status
            render '?' + status.code
        }

        if (field == 'plannerType') {
            def type = PlannerType.get(valueId.toLong())
            record.type = type
            render '#' + type.code
        }
        if (field == 'journalType') {
            def type = JournalType.get(valueId.toLong())
            record.type = type
            render '#' + type.code
        }
        if (field == 'writingType') {
            def type = WritingType.get(valueId.toLong())
            record.type = type
            render '#' + type.code
        }
        if (field == 'goalType') {
            def type = GoalType.get(valueId.toLong())
            record.type = type
            render '#' + type.code
        }
        if (field == 'taskLocation') {
            def location = Location.get(valueId.toLong())
            record.location = location
            render location.code
        }

        if (field == 'priority') {
            record.priority = valueId.toInteger()
            render valueId
        }

        if (field == 'percentCompleted') {
            record.percentCompleted = valueId.toInteger()
            render valueId
        }
        if (field == 'plannedDuration') {
            record.plannedDuration = valueId.toInteger()
            render (valueId + "''")
        }

        if (field == 'blog') {
            if (valueId != 'null') {
            def b = Blog.get(valueId)
            record.blog = b
            render "" + b.code
            }
            else{
                record.blog = null
                render ''
            }

        }
 if (field == 'pomegranate') {
            if (valueId != 'null') {
            def b = Pomegranate.get(valueId)
            record.pomegranate = b
            render "" + b.code
            }
            else{
                record.pomegranate = null
                render ''
            }

        }

    }

    def commandNotes(){
        def r = ['info': CommandPrefix.get(params.q)?.notes]
        render(r as JSON)
    }
    
    
    def getIsbnInfo(String line){
     
      def isbn
       try {
                        java.util.regex.Matcher matcher = line =~ /(\d{13}|\d{12}X|\d{12}x|\d{9}X|\d{9}x|\d{10})[^\d]*/
                        // todo: fix it to be exact match, anythwere in the filename
                            isbn = matcher[0][1]
                            
                    def b = Book.findByIsbn(isbn)
                    if (isbn && b)
		      render 'Dup ' + b.id
		      else if (isbn)
			render isbn
			else '-'
			  
                    }
                    catch (Exception e) {
                        
                        render '-'
                    }
                    
                    
			
                    
                    
                    
                    
                    
                    
    }
    
    def verifySmartFileName(String line){
     
          def properties
                try {
                    properties = transformMcsNotation(line)['properties']
               
    def n = grailsApplication.classLoader.loadClass(entityMapping[line.split(' ')[0].toUpperCase()]).newInstance()
    
                if (!properties) {
                    render("error")
                    
                } else {
                   n.properties = properties
                   

                    if (!n.validate()) {

                        render('error')
                        println('record has error')
                    }
                    
                    else render ("correct")
                }
               

                 } catch (Exception e) {
                    render("error")
		//    e.printStackTrace()
                 //return   
                }
                //render("correct")
                
      
    }
	
	
	def viewRecordImage() {

        
        def f
		def f2
        def record = grailsApplication.classLoader.loadClass(entityMapping[params.entityCode]).get(params.id)


        f = new File(OperationController.getPath('module.sandbox.' + record.entityCode() + '.path') + '/' + record.id + 'j.jpg')
        
		f2 = new File(OperationController.getPath('module.sandbox.' + record.entityCode() + '.path') + '/' + record.id + 'n.jpg')
        
		
        if (f?.exists()) {
            byte[] image = f.readBytes()
            response.outputStream << image
        }
		else if (f2?.exists()) {
            byte[] image = f2.readBytes()
            response.outputStream << image
        }
        //  else println 'cover not there for book ' + params.id

    }



	
}
