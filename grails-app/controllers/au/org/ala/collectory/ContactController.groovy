package au.org.ala.collectory

class ContactController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [contactInstanceList: Contact.listOrderByLastName(params), contactInstanceTotal: Contact.count()]
    }

    def create = {
        def contactInstance = new Contact()
        contactInstance.properties = params
        contactInstance.userLastModified = username()
        return [contactInstance: contactInstance, caller: params.caller, callerId: params.callerId]
    }

    def save = {
        def contactInstance = new Contact(params)
        contactInstance.userLastModified = username()?:'not available'
        params.each{println it}
        contactInstance.validate()
        contactInstance.errors.each{println it}
        if (contactInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'contact.label', default: 'Contact'), contactInstance.id])}"
            if (params.caller == 'collection') {
                redirect(controller: params.caller, action: 'addNewContact', params: [contactId: contactInstance.id, collectionId: params.callerId])
            } else {
                redirect(action: "show", id: contactInstance.id)
            }
        }
        else {
            render(view: "create", model: [contactInstance: contactInstance], caller: params.caller, callerId: params.callerId)
        }
    }

    def show = {
        def contactInstance = Contact.get(params.id)
        if (!contactInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
        else {
            [contactInstance: contactInstance]
        }
    }

    def edit = {
        def contactInstance = Contact.get(params.id)
        if (!contactInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [contactInstance: contactInstance, returnTo: params.returnTo]
        }
    }

    def update = {
        def contactInstance = Contact.get(params.id)
        if (contactInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (contactInstance.version > version) {
                    
                    contactInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'contact.label', default: 'Contact')] as Object[], "Another user has updated this Contact while you were editing")
                    render(view: "edit", model: [contactInstance: contactInstance])
                    return
                }
            }
            contactInstance.properties = params
            contactInstance.userLastModified = username()
            if (!contactInstance.hasErrors() && contactInstance.save(flush: true)) {
                ActivityLog.log username(), isAdmin(), Action.DELETE, "contact ${params.id}"
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'contact.label', default: 'Contact'), contactInstance.id])}"
                if (params.returnTo) {
                    redirect(uri: params.returnTo)
                } else {
                    redirect(action: "show", id: contactInstance.id)
                }
            }
            else {
                render(view: "edit", model: [contactInstance: contactInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
    }

    /**
     * MEW - modified to cascade delete all ContactFor links for the contact
     */
    def delete = {
        def contactInstance = Contact.get(params.id)
        if (contactInstance) {
            try {
                ActivityLog.log username(), isAdmin(), Action.DELETE, "contact ${contactInstance.buildName()}"
                // need to delete any ContactFor links first
                ContactFor.findAllByContact(contactInstance).each {
                    it.delete(flush: true)
                }
                contactInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
                redirect(action: "list")
            } catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
    }

    private String username() {
        return (request.getUserPrincipal()?.attributes?.email)?:'not available'
    }

    private boolean isAdmin() {
        return (request.isUserInRole(ProviderGroup.ROLE_ADMIN))
    }
}
