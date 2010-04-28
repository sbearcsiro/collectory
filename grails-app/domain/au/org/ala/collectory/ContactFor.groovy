package au.org.ala.collectory
/*  Represents a contact in the context of a specific group, eg institution,
 *  collection or dataset.
 *
 *  - based on collectory data model version 5
 */

class ContactFor {

    Contact contact
    long entityId
    String entityType
    String role
    boolean administrator = false

    ContactFor () {}

    ContactFor (Contact contact, long entityId, String entityType, String role, boolean isAdministrator) {
        this.contact = contact
        this.entityId = entityId
        this.entityType = entityType
        this.role = role
        this.isAdministrator = isAdministrator
    }
    
    static mapping = {
        contact index: 'contact_id_idx'
        entityId index: 'entity_id_idx'
    }

    static constraints = {
        contact()
        entityId()
        entityType(blank:false, inList: ['ProviderGroup', 'Infosource'])
    }

    def print() {
        ["Contact id: " + contact.id,
         "Entity id: " + entityId,
         "Entity type: " + entityType,
         "Role: " + role,
         "isAdmin: " + isAdministrator]
    }

}
