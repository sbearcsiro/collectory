/***************************************************************************
 * Copyright (C) 2010 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 ***************************************************************************/

package au.org.ala.collectory

import org.hibernate.ObjectNotFoundException
import grails.converters.JSON

/**
 *  Represents an organisational group in the collectory, such as an
 *  institution or collection.
 *
 *  - based on collectory data model version 4
 *
 *  NOTE: class name changed to ProviderGroup as Group is a reserved word in many persistence languages
 *
 * .@history 2010-04-23 MEW Replaced String location with BigDecimal latitude, longitude and String altitude
 * .@history 2010-05-27 MEW Refactored model
 * .@history 2010-06-02 MEW Renamed providerCodes, changed to list, added internal mirror field
 *
 */

class ProviderGroup implements Serializable {

    static final int NO_INFO_AVAILABLE = -1
    static final String GROUP_TYPE_COLLECTION = 'Collection'
    static final String GROUP_TYPE_INSTITUTION = 'Institution'
    static final String ENTITY_TYPE = 'ProviderGroup'
    static final String LSID_PREFIX = 'urn:lsid:'
    static final int ABSTRACT_LENGTH = 250

    // general attributes
    String guid                 // this is not the DB id but a known identifier
                                // such as an LSID or institution code
    String name
    String acronym              //
    String groupType            // what sort of entity this is - eg institution, collection, project
    String pubDescription       // public description
    String techDescription      // technical description
    String focus                //
    Address address
    BigDecimal latitude = NO_INFO_AVAILABLE     // decimal latitude
    BigDecimal longitude = NO_INFO_AVAILABLE    // decimal longitude
    String altitude             // may include units eg 700m
    String state
    String websiteUrl
    Image logoRef              // identifies the entity's logo within the image store
    Image imageRef             // the main image to represent the entity
    String email
    String phone
    boolean isALAPartner = false
    Date dateCreated = new Date()
    Date dateLastModified = new Date()
    String userLastModified
    Date dateFirstDataReceived
    String notes
    String networkMembership    // a list of names of networks (CHAH, etc) that the group belongs to as JSON list

    static embedded = ['address', 'logoRef', 'imageRef']

    // collection attributes
    String providerCodes       // the codes used for this entity by the owning institution as a JSON array
                               //  form is: ["code1", "code2"]
    String internalProviderCodes// a set of codes for internal use that override the providerCodes
    String internalInstitutionCodes

    // institution attributes
    String institutionType      // the type of institution, eg herbarium, library

    // project attributes
    Date projectStart
    Date projectEnd

    // if this is a collection there will be one CollectionScope object
    CollectionScope scope

    // there may be zero or one InfoSources for this collection
    InfoSource infoSource

    // may have any number of parents and children
    static hasMany = [ parents: ProviderGroup, children: ProviderGroup ]

    /* this causes stack overflow from circular validations - we don't want cascading deletes anyway */
    //static belongsTo = ProviderGroup

    static transients = ['providerCodeList', 'listOfCollectionCodesForLookup', 'listOfinstitutionCodesForLookup',
            'providerCodesByPrecedence', 'primaryInstitution', 'primaryContact', 'memberOf', 'networkTypes',
            'collectionSummary', 'institutionSummary', 'mappable']

    static networkTypes = ["CHAH", "CHAFC", "CHAEC", "AMRRN", "CAMD"]

    static constraints = {
        guid(nullable:true, maxSize:45)         // allow blank for institutions - therefore can't make unique
        name(blank:false, maxSize:128)          // unique:true - ideally should be unique but relax so we can view all BCI data
        acronym(nullable:true, maxSize:45)
        groupType(blank:false, maxSize:45, inList: [GROUP_TYPE_INSTITUTION, GROUP_TYPE_COLLECTION])
        pubDescription(nullable:true, maxSize:2048)
        techDescription(nullable:true, maxSize:2048)
        focus(nullable:true, maxSize:2048)
        address(nullable:true)
        latitude(max:360.0, min:-360.0, scale:10)
        longitude(max:360.0, min:-360.0, scale:10)
        altitude(nullable:true)
        state(nullable:true, maxSize:45, inList: ['Australian Capital Territory', 'New South Wales', 'Queensland', 'Northern Territory', 'Western Australia', 'South Australia', 'Tasmania', 'Victoria'])
        websiteUrl(nullable:true, maxSize:256)
        logoRef(nullable:true)
        imageRef(nullable:true)
        email(nullable:true, maxSize:256)
        phone(nullable:true, maxSize:45)
        isALAPartner()
        dateCreated(nullable:true)
        dateLastModified()
        userLastModified(maxSize:256)
        dateFirstDataReceived(nullable:true)
        notes(nullable:true, maxSize:2048)
        networkMembership(nullable:true, maxSize:256)
        institutionType(nullable:true, maxSize:45, inList:['aquarium', 'archive', 'botanicGarden', 'conservation', 'fieldStation', 'government', 'herbarium', 'historicalSociety', 'horticulturalInstitution', 'independentExpert', 'industry', 'laboratory', 'library', 'management', 'museum', 'natureEducationCenter', 'nonUniversityCollege', 'park', 'repository', 'researchInstitute', 'school', 'scienceCenter', 'society', 'university', 'voluntaryObserver', 'zoo'])

        providerCodes(nullable:true, maxSize:2048)
        internalProviderCodes(nullable:true, maxSize:2048)
        internalInstitutionCodes(nullable:true, maxSize:45)

        projectStart(nullable:true)
        projectEnd(nullable:true)

        scope(nullable:true)            // should be present if type is "Collection"
        infoSource(nullable:true)
    }

    static namedQueries = {
        collections {
            eq(groupType, GROUP_TYPE_COLLECTION)
        }
        institutions {
            eq(groupType, GROUP_TYPE_INSTITUTION)
        }
    }

    /**
     * Adds a contact for this group using the supplied relationship attributes
     *
     * Contact relationships are handled statically because the relationship has attributes.
     *
     * @param contact the contact
     * @param role the role this contact has for this group
     * @param isAdministrator whether this contact is allowed to administer this group
     * @param isPrimaryContact whether this contact is the one that should be displayed as THE contact
     * @param modifiedBy the user that made the change
     */
    void addToContacts(Contact contact, String role, boolean isAdministrator, boolean isPrimaryContact, String modifiedBy) {
        // safety net - if there is no id we can't do this - will happen if the save fails without detection
        if (this.id == null) {
            return
        }
        def cf = new ContactFor()
        cf.contact = contact
        cf.entityId = this.id
        cf.entityType = "ProviderGroup"
        cf.role = role?.empty ? null : role
        cf.administrator = isAdministrator
        cf.primaryContact = isPrimaryContact
        cf.userLastModified = modifiedBy
        cf.save(flush: true)
        if (cf.hasErrors()) {
            cf.errors.each {println it.toString()}
        }
    }

    /**
     * Gets a list of contacts along with their role and admin status for this group
     *
     */
    List<ContactFor> getContacts() {
        // handle this being called before it has been saved (and therefore doesn't have an id - and can't have contacts)
        if (this.id) {
            // filter out records where the contact is missing
            // (safety net - ContactFor records should be deleted when Contact is)
            return ContactFor.findAllByEntityId(this.id).findAll{ cf ->
                try {
                    cf.contact != null
                } catch (ObjectNotFoundException e) {
                    false
                }
            }
        } else {
            []
        }
    }

    /**
     * Return the contact that should be displayed for this group.
     *
     * @return primary ContactFor (contains the contact and the role for this collection)
     */
    ContactFor getPrimaryContact() {
        List<ContactFor> list = getContacts()
        switch (list.size()) {
            case 0: return null
            case 1: return list[0]
            default:
                ContactFor result = null
                list.each {
                    if (it.primaryContact) result = it  // definitive (as long as there is only one primary)
                    if (it.role.toLowerCase() =~ 'curator') result = it  // second choice
                    if (!result && it.role.toLowerCase() =~ 'director') result = it  // third choice
                    if (!result && it.role.toLowerCase() =~ 'manager') result = it  // fourth choice
                }
                if (!result) result = list[0]  // just take one
                return result
        }
    }

    /**
     * Deletes the linkage between the contact and this group
     */
    void deleteFromContacts(Contact contact) {
        // TODO: add entityType to the search
        ContactFor.findByEntityIdAndContact(this.id, contact)?.delete()
    }

    /**
     * This elaborate and obtuse construct is designed to avoid errors at display time due to database inconsistencies
     * @return same as getChildren() but without children that do not exist in the database
     */
    List<ProviderGroup> getSafeChildren() {
        List<ProviderGroup> result = []
        getChildren().each{
            try {
                it.name
                result << it
            } catch (ObjectNotFoundException e) {
                false
            }
        }
        return result.sort{it.name}
    }

    /**
     * Returns true if:
     *  a) is an institution and isALAPartner flag is true
     *  b) is a collection and any parent institution is a partner
     *  c) has membership of a collection network (hub) (assumed that all hubs are partners)
     */
    boolean getIsALAPartner() {
        if (groupType == GROUP_TYPE_COLLECTION && parents.any({it.isALAPartner}) ) {
            return true
        } else if (networkMembership != null && networkMembership != "[]") {
            return true
        } else {
            return this.isALAPartner
        }
    }

    String toString() {
        return name.substring(0, Math.min(60, name.size()))
    }

    /**
     * Returns a list of all institutions sorted alphabetically.
     * @return
     */
    static List listInstitutions() {
        return ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION, [sort:'name'])
    }

    /**
     * Returns a list of all institutions that are parents of this group sorted alphabetically.
     * @return
     */
    List getParentInstitutionsOrderedByName() {
        return new ArrayList<ProviderGroup>(this.getParents()).sort{item-> item.name}
    }

    /**
     * Returns the JSON string of provider codes with the highest precedence.
     *
     * @return JSON array of strings
     */
    private String getProviderCodesByPrecedence() {
        switch (this.groupType) {
            case GROUP_TYPE_INSTITUTION:
                if (internalProviderCodes) return internalProviderCodes
                if (providerCodes) return providerCodes
                if (acronym) return "[${acronym}]"
                return ""
            case GROUP_TYPE_COLLECTION:
                if (internalProviderCodes) return internalProviderCodes
                return providerCodes
            default:
                return ""
        }
    }

    /**
     * Returns a list of provider codes with the highest precedence.
     *
     * Does NOT interpret the ANY keyword, ie returns it for caller to interpret.
     *
     * @return List of String
     */
    private List<String> getProviderCodesByPrecedenceAsList() {
        String codes = getProviderCodesByPrecedence()
        // return empty list if the keyword 'ANY' is present
        if (codes) {
            def jsonArray = JSON.parse(codes)
            return jsonArray.collect {it}
        } else {
            return []
        }
    }

    /*
     * Returns the list of collection codes that can be used to look up specimen records
     *
     * stored form of codes is: ["code1", "code2"]
     * @return the list of codes - may be empty
     */
    List<String> getListOfCollectionCodesForLookup() {
        if (groupType == GROUP_TYPE_COLLECTION) {
            String codes = getProviderCodesByPrecedence()
            // return empty list if the keyword 'ANY' is present
            if (containsAny(codes)) {
                return []
            }
            if (codes) {
                def jsonArray = JSON.parse(codes)
                return jsonArray.collect {it}
            } else {
                return []
            }
        } else {
            // may wish to combine all collection codes from child collections in the future
            return []
        }
    }

    /**
     * Returns the list of provider codes for the institution. Used to look up specimen records.
     * It is intended that this method is called on a collection.
     *
     * @return the list of codes - may be empty
     */
    List<String> getListOfInstitutionCodesForLookup() {
        String codes = ""
        // institution codes that are defined in the collection take precedence
        if (this.internalInstitutionCodes) {
            codes = getInternalInstitutionCodes()
        } else {
            def inst = findPrimaryInstitution()
            if (inst) {
                codes = inst.getProviderCodesByPrecedence();
            }
        }
        // return empty list if the keyword 'ANY' is present
        if (containsAny(codes)) {
            return []
        }
        if (codes) {
            def jsonArray = JSON.parse(codes)
            return jsonArray.collect {it}
        } else {
            return []
        }
    }

    /**
     * Returns this collection's parent institution. If multiple, uses rules to pick one.
     *
     * @return the collection's parent institution
     */
    ProviderGroup findPrimaryInstitution() {
        if (this.parents == null || this.parents.isEmpty()) return null
        switch (getParents()?.size()) {
            case 0: return null
            case 1: return getParents().toArray()[0]
            default:
                // use some rules - these can be extended as necessary, eg looking at institution code
                // for now take the first parent that is an institution
                getParents().findByGroupType(GROUP_TYPE_INSTITUTION)
        }
        return null
    }

    boolean isMemberOf(String network) {
        if (!this.networkMembership) {
            return false
        }
        return (this.networkMembership =~ network)
    }

    private boolean containsAny(codes) {
        if (codes?.toLowerCase() =~ '"any"') {
            return true
        }
        return false
    }

    /**
     * Returns true if the passed code is included (as a whole word) in the group's provider codes or
     * internal provider codes or if the internal codes are set to match ANY.
     *
     * Notes:
     * If internal (hidden) provider codes are present the code must match them.
     * If the internal provider codes contains the keyword "ANY", all codes will match.
     * Matches are case insensitive.
     * If the group is an institution, the acronym is the default provider code.
     * Assumes provider codes are represented as JSON array strings.
     *
     * @param code the code to match
     * @return true if this group has the passed code
     */
    boolean hasProviderCode(String code) {
        if (internalProviderCodes && containsAny(internalProviderCodes)) {
            return true
        } else if (internalProviderCodes) {
            return internalProviderCodes?.toLowerCase() =~ '"' + code?.toLowerCase() + '"'
        } else if (providerCodes) {
            return providerCodes?.toLowerCase() =~ '"' + code?.toLowerCase() + '"'
        } else if (groupType == ProviderGroup.GROUP_TYPE_INSTITUTION) {
            return acronym?.equalsIgnoreCase(code)
        }
        return false
    }

    /**
     * Tests whether this collection matches the supplied provider codes.
     *
     * @param institutionCode
     * @param collectionCode
     * @return
     */
    boolean matchesCollection(String institutionCode, String collectionCode) {
        // must be a collection
        if (groupType != GROUP_TYPE_COLLECTION) {return false}
        // cannot both be null or empty
        if (!institutionCode && !collectionCode) {return false}
        // must have collection code if it is given
        boolean hasCollectionCode = !collectionCode || hasProviderCode(collectionCode)
        // must have institution code if it is given
        boolean hasInstitutionCode = false
        if (hasCollectionCode) {
            // internal code takes precedence
            if (internalInstitutionCodes && institutionCode) {
                hasInstitutionCode = internalInstitutionCodes?.toLowerCase() =~ '"' + institutionCode.toLowerCase() + '"'
            } else {
                hasInstitutionCode = !institutionCode || findPrimaryInstitution()?.hasProviderCode(institutionCode)
            }
        }
        // must satisfy both
        return hasCollectionCode && hasInstitutionCode
    }

    /**
     * Returns a summary of the collection including:
     * - id
     * - name
     * - acronym
     * - lsid if available
     * - primary institution (id & name) if available
     * - description
     * - provider codes for matching with biocache records
     *
     * @return CollectionSummary
     */
    CollectionSummary getCollectionSummary() {
        CollectionSummary cs = init(new CollectionSummary())
        def inst = findPrimaryInstitution()
        if (inst) {
            cs.institution = inst.name
            cs.institutionId = inst.id
        }
        cs.derivedInstCodes = getListOfInstitutionCodesForLookup()
        cs.derivedCollCodes = getListOfCollectionCodesForLookup()
        return cs
    }

    /**
     * Returns a summary of the institution including:
     * - id
     * - name
     * - acronym
     * - lsid if available
     * - description
     * - provider codes for matching with biocache records
     *
     * @return InstitutionSummary
     */
    InstitutionSummary getInstitutionSummary() {
        InstitutionSummary is = init(new InstitutionSummary()) as InstitutionSummary
        is.derivedInstCodes = getProviderCodesByPrecedenceAsList()
        is.collections = children.collect {if (it.groupType==GROUP_TYPE_COLLECTION) [it.id, it.name]}
        return is
    }

    private ProviderGroupSummary init(pgs) {
        pgs.id = id
        pgs.name = name
        pgs.acronym = acronym
        pgs.shortDescription = makeAbstract()
        if (guid?.startsWith('urn:lsid:')) {
            pgs.lsid = guid
        }
        return pgs
    }

    /**
     * Trims the passed string to the specified length breaking at word boundaries and adding an elipsis if trimmed.
     */
    def trimLength = {trimString, stringLength ->

        String concatenateString = "..."
        List separators = [".", " "]

        if (stringLength && (trimString?.length() > stringLength)) {
            trimString = trimString.substring(0, stringLength - concatenateString.length())
            String separator = separators.findAll{trimString.contains(it)}?.min{trimString.lastIndexOf(it)}
            if(separator){
                trimString = trimString.substring(0, trimString.lastIndexOf(separator))
            }
            trimString += concatenateString
        }
        return trimString
    }

    /**
     * Returns descriptive text trimmed to the default abstract length.
     *
     * @return abstract
     */
    String makeAbstract() {
        makeAbstract(ABSTRACT_LENGTH)
    }

    /**
     * Returns descriptive text trimmed to the specified length.
     *
     * @return abstract
     */
    String makeAbstract(int length) {
        String chunk = ""
        if (pubDescription) {
            chunk = pubDescription
        } else if (techDescription) {
            chunk = techDescription
        } else if (focus) {
            chunk = focus
        }
        if (chunk.size() < length) {
            return (chunk) ? chunk : ""
        } else {
            return trimLength(chunk, length)
        }
    }

    /**
     * Returns the identifier part of a link that is optimised for permanence.
     *
     * Prioity is:
     * 1. lsid
     * 2. acronym
     * 3. DB id
     * @return an identifier
     */
    String generatePermalink() {
        if (guid?.startsWith(LSID_PREFIX)) {
            return guid
        } else if (acronym) {
            return acronym
        } else {
            return id
        }
    }

    /**
     * Returns true if the group can be mapped.
     *
     * Can be mapped if the group or its primary institution have valid lat and long.
     * @return
     */
    boolean isMappable() {
        if (latitude != 0.0 && latitude != -1 && longitude != 0.0 && longitude != -1) {
            return true
        }
        // use parent institution if lat/long not defined
        def inst = findPrimaryInstitution()
        if (inst && inst.latitude != 0.0 && inst.latitude != -1 && inst.longitude != 0.0 && inst.longitude != -1) {
            return true
        }
        return false
    }
}

/**
 * Standardised form of an address.
 *
 * Used 'in-line' in ProviderGroup, ie does not create a separate table.
 */
class Address implements Serializable {
    String street           // includes number eg 186 Tinaroo Creek Road
    String postBox          // eg PO Box 2104
    String city
    String state            // full name eg Queensland
    String postcode
    String country

    static transients = ['empty']
    
    static constraints = {
        street(nullable:true)
        postBox(nullable:true)
        city(nullable:true)
        state(nullable:true)
        postcode(nullable:true)
        country(nullable:true)
    }

    boolean isEmpty() {
        return !(street || postBox || city || state || postcode || country)
    }

    List<String> nonEmptyAddressElements() {
        List<String> elements = []
        if (street) {elements << street}
        if (city) {elements << city}
        if (state) {elements << state}
        if (postcode) {elements << postcode}
        return elements
    }

    String buildAddress() {
        return nonEmptyAddressElements().join(" ")
    }
}

/**
 * Standardised form of an image reference.

 *
 * Used 'in-line' in ProviderGroup, ie does not create a separate table.
 */
class Image implements Serializable {
    String file
    String caption
    String attribution
    String copyright

    static constraints = {
        file(blank:false)
        caption(nullable:true)
        attribution(nullable:true)
        copyright(nullable:true)
    }
}
