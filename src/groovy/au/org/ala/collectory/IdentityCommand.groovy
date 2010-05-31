package au.org.ala.collectory

/**
 * Command class for wizard pages
 */

class IdentityCommand implements Serializable {
    String guid
    String name
    String acronym
    String focus
    String collectionType
    String active

    static constraints = {
        guid(blank:false, maxSize:45)
        name(blank:false, maxSize:128)
        acronym(nullable:true, maxSize:45)
        focus(nullable:true, maxSize:2048)
        collectionType(nullable: true, inList: [
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
            "visual"])
        active(nullable:true, inList:['Active growth', 'Closed', 'Consumable', 'Decreasing', 'Lost', 'Missing', 'Passive growth', 'Static'])
    }
}


