package au.org.ala.collectory

import org.springframework.web.context.request.RequestContextHolder
import grails.converters.JSON
import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent

class ManageController {

    def authService
    def crudService

    /**
     * Landing page for self-service management of entities.
     *
     * This is not cas-enabled so we must use the helper cookie to determine whether the user is logged in.
     * If the user is logged in, redirect to the cas-enabled 'list' action, so we can get roles.
     * Only users who are NOT logged in will see the 'index' page.
     *
     * @param noRedirect if present will override the redirect (for testing purposes only)
     */
    def index = {
        // forward if logged in
        if (AuthenticationCookieUtils.cookieExists(request, AuthenticationCookieUtils.ALA_AUTH_COOKIE)
            && !params.noRedirect) {
            redirect(action: 'list')
        }
    }

    /**
     * Landing page for self-service management of entities.
     * 
     * @param show = user will display user login/cookie/roles details
     */
    def list = {

        // find the entities the user is allowed to edit
        def entities = authService.authorisedForUser(authService.username()).sorted

        // get their contact details in case needed
        def contact = Contact.findByEmail(authService.username())

        [entities: entities, user: contact, show: params.show]
    }

    def show = {
        // assume it's a collection for now
        def instance = ProviderGroup._get(params.id)
        if (!instance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params?.id])}"
            redirect(controller: "manage", action: "list")
        } else {
            [instance: instance, changes: getChanges(instance.uid)]
        }

    }

    def update = {
        if (request.post && request.getHeader('Content-Type').equals('application/json')) {
            def changes = request.JSON
            if (changes.api_key != 'Venezuela') {
                render(status: 403, text: 'Forbidden access')
            } else {
                println(changes)
                def instance = ProviderGroup._get(changes.uid)
                if (instance.version != changes.version as int) {
                    render(status: 202, text: 'Another user has updated this record while you were editing.')
                } else {
                    crudService.updateCollection(instance, changes)
                    render(status: 200, text: 'Ok')
                }
            }
        } else {
            render(status: 400, text: 'Wrong format')
        }
    }

    def getChanges(uid) {
        // get audit records
        return AuditLogEvent.findAllByUri(uid,[sort:'lastUpdated',order:'desc',max:20])
    }

}
