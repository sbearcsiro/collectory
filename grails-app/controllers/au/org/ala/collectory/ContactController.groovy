package au.org.ala.collectory

import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class ContactController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

/*
 * Access control
 *
 * All methods require EDITOR role.
 * Delete requires ADMIN role.
 */
    def authService
    def beforeInterceptor = [action:this.&auth]
    def auth() {
        if (!authService.userInRole(ProviderGroup.ROLE_EDITOR)) {
            render "You are not authorised to access this page."
            return false
        }
    }
/*
 End access control
 */

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = 'lastName'
        [contactInstanceList: Contact.list(params), contactInstanceTotal: Contact.count()]
    }

    def name = {
        def contactInstance = Contact.get(params.id)
        if (!contactInstance) {
            render "contact not found"
        }
        else {
            render contactInstance.buildName()
        }
    }
    
    def create = {
        def contactInstance = new Contact()
        contactInstance.properties = params
        contactInstance.userLastModified = authService.username()
        return [contactInstance: contactInstance, returnTo: params.returnTo]
    }

    def save = {
        def contactInstance = new Contact(params)
        contactInstance.userLastModified = authService.username()?:'not available'
        contactInstance.validate()
        contactInstance.errors.each{println it}
        if (contactInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'contact.label', default: 'Contact'), contactInstance.id])}"
            if (params.returnTo) {
                redirect(uri: params.returnTo + "?contactId=${contactInstance.id}")
            } else {
                redirect(action: "show", id: contactInstance.id)
            }
        }
        else {
            render(view: "create", model: [contactInstance: contactInstance], returnTo: params.returnTo)
        }
    }

    def show = {
        def contactInstance = Contact.get(params.id)
        if (!contactInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
        else {
            [contactInstance: contactInstance,
             changes: AuditLogEvent.findAllByPersistedObjectIdAndClassName(
                     contactInstance.id,'au.org.ala.collectory.Contact',[sort:'lastUpdated',order:'desc',max:10])]
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
                    render(view: "edit", model: [contactInstance: contactInstance, returnTo: params.returnTo])
                    return
                }
            }
            contactInstance.properties = params
            contactInstance.userLastModified = authService.username()
            if (!contactInstance.hasErrors() && contactInstance.save(flush: true)) {
                ActivityLog.log authService.username(), authService.isAdmin(), Action.EDIT_SAVE, "contact ${params.id}"
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'contact.label', default: 'Contact'), contactInstance.id])}"
                if (params.returnTo) {
                    redirect(uri: params.returnTo)
                } else {
                    redirect(action: "show", id: contactInstance.id)
                }
            }
            else {
                render(view: "edit", model: [contactInstance: contactInstance, returnTo: params.returnTo])
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
            if (authService.isAdmin()) {
                try {
                    ActivityLog.log authService.username(), authService.isAdmin(), Action.DELETE, "contact ${contactInstance.buildName()}"
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
            } else {
                render "You are not authorised to access this page."
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contact.label', default: 'Contact'), params.id])}"
            redirect(action: "list")
        }
    }

}
