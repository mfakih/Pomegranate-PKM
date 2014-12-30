package mcs

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import cmn.DataChangeAudit
import jxl.Sheet
import jxl.Workbook
import mcs.parameters.JournalType
import mcs.parameters.PlannerType
import mcs.parameters.WorkStatus

class TaskController { // entity id = 127

    def supportService

    def index() {

        redirect(action: "list", params: params)

    }
    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']


    def list() {

        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = (params.sort ? params.sort : 'lastUpdated')
        params.order = (params.order ? params.order : 'desc')

        //def breadCrumb = """<a href="${createLink(controller: 'task', action: 'index')}"> Task </a> &raquo; All records ( ${Task.count()} )"""
        [list: Task.list(params),
                totalRecords: Task.count()]

    }

    def deleted() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = (params.sort ? params.sort : 'lastUpdated')
        params.order = (params.order ? params.order : 'desc')

        def breadCrumb = """<a href="${createLink(controller: 'task', action: 'index')}"> Task </a> &raquo; Deleted records ( ${Task.deleted().count()} )"""
        render(view: 'list', model: [list: Task.deleted().list(params),
                totalRecords: Task.deleted().count(), breadCrumb: breadCrumb])

    }




    def show() {

        def taskInstance = Task.get(params.id)
        if (!taskInstance) {
            flash.message = "record.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "Task not found with id ${params.id}"
            redirect(action: 'list')
        }
        else {

            def changes = DataChangeAudit.findAllByEntityIdAndRecordId(127, params.id)
            def documents = Document.executeQuery("from Document d where d.applicationCode like :applicationCode and d.entityId = :entityId and d.recordId = :recordId", [applicationCode: 'mcs', entityId: new Long(127), recordId: params.id.toLong()], [sort: 'dateCreated', order: 'desc'])

            //    def breadCrumb = """<a href="${createLink(controller: 'task', action: 'index')}"> Task </a> &raquo; ${taskInstance.toString()}"""

            [taskInstance: taskInstance, changes: changes, documents: documents]
        }

    }


    def qshow() {
        def taskInstance = Task.get(params.id)
        if (!taskInstance) {
            flash.message = "record.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "Task not found with id ${params.id}"
            redirect(action: 'list')
        }
        else {
            [taskInstance: taskInstance]
        }
    }


    def markCompleted() {
        def taskInstance = Task.get(params.id)
        if (!taskInstance) {
            flash.message = "record.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "Task not found with id ${params.id}"
            render 'Task not found'
        }
        else {
            taskInstance.completedOn = new Date()
            taskInstance.taskStatus = WorkStatus.get(4)
            render 'Task marked as completed'
        }
    }



    def markAlmostCompleted() {
        def taskInstance = Task.get(params.id)
        if (!taskInstance) {
            flash.message = "record.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "Task not found with id ${params.id}"
            render 'Task not found'
        }
        else {
            taskInstance.almostCompletedOn = new Date()
            taskInstance.taskStatus = WorkStatus.get(5)
            render 'Task marked as almost completed'
        }
    }


    def delete() {
        def taskInstance = Task.get(params.id)
        if (taskInstance) {
            try {
                //taskInstance.delete()
                taskInstance.deletedOn = new Date()
                flash.message = "Task.deleted"
                flash.args = [params.id]
                flash.defaultMessage = "Task ${params.id} deleted"
                render "Task ${params.id} deleted"
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "taskInstance.not.deleted"
                flash.args = [params.id]
                flash.defaultMessage = "Task ${params.id} could not be deleted"
                render "Task ${params.id} could not be deleted" //redirect(action:'show',id:params.id)
            }
        }
        else {
            flash.message = "taskInstance.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "Task not found with id ${params.id}"
            render "Task not found with id ${params.id}" //redirect(action:'list')
        }
    }




    def update() {
        def taskInstance = Task.get(params.id)
        if (taskInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (taskInstance.version > version) {
                    // was lowercase
                    taskInstance.errors.rejectValue("version", "optimistic.locking.failure", "Another user has updated this Task while you were editing")
                    render(view: 'edit', model: [taskInstance: taskInstance])
                }
            }
            taskInstance.properties = params
            if (!taskInstance.hasErrors() && taskInstance.save(flush: true)) {

                flash.message = "Task.updated"
                flash.args = [params.id]
                flash.defaultMessage = "Task ${params.id} updated"
                //redirect(action:'show',id:taskInstance.id)
                redirect(action: 'list')
            }
            else {
                render(view: 'edit', model: [taskInstance: taskInstance])
            }
        }
        else {
            flash.message = "task.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "task not found with id ${params.id}"
            redirect(action: 'list')

        }
    }


    def edit() {

        def taskInstance = Task.get(params.id)
        if (!taskInstance) {
            flash.message = "Task.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "Task not found with id ${params.id}"
            render 'Record not found'
        }
        else {
            render(template: '/task/edit', model: [taskInstance: taskInstance])
        }

    }

    def qupdate() {
        def taskInstance = Task.get(params.id)
        if (taskInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (taskInstance.version > version) {
                    // was lowercase
                    taskInstance.errors.rejectValue("version", "optimistic.locking.failure", "Another user has updated this Task while you were editing")
                    render(view: 'qedit', model: [taskInstance: taskInstance,
                            qmessage: "Another user has updated this task while you were editing"])
                }
            }
            taskInstance.properties = params
            if (!taskInstance.hasErrors() && taskInstance.save(flush: true)) {
               render(template: '/gTemplates/recordSummary', model: [record: taskInstance, justUpdated: true])
//                render 'Task updated'
            }
            else {
                render(template: '/task/edit', model: [taskInstance: taskInstance])
            }
        }
        else {
            flash.message = "task.not.found"
            flash.args = [params.id]
            flash.defaultMessage = "task not found with id ${params.id}"
            render 'Record not found'
        }
    }




    def create() {

        def taskInstance = new Task()
        taskInstance.properties = params
        def breadCrumb = "Create new Task"
        [taskInstance: taskInstance, breadCrumb: breadCrumb]

    }

    def qcreate() {

        def taskInstance = new Task()
        taskInstance.properties = params
        render(view: 'qcreate', model: [taskInstance: taskInstance])

    }

    def save() {
        def taskInstance = new Task(params)
        def breadCrumb = "Create new Task"
        if (!taskInstance.hasErrors() && taskInstance.save(flush: true)) {
            // session['lastparentId'] =  taskInstance.parent.id
            flash.message = "task.created"
            flash.args = [taskInstance.id]
            flash.defaultMessage = "Task ${taskInstance.id} created"
            //              render(view:'create',model:[taskInstance: new Task()])

            redirect(action: 'create', model: [taskInstance: new Task(params), breadCrumb: breadCrumb])
        }
        else {

            render(view: 'create', model: [taskInstance: taskInstance, breadCrumb: breadCrumb])
        }
    }

    def qsave() {
        def taskInstance = new Task(params)
        if (!taskInstance.hasErrors() && taskInstance.save(flush: true)) {
            // session['lastparentId'] =  taskInstance.parent.id
            render(view: 'qshow', model: [taskInstance: taskInstance, hide: true,
                    qmessage: "Task ${taskInstance.toString()} created"])
            //new Task(),
        }
        else {
            flash.message = null
            render(view: 'qcreate', model: [taskInstance: new Task()])
        }
    }




    def getSearchResults() {
        def q = params.q ?: null

        if (!q || (q && q.trim().equals(''))) {
            render ""
        } else


        if (q.length() == 1)
            render "<br/><span class='alert'>You must type at least two characters.</span>"
        else {
            try {
                def results = Task.search('*' + q + '*', [max: 10])

                if (results.results.size() == 0)
                    render "<br/><span class='alert'>No matching records found for: <b>" + q + '</b></span><br/>'
                else
                    render(template: "/task/listResults", model: [matchingRecords: results.results,
                            displayedHits: results.results.size(),
                            totalHits: Task.countHits('*' + q + '*'), searchTerms: q])
            } catch (Exception e) {
                println e
            }
        } // end of else
    }



    def exportToExcel() {

        def header = [:]
        header.id = "Id"
        header.priority = "Priority"
        header.taskStatus = "Task status"
        header.plannedDuration = "Planned duration"
        header.name = "Name"
        header.description = "Description"
        header.location = "Location"
        header.course = "Course"

        header.notes = "Notes"
        header.dateCreated = "Date Created"
        header.lastUpdated = "Last Updated"
        // set our header and content type
        response.setHeader("Content-disposition", "attachment; filename=TaskList.xls")
        response.contentType = "application/vnd.ms-excel"
        //UtilController.writeExcel(response.outputStream, header, Task.list())
    } // end of exportToExcel
//
//    def schedule() {
//        def t = Task.get(params.id)
//        Date startDate = Date.parse('yyyy-MM-dd', supportService.fromWeekDate(params.newvalue.split(/ /)[0]))
//        //def d = params.newvalue.substring(4)
//        new Planner([description: '', startDate: startDate,
//                endDate: startDate, type: PlannerType.get(7), planLevel: 'd', task: t]).save()
//        new Journal([body: WorkStatus.get(11).name, task: t, startDate: new Date(), endDate: new Date(), type: JournalType.get(50), level: 'd']).save()
//        render params.newvalue
//    }


    def assignRecordToDate() {

        def book
        def task
        def excerpt
        def goal


        switch(params.recordType.toLowerCase()){
            case 'r': book = Book.get(params.recordId)
                break
            case 't': task = Task.get(params.recordId)
                break
            case 'g': goal = Goal.get(params.recordId)
                break
          case 'e': excerpt = Excerpt.get(params.recordId)
                break
        }
        def level = params.level

        def date = params.date//.substring(0,3).toString()
        def stime
        def etime
//        if (params.date.length() > 3){
//            stime = ' ' + params.date.substring(4) + ':00'
//            etime = ' ' + (params.date.substring(4).toInteger() + 1).toString() + ':00'
//        }
//        else {
//            stime = ' 00:00'
//            etime = ' 00:00'
//        }

	def summary = params.summary ?: 'No summary'

        def startDate = SupportService.fromWeekDateAsDateTimeFullSyntax(date)
            //Date.parse('dd.MM.yyyy HH:mm', supportService.fromWeekDate(date) + stime)
        def endDate = new Date(startDate.time + 3600000)
            //Date.parse('dd.MM.yyyy HH:mm', supportService.fromWeekDate(date) + etime)

//        def t = Task.get(params.id)
        def jp
        if (params.type == 'P')
        jp = new Planner([description: '', startDate: startDate, endDate: endDate, book: book, level: level, summary: summary,
                type: PlannerType.findByCode('assign'),
                status: WorkStatus.findByCode('not-started'),
                excerpt: excerpt, task: task, goal: goal]).save()
        else {
            jp = new Journal([description: '?', startDate: startDate, endDate: endDate, book: book, level: level, summary: summary,
                    type: JournalType.findByCode('act'), task: task, goal: goal,  excerpt: excerpt])
                    j.save()
        }

//        render(template: '/layouts/achtung', model: [message: 'Record assigned to date ' + params.date])
        render(template: '/gTemplates/recordSummary', model: [record: jp])
    }



    def updateStatus() {
        def g = Task.get(params.id)
        g.taskStatus = WorkStatus.get(params.taskStatus.id)
        //    new Planner([description: '', startDate: d1, endDate: d2, type: PlannerType.get(7), planLevel: 'M', task: g]).save()
        new Journal([body: WorkStatus.get(params.taskStatus.id).name, task: g, startDate: new Date(), endDate: new Date(), type: JournalType.get(50), level: 'd']).save()

        render(template: "/task/line", model: [taskInstance: g])

    }

    def updateParentGoal() {
        def g = Task.get(params.id)
        g.properties = params
        //        new Journal([body: WorkStatus.get(params.taskStatus.id).name, task: g, startDate: new Date(), endDate: new Date(), type: JournalType.get(50), level: 'd']).save()

        render(template: "/task/line", model: [taskInstance: g])

    }




    def importExcel() {
        Workbook workbook = Workbook.getWorkbook(new File('r:/hom/rpr/mcs_tasks.xls'))
        Sheet sheet = workbook.getSheet(0)

        def skipped = '';
        for (int r = 1; r < sheet.rows; r++) {
            println("\n\n" + sheet?.getCell(1, r)?.contents)
            println sheet?.getCell(0, r)?.contents
            def n = new Task()
//            n.front = Front.findByFrontCodeLike(sheet?.getCell(0, r)?.contents.toUpperCase())
            n.priority = (sheet?.getCell(1, r)?.contents?.length() == 1 ? sheet?.getCell(1, r)?.contents.toInteger() : 2)

            n.recurring = sheet?.getCell(2, r)?.contents?.trim() ? sheet?.getCell(1, r)?.contents : null
            n.name = sheet?.getCell(3, r)?.contents?.trim()
            n.taskStatus = WorkStatus.get(3)

            n.save(flush: true)
            println n.fullString()
        }
    }

    def refresh() {
        render(template: '/task/line', model: [taskInstance: Task.get(params.id)])
    }

    def details() {
        render(template: '/gTemplates/recordDetails', model: [record: Task.get(params.id)])
    }

    def calendar() {
        def title
        if (params.jp == 'J')
            title = "J " + JournalType.get(params.id).name
        if (params.jp == 'P')
            title = "P " + PlannerType.get(params.id).name

        render(view: '/task/calendar', model: [type: params.id, jp: params.jp, title: title])
    }

    def timeline() {
        render(view: '/task/timeline')
    }

    def search() {

        def results = null
        def list = null

        def queryWhere = ''
        def query = []
        def queryParams = []
        def count = 0

        def c = params.isTodo
//        if (c == 'on'){
//            queryWhere += 'isTodo = ? and '
//            queryParams.add(true)
//        } else {
//            queryWhere += 'isTodo = ? and '
//            queryParams.add(false)
//        }

        c = params.location
        if (c != 'null')
            query += ('location.id = ' + c)

//        c = params['location.id']
//        if (c != 'null'){
//            queryWhere += 'location = ? and '
//            query += 'location.id = ' + c
//            queryParams.add(Location.get(c.toLong()))
//        }

        c = params.taskStatus
        if (c != 'null') {
            queryWhere += 'taskStatus = ? and '
            query += 'taskStatus.id = ' + c
            queryParams.add(WorkStatus.get(c.toLong()))
        }

        c = params.course
        if (c != 'null') {
            queryWhere += 'course = ? and '
            query += 'course.id = ' + c
            queryParams.add(Course.get(c))
        }

        c = params.department
        if (c != 'null') {
            queryWhere += 'department = ? and '
            query += 'department.id = ' + c
            queryParams.add(Department.get(c.toLong()))
        }

        println 'query is now ' + query
//        query += ' order by department.departmentCode desc'
//        queryWhere = StringUtils.removeEnd(queryWhere, ' and ')
//        query = StringUtils.removeEnd(queryWhere, ' and ')

//        results = Task.executeQuery('from Task ' + (queryWhere != '' ? ' where ' : '') + queryWhere + '  order by department.departmentCode desc', queryParams, params)
        def fullQuery = 'from Task ' + (query.size == 0 ? '' : ' where ' + query.join(' and '))// + ' order by department.departmentCode desc'
        list = Task.executeQuery(fullQuery)
//        count = Task.executeQuery('select count(*) from Task ' + (queryWhere != '' ? ' where ' : '') + queryWhere, queryParams)[0]

//        render(template: '/task/list', model: [list: results, count: count,
//                title: "Search results - ${count} tasks found "
//            ])
        render(template: '/gTemplates/recordListing', model: [list: list, title: fullQuery])
    }

    def showPlans() {
        def taskInstance = Task.get(params.id)
        render(template: '/gTemplates/recordListing', model: [list: Planner.findAllByTask(Task.get(taskInstance.id))])
    }


    def expotTodotxt = {
        def result = ''

        def priorityMap = [5: 'A', 4: 'B', 3: 'C', 2: 'D', 1: 'E']
        for (i in Task.executeQuery("from Task where status.code != ? order by priority asc, department asc, summary asc", ['completed'])){
            result += "(${i.priority ? priorityMap[i.priority] : 'C'}) ${i.dateCreated.format('yyyy-MM-dd')} +${i.department?.code} @${i.location ? i.location?.code: 'none'} ${i.summary}<br/>"
            //  ? i.parentGoal?.code : 'usr'}
        }

        for (i in Task.executeQuery("from Task where status.code = ? order by priority asc, department asc, summary asc", ['completed'])){
            result += "x ${i.completedOn ? i.completedOn.format('yyyy-MM-dd') : new Date().format('yyyy-MM-dd') } (${i.priority ? priorityMap[i.priority] : 'C'}) ${i.dateCreated.format('yyyy-MM-dd')} +${i.parentGoal ? i.parentGoal?.code : 'usr'} @${i.location ?: 'none'} ${i.summary}<br/>"
        }
        render result.decodeHTML()
    }

    def kanban() {
        render(template: '/reports/kanban')
    }

} // end of class