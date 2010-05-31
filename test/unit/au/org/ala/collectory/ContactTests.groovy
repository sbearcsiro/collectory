package au.org.ala.collectory

import grails.test.*

class ContactTests extends GrailsUnitTestCase {
    Contact contact

    protected void setUp() {
        super.setUp()
        contact = new Contact(
            title: "Dr",
            firstName: "contact",
            lastName: "Woolston",
            phone: "0262465909",
            mobile: "0419468551",
            email: "contact.woolston@csiro.au",
            notes: "to be treated with exaggerated respect",
            publish: true)

    }

    protected void tearDown() {
        super.tearDown()
    }

    void testConstraints() {

        mockForConstraintsTests(Contact, [ contact ])
        contact.validate()
        if (contact.hasErrors())
            println badContact.errors
        assertTrue contact.validate()

        // test validation
        def testContact = new Contact()
        assertFalse testContact.validate()
        assertEquals "nullable", testContact.errors["firstName"]
        assertEquals "nullable", testContact.errors["lastName"]
    }

    void testTitle() {
        mockForConstraintsTests(Contact)

        def testContact = new Contact(title: "Dr", firstName: "Lemmy", lastName: "Caution")
        if (testContact.hasErrors())
            println testContact.errors
        assertTrue testContact.validate()

        def badContact = new Contact(title: "Archbishop", firstName: "Lemmy", lastName: "Caution")
        assertFalse badContact.validate()
        if (badContact.hasErrors())
            println badContact.errors
        assertEquals "inList", badContact.errors['title']
    }

    void testEmail() {
        mockForConstraintsTests(Contact)

        def testContact = new Contact(firstName: "Lemmy", lastName: "Caution", email: "contact@csiro.au")
        assertTrue testContact.validate()

        def badContact = new Contact(firstName: "Lemmy", lastName: "Caution", email: "contact.csiro")
        badContact.validate()
        if (badContact.hasErrors())
            println badContact.errors
        assertEquals "email", badContact.errors['email']
    }

    void testparseName() {
        contact = new Contact()
        contact.parseName("Dr Lemmy Caution")
        assertEquals "Dr", contact.title
        assertEquals "Lemmy", contact.firstName
        assertEquals "Caution", contact.lastName

        //log contact.toString()

        contact = new Contact()
        contact.parseName("Lemmy Caution")
        assertNull contact.title
        assertEquals "Lemmy", contact.firstName
        assertEquals "Caution", contact.lastName

        contact = new Contact()
        contact.parseName("Lemmy A. Caution")
        assertEquals "", contact.title
        assertEquals "Lemmy A.", contact.firstName
        assertEquals "Caution", contact.lastName

        contact = new Contact()
        contact.parseName("Dr_Lemmy_Caution")
        assertNull contact.title
        assertNull contact.firstName
        assertEquals "Dr_Lemmy_Caution", contact.lastName

        contact = new Contact()
        contact.parseName("")
        assertNull contact.title
        assertNull contact.firstName
        assertNull contact.lastName

        contact = new Contact()
        contact.parseName("Mr Lemmy Alphaville Caution")
        assertEquals "Mr", contact.title
        assertEquals "Lemmy Alphaville", contact.firstName
        assertEquals "Caution", contact.lastName

    }
}
