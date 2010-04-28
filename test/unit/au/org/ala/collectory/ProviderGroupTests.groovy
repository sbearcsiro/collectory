package au.org.ala.collectory

import grails.test.*

class ProviderGroupTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testLatitude() {
        ProviderGroup pg = new ProviderGroup(guid: '237645', name: 'Bees', groupType: 'Collection', latitude: -40.032)
        assertEquals(-40.032, pg.latitude)
    }
}
