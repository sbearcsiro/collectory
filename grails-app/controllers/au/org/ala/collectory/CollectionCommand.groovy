package au.org.ala.collectory

import org.codehaus.groovy.grails.validation.Validateable
import org.springframework.web.multipart.MultipartFile
import org.apache.log4j.Logger

/**
 * A command class for collecting and validating a collection instance.
 *
 * User: markew
 * Date: May 12, 2010
 */

// this annotation wires the validate/errors methods/properties
@Validateable
class CollectionCommand implements Serializable {
    // maps to ProviderGroup
    long id                     // the DB id of the ProviderGroup that stores the collection
    String guid                 // this is not the DB id but a known identifier
                                // such as an LSID or institution code
    String name
    String acronym              //
    String pubDescription       // public description
    String techDescription      // technical description
    String focus                //
    Address address
    BigDecimal latitude = ProviderGroup.NO_INFO_AVAILABLE     // decimal latitude
    BigDecimal longitude = ProviderGroup.NO_INFO_AVAILABLE    // decimal longitude
    String state
    String websiteUrl
    Image imageRef             // the main image to represent the entity
    String email
    String phone
    String notes
    String providerCollectionCode       // the code used for this entity by the owning institution

    List<ProviderGroup> parents = []

    List<ContactFor> contacts = []

    // maps to CollectionScope
    String collectionType       // type of collection e.g live, preserved, tissue, DNA
    String keywords
    String active               // see active vocab
    int numRecords = ProviderGroup.NO_INFO_AVAILABLE
                                // total number of records held that are able to be digitised
    int numRecordsDigitised = ProviderGroup.NO_INFO_AVAILABLE
                                // number of records that are digitised

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

	String startDate            // the start date of the period the collection covers
	String endDate	            // the end date of the period the collection covers

	List<String> kingdomCoverage = []      // the higher taxonomy that the collection covers - see kingdom_coverage vocab
                                // a space-separated string that can contain any number of these values:
                                // Animalia Archaebacteria Eubacteria Fungi Plantae Protista
    String scientificNames

    // maps to InfoSource
	String webServiceUri
    String webServiceProtocol

    // operational fields
    List<Long> addedInstitutions = []
    List<Long> deletedInstitutions = []
    List<ContactFor> deletedContacts = []

    static constraints = {
        guid(blank:false, maxSize:45)
        name(blank:false, maxSize:128)
        acronym(nullable:true, maxSize:45)
        pubDescription(nullable:true, maxSize:2048)
        techDescription(nullable:true, maxSize:2048)
        focus(nullable:true, maxSize:2048)
        address(nullable:true)
        latitude(max:360.0, min:-360.0, scale:10)
        longitude(max:360.0, min:-360.0, scale:10)
        state(nullable:true, maxSize:45, inList: ['Australian Capital Territory', 'New South Wales', 'Queensland', 'Northern Territory', 'Western Australia', 'South Australia', 'Tasmania', 'Victoria'])
        websiteUrl(nullable:true, maxSize:256)
        imageRef(nullable:true)
        email(nullable:true, maxSize:256)
        phone(nullable:true, maxSize:45)
        notes(nullable:true, maxSize:2048)
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
        providerCollectionCode(nullable:true, maxSize:45)

        keywords(nullable:true)
        active(nullable:true, inList:['Active growth', 'Closed', 'Consumable', 'Decreasing', 'Lost', 'Missing', 'Passive growth', 'Static'])
        numRecords()
        numRecordsDigitised()
        states(nullable:true)
        geographicDescription(nullable:true)
        webServiceUri(nullable:true)
        webServiceProtocol(nullable:true)
        eastCoordinate(max:360.0, min:-360.0, scale:10)
        westCoordinate(max:360.0, min:-360.0, scale:10)
        northCoordinate(max:360.0, min:-360.0, scale:10)
        southCoordinate(max:360.0, min:-360.0, scale:10)
        startDate(nullable:true, maxSize:45)
        endDate(nullable:true, maxSize:45)
        kingdomCoverage(validator: { kc ->
                boolean ok = true
                kc.each {
                    if (!['Animalia', 'Archaebacteria', 'Eubacteria', 'Fungi', 'Plantae', 'Protista'].contains(it)) {
                        ok = false  // return false does not work here!
                    }
                }
                return ok
            })
        scientificNames(nullable:true)
    }

    static List<String> kingdoms() {
        return ['Animalia', 'Archaebacteria', 'Eubacteria', 'Fungi', 'Plantae', 'Protista']
    }

    boolean addAsParent(long institutionId) {
        ProviderGroup inst = ProviderGroup.get(institutionId)
        if (!inst) {
            return false
        }
        parents << inst
        // also remove from the deleted list in case we removed it in this flow
        deletedInstitutions.remove(inst.id)
        // NOTE that the collection must be added to the institution as a child and the institution must also be saved
        // when we commit (to preserve the child link)
        // to do this we need to carry a list of added institutions
        addedInstitutions << inst.id
        return true
    }

    boolean removeAsParent(long institutionId) {
        ProviderGroup inst = ProviderGroup.get(institutionId)
        if (!inst) {
            return false
        }
        //parents - inst  // this syntax should work but doesn't
        parents.remove(inst)
        // also remove from the added list in case we added it in this flow
        addedInstitutions.remove(inst.id)
        // NOTE that the collection must be removed as a child of the institution and the institution must also be saved
        // when we commit
        // to do this we need to carry a list of removed institutions
        deletedInstitutions << inst.id
        return true
    }

    void addAsContact(Contact contact, String role, boolean isAdmin) {
        if (contact) {
            contacts << new ContactFor(contact:contact, entityId:this.id,
                    entityType:ProviderGroup.ENTITY_TYPE, role:role, administrator:isAdmin)
            // also remove from the deleted list in case we removed it in this flow
            deletedContacts.remove(deletedContacts.find{it.contact.id == contact.id})
        }
    }

    void removeAsContact(Contact contact) {
        // move from contacts list to deletedContacts
        if (contact) {
            // first add to deleted
            deletedContacts << contacts.find{it.contact.id == contact.id}
            // then remove from contacts
            contacts.remove(contacts.find{it.contact.id == contact.id})
            /*// clone the list as we want to modify the real list
            new ArrayList<ContactFor>(contacts).each {
                if (it.contact.id == contact.id) {
                    contacts.remove(it)
                    deletedContacts << it
                }
            }*/
        }
    }

    boolean load(long collectionId) {
        def collectionInstance = ProviderGroup.get(collectionId)
        if (!collectionInstance) {
            return false
        }

        // would be nice to load named props in one go but doesn't seem to work
        //println "coll props = " + collectionInstance.properties['guid', 'name']
        //this.properties['guid', 'name'] = collectionInstance.properties.entrySet()
        //println "cmd props = " + this.properties['guid', 'name']

        // load from ProviderGroup
        id = collectionId
        guid = collectionInstance.guid
        name = collectionInstance.name
        acronym = collectionInstance.acronym
        pubDescription = collectionInstance.pubDescription
        techDescription = collectionInstance.techDescription
        focus = collectionInstance.focus
        address = collectionInstance.address
        latitude = collectionInstance.latitude
        longitude = collectionInstance.longitude
        state = collectionInstance.state
        websiteUrl = collectionInstance.websiteUrl
        imageRef = collectionInstance.imageRef
        email = collectionInstance.email
        phone = collectionInstance.phone
        notes = collectionInstance.notes
        providerCollectionCode = collectionInstance.providerCollectionCode

        parents = collectionInstance.getParentInstitutionsOrderedByName()

        contacts = collectionInstance.getContacts()

        // load from CollectionScope
        CollectionScope collectionScope = collectionInstance.scope
        if (collectionScope) {
            collectionType = collectionScope.collectionType
            keywords = collectionScope.keywords
            active = collectionScope.active
            numRecords = collectionScope.numRecords
            numRecordsDigitised = collectionScope.numRecordsDigitised
            states = collectionScope.states
            geographicDescription = collectionScope.geographicDescription
            eastCoordinate = collectionScope.eastCoordinate
            westCoordinate = collectionScope.westCoordinate
            northCoordinate = collectionScope.northCoordinate
            southCoordinate = collectionScope.southCoordinate
            startDate = collectionScope.startDate
            endDate = collectionScope.endDate
            if (collectionScope.kingdomCoverage) {
                kingdomCoverage = collectionScope.kingdomCoverage.split(" ")
            }
            scientificNames = collectionScope.scientificNames
        }

        // load from InfoSource
        InfoSource infosource = collectionInstance.infoSource
        if (infosource) {
            webServiceUri = infosource.getWebServiceUri()
            webServiceProtocol = infosource.getWebServiceProtocol()
        }

        return true
    }

    /**
     * Saves the command object to its constituent domain objects.
     *
     * @param the owning collection
     * @param user the user that modified the data
     * @return
     */
    boolean save(String user) {
        def collectionInstance = ProviderGroup.get(id)
        if (!collectionInstance) {
            return false
        }
        return updateFromCommand(collectionInstance, user)
    }

    /**
     * Saves the command object by creating its constituent domain objects.
     *
     * @param the owning collection
     * @param user the user that modified the data
     * @return
     */
    boolean create(String user) {
        // provider group
        def collectionInstance = new ProviderGroup(groupType: ProviderGroup.GROUP_TYPE_COLLECTION)
        return updateFromCommand(collectionInstance, user)
    }

    boolean updateFromCommand(ProviderGroup collectionInstance, String user) {
        // TODO: should use a service call to transactionalise
        collectionInstance.properties['guid', 'name', 'acronym', 'focus',
                'pubDescription', 'techDescription', 'notes',
                'websiteUrl', 'imageRef',
                'address', 'state', 'email', 'phone', 'parents'] = this.properties
        ['longitude', 'latitude'].each {
            collectionInstance."${it}" = this."${it}" ? this."${it}" : ProviderGroup.NO_INFO_AVAILABLE // set value where null -> -1
        }
        // update collection scope
        // create a scope if there isn't one
        if (!collectionInstance.scope) {
            collectionInstance.scope = new CollectionScope()
        }
        collectionInstance.scope.properties['collectionType', 'keywords', 'active', 'states', 'geographicDescription',
                'startDate', 'endDate', 'scientificNames'] = this.properties
        collectionInstance.scope.kingdomCoverage = this.kingdomCoverage?.join(" ")
        println "KC=" + collectionInstance.scope.kingdomCoverage
        ['eastCoordinate', 'westCoordinate', 'northCoordinate', 'southCoordinate', 'numRecords', 'numRecordsDigitised'].each {
            collectionInstance.scope."${it}" = this."${it}" ? this."${it}" : ProviderGroup.NO_INFO_AVAILABLE // set value where null -> -1
        }
        // modify and save changes to institutions
        addedInstitutions.each {
            ProviderGroup inst = ProviderGroup.get(it)
            inst.addToChildren(collectionInstance)
            inst.dateLastModified = new Date()
            inst.userLastModified = user
            inst.save()
            if (inst.hasErrors()) {
                inst.errors.each {println it}
                return false
            }
        }
        deletedInstitutions.each {
            ProviderGroup inst = ProviderGroup.get(it)
            inst.removeFromChildren(collectionInstance)
            inst.dateLastModified = new Date()
            inst.userLastModified = user
            inst.save()
            if (inst.hasErrors()) {
                inst.errors.each {println it}
                return false
            }
        }
        // save changes to contacts
        contacts.each {
            // save only the new ones
            if (!it.id) {
                it.userLastModified = user
                it.save()
                if (it.hasErrors()) {
                    it.errors.each {println it}
                    return false
                }
            }
        }
        // delete the link record for any contacts that were removed
        deletedContacts.each {
            println "deletedContact ${it} with id ${it.id}"
//                ContactFor cf = ContactFor.get(it.id)
//                println "ContactFor " + cf
//                if (cf) {
                //cf.delete(flush: true)
                ContactFor.executeUpdate("delete ContactFor where id = ?",[it.id])
//                }
        }

        // update infosource
        def infosourceChanged = false
        InfoSource infosource = collectionInstance.infoSource
        if (infosource == null) {
            /* create new if there are some values to save */
            if (webServiceUri || webServiceProtocol) {
                // create new infosource
                infosource = new InfoSource(title: "created for " + collectionInstance.name)
                infosource.setWebServiceUri webServiceUri
                infosource.setWebServiceProtocol webServiceProtocol
                infosource.addToCollections(collectionInstance)
                infosourceChanged = true
                collectionInstance.infoSource = infosource
            }
        } else if (infosource.getWebServiceUri() != webServiceUri || infosource.getWebServiceProtocol() != webServiceProtocol) {
            /* infosources may serve many collections, therefore we don't want to modify it
             * unless this is its only collection */
            // does the infosource have other collections?
            if (infosource.collections.size() > 1) {
                // it does - so make a clone to host our modifications
                collectionInstance.infoSource = new InfoSource(infosource.properties)
                // swap to the clone
                infosource = collectionInstance.infoSource
                infosource.title << " modified for " + collectionInstance.name
                infosource.collections = []
                infosource.addToCollections(collectionInstance)
            }
            // modify it
            infosource.setWebServiceUri webServiceUri
            infosource.setWebServiceProtocol webServiceProtocol
            infosourceChanged = true
        }
        if (infosourceChanged) {
            infosource.dateLastModified = new Date()
            infosource.userLastModified = user
            infosource.save(flush:true)
            if (infosource.hasErrors()) {
                infosource.errors.each {println it}
                return false
            }
        }
        collectionInstance.scope.dateLastModified = new Date()
        collectionInstance.scope.userLastModified = user
        collectionInstance.scope.save(flush:true)
        if (collectionInstance.scope.hasErrors()) {
            collectionInstance.scope.errors.each {println it}
            return false
        }
        collectionInstance.dateLastModified = new Date()
        collectionInstance.userLastModified = user
        collectionInstance.save(flush:true)
        if (collectionInstance.hasErrors()) {
            collectionInstance.errors.each {println it}
            return false
        }

        return true
    }

}
