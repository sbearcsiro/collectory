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
        ProviderGroup pg = new ProviderGroup(guid: '237645', name: 'Bees', groupType: 'Collection', latitude: -40.03234665)
        assertEquals(-40.03234665, pg.latitude)
    }

    void testHasProviderCode() {
        ProviderGroup pg = new ProviderGroup(
                guid: '237645',
                name: 'Bees',
                groupType: ProviderGroup.GROUP_TYPE_COLLECTION,
                providerCodes: '["ants", "pants", "plants"]')

        assertTrue pg.hasProviderCode('ants')
        assertTrue pg.hasProviderCode('PANTS')
        assertTrue pg.hasProviderCode('Plants')

        assertFalse pg.hasProviderCode('pant')
        assertFalse pg.hasProviderCode('lant')
        assertFalse pg.hasProviderCode('bees')

        pg.internalProviderCodes = '["bees", "knees", "plants"]'

        assertTrue pg.hasProviderCode('bees')
        assertTrue pg.hasProviderCode('KNEES')
        assertTrue pg.hasProviderCode('Plants')

        assertFalse pg.hasProviderCode('ants')
        assertFalse pg.hasProviderCode('pants')
        assertFalse pg.hasProviderCode('nees')

        pg.internalProviderCodes = '["ANY", "knees", "plants"]'

        assertTrue pg.hasProviderCode('wallabees')
        assertTrue pg.hasProviderCode('KNEES')
        assertTrue pg.hasProviderCode('ants')
    }

    void testMatchesCollection() {
        ProviderGroup pg = new ProviderGroup(
                guid: '237645',
                name: 'Bees',
                groupType: ProviderGroup.GROUP_TYPE_COLLECTION,
                providerCodes: '["ants", "pants", "plants"]',
                internalInstitutionCodes: '["CSIRO"]')

        assertTrue pg.matchesCollection('csiro', 'ants')

        // other tests require relationships - see integration tests
    }
}
