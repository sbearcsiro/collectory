package au.org.ala.collectory

import grails.test.GrailsUnitTestCase
import grails.converters.JSON
import grails.converters.JSON.Builder

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

    void testSubCollectionParsing() {
        def json = '[{"name":"coll1","description":"desc1"},{"name":"coll2","description":"desc2"}]'
        def subCollections = JSON.parse(json)
        assertEquals 2, subCollections.size()
        subCollections.eachWithIndex { it, index ->
            assertEquals "coll${index+1}", it.name
            assertEquals "desc${index+1}", it.description
        }
        List<String> names = []
        List<String> descs = []
        JSON.parse(json).each {
            names << it.name
            descs << it.description
        }
        assertEquals 2, names.size()
        assertEquals 2, descs.size()
        assertEquals "coll1", names[0]
        assertEquals "coll2", names[1]
        assertEquals "desc1", descs[0]
        assertEquals "desc2", descs[1]
    }

    void testSubCollectionJSONBuilding() {
        def json = '[{"name":"coll1","description":"desc1"},{"name":"coll2","description":"desc2"}]'
        cc.loadSubCollections json
        cc.subCollections.each {println it.name + " - " + it.description}
        assertEquals 2, cc.subCollections.size()
        assertEquals "coll1", cc.subCollections[0].name
        assertEquals "desc2", cc.subCollections[1].description
    }
}
