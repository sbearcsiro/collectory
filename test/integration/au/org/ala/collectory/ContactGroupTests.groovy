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
        pete = new Contact(firstName: "Peter", lastName: "Flemming", publish: true, email: "pete@csiro.au", userLastModified: "test")
        pete.save(flush: true)
        if (pete.hasErrors()) pete.errors.each {println it}
        mark = new Contact(firstName: "Mark", lastName: "Woolston", publish: true, userLastModified: "test")
        mark.save(flush: true)
        if (mark.hasErrors()) mark.errors.each {println it}
        // an entity of type ProviderGroup
        group = new Institution(guid: "ABC", uid:'in13', name: "XYZ", userLastModified: "test").save(flush: true)
        if (group.hasErrors()) group.errors.each {println it}
   }

    protected void tearDown() {
        super.tearDown()
    }

    void testLinks() {

        // make sure contacts are stored in the db
        assertEquals 2, Contact.count()

        assertEquals 0, ContactFor.count()

        // create a contact link
        new ContactFor(contact: pete, entityUid: group.uid, role: "Manager",
                administrator: true, primaryContact: true, userLastModified: "test").save(flush: true)

        assertEquals 1, ContactFor.count()

        // retrieve contact links
        def contacts = ContactFor.findAll()
        assertEquals 1, contacts.size()

        // examine it
        ContactFor cf = contacts.get(0)
        println cf.print()

        new ContactFor(contact: mark, entityUid: group.uid, role: "Asst Manager",
                administrator: true, primaryContact: false, userLastModified: "test").save(flush: true)

        // retrieve links for an entity
        def ecf = ContactFor.findAllByEntityId(group.id)
        assertEquals 2, ecf.size()
    }

    void testGroupContactsManualAdd() {
        // create contact links manually
        new ContactFor(contact: pete, entityUid: group.uid, role: "Manager",
                administrator: true, primaryContact: true, userLastModified: "test").save(flush: true)
        new ContactFor(contact: mark, entityUid: group.uid, role: "Asst Manager",
                administrator: true, primaryContact: false, userLastModified: "test").save(flush: true)

        // test getContacts
        assertEquals 2, group.getContacts().size()

        // test deleteContact
        group.deleteFromContacts(mark)
        group.deleteFromContacts(pete)
        assertEquals 0, group.getContacts().size()

        assertEquals 0, ContactFor.count()
    }

    void testGroupContactsUsingAddContact() {

        group.addToContacts(mark, "Project Officer", false, false, 'test')
        group.addToContacts(pete, "Manager", true, true, 'test')

        assertEquals 2, group.getContacts().size()
        List<ContactFor> contacts = group.getContacts()
        contacts.sort {item -> item.contact.id}
        println contacts[0].print()
        println contacts[1].print()
        assertEquals "Peter", contacts[0].contact.firstName
        assertEquals "Manager", contacts[0].role
        assertEquals true, contacts[0].administrator
        assertEquals true, contacts[0].primaryContact
        assertEquals "Mark", contacts[1].contact.firstName
        assertEquals "Project Officer", contacts[1].role
        assertEquals false, contacts[1].administrator
        assertEquals false, contacts[1].primaryContact

        // make sure the links were written to the db
        assertEquals 2, ContactFor.count()
    }

    // tests to see if the dynamic wiring in integration tests breaks the isAdministrator call
    void testIsAdministrator() {
        // create a contact link
        new ContactFor(contact: pete, entityUid: group.uid, role: "Manager",
                administrator: true, primaryContact: true, userLastModified: "test").save(flush: true)

        assertEquals 1, ContactFor.count()

        ContactFor cf = ContactFor.findByContact(pete)
        assertNotNull cf
        assertEquals 'Peter', cf.contact.firstName
        assertTrue cf.administrator

    }

    void testSearchByUser() {
        // create a contact link
        new ContactFor(contact: pete, entityUid: group.uid, role: "Manager",
                administrator: true, primaryContact: true, userLastModified: "test").save(flush: true)

        def userContact = Contact.findByEmail("pete@csiro.au")
        assertNotNull userContact

        def collectionList = []
        ContactFor.findAllByContact(userContact).each {
            ProviderGroup pg = ProviderGroup.findById(it.entityId)
            if (pg) {
                collectionList << pg
            }
        }
        assertEquals 1, collectionList.size()
    }
}
