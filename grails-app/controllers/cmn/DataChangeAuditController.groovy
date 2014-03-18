package cmn

class DataChangeAuditController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index () {
        redirect(action: "list", params: params)
    }

    def list () {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [dataChangeAuditInstanceList: DataChangeAudit.list(params), dataChangeAuditInstanceTotal: DataChangeAudit.count()]
    }

    def create () {
        def dataChangeAuditInstance = new DataChangeAudit()
        dataChangeAuditInstance.properties = params
        return [dataChangeAuditInstance: dataChangeAuditInstance]
    }

    def save () {
        def dataChangeAuditInstance = new DataChangeAudit(params)
        if (dataChangeAuditInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), dataChangeAuditInstance.id])}"
            redirect(action: "show", id: dataChangeAuditInstance.id)
        }
        else {
            render(view: "create", model: [dataChangeAuditInstance: dataChangeAuditInstance])
        }
    }

    def show () {
        def dataChangeAuditInstance = DataChangeAudit.get(params.id)
        if (!dataChangeAuditInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), params.id])}"
            redirect(action: "list")
        }
        else {
            [dataChangeAuditInstance: dataChangeAuditInstance]
        }
    }

    def edit () {
        def dataChangeAuditInstance = DataChangeAudit.get(params.id)
        if (!dataChangeAuditInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [dataChangeAuditInstance: dataChangeAuditInstance]
        }
    }

    def update () {
        def dataChangeAuditInstance = DataChangeAudit.get(params.id)
        if (dataChangeAuditInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (dataChangeAuditInstance.version > version) {
                    
                    dataChangeAuditInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit')] as Object[], "Another user has updated this DataChangeAudit while you were editing")
                    render(view: "edit", model: [dataChangeAuditInstance: dataChangeAuditInstance])
                    return
                }
            }
            dataChangeAuditInstance.properties = params
            if (!dataChangeAuditInstance.hasErrors() && dataChangeAuditInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), dataChangeAuditInstance.id])}"
                redirect(action: "show", id: dataChangeAuditInstance.id)
            }
            else {
                render(view: "edit", model: [dataChangeAuditInstance: dataChangeAuditInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete () {
        def dataChangeAuditInstance = DataChangeAudit.get(params.id)
        if (dataChangeAuditInstance) {
            try {
                dataChangeAuditInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataChangeAudit.label', default: 'DataChangeAudit'), params.id])}"
            redirect(action: "list")
        }
    }
}
