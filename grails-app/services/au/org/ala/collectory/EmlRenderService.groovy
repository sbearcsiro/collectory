package au.org.ala.collectory

import groovy.xml.StreamingMarkupBuilder
import groovy.xml.XmlUtil

class EmlRenderService {

    static transactional = true

    /**
     * This service generates eml by directly replacing tokens in a template file.
     * @param dr the resource to describe
     * @return xml string
     */
    def generateEmlForDataResource(DataResource dr) {
        //def template = new XmlSlurper().parse(new File("/data/collectory/templates/dataResourceTemplate.xml"))
        def template = new File("/data/collectory/templates/dataResourceTemplate.xml").getText()
        template = template.replaceAll(/\$[\.\w]*/) {
            def field = it[1..it.size()-1]
            def parts = field.tokenize('.')
            def value
            switch (parts.size()) {
                case 1:
                    value = dr."${field}"
                    break
                case 2:
                    value = dr."${parts[0]}"?."${parts[1]}"
                    break
                case 3:
                    value = dr."${parts[0]}"?."${parts[1]}"?."${parts[2]}"
                    break
            }
            value ?: ""
        }
        return template
    }

    def emlForResource(DataResource dr) {

        def builder = new StreamingMarkupBuilder()
        builder.encoding = 'UTF-8'
        builder.useDoubleQuotes = true
        def dp = dr.dataProvider

        def eml = builder.bind {
            mkp.xmlDeclaration()
            namespaces << [eml:"eml://ecoinformatics.org/eml-2.1.1",
            xsi:"http://www.w3.org/2001/XMLSchema-instance",
            dc:"http://purl.org/dc/terms/"]

            'eml:eml'('xsi:schemaLocation':"eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/dev/eml.xsd",
            'packageId':"619a4b95-1a82-4006-be6a-7dbe3c9b33c5/v7",
            'system':"http://gbif.org",
            'scope':"system",
            'xml:lang':"en") {

                mkp.comment "The IPT is concerned with descriptions of datasets only."
                dataset() {

                    /* alt identifier */
                    alternateIdentifier('ala.org.au:' + dr.uid)

                    /* title */
                    title('xmlns:lang':'en', dr.name)

                    /* creator */
                    def crt = dr.institution
                    if (!crt) {
                        crt = dp
                    }
                    if (crt) {
                        creator() {
                            organizationName(crt.name)
                            if (crt.address) {
                                out << addAddress(crt.address)
                            }
                            out << addIf(crt.phone, 'phone' )
                            out << addIf(crt.email, 'electronicMailAddress')
                            out << addIf(crt.websiteUrl, 'onlineUrl')
                        }
                    }

                    /* metadata provider */
                    metadataProvider() {
                        organizationName(dp)
                        if (dp.address) {
                            out << addAddress(dp.address)
                        }
                        out << addIf(dp.phone, 'phone' )
                        out << addIf(dp.email, 'electronicMailAddress')
                        out << addIf(dp.websiteUrl, 'onlineUrl')
                    }

                    /* associated parties */
                    associatedParty(ala(true))

                    /* pub date */
                    def lastPub = dr.lastUpdated
                    if (lastPub) {
                      lastPub = lastPub.toString()[0..9]
                    }
                    pubDate lastPub

                    /* language */
                    language "English"

                    /* abstract */
                    'abstract'() {
                        mkp.comment "TODO: convert ALA format markup to the DocBook markup used in eml."
                        para dr.pubDescription
                    }

                    /* intellectual rights */
                    intellectualRights {
                        para  dr.rights
                    }

                    /* distribution */
                    distribution {
                        online {
                          url('function':'information',"http://collections.ala.org.au/public/show/" + dr.uid)
                        }
                    }

                    /* contact */
                    mkp.comment "At least one human contact is required. This is sourced from the resource, provider, institution contacts in that order of precedence"
                    mkp.comment "We should try to load metadata to support this for all resources."
                    def cnt = dr.primaryContact
                    if (!cnt) {cnt = dp.primaryContact}
                    if (cnt) {
                        out << addContact(cnt)
                    } else {
                        contact(ala(false))
                    }

                }
            }
        }
        
        //return eml.toString()  // for production usage
        return XmlUtil.serialize(eml) // pretty-printed for development
    }

    def addIf = { value, tag ->
        { it ->
            if (value)
                "${tag}"(value)
        }
    }

    def addAddress = { ad ->
        { it ->
            address {
                out << addIf(ad.street, 'deliveryPoint' )
                out << addIf(ad.city, 'city' )
                out << addIf(ad.state, 'administrativeArea' )
                out << addIf(ad.postcode, 'postalCode' )
                out << addIf(ad.country, 'country' )
            }
        }
    }

    def addContact = { cnt ->
        { it ->
            contact {
                if (cnt.contact.firstName || cnt.contact.lastName) {
                    individualName {
                        out << addIf(cnt.contact.title, 'salutation')
                        out << addIf(cnt.contact.firstName, 'givenName')
                        out << addIf(cnt.contact.lastName, 'surName')
                    }
                }
                out << addIf(cnt.contact.phone, 'phone')
                out << addIf(cnt.contact.email, 'electronicMailAddress')
            }
        }
    }

    /**
     * inject ALA as an agentType or agentTypeWithRole
     * @param boolean if true will include role
     */
    def ala = { withRole ->
        { it ->
            organizationName "Atlas of Living Australia (ALA)"
            address {
                deliveryPoint "CSIRO Black Mountain Laboratories, Clunies Ross Street, ACTON"
                city "Canberra"
                administrativeArea "ACT"
                postalCode "2601"
                country "Australia"
            }
            electronicMailAddress "info@ala.org.au"
            if (withRole) {
                role "distributor"
            }
        }
    }

    /*
    def emlForResource(DataResource dr) {

        def writer = new StringWriter()
        def xml = new MarkupBuilder(writer)

        xml.'eml:eml'('xmlns:eml':"eml://ecoinformatics.org/eml-2.1.0",
            'xmlns:xsi':"http://www.w3.org/2001/XMLSchema-instance",
            'xmlns:dc':"http://purl.org/dc/terms/",
            'xsi:schemaLocation':"eml://ecoinformatics.org/eml-2.1.0 http://rs.gbif.org/schema/eml-gbif-profile/dev/eml.xsd",
            'xml:lang':"en",
            'packageId':"619a4b95-1a82-4006-be6a-7dbe3c9b33c5/v7",
            'system':"http://gbif.org",
            'scope':"system") {

            dataset() {
                alternativeIdentifier('dr376')
                title('xmlns:lang':'en', 'OZCAM provider for Australian Museum')

                creator() {
                    individualName() {
                        givenName('Lemmy')
                        surname('Caution')
                    }
                    organizationName('ALA')
                }

                'abstract'() {
                    para('Specimens')
                }
            }
        }
        return writer.toString()
    }
*/
}
