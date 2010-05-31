package au.org.ala.collectory

import grails.test.*
import org.codehaus.groovy.grails.web.json.JSONObject
import au.com.bytecode.opencsv.CSVReader

class DataLoaderServiceTests extends GrailsUnitTestCase {

    def dataLoaderService

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

    /* order of fields in BCI csv
"lsid","record_id","created","modified","name","code","kind","taxon_scope","geo_scope","size","size_approx_int","founded_year","notes","contact_person","contact_position","contact_phone","contact_fax","contact_email","web_site","web_service_uri","web_service_type","location_department","location_street","location_post_box","location_city","location_state","location_postcode","location_country_name","location_country_iso","location_long","location_lat","location_alt","location_notes","institution_name","institution_type","institution_uri","description_tech","description_pub","url"
     */

    void testOpencsv() {
        def column = ["lsid","record_id","created","modified","name","code","kind","taxon_scope","geo_scope","size","size_approx_int","founded_year","notes","contact_person","contact_position","contact_phone","contact_fax","contact_email","web_site","web_service_uri","web_service_type","location_department","location_street","location_post_box","location_city","location_state","location_postcode","location_country_name","location_country_iso","location_long","location_lat","location_alt","location_notes","institution_name","institution_type","institution_uri","description_tech","description_pub","url"]
        CSVReader reader = new CSVReader(new FileReader("/Users/markew/data/BCI/lookup_lsid.csv"))
        String [] nextLine;
        int i = 0
		while ((nextLine = reader.readNext()) != null /*&& i++ < 20*/) {
            if (nextLine[28] == 'AU' || nextLine[27] == 'Australia') {
                for (int j=0; j < column.size(); j++) {
//                    println(column[j] + ": " + nextLine[j])
                }
                //println ""
                i++
            }
		}
        println "Total = " + i
        
    }

    void testLoadBCIData() {

//        log.debug "Here is some logging"
        //dataLoaderService = new DataLoaderService()

        dataLoaderService.loadBCIData("/data/collectory/bootstrap/lookup_lsid.csv")
        println "ProviderGroup.count = " + ProviderGroup.count()
        println "CollectionScope.count = " + CollectionScope.count()
        println "InfoSource.count = " + InfoSource.count()

        ProviderGroup group1 = ProviderGroup.findByGuid("urn:lsid:biocol.org:col:34593")
        assertNotNull group1
        assertEquals "WINC", group1.acronym
        log.info "Collection id is " + group1.id
        println group1.id

        Contact contact1 = Contact.findByLastName("Jennings")
        assertNotNull contact1
        println contact1.id

        ContactFor contactFor1 = ContactFor.findByEntityId(group1.id)

        if (contactFor1 == null) {
            ContactFor.findAll().each {
                println it.print()
            }

            // attempt to create
            ContactFor contactFor2 = new ContactFor(contact1, group1.id, "ProviderGroup", "Contact", true).save(flush: true)
            if (contactFor2.hasErrors()) {
                contactFor2.errors.each {println it.toString()}
            }
            assertEquals 1, ContactFor.count()
        }

    }
}
