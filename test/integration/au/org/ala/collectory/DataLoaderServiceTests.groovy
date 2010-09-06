package au.org.ala.collectory

import grails.test.*
import org.codehaus.groovy.grails.web.json.JSONObject
import au.com.bytecode.opencsv.CSVReader
import grails.converters.JSON

class DataLoaderServiceTests extends GrailsUnitTestCase {

    def dataLoaderService

    def column = ["lsid","record_id","created","modified","name","code","kind","taxon_scope","geo_scope","size","size_approx_int","founded_year","notes","contact_person","contact_position","contact_phone","contact_fax","contact_email","web_site","web_service_uri","web_service_type","location_department","location_street","location_post_box","location_city","location_state","location_postcode","location_country_name","location_country_iso","location_long","location_lat","location_alt","location_notes","institution_name","institution_type","institution_uri","description_tech","description_pub","url"]

    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testJSONLoad() {
        def result = dataLoaderService.loadContact("Lemmy", "Caution", true)
        assertEquals 'Lemmy', result.firstName

        def contact = dataLoaderService.loadFromFile("/Users/markew/load.json")
        assertEquals 'Sandy', contact.firstName
    }

    void testLoadSupplimentaryData() {
        //dataLoaderService.loadSupplementaryData("/data/collectory/bootstrap/sup.json", false)
    }
    
    /* order of fields in BCI csv
"lsid","record_id","created","modified","name","code","kind","taxon_scope","geo_scope","size","size_approx_int","founded_year","notes","contact_person","contact_position","contact_phone","contact_fax","contact_email","web_site","web_service_uri","web_service_type","location_department","location_street","location_post_box","location_city","location_state","location_postcode","location_country_name","location_country_iso","location_long","location_lat","location_alt","location_notes","institution_name","institution_type","institution_uri","description_tech","description_pub","url"
     */

    void testOpencsv() {
        CSVReader reader = new CSVReader(new FileReader("/data/collectory/bootstrap/lookup_lsid.csv"))
        String [] nextLine;
        int i = 0
		while ((nextLine = reader.readNext()) != null /*&& i++ < 20*/) {
            if (nextLine[28] == 'AU' || nextLine[27] == 'Australia') {
//                for (int j=0; j < column.size(); j++) {
//                    println(column[j] + ": " + nextLine[j])
//                }
                //println ""
                i++
            }
		}
        println "Total = " + i
        
    }

    void testLoadingAsParams() {
        CSVReader reader = new CSVReader(new FileReader("/data/collectory/bootstrap/lookup_lsid.csv"))
        String [] nextLine;
		while ((nextLine = reader.readNext()) != null) {
            if (nextLine[28] == 'AU' || nextLine[27] == 'Australia') {
                def params = [:]
                column.eachWithIndex {it, i ->
                    if (nextLine[i]) {
                        params[it] = nextLine[i]
                    }
                }
                assertEquals nextLine[4], params.name
                // try loading a domain object
                def pg = new Collection()
                pg.properties = params
                assertEquals nextLine[4], pg.name
            }
		}
    }

    void testLoadBCIData() {

//        log.debug "Here is some logging"
        //dataLoaderService = new DataLoaderService()

        dataLoaderService.loadBCIData("/data/collectory/bootstrap/lookup_lsid.csv")
        println "Collections added = " + ProviderGroup.countByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)
        println "Institutions added = " + ProviderGroup.countByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION)

        ProviderGroup group0 = ProviderGroup.findByGuid("1004")
        assertNotNull group0
        //assertEquals "CSIRO", group0.acronym
        assertTrue group0.getIsALAPartner()
        
        ProviderGroup group1 = ProviderGroup.findByGuid("urn:lsid:biocol.org:col:34593")
        assertNotNull group1
        assertEquals "WINC", group1.acronym
        log.info "Collection id is " + group1.id
        println group1.id

        Contact contact1 = Contact.findByLastName("Jennings")
        assertNotNull contact1
        println contact1.id

        ContactFor contactFor1 = ContactFor.findByEntityUid(group1.uid)

        if (contactFor1 == null) {
            ContactFor.findAll().each {
                println it.print()
            }

            // attempt to create
            ContactFor contactFor2 = new ContactFor(contact1, group1.uid, "Contact", true, true).save(flush: true)
            if (contactFor2.hasErrors()) {
                contactFor2.errors.each {println it.toString()}
            }
            assertEquals 1, ContactFor.count()
        }

    }

    void testLoadAmrrnData() {
        dataLoaderService.loadAmrrnData()
        ProviderGroup.findAll().each {
            println it.guid + " " + it.name
        }
        assertEquals 32, ProviderGroup.findAll().size()
        assertEquals 31, Contact.findAll().size()
        assertEquals 32, ContactFor.findAll().size()
    }
}
