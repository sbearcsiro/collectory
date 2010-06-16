package au.org.ala.collectory

import grails.converters.JSON

/**
 * Models collection-specific information. Extends a ProviderGroup object where the type is collection.
 * 
 * A ProviderGroup[type=Collection] + its CollectionScope describe a collection.
 */
class CollectionScope implements Serializable {

    String collectionType       // type of collection e.g live, preserved, tissue, DNA
    String keywords
    String active               // see active vocab
    int numRecords = ProviderGroup.NO_INFO_AVAILABLE
                                // total number of records held that are able to be digitised
    int numRecordsDigitised = ProviderGroup.NO_INFO_AVAILABLE
                                // number of records that are digitised

    /* Coverage - What the collection covers */

    // Geographic Coverage
    String states               // states and territories that are covered by the collection - see state vocab
	String geographicDescription// a free text description of where the data relates to
	BigDecimal eastCoordinate = ProviderGroup.NO_INFO_AVAILABLE
                                // furthest point East for this collection in decimal degrees
	BigDecimal westCoordinate = ProviderGroup.NO_INFO_AVAILABLE
                                // furthest point West for this collection in decimal degrees
	BigDecimal northCoordinate = ProviderGroup.NO_INFO_AVAILABLE
                                // furthest point North for this collection in decimal degrees
	BigDecimal southCoordinate = ProviderGroup.NO_INFO_AVAILABLE
                                // furthest point South for this collection in decimal degrees

	//Temporal Coverage - Time period the collection covers	single_date	The single date that the collection covers
	String startDate            // the start date of the period the collection covers
	String endDate	            // the end date of the period the collection covers

	//Taxonomic - Taxonomic coverage
	String kingdomCoverage      // the higher taxonomy that the collection covers - see kingdom_coverage vocab
                                // a space-separated string that can contain any number of these values:
                                // Animalia Archaebacteria Eubacteria Fungi Plantae Protista
    String scientificNames      // as JSON array eg ["Insecta", "Arachnida"]

    Date dateCreated = new Date()
    Date dateLastModified = new Date()
    String userLastModified

    String subCollections       // list of sub-collections as JSON

    // A collection has exactly one CollectionScope
    static belongsTo = ProviderGroup

    static constraints = {
        collectionType(nullable: true, maxSize: 256/*, inList: [
            "archival",
            "art",
            "audio",
            "cellcultures",
            "electronic",
            "facsimiles",
            "fossils",
            "genetic",
            "living",
            "observations",
            "preserved",
            "products",
            "taxonomic",
            "texts",
            "tissue",
            "visual"]*/)
        keywords(nullable:true, maxSize:1024)
        active(nullable:true, inList:['Active growth', 'Closed', 'Consumable', 'Decreasing', 'Lost', 'Missing', 'Passive growth', 'Static'])
        numRecords()
        numRecordsDigitised()
        states(nullable:true)
        geographicDescription(nullable:true)
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
        scientificNames(nullable:true, maxSize:2048)
        subCollections(nullable:true, maxSize:4096)
        dateCreated(nullable:true)
        dateLastModified()
        userLastModified(maxSize:256)
    }

    def listSubCollections() {
        if (!subCollections) return []
        def result = []
        JSON.parse(subCollections).each {
            result << [name: it.name, description: it.description]
        }
        return result
    }
}
