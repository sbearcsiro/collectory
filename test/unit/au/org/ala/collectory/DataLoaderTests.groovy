package au.org.ala.collectory

import grails.test.*
import au.org.ala.collectory.DataLoaderService.BCI
/**
 * Created by IntelliJ IDEA.
 * User: markew
 * Date: Apr 21, 2010
 * Time: 2:53:20 PM
 * To change this template use File | Settings | File Templates.
 */
class DataLoaderTests extends GrailsUnitTestCase {

    def dataLoaderService

    protected void setUp() {
        super.setUp()
        // need to instantiate explicitly in unit tests
        dataLoaderService = new DataLoaderService()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testBuildLocation() {
        String[] coll = new String[46]
        coll[BCI.LOCATION_LONG.ordinal()] = "151.0414080000"
        coll[BCI.LOCATION_LAT.ordinal()] = "-33.7465780000"
        coll[BCI.LOCATION_ALT.ordinal()] = "700m"
        assertEquals "Lat: -33.7465780000 Long: 151.0414080000 Alt: 700m", dataLoaderService.buildLocation(coll)

        coll[BCI.LOCATION_LAT.ordinal()] = ""
        assertEquals "Long: 151.0414080000 Alt: 700m", dataLoaderService.buildLocation(coll)

        coll[BCI.LOCATION_ALT.ordinal()] = ""
        assertEquals "Long: 151.0414080000", dataLoaderService.buildLocation(coll)
        
    }

    void testBuildSize() {
        String[] coll = new String[46]
        coll[BCI.SIZE_APPROX_INT.ordinal()] = ""

        coll[BCI.SIZE.ordinal()] = "200 000"
        assertEquals 200000, dataLoaderService.buildSize(coll)

        coll[BCI.SIZE.ordinal()] = "200,000"
        assertEquals 200000, dataLoaderService.buildSize(coll)

        coll[BCI.SIZE.ordinal()] = "200.000"
        assertEquals 200000, dataLoaderService.buildSize(coll)
    }

}
