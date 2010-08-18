package au.org.ala.collectory

class ProviderMapController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = "collectionName"
        if (!params.order) params.order = "asc"
        def maps = ProviderMap.withCriteria {
            maxResults(params.max?.toInteger())
            firstResult(params.offset?.toInteger())
            if (params.sort == 'collectionName') {
                collection {
                    order('name', params.order)
                }
            } else {
                order(params.sort, params.order)
            }
        }
        [providerMapInstanceList: maps, providerMapInstanceTotal: ProviderMap.count()]
    }

    def create = {
        def providerMapInstance = new ProviderMap()
        providerMapInstance.properties = params
        return [providerMapInstance: providerMapInstance]
    }

    def save = {
        def providerMapInstance = new ProviderMap(params)
        if (providerMapInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), providerMapInstance.id])}"
            redirect(action: "show", id: providerMapInstance.id)
        }
        else {
            render(view: "create", model: [providerMapInstance: providerMapInstance])
        }
    }

    def show = {
        def providerMapInstance = ProviderMap.get(params.id)
        if (!providerMapInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), params.id])}"
            redirect(action: "list")
        }
        else {
            [providerMapInstance: providerMapInstance]
        }
    }

    def edit = {
        def providerMapInstance = ProviderMap.get(params.id)
        if (!providerMapInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [providerMapInstance: providerMapInstance]
        }
    }

    def update = {
        def providerMapInstance = ProviderMap.get(params.id)
        if (providerMapInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (providerMapInstance.version > version) {
                    
                    providerMapInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'providerMap.label', default: 'ProviderMap')] as Object[], "Another user has updated this ProviderMap while you were editing")
                    render(view: "edit", model: [providerMapInstance: providerMapInstance])
                    return
                }
            }
            providerMapInstance.properties = params
            if (!providerMapInstance.hasErrors() && providerMapInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), providerMapInstance.id])}"
                redirect(action: "show", id: providerMapInstance.id)
            }
            else {
                render(view: "edit", model: [providerMapInstance: providerMapInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def providerMapInstance = ProviderMap.get(params.id)
        if (providerMapInstance) {
            try {
                providerMapInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerMap.label', default: 'ProviderMap'), params.id])}"
            redirect(action: "list")
        }
    }
}
