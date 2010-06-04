package au.org.ala.collectory

import grails.converters.*;
import au.com.bytecode.opencsv.CSVReader

class DataLoaderService {

    def institutionCodeLoaderService

    boolean transactional = false

    /* List of field names as BCI names
     * LSID,RECORD_ID,CREATED,MODIFIED,NAME,CODE,KIND,TAXON_SCOPE,GEO_SCOPE,SIZE,SIZE_APPROX_INT,FOUNDED_YEAR,NOTES,CONTACT_PERSON,CONTACT_POSITION,CONTACT_PHONE,CONTACT_FAX,CONTACT_EMAIL,WEB_SITE,WEB_SERVICE_URI,WEB_SERVICE_TYPE,LOCATION_DEPARTMENT,LOCATION_STREET,LOCATION_POST_BOX,LOCATION_CITY,LOCATION_STATE,LOCATION_POSTCODE,LOCATION_COUNTRY_NAME,LOCATION_COUNTRY_ISO,LOCATION_LONG,LOCATION_LAT,LOCATION_ALT,LOCATION_NOTES,INSTITUTION_NAME,INSTITUTION_TYPE,INSTITUTION_URI,DESCRIPTION_TECH,DESCRIPTION_PUB,URL
     */
    // List of field names as domain property names (_NAx are not mapped)
    def column = ["guid","_NA1","_NA2","_NA3","name","acronym","kind","focus","geographicDescription","size","numRecords","startDate","notes","contactName","contactRole","contactPhone","contactFax","contactEmail","websiteUrl","webServiceUri","webServiceProtocol","_NA4","street","postBox","city","state","postcode","country","countryIsoCode","longitude","latitude","altitude","_NA6","institutionName","institutionType","institutionUri","techDescription","pubDescription","_NA7"]

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

            /* create a params map from the csv data
             * using the domain property names as keys (ignoring blank and unmapped fields)
             */
            def params = [:]
            column.eachWithIndex {it, i ->
                if (!it.startsWith('_NA') && nextLine[i]) {
                    params[it] = nextLine[i]
                }
            }

            // only load aussie collections
            if (params.countryIsoCode == 'AU' || params.country == 'Australia' ||
                ['34908', '35014', '14847', '15596', '34932'].any {params.guid.endsWith(it)}) {

                /* contact */
                Contact contact = new Contact()
                contact.userLastModified = "BCI loader"
                contact.parseName(params.contactName)
                contact.phone = params.contactPhone
                contact.email = params.contactEmail
                contact.fax = params.contactFax
                contact.publish = true
                if (contact.hasContent()) {
                    contact.save(flush: true)
                    if (contact.hasErrors()) {
                        showErrors(params.name, contact.errors)
                    }
                } else {
                    contact = null
                }

                /*
                 * Logic here is:
                 *
                 * if record is an institution (rather than a collection)
                 *      if institution with same name exists (has already been loaded)
                 *          update properties
                 *      else
                 *          load institution-specific properties
                 * else
                 *      load collection-specific properties (creating an infosource if needed)
                 *
                 * validate and save
                 * add contact if there is one
                 * if record is a collection
                 *      if there is institution information
                 *          if the institution exists
                 *              update any empty fields
                 *          else
                 *              create it and save
                 *          add as parent to collection
                 * save
                 */
                
                /* provider */
                ProviderGroup provider = new ProviderGroup()
                // load some values
                provider.properties["guid","name","acronym","focus","notes","websiteUrl","longitude","latitude",
                        "altitude","techDescription","pubDescription"] = params
                provider.address = new Address()
                provider.address.properties["street","postBox","city","state","postcode","country"] = params
                provider.userLastModified = "BCI loader"

                // check whether it's really an institution
                if (recogniseInstitution(provider.name)) {
                    String institutionName = standardiseInstitutionName(provider.name)
                    /* institution */
                    // see if an institution with this name has already been saved
                    def institution = ProviderGroup.findByNameAndGroupType(institutionName, ProviderGroup.GROUP_TYPE_INSTITUTION)
                    if (institution) {
                        // update it with these richer details
                        println "updating existing institution ${institution.name} with collection-level data"
                        institution.properties["guid","name","acronym","notes","websiteUrl","longitude","latitude",
                                "altitude","techDescription","pubDescription"] = params
                        institution.address = new Address()
                        institution.address.properties["street","postBox","city","state","postcode","country"] = params
                        provider.institutionType = massageInstitutionType(params.institutionType)
                        if (!provider.institutionType)
                            provider.institutionType = massageInstitutionType(params.kind)
                        institution.isALAPartner = isALAPartner(institution.name)
                        institution.userLastModified = "BCI loader"
                        // discard existing provider object and make this the provider (so we can do common processing later)
                        provider = institution
                    } else {
                        provider.name = institutionName
                        provider.groupType = ProviderGroup.GROUP_TYPE_INSTITUTION
                        provider.institutionType = massageInstitutionType(params.institutionType)
                        if (!provider.institutionType)
                            provider.institutionType = massageInstitutionType(params.kind)
                        // use AFD museum list to look up missing acronyms
                        if (!provider.acronym) {
                            String code = institutionCodeLoaderService.lookupInstitutionCode(provider.name)
                            if (code) {
                                println "Using code ${code} for institution ${provider.name}"
                                provider.acronym = code
                                // TODO: provider.providerCodes = code
                            }
                        }
                        provider.isALAPartner = isALAPartner(institutionName)
                    }
                } else {
                    /* collection */
                    provider.groupType = ProviderGroup.GROUP_TYPE_COLLECTION
                    provider.scope = new CollectionScope()
                    provider.scope.properties["geographicDescription","startDate"] = params
                    provider.scope.keywords = extractKeywords(params)
                    provider.scope.numRecords = buildSize(params)
                    provider.scope.userLastModified = "BCI loader"
                    // create or assign infosource only if there is some data
                    String webServiceUri = params.webServiceUri
                    String webServiceType = params.webServiceProtocol

                    if (webServiceUri) {
                        // see if there is an existing infosource that matches the access parameters
                        InfoSource is = InfoSource.list().find {
                            it.getWebServiceUri() == webServiceUri &&
                            it.getWebServiceProtocol() == webServiceType
                        }
                        if (!is) {
                            // create a new one
                            is = new InfoSource(title: "created for " + provider.name)
                            is.setWebServiceUri webServiceUri
                            is.setWebServiceProtocol webServiceType
                        }
                        provider.infoSource = is
                        is.addToCollections(provider)
                        is.userLastModified = "BCI loader"

                        is.save()
                        if (!is.validate()) {
                            is.errors.each {
                                println it
                            }
                        }
                    }

                }

                println ">> Loading ${provider?.name} as ${provider.groupType}"
                if (!provider.validate()) {
                    provider.errors.each {
                        println it
                    }
                }

                // save provider before linking contacts as we need the generated id
                provider.save(flush: true)
                if (provider.hasErrors()) {
                    showErrors(params.name, provider.errors)
                    // no point proceeding if the contact didn't save
                    continue;
                }

                // add contact if it exists and is ok
                if (contact && !contact.hasErrors()) {
                    String role = params.contactRole
                    // is the contact an editor?
                    // default to true
                    provider.addToContacts(contact, role?.empty ? "Contact" : role, true, "BCI loader")
                    // does not require a save
                }

                // only handle owning institutions if this is a collection
                if (provider.groupType == ProviderGroup.GROUP_TYPE_COLLECTION) {
                    /* institution */
                    String institutionName = standardiseInstitutionName(params.institutionName)
                    // only process if it has a name
                    ProviderGroup institution = null
                    if (institutionName) {
                        // see if it already exists
                        /* we should do this with guids but the BCI has no guids for institutions so just use name */
                        institution = ProviderGroup.findByName(institutionName)
                        if (institution != null) {
                            // update if blank
                            println ">> Updating institution ${institutionName} with type and uri and adding to collection ${provider.name}"
                            if (!institution.institutionType)
                                institution.institutionType = massageInstitutionType(params.institutionType)
                            if (!institution.websiteUrl)
                                institution.websiteUrl = params.institutionUri
                        } else {
                            println ">> Creating institution ${institutionName} for collection ${provider.name}"
                            institution = new ProviderGroup()
                            institution.groupType = "Institution"
                            institution.name = institutionName
                            // fudge the institution guid for now
                            institution.guid = institutionGuid++
                            institution.institutionType = massageInstitutionType(params.institutionType)
                            institution.websiteUrl = params.institutionUri
                            // use AFD museum list to look up acronyms
                            String code = institutionCodeLoaderService.lookupInstitutionCode(institution.name)
                            if (code) {
                                println "Using code ${code} for institution ${institution.name}"
                                institution.acronym = code
                            }
                            institution.isALAPartner = isALAPartner(institution.name)
                            institution.userLastModified = "BCI loader"
                            provider.save(flush: true)
                        }
                    }

                    // link collection to institution if we have one
                    if (institution) {
                        institution.addToChildren provider
                        institution.userLastModified = "BCI loader"

                        institution.save(flush: true)
                        if (institution.hasErrors()) {
                            showErrors(nextLine[BCI.LSID.ordinal()], institution.errors)
                        }

                        provider.addToParents institution
                        provider.save(flush: true)
                    }
                }
            }
		}

    }

    void showErrors(String label, Object errors) {
        println label
        errors.each {println it.toString()}
    }

    int parseInt(String s) {
        if (s == null)
            return ProviderGroup.NO_INFO_AVAILABLE
        return s?.empty ? ProviderGroup.NO_INFO_AVAILABLE : s as int
    }

    double parseDouble(String s) {
      return s?.empty ? ProviderGroup.NO_INFO_AVAILABLE : s as double
    }

    String buildLocation(params) {
        def map = ['Lat':params.latitude,
                   'Long':params.longitude,
                   'Alt':params.altitude]

        def strings = map.collect {key, value ->
            value?.empty ? '' : key + ": " + value + " "
        }

        return strings.join().trim()
    }

    int buildSize(params) {
        int size = parseInt(params.numRecords)
        if (size == ProviderGroup.NO_INFO_AVAILABLE) {
            // try to parse the text version of size in case it can be interpreted as a number
            String sizeStr = params.size
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
        if (bciType) {
            String type = bciType.toLowerCase()
            if (ProviderGroup.constraints.institutionType.inList.contains(type)) {
                return type
            }
            if (type =~ "government") return "government"
            if (type =~ "museum") return "museum"
            if (type =~ "university") return "university"
            if (type =~ "herbarium") return "herbarium"
            println "Failed to massage institution type: ${bciType}"
        }
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


    /**
     * Checks collection name to see if it is really a known institution.
     *
     * @param name to check
     * @return true if known
     */
    boolean recogniseInstitution(String name) {
        name = standardiseInstitutionName(name)
        return name in ['Commonwealth Scientific and Industrial Research Organisation',
                'Commonwealth Scientific and Industrial Research Organisation',
                'Tasmanian Museum and Art Gallery',
                'Museum Victoria',
                'Australian Museum',
                'South Australian Museum',
                'Tasmanian Department of Primary Industries and Water',
                'UWA Faculty of Natural & Agricultural Sciences',
                'Western Australian Department of Conservation & Land Management']
    }

    /**
     * Transforms institution name into a standardised form.
     *
     * @param name to check
     * @return standardised name
     */
    String standardiseInstitutionName(String name) {
        if (!name) return null
        name = name.trim()
        if (name[name.size() - 1] == '.')
            name = name.substring(0, name.size() - 1)
        switch (name) {
            case 'CSIRO': return 'Commonwealth Scientific and Industrial Research Organisation'
            case 'Australian Commonwealth Scientific and Research Organization (CSIRO)': return 'Commonwealth Scientific and Industrial Research Organisation'
            case 'Department of Tasmanian Museum and Art Gallery': return 'Tasmanian Museum and Art Gallery'
            case 'Museum of Victoria': return 'Museum Victoria'
            case 'Australian Museum': return 'Australian Museum'
            case 'South Australian Museum': return 'South Australian Museum'
            case 'Tasmanian Department of Primary Industries and Water': return 'Tasmanian Department of Primary Industries and Water'
            case 'UWA Faculty of Natural & Agricultural Sciences': return 'UWA Faculty of Natural & Agricultural Sciences'
            case 'Western Australian Department of Conservation & Land Management': return 'Western Australian Department of Conservation & Land Management'

            default: return name
        }
    }

    boolean isALAPartner(String name) {
        return name in [
                'Commonwealth Scientific and Industrial Research Organisation',
                'Australian Museum',
                'Queensland Museum',
                'Tasmanian Museum and Art Gallery',
                'Southern Cross University',
                'University of Adelaide',
                'Australian Government Department of Agriculture, Fisheries and Forestry',
                'Australian Government Department of the Environment, Water, Heritage and the Arts ',
                'Museum Victoria',
                'Museum of Victoria']
    }

    String extractKeywords(params) {
        List words = params.kind.tokenize("[, ()/]")
        words = words.collect{it.toLowerCase()}
        def keywords = words.findAll {!(it in ['and','not','specified'])}
        return (keywords as JSON).toString()
    }
}
