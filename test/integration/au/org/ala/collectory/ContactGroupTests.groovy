package au.org.ala.collectory
/*
 * Tests the interaction between contacts and ProviderGroups/Infosources
 */
import grails.test.*

class ContactGroupTests extends GrailsUnitTestCase {

    Contact pete, mark
    def group

    protected void setUp() {
        super.setUp()
        // some contacts
        pete = [firstName: "Peter", lastName: "Flemming", publish: true]
        pete.save(flush: true)
        mark = [firstName: "Mark", lastName: "Woolston", publish: true]
        mark.save(flush: true)
        // an entity of type ProviderGroup
        group = new ProviderGroup(guid: "ABC", name: "XYZ", groupType: "Institution").save(flush: true)
   }

    protected void tearDown() {
        super.tearDown()
    }

    void testLinks() {

        // make sure contacts are stored in the db
        assertEquals 2, Contact.count()

        assertEquals 0, ContactFor.count()

        // create a contact link
        new ContactFor(pete, group.id, "ProviderGroup", "Manager", true).save(flush: true)

        assertEquals 1, ContactFor.count()

        // retrieve contact links
        def contacts = ContactFor.findAll()
        assertEquals 1, contacts.size()

        // examine it
        ContactFor cf = contacts.get(0)
        println cf.print()

        new ContactFor(mark, group.id, "ProviderGroup", "Asst Manager", true).save(flush: true)

        // retrieve links for an entity
        def ecf = ContactFor.findAllByEntityId(group.id)
        assertEquals 2, ecf.size()
    }

    void testGroupContactsManualAdd() {
        // create contact links manually
        new ContactFor(pete, group.id, "ProviderGroup", "Manager", true).save(flush: true)
        new ContactFor(mark, group.id, "ProviderGroup", "Asst Manager", true).save(flush: true)

        // test getContacts
        assertEquals 2, group.getContacts().size()

        // test deleteContact
        group.deleteFromContacts(mark)
        group.deleteFromContacts(pete)
        assertEquals 0, group.getContacts().size()

        assertEquals 0, ContactFor.count()
    }

    void testGroupContactsUsingAddContact() {

        group.addToContacts(mark, "Project Officer", false)
        group.addToContacts(pete, "Manager", true)

        assertEquals 2, group.getContacts().size()
        List<ContactFor> contacts = group.getContacts()
        contacts.sort {item -> item.contact.id}
        println contacts[0].print()
        println contacts[1].print()
        assertEquals "Peter", contacts[0].contact.firstName
        assertEquals "Manager", contacts[0].role
        assertEquals true, contacts[0].isAdministrator
        assertEquals "Mark", contacts[1].contact.firstName
        assertEquals "Project Officer", contacts[1].role
        assertEquals false, contacts[1].isAdministrator

        // make sure the links were written to the db
        assertEquals 2, ContactFor.count()
    }

    // tests to see if the dynamic wiring in integration tests breaks the isAdministrator call
    void testIsAdministrator() {
        // create a contact link
        new ContactFor(pete, group.id, "ProviderGroup", "Manager", true).save(flush: true)

        assertEquals 1, ContactFor.count()

        ContactFor cf = ContactFor.findByContact(pete)
        assertNotNull cf
        assertEquals 'Peter', cf.contact.firstName
        assertTrue cf.isAdministrator

    }

}
