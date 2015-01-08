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

import mcs.Book
import mcs.Course
import mcs.Department
import mcs.Goal
import mcs.Writing
import mcs.parameters.ResourceStatus


class ReportController {

    def supportService


    def heartbeat() {
        def dates = [:]
        for (c in [[mcs.Goal, 'Goal'], [mcs.Task, 'Task'],
//                [mcs.Book, 'Resource'],
                [mcs.Planner, 'Plan'],
                [mcs.Journal, 'Journal'], [app.IndexCard, 'Note']]) {
            for (t in c[0].findAllByDateCreatedGreaterThan(new Date() - 30, [sort: 'dateCreated', order: 'asc'])) {
                def date = t.dateCreated.format('yyyy-MM-dd')
                if (!dates[date])
                    dates[date] = ['Goal': 0,
                            'Task': 0,
//                            'Resource': 0,
                            'Plan': 0,
                            'Journal': 0,
                            'Writing': 0,
                            'Note': 0
                    ]

                dates[date][c[1]] += 1
            }
        }
        render(template: '/reports/heartbeat', model: [dates: dates])
    }

 def taskCompletionTrack() {
        def dates = [:]
        for (c in [[mcs.Task, 'Task']]) {
            for (t in c[0].findAllByDateCreatedGreaterThan(new Date() - 90, [sort: 'dateCreated', order: 'asc'])) {
                def date = t.dateCreated.format('yyyy-MM-dd')
                if (!dates[date])
                    dates[date] = ['newTasks': 0,
                            'completedTasks': 0
                    ]

                dates[date]['newTasks'] += 1
            }

            for (t in c[0].findAllByDateCreatedGreaterThan(new Date() - 90, [sort: 'dateCreated', order: 'asc'])) {
                if (t.completedOn){
                def date = t.completedOn.format('yyyy-MM-dd')
                if (!dates[date])
                    dates[date] = ['newTasks': 0,
                            'completedTasks': 0
                    ]

                dates[date]['completedTasks'] += 1
                }
            }
        }
        render(template: '/reports/taskCompletionTrack', model: [dates: dates])
    }


    def whereIsMyData() {
        render(template: '/reports/whereismydata', model: [])
    }

    def statistics() {
        render(template: '/reports/statistics', model: [])
    }

    def departmentCourses() {
        render(template: '/reports/departmentCourses', model: [id: params.id])
    }

    def indicatorsByCategory() {
        render(template: '/reports/indicatorsByCategory', model: [id: params.id])
    }

    def indicatorPanorama() {
        render(template: '/reports/indicatorPanorama')
    }


    def convertWeekDate() {
        render(template: '/reports/convertWeekDate')
    }


    def textbooksPanorama() {
        def currentTextbooks = Book.executeQuery("select concat(course.code, ' ', course.title), id, title from Book where status = ? and orderNumber = course.currentTextbookLevel order by course.code", [ResourceStatus.get(1)])
        def textbooks = Book.executeQuery("select course.department.name, concat(course.code, ' ', course.title), id, title from Book where status is ? order by course.code", ResourceStatus.get(1))
        render(template: '/reports/textbooksPanorama', model: [textbooks: textbooks, currentTextbooks: currentTextbooks])
    }


    def random() {

        def list = [:]
        def listw = [:]
        Book.findAllByTitleIsNotNull().eachWithIndex() { b, i ->
//            if (b.id)
            list[i] = b.id
        }
        Writing.list().eachWithIndex() { b, i ->
//            if (b.id)
            listw[i] = b.id
        }
        render(template: '/gTemplates/recordListing', model: [list:
                [
                        mcs.Book.get(list[Math.floor(Math.random() * mcs.Book.countByTitleIsNotNull()).toInteger()]),
                        mcs.Writing.get(listw[Math.floor(Math.random() * mcs.Writing.count()).toInteger()])
                ]
        ])

    }

    def duplicateIsbnBooks() {
        def books = []
        def previousIsbn = ''
        def previousBook = null
        def found = 0
        Book.findAllByIsbnIsNotNull(sort: 'isbn').each() {
            if (found < 20) {
                if (previousIsbn == '') {
                    previousIsbn = it.isbn.trim()
                    previousBook = it
                } else if (it.isbn == previousIsbn) {
                    books.add(previousBook)
                    books.add(it)
                    found++
                } else {
                    previousBook = it
                    previousIsbn = it.isbn.trim()
                }
            }
        }
        render(template: '/gTemplates/recordListing', model: [list: books])
    }


    def longestWrt() {

        def m1 = [:]
        def longestWrt = []
        mcs.Writing.list().each() {
            m1[it.id] = it.body?.length() ?: 0
        }
        def map = m1.sort { a, b -> b.value <=> a.value }
        def limit = 30
        def i = 0
        map.each() {
            if (i < limit) {
                longestWrt.add(mcs.Writing.get(it.key))
                i++
            }
        }

        render(template: '/writing/line', collection: longestWrt, var: 'writingInstance')

    }

    def parametersList() {
        render(template: '/reports/parameters')
    }

    def courses() {
        render(template: '/reports/courses')
    }


    def writingGroupByCourseFlat() {
        def courses
        def department
        if (params.id)
            [courses: Course.findAllByDepartment(Department.get(params.id), [sort: 'code']),
                    department: Department.get(params.id)]
        else
            [courses: Course.findAll([sort: 'code'])]

        render(template: '/reports/writingGroupByCourseFlat', model: [courses: courses, department: department])

    }


    def tagCloud() {
        render(template: '/reports/tagCloud', model: [])
    }
    def contactCloud() {
        render(template: '/reports/contactCloud', model: [])
    }


    def detailedAdd() {
        render(template: '/reports/detailedAdd', model: [])
    }


    def paymentCategories() {
        render(template: '/reports/paymentCategories', model: [])
    }

    def saveDateSelection() {

//        def date
//        if (params.date)
//        date = Date.parse("dd.MM.yyyy", params.date)

        try {
            def startDate
            def endDate
            if (params.date1) {
                session['startDate'] = Date.parse("d.M.yyyy HH:mm", params.date1 + ' ' + ' 00:00')
                session['endDate'] = Date.parse("d.M.yyyy HH:mm", params.date2 + ' ' + ' 23:59')
                startDate = Date.parse("d.M.yyyy HH:mm", params.date1 + ' ' + ' 00:00')
                endDate = Date.parse("d.M.yyyy HH:mm", params.date2 + ' ' + ' 23:59')

//        render(template: '/reports/jpReport', model: [level: params.level,
//                title: '', plans: Planner.executeQuery('from Planner where date(startDate) >= ? and date(endDate) <= ?', [startDate, endDate]),
//                journals: Journal.findAll('from Journal where date(startDate) >= ? and date(endDate) <= ?', [startDate, endDate]),
//                startDate: startDate, endDate: endDate])
//
                def title = 'Activity log and agenda for: <b> ' +
                        (startDate.format('dd.MM.yyyy') == endDate.format('dd.MM.yyyy') ? startDate.format('EE dd.MM.yyyy') :
                                startDate.format('EE dd.MM.yyyy') + ' - ' + endDate.format('EE dd.MM.yyyy')) + '</b>'
                if (session['JP'] == 1)
                    render(template: '/reports/jpCalendar', model: [startDate: startDate, endDate: endDate])

                if (session['Jtrk'] == 1)
                    render(template: '/reports/jtrkReport', model: [startDate: startDate, endDate: endDate])

                if (session['Qtrans'] == 1)
                    render(template: '/reports/financialReportTrans', model: [startDate: startDate, endDate: endDate])

                if (session['Qacc'] == 1)
                    render(template: '/reports/financialReportAcc', model: [startDate: startDate, endDate: endDate])

                if (session['log'] == 1) {
                    def list = []
                    for (c in [
                            mcs.Goal, mcs.Task, mcs.Planner, mcs.Journal,
                            mcs.Writing, app.IndexCard, mcs.Book]) {
                        list += c.executeQuery(' from ' + c.name + ' where dateCreated between ? and ? ', [startDate, endDate])
                    }

                    for (c in [
                            mcs.Planner, mcs.Journal]) {
                        list += c.executeQuery(' from ' + c.name + ' where startDate between ? and ? ', [startDate, endDate])
                    }
                    for (c in [
                            app.Payment, app.IndicatorData]) {
                        list += c.executeQuery(' from ' + c.name + ' where date between ? and ? ', [startDate, endDate])
                    }

                    render(template: '/gTemplates/recordListing', model: [list: list, title: title])
                }

//                            Planner.executeQuery('from Planner where (date(dateCreated) >= ? and date(dateCreated) <= ?) or (date(startDate) >= ? and date(startDate) <= ?) order by dateCreated desc', [startDate, endDate, startDate, endDate]) +
//
//
//
//                                    Goal.findAll('from Goal where date(dateCreated) >= ? and date(dateCreated) <= ? order by dateCreated desc', [startDate, endDate], [max: 40]) +
//                                    Task.findAll('from Task where date(dateCreated) >= ? and date(dateCreated) <= ? order by dateCreated desc', [startDate, endDate], [max: 40]) +
//
//                                    Journal.executeQuery('from Journal where (date(dateCreated) >= ? and date(dateCreated) <= ?) or (date(startDate) >= ? and date(startDate) <= ?) order by dateCreated desc', [startDate, endDate, startDate, endDate]) +
//                                    IndicatorData.findAll('from IndicatorData where date(date) >= ? and date(date) <= ? order by dateCreated desc', [startDate, endDate]) +
//                                    Payment.findAll('from Payment where date(date) >= ? and date(date) <= ? order by dateCreated desc', [startDate, endDate]) +
//                                    Writing.findAll('from Writing where date(dateCreated) >= ? and date(dateCreated) <= ? order by dateCreated desc', [startDate, endDate]) +
//                                    IndexCard.findAll('from IndexCard where date(dateCreated) >= ? and date(dateCreated) <= ? order by dateCreated desc', [startDate, endDate]) +
//                                    Book.findAll('from Book where date(lastUpdated) >= ? and date(lastUpdated) <= ? order by dateCreated desc', [startDate, endDate], [max: 20]) +
//                                    Excerpt.findAll('from Excerpt where date(lastUpdated) >= ? and date(lastUpdated) <= ? order by dateCreated desc', [startDate, endDate], [max: 20])
//                            ,
//                            title: title
//                    ])

            }
            //  else render ''
        } catch (Exception e) {
            println e.toString()
        }
    }

    def setJPReportType = {

        if (session[params.id] == 1) {
            session[params.id] = 0
            render params.id
        } else {
            session[params.id] = 1
            render '<b>' + params.id + '</b>'
        }
//        render params.id + ' is now ' + session[params.id]
    }
 def showLine1Only = {

        session['showLine1Only'] = 'on'
   render(template: '/layouts/achtung', model: [message: "Only the first line of the card will be shown in future listings"])
    }
 def showFullCard = {
     session['showLine1Only'] = 'off'
        session['showFullCard'] = 'on'
     render(template: '/layouts/achtung', model: [message: "The full card will be shown in future listings"])
    }

    def homepageSavedSearches(){
      render (template: '/reports/homepageSavedSearches')
    }



    def coursePercentages(){
        Goal.list().each(){
            if (!it.percentCompleted)
                it.percentCompleted = 30
        }
        def total = 0
        def ps = 0
        for (c in Course.list()){
            total = 0
            ps = 0
              total = Goal.countByCourseAndDeletedOnIsNull(c)
            for (g in Goal.findAllByCourseAndDeletedOnIsNull(c)){
                ps += g.percentCompleted
            }
            c.percentCompleted = total != 0 ? ps / total : 0

        }
    }
} // end of class