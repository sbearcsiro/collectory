package au.org.ala.collectory

import grails.test.*

class CollectionScopeTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testSomething() {

        CollectionScope cs = new CollectionScope()()
        mockForConstraintsTests(CollectionScope, [cs])

        cs.kingdomCoverage = "Animalia"
        assertTrue cs.validate()
        assertFalse cs.hasErrors()

        cs.kingdomCoverage = "Dogs"
        assertFalse cs.validate()
        assertEquals 'validator', cs.errors['kingdomCoverage']

        cs.kingdomCoverage = "Dogs Plantae"
        assertFalse cs.validate()
        assertEquals 'validator', cs.errors['kingdomCoverage']

        cs.kingdomCoverage = "Animalia Plantae"
        assertTrue cs.validate()
        assertFalse cs.hasErrors()
    }
}
