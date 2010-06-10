package au.org.ala.collectory

import grails.test.GrailsUnitTestCase

/**
 * Created by markew
 * Date: May 13, 2010
 * Time: 9:23:08 AM
 */
class CollectionCommandTests extends GrailsUnitTestCase {

    CollectionCommand cc
    ProviderGroup pg1
    Contact c1

    protected void setUp() {
        super.setUp()
//        mockDomain ProviderGroup
        cc = new CollectionCommand()
        pg1 = new ProviderGroup(id:1)
        c1 = new Contact(id:3)
    }

    protected void tearDown() {
        super.tearDown()
    }

    /**
     * really just testing the techniques used not the method
     */
    void testAddAsParent() {
        assertEquals 0, cc.parents.size
        cc.parents << pg1
        assertEquals 1, cc.parents.size
    }

    void testRemoveAsParent() {
        cc.parents << pg1
        assertEquals 1, cc.parents.size
        cc.parents.remove(pg1)
        assertEquals 0, cc.parents.size
    }

    void testAddAsContact() {
        cc.addAsContact c1, "Editor", true
        assertEquals 1, cc.contacts.size()
    }

    void testRemoveAsContact() {
        cc.addAsContact c1, "Editor", true
        assertEquals 1, cc.contacts.size()
        cc.removeAsContact c1
        assertEquals 0, cc.contacts.size()
    }

    void testToJSON() {
        assertEquals '["Entomology","Insects","Spiders"]', cc.toJSON('Entomology,Insects,Spiders')
    }

    void testToCSVString() {
        assertEquals 'Entomology,Insects,Spiders', cc.toCSVString('["Entomology","Insects","Spiders"]')
    }

    void testBigDecimalValidation() {
        mockForConstraintsTests CollectionCommand, [cc]
        cc.setLatitude "-35.6789"
        cc.validate()
        assertFalse cc.hasErrors()
        assertEquals "-35.6789", cc.getLatitude()

        cc.setLatitude "trevor"
        cc.validate()
        if (cc.hasErrors()) {
            cc.errors.each {println it}
        }
        assertTrue cc.hasErrors()

    }
}
