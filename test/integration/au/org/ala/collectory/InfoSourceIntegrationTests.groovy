package au.org.ala.collectory

import grails.test.GrailsUnitTestCase

/**
 * Created by markew
 * Date: May 27, 2010
 * Time: 2:56:46 PM
 */
class InfoSourceIntegrationTests extends GrailsUnitTestCase {
    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testAccessParameters() {

        InfoSource is = new InfoSource(title: "test")

        assertNull is.getWebServiceUri()
        
        is.setWebServiceUri "http://test"
        is.setWebServiceProtocol "DiGIR"

        assertEquals "http://test", is.getWebServiceUri()
        assertEquals "DiGIR", is.getWebServiceProtocol()
    }

}
