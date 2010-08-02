package au.org.ala.collectory

class ProviderGroupController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [providerGroupInstanceList: ProviderGroup.list(params), providerGroupInstanceTotal: ProviderGroup.count()]
    }

    def create = {
        def providerGroupInstance = new ProviderGroup()
        providerGroupInstance.properties = params
        return [providerGroupInstance: providerGroupInstance]
    }

    def save = {
        def providerGroupInstance = new ProviderGroup(params)
        if (providerGroupInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), providerGroupInstance.id])}"
            redirect(action: "show", id: providerGroupInstance.id)
        }
        else {
            render(view: "create", model: [providerGroupInstance: providerGroupInstance])
        }
    }

    def show = {
        def providerGroupInstance = ProviderGroup.get(params.id)
        if (!providerGroupInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
            redirect(action: "list")
        }
        else {
            [providerGroupInstance: providerGroupInstance]
        }
    }

    def edit = {
        def providerGroupInstance = ProviderGroup.get(params.id)
        if (!providerGroupInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [providerGroupInstance: providerGroupInstance]
        }
    }

    def update = {
        def providerGroupInstance = ProviderGroup.get(params.id)
        if (providerGroupInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (providerGroupInstance.version > version) {
                    
                    providerGroupInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'providerGroup.label', default: 'ProviderGroup')] as Object[], "Another user has updated this ProviderGroup while you were editing")
                    render(view: "edit", model: [providerGroupInstance: providerGroupInstance])
                    return
                }
            }
            providerGroupInstance.properties = params
            if (!providerGroupInstance.hasErrors() && providerGroupInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), providerGroupInstance.id])}"
                redirect(action: "show", id: providerGroupInstance.id)
            }
            else {
                render(view: "edit", model: [providerGroupInstance: providerGroupInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def providerGroupInstance = ProviderGroup.get(params.id)
        if (providerGroupInstance) {
            try {
                providerGroupInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
            redirect(action: "list")
        }
    }
}
