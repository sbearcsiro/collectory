package au.org.ala.collectory

import grails.test.*

class ProviderMapTests extends GrailsUnitTestCase {

    ProviderMap map
    ProviderCode code1
    ProviderCode code2
    ProviderCode code3
    ProviderGroup pg1

    protected void setUp() {
        super.setUp()
        mockDomain ProviderCode
        mockDomain ProviderMap
        code1 = new ProviderCode(code:'code1')
        code2 = new ProviderCode(code:'code2')
        code3 = new ProviderCode(code:'code3')
        map = new ProviderMap()
        map.addToInstitutionCodes(code1)
        map.addToCollectionCodes(code2)
        map.addToCollectionCodes(code3)
        pg1 = new ProviderGroup(id:12, groupType:'collection', name:'pg name')
        map.providerGroup = pg1
        map.save()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testContains() {
        assertTrue ([code1,code2,code3].collect{it.code}.contains("code1"))
    }
    
    void testMatches() {
        def cCodes = map.getCollectionCodes()
        assertEquals 2, cCodes.size()
        assertTrue cCodes.collect{it.code}.contains("code2")

        assertTrue map.matches("code1", "code2")
        assertTrue map.matches("code1", "code3")
        assertFalse map.matches("code2", "code3")
    }

    void testFindMatch() {
        def pg1 = ProviderMap.find("from provider_map_provider_code as pp, provider_code as c, provider_map as m where c.code = 'CSIRO' and pp.provider_code_id = c.id and m.id = pp.provider_map_institution_codes_id")
        

        def pg = ProviderMap.findMatch("code1", "code2")
        assertNotNull pg
        assertEquals "pg name", pg.name
        assertEquals 12, ProviderMap.findMatchId("code1", "code2")

        // alt
        //def x = ProviderMap.find('from ProviderMap as pm where pm.institutionCode.code = code1')
        //println x
    }
}
