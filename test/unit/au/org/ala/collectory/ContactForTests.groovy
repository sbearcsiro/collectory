package au.org.ala.collectory

import grails.test.*

class ContactForTests extends GrailsUnitTestCase {

    ContactFor cf

    protected void setUp() {
        super.setUp()

        cf = new ContactFor(
            contact: [id: 4, lastName: "Caution"] as Contact,  // mock list as Contact class 
            entityId: 27,
            entityType: "Institution",
            role: "Manager",
            administrator: true)

    }

    protected void tearDown() {
        super.tearDown()
    }

    void testPrint() {
        assertEquals([
            "Contact id: 4",
            "Entity id: 27",
            "Entity type: Institution",
            "Role: Manager",
            "Admin: true"]
            , cf.print())
    }
}
