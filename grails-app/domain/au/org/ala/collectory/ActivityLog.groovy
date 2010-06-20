package au.org.ala.collectory

import org.codehaus.groovy.grails.plugins.springsecurity.AuthorizeTools

/**
 * Records user activity such as login and editing.
 */
class ActivityLog implements Serializable {

    Date timestamp                              // time of the event
    String user                                 // username
    String roles                                // space separated list of roles
    long entityId = -1                          // id of the affected record if any
    boolean contactForEntity = false            // are they a contact for the record
    boolean administratorForEntity = false      // are they an administrator of the record
    String action                               // what did they do

    static transients = ['Actions']
    
    static constraints = {
        timestamp(blank:false)
        user(blank:false)
        roles()
        entityId()
        contactForEntity()
        administratorForEntity()
        action(blank:false)
    }

    static void log(String user, Action action) {
        //def a = Actions.valueOf(Actions.class, action)
        //def actionText = a ? a.toString() : action
        def roles = AuthorizeTools.getPrincipalAuthorities().join(" ")
        def al = new ActivityLog(timestamp: new Date(), user: user, roles: roles, action: action.toString())
        al.errors.each {println it}
        al.save(flush:true)
    }

    static void log(String user, Action action, String item) {
        new ActivityLog(timestamp: new Date(), user: user, roles: AuthorizeTools.getPrincipalAuthorities().join(" "), action: action.toString() + " " + item).save(flush:true)
    }

    // use different param order so we reject ids being passed as a string rather than creating badly formed records
    static void log(String user, long entityId, Action action) {
        ProviderGroup pg = ProviderGroup.findById(entityId)
        if (!pg) {
            log(user, action, " entity with id = ${entityId}")
            return
        }
        boolean isContact = false
        boolean isAdmin = false
        Contact c = Contact.findByEmail(user)
        if (c) {
            ContactFor cf = ContactFor.findByContactAndEntityId(c, entityId)
            if (cf) {
                isContact = true
                isAdmin = cf.isAdministrator()
            }
        }
        new ActivityLog(timestamp: new Date(), user: user, roles: AuthorizeTools.getPrincipalAuthorities().join(" "),
                entityId: entityId, contactForEntity:isContact,
                administratorForEntity: isAdmin, action: action.toString()).save(flush:true)
    }

    String toString() {
        if (entityId != -1) {
            "${timestamp}: ${user} ${action} ${ProviderGroup.findById(entityId)?.name}"
        } else {
            "${timestamp}: ${user} ${action}"
        }
    }

}
