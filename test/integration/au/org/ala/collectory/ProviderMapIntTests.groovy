package au.org.ala.collectory

import grails.test.GrailsUnitTestCase

/**
 * Created by markew
 * Date: Jul 30, 2010
 * Time: 9:17:23 AM
 */
class ProviderMapIntTests extends GrailsUnitTestCase {

    ProviderMap map
    ProviderCode code1
    ProviderCode code2
    ProviderCode code3
    ProviderGroup pg1

    protected void setUp() {
        super.setUp()
        code1 = new ProviderCode(code:'code1').save(flush:true)
        code2 = new ProviderCode(code:'code2').save(flush:true)
        code3 = new ProviderCode(code:'code3').save(flush:true)
        map = new ProviderMap()
        map.addToInstitutionCodes(code1)
        map.addToCollectionCodes(code2)
        map.addToCollectionCodes(code3)
        pg1 = new ProviderGroup(id:12, groupType:'collection', name:'pg name').save(flush:true)
        map.providerGroup = pg1
        map.save(flush:true)
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
        def pg1 = ProviderMap.find("from ProviderMapProviderCode as pp, ProviderCode as c, ProviderMap as m where c.code = 'CSIRO' and pp.providerCodeId = c.id and m.id = pp.providerMapInstitutionCodesId")


        def pg = ProviderMap.findMatch("code1", "code2")
        assertNotNull pg
        assertEquals "pg name", pg.name
        assertEquals 12, ProviderMap.findMatchId("code1", "code2")

        // alt
        //def x = ProviderMap.find('from ProviderMap as pm where pm.institutionCode.code = code1')
        //println x
    }
}
