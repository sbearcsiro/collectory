package au.org.ala.collectory

import grails.converters.*;
import au.com.bytecode.opencsv.CSVReader

class DataLoaderService {

    boolean transactional = true
    // define an enum to allow us to access BCI csv columns by name
    enum BCI {LSID,RECORD_ID,CREATED,MODIFIED,NAME,CODE,KIND,TAXON_SCOPE,GEO_SCOPE,SIZE,SIZE_APPROX_INT,FOUNDED_YEAR,NOTES,CONTACT_PERSON,CONTACT_POSITION,CONTACT_PHONE,CONTACT_FAX,CONTACT_EMAIL,WEB_SITE,WEB_SERVICE_URI,WEB_SERVICE_TYPE,LOCATION_DEPARTMENT,LOCATION_STREET,LOCATION_POST_BOX,LOCATION_CITY,LOCATION_STATE,LOCATION_POSTCODE,LOCATION_COUNTRY_NAME,LOCATION_COUNTRY_ISO,LOCATION_LONG,LOCATION_LAT,LOCATION_ALT,LOCATION_NOTES,INSTITUTION_NAME,INSTITUTION_TYPE,INSTITUTION_URI,DESCRIPTION_TECH,DESCRIPTION_PUB,URL}

    def loadContact(String firstName, String lastName, boolean publish) {
        Contact c = JSON.parse("""{
            firstName: "${firstName}",
            lastName: "$lastName",
            publish: """ + publish + "}") as Contact
        return c
    }

    def loadFromFile(String filename) {
        Contact c = JSON.parse(new FileInputStream(filename), "UTF-8") as Contact
        return c
    }

    def loadBCIData(String filename) {
        CSVReader reader = new CSVReader(new FileReader(filename))
        String [] nextLine;
        int institutionGuid = 1000

		while ((nextLine = reader.readNext()) != null) {

            // only load aussie collections
            if (nextLine[BCI.LOCATION_COUNTRY_ISO.ordinal()] == 'AU' ||
                nextLine[BCI.LOCATION_COUNTRY_NAME.ordinal()] == 'Australia' ||
                ['34908', '35014', '14847', '15596', '34932'].any {nextLine[BCI.LSID.ordinal()].endsWith(it)}) {

                /* contact */
                Contact contact = new Contact()
                contact.userLastModified = "BCI loader"
                contact.parseName(nextLine[BCI.CONTACT_PERSON.ordinal()])
                contact.phone = nextLine[BCI.CONTACT_PHONE.ordinal()]
                contact.email = nextLine[BCI.CONTACT_EMAIL.ordinal()]
                contact.fax = nextLine[BCI.CONTACT_FAX.ordinal()]
                contact.publish = true
                if (contact.hasContent()) {
                    contact.save(flush: true)
                    if (contact.hasErrors()) {
                        showErrors(nextLine[BCI.LSID.ordinal()], contact.errors)
                    }
                } else {
                    contact = null
                }
                
                /* collection */
                ProviderGroup collection = new ProviderGroup()
                collection.userLastModified = "BCI loader"
                collection.scope = new CollectionScope()
                collection.scope.userLastModified = "BCI loader"
                collection.guid = nextLine[BCI.LSID.ordinal()]
                collection.name = nextLine[BCI.NAME.ordinal()]
                collection.groupType = "Collection"
                collection.acronym = nextLine[BCI.CODE.ordinal()]
                collection.focus = nextLine[BCI.TAXON_SCOPE.ordinal()]
                collection.scope.numRecords = buildSize(nextLine)
                collection.providerCollectionCode = nextLine[BCI.RECORD_ID.ordinal()]
                // collection.dateCreated is auto-generated at save time
                collection.notes = nextLine[BCI.NOTES.ordinal()]
                collection.websiteUrl = nextLine[BCI.WEB_SITE.ordinal()]
                collection.isALAPartner = false
                collection.techDescription = nextLine[BCI.DESCRIPTION_TECH.ordinal()]
                collection.pubDescription = nextLine[BCI.DESCRIPTION_PUB.ordinal()]
                collection.latitude = parseDouble(nextLine[BCI.LOCATION_LAT.ordinal()])
                collection.longitude = parseDouble(nextLine[BCI.LOCATION_LONG.ordinal()])
                collection.altitude = nextLine[BCI.LOCATION_ALT.ordinal()]
                collection.state = massageState(nextLine[BCI.LOCATION_STATE.ordinal()])

                Address address = new Address()
                address.street = nextLine[BCI.LOCATION_STREET.ordinal()]
                address.postBox = nextLine[BCI.LOCATION_POST_BOX.ordinal()]
                address.city = nextLine[BCI.LOCATION_CITY.ordinal()]
                address.state = nextLine[BCI.LOCATION_STATE.ordinal()]
                address.postcode = nextLine[BCI.LOCATION_POSTCODE.ordinal()]
                address.country = nextLine[BCI.LOCATION_COUNTRY_NAME.ordinal()]
                //if (!address.isEmpty()) {
                    collection.address = address
                //}
                println ">> Loading ${collection?.name}"
                if (!collection.validate()) {
                    collection.errors.each {
                        println it
                    }
                }

                collection.scope.collectionType = nextLine[BCI.KIND.ordinal()]
                collection.scope.geographicDescription = nextLine[BCI.GEO_SCOPE.ordinal()]
                collection.scope.startDate = nextLine[BCI.FOUNDED_YEAR.ordinal()]
                collection.scope.numRecords = buildSize(nextLine)

                // create or assign infosource only if there is some data
                String webServiceUri = nextLine[BCI.WEB_SERVICE_URI.ordinal()]
                String webServiceType = nextLine[BCI.WEB_SERVICE_TYPE.ordinal()]

                if (webServiceUri) {
                    // see if there is an existing infosource that matches the access parameters
                    InfoSource is = InfoSource.list().find {
                        it.getWebServiceUri() == webServiceUri &&
                        it.getWebServiceProtocol() == webServiceType
                    }
                    if (!is) {
                        // create a new one
                        is = new InfoSource(title: "created for " + collection.name)
                        is.setWebServiceUri webServiceUri
                        is.setWebServiceProtocol webServiceType
                    }
                    collection.infoSource = is
                    is.addToCollections(collection)
                    is.userLastModified = "BCI loader"

                    is.save()
                    if (!is.validate()) {
                        is.errors.each {
                            println it
                        }
                    }
                }

                // save collection before linking contacts as we need the generated id
                collection.save(flush: true)
                if (collection.hasErrors()) {
                    showErrors(nextLine[BCI.LSID.ordinal()], collection.errors)
                    // no point proceeding if the contact didn't save
                    continue;
                }

                // contact is for the collection
                if (contact && !contact.hasErrors()) {
                    String role = nextLine[BCI.CONTACT_POSITION.ordinal()]
                    // is the contact an editor?
                    // default to true
                    collection.addToContacts(contact, role?.empty ? "Contact" : role, true, "BCI loader")
                }
                
                /* institution */
                String institutionName = nextLine[BCI.INSTITUTION_NAME.ordinal()]
                // only process if it has a name
                ProviderGroup institution = null
                if (institutionName) {
                    // see if it already exists
                    /* we should do this with guids but the BCI has no guids for institutions so just use name */
                    institution = ProviderGroup.findByName(institutionName)
                    if (institution != null) {
                        // TODO: update any fields that are currently blank (and save)
                        assert institution.guid
                    } else {
                        institution = new ProviderGroup()
                        institution.groupType = "Institution"
                        institution.name = institutionName
                        // fudge the institution guid for now
                        institution.guid = institutionGuid++
                        institution.institutionType = massageInstitutionType(nextLine[BCI.INSTITUTION_TYPE.ordinal()])
                        institution.websiteUrl = nextLine[BCI.INSTITUTION_URI.ordinal()]
                        institution.userLastModified = "BCI loader"
                        collection.save(flush: true)
                    }
                }

                // link collection to institution if we have one
                if (institution) {
                    institution.addToChildren collection
                    institution.userLastModified = "BCI loader"

                    institution.save(flush: true)
                    if (institution.hasErrors()) {
                        showErrors(nextLine[BCI.LSID.ordinal()], institution.errors)
                    }
                    
                    collection.addToParents institution
                    collection.save(flush: true)
                }
                
            }
		}

    }

    void showErrors(String label, Object errors) {
        println label
        errors.each {println it.toString()}
    }

    int parseInt(String[] values, int index) {
      String s = values[index]
      return s?.empty ? ProviderGroup.NO_INFO_AVAILABLE : s as int
    }

    double parseDouble(String s) {
      return s?.empty ? ProviderGroup.NO_INFO_AVAILABLE : s as double
    }

    String buildLocation(String[] nextLine) {
        def map = ['Lat':nextLine[BCI.LOCATION_LAT.ordinal()],
                   'Long':nextLine[BCI.LOCATION_LONG.ordinal()],
                   'Alt':nextLine[BCI.LOCATION_ALT.ordinal()]]

        def strings = map.collect {key, value ->
            value?.empty ? '' : key + ": " + value + " "
        }

        return strings.join().trim()
    }

    int buildSize(String[] nextLine) {
        int size = parseInt(nextLine, BCI.SIZE_APPROX_INT.ordinal())
        if (size == ProviderGroup.NO_INFO_AVAILABLE) {
            // try to parse the text version of size in case it can be interpreted as a number
            String sizeStr = nextLine[BCI.SIZE.ordinal()]
            if (sizeStr) {
                // remove spaces and commas
                def sizeTrim = ''
                sizeStr.each { item ->
                    if (('0'..'9').contains(item as char)) {
                        sizeTrim += item
                    }
                }
                try {
                    size = sizeTrim as int
                } catch (NumberFormatException e) {
                    // give up
                }
            }
        }
        return size
    }

    String massageInstitutionType(String bciType) {
        String type = bciType.toLowerCase()
        if (ProviderGroup.constraints.institutionType.inList.contains(type)) {
            return type
        }
        if (type.startsWith("government")) return "government"
        if (type.startsWith("museum")) return "museum"
        return null
    }

    String massageState(String bciState) {
        switch (bciState.trim()) {
            case 'A.C.T.': return 'Australian Capital Territory'
            case 'ACT': return 'Australian Capital Territory'
            case 'N.S.W.': return 'New South Wales'
            case 'NSW': return 'New South Wales'
            case 'QLD': return 'Queensland'
            case 'NT': return 'Northern Territory'
            case 'Darwin': return 'Northern Territory'
            case 'WA': return 'Western Australia'
            case 'SA': return 'South Australia'
            case 'Southern Australia': return 'South Australia'
            case 'TAS': return 'Tasmania'
            case 'VIC': return 'Victoria'
        }
        return bciState.trim()
    }
}
