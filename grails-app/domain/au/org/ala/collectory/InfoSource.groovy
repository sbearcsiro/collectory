package au.org.ala.collectory

import grails.util.JSonBuilder
import grails.converters.JSON

class InfoSource implements Serializable {

    static final int NO_INFO_AVAILABLE = -1
    static final String ENTITY_TYPE = 'InfoSource'

    /* dataset */
    String guid                 // this is not the DB id but a known identifier
    String acronym              // an acronym for the dataset
    String title                // title of the dataset
    String abstractText         // a short text description of the dataset
    Date dateAvailable          // date that the dataset was first made available via the ALA
    String datasetType          // see dataset_type vocab
    String keywords
    String active               // see active vocab
    String basisOfRecord        // see basis_of_record vocab
    String language             // 2 letter acronym - see language vocab
    String notes                // general notes about the dataset that do not fit into any other field
    String informationWithheld  // additional fields available in the source but not published in the dataset
    String generalisations      // reduction to data accuracy for the entire data set (e.g. all resolution reduced to 1.111)

    /* spatial - Metadata specific to spatial datasets */
    String spatialRepresentationType
                                // type of geospatial data - vector, grid, textTable - see spatial_representation_type vocab
    String spatialResolution    // e.g. scale or ground distance

    /* rights - Intellectual property and licensing conditions */
    String rights               // information about rights held in and over the resource.
                                //      - e.g licensed under Creative Commons Australia 2.5 Attribution
    String rightsHolder	    // person who hold the rights, if different from the contact
    String security	            // any restrictions on who can access the dataset as a whole
    String licenseType         // the Creative Commons License that applies to the data set e.g. non commercial,
                                //      share alike - see rights_restrictions vocab
    String restrictions	        // statement of any additional terms for usage imposed by the provider
    String citation	            // how to cite the owner when using the dataset
    String providerAgreement   // link to an ALA data provider agreement

    /* Coverage - What the dataset covers */

    //Geographic Coverage - Where the dataset covers
    String states               // states and territories that are covered by the dataset - see state vocab
	String geographicDescription// a free text description of where the data relates to
	String wellKnownText	    // a text markup language for representing vector geometry objects on a map
	BigDecimal eastCoordinate = NO_INFO_AVAILABLE
                                // furthest point East for this dataset in decimal degrees
	BigDecimal westCoordinate = NO_INFO_AVAILABLE
                                // furthest point West for this dataset in decimal degrees
	BigDecimal northCoordinate = NO_INFO_AVAILABLE
                                // furthest point North for this dataset in decimal degrees
	BigDecimal southCoordinate = NO_INFO_AVAILABLE
                                // furthest point South for this dataset in decimal degrees

	//Temporal Coverage - Time period the dataset covers	single_date	The single date that the dataset covers
	String startDate            // the start date of the period the dataset covers
	String endDate	            // the end date of the period the dataset covers

	//Taxonomic - Taxonomic coverage
	String kingdomCoverage      // the higher taxonomy that the dataset covers - see kingdom_coverage vocab
                                // a space-separated string that can contain any number of these values:
                                // Animalia Archaebacteria Eubacteria Fungi Plantae Protista

    /* supply - How the dataset is made available */
    String accessParameters     // JSON text block with access, transformation and connection information:
                                //      Dwc mapping method, Data Integration task ID, update type (has a vocab), update
                                //      frequency (has a vocab), access point url and parameters, file format, field,
                                //      text and record delimiters etc
                                // Simple version to start with is:
                                //  {"uri":"http:..","protocol":"TAPIR"}
                                // protocol is one of: none, BioCase, DiGIR, TAPIR, Rest

    Date dateCreated = new Date()
    Date dateLastModified = new Date()
    String userLastModified

    // An infosource serves many collections
    static hasMany = [collections: ProviderGroup]


    static constraints = {
        guid(nullable:true, maxSize: 45)   // will become blank:false, unique:true
        acronym(nullable:true, maxSize:45)
        title(blank:false, maxSize:128)
        abstractText(nullable:true, maxSize:2048)
        dateAvailable(nullable:true)
        datasetType(nullable:true)
        keywords(nullable:true)
        active(nullable:true, inList:['Active growth', 'Closed', 'Consumable', 'Decreasing', 'Lost', 'Missing', 'Passive growth', 'Static'])
        basisOfRecord(nullable:true, inList:['Occurrence', 'Event', 'Location', 'Taxon', 'Preserved Specimen', 'Fossil Specimen', 'Living Specimen', 'Human Observation', 'Machine Observation', 'Nomenclatural Checklist'])
        language(nullable:true, maxSize:2)  // should be a list
        notes(nullable:true, maxSize:2048)
        informationWithheld(nullable:true, maxSize:1024)
        generalisations(nullable:true, maxSize:256)

        spatialRepresentationType(nullable:true, inList:['Grid', 'Georectified', 'Georeferenceable', 'Vector'])
        spatialResolution(nullable:true)

        rights(nullable:true)
        rightsHolder(nullable:true)
        security(nullable:true)
        licenseType(nullable:true, inList:['Attribution', 'Attribution-ShareAlike', 'Attribution-NonCommercial', 'Attribution-NonCommercial-ShareAlike'])
        restrictions(nullable:true)
        citation(nullable:true)
        providerAgreement(nullable:true)

        states(nullable:true)
        geographicDescription(nullable:true)
        wellKnownText(nullable:true)
        eastCoordinate(max:360.0, min:-360.0, scale:10)
        westCoordinate(max:360.0, min:-360.0, scale:10)
        northCoordinate(max:360.0, min:-360.0, scale:10)
        southCoordinate(max:360.0, min:-360.0, scale:10)

        startDate(nullable:true, maxSize:45)
        endDate(nullable:true, maxSize:45)

        kingdomCoverage(nullable:true, maxSize:1024,
            validator: { kc ->
                if (!kc) {
                    return true
                }
                boolean ok = true
                // split value by spaces
                kc.split(" ").each {
                    if (!['Animalia', 'Archaebacteria', 'Eubacteria', 'Fungi', 'Plantae', 'Protista'].contains(it)) {
                        ok = false  // return false does not work here!
                    }
                }
                return ok
            })

        accessParameters(nullable:true, maxSize:5000)
        dateCreated(nullable:true)
        dateLastModified()
        userLastModified(maxSize:256)
    }

    // access params - form is: {"uri":"http:..","protocol":"TAPIR"}
    void setWebServiceUri(String uri) {
        def ap = [uri: uri, protocol: getWebServiceProtocol()]
        accessParameters = ap.encodeAsJSON()
    }

    String getWebServiceUri() {
        if (accessParameters) {
            def ap = JSON.parse(accessParameters)
            return ap.uri
        } else {
            return null
        }
    }

    void setWebServiceProtocol(String protocol) {
        def ap = [uri: getWebServiceUri(), protocol: protocol]
        accessParameters = ap.encodeAsJSON()
    }

    String getWebServiceProtocol() {
        if (accessParameters) {
            def ap = JSON.parse(accessParameters)
            return ap.protocol
        } else {
            return null
        }
    }

}
