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

/**
 *  Base class for an organisational group in the collectory, such as an
 *  institution or collection.
 *
 *  - based on collectory data model version 4
 *
 *  NOTE: class name changed to ProviderGroup as Group is a reserved word in many persistence languages
 *
 * .@history 2010-04-23 MEW Replaced String location with BigDecimal latitude, longitude and String altitude
 * .@history 2010-05-27 MEW Refactored model
 * .@history 2010-06-02 MEW Renamed providerCodes, changed to list, added internal mirror field
 * .@history 2010-07-02 MEW Replaced providerCodes with ProviderCode and ProviderMap tables
 * .@history 2010-08-02 MEW Refactored using inheritance
 */

abstract class ProviderGroup implements Serializable {

    static final int NO_INFO_AVAILABLE = -1
    static final String LSID_PREFIX = 'urn:lsid:'
    static final int ABSTRACT_LENGTH = 250
    // for want of somewhere appropriate to put these:
    static final String ROLE_ADMIN = 'ROLE_COLLECTION_ADMIN'
    static final String ROLE_EDITOR = 'ROLE_COLLECTION_EDITOR'

    // general attributes
    String guid                 // this is not the DB id but a known identifier
                                // such as an LSID or institution code
    String uid                  // ALA assigned identifier for matching across sub-systems
    String name
    String acronym              //
    //String groupType            // what sort of entity this is - eg institution, collection, project
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
    String notes
    String networkMembership    // a list of names of networks (CHAH, etc) that the group belongs to as JSON list
    String attributions = ''    // list of space-separated uids for attributions
    Date dateCreated
    Date lastUpdated
    String userLastModified

    static embedded = ['address', 'logoRef', 'imageRef']

    static transients = ['primaryInstitution', 'primaryContact', 'memberOf', 'networkTypes', 'mappable','ALAPartner']

    static networkTypes = ["CHAH", "CHAFC", "CHAEC", "CHACM", "CAMD"]

    static statesList = ['Australian Capital Territory', 'New South Wales', 'Queensland', 'Northern Territory', 'Western Australia', 'South Australia', 'Tasmania', 'Victoria']

    static mapping = {
        tablePerHierarchy false
        uid index: 'uid_idx'
    }

    static constraints = {
        guid(nullable:true, maxSize:45)         // allow blank for institutions - therefore can't make unique
        uid(blank:false, maxSize:20)
        name(blank:false, maxSize:1024)          // unique:true - ideally should be unique but relax so we can view all BCI data
        acronym(nullable:true, maxSize:45)
        pubDescription(nullable:true, maxSize:2048)
        techDescription(nullable:true, maxSize:2048)
        focus(nullable:true, maxSize:2048)
        address(nullable:true)
        latitude(max:360.0, min:-360.0, scale:10)
        longitude(max:360.0, min:-360.0, scale:10)
        altitude(nullable:true)
        state(nullable:true, maxSize:45, inList: statesList)
        websiteUrl(nullable:true, maxSize:256)
        logoRef(nullable:true)
        imageRef(nullable:true)
        email(nullable:true, maxSize:256)
        phone(nullable:true, maxSize:45)
        isALAPartner()
        notes(nullable:true, maxSize:2048)
        networkMembership(nullable:true, maxSize:256)
        attributions(nullable:true, maxSize:256)
    }

    /*  Contacts  */
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
        if (dbId() == null) {
            return
        }
        def cf = new ContactFor()
        cf.contact = contact
        cf.entityUid = uid
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
        if (dbId()) {
            return ContactFor.findAllByEntityUid(uid)
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
                for (cf in list) {
                    if (cf.primaryContact)  // definitive (as long as there is only one primary)
                        return cf
                }
                if (!result) result = list[0]  // just take one
                return result
        }
    }

    /**
     * Return all contacts for this group with the primary contact listed first.
     *
     * @return list of ContactFor (contains the contact and the role for this collection)
     */
    List<ContactFor> getContactsPrimaryFirst() {
        List<ContactFor> list = getContacts()
        if (list.size() > 1) {
                for (cf in list) {
                    if (cf.primaryContact) {
                        // move it to the top
                        Collections.swap(list, 0, list.indexOf(cf))
                        break
                    }
                }
        }
        return list
    }

    /**
     * Deletes the linkage between the contact and this group
     */
    void deleteFromContacts(Contact contact) {
        ContactFor.findByEntityUidAndContact(uid, contact)?.delete()
    }
    
    /**
     * Returns a truncated name.
     */
    String toString() {
        return name.substring(0, Math.min(60, name.size()))
    }

    boolean isMemberOf(String network) {
        if (!networkMembership) {
            return false
        }
        return (networkMembership =~ network)
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
     * Should always be the UID.
     *
     * @return an identifier
     */
    String generatePermalink() {
        if (uid) {
            return uid
        }
        if (guid?.startsWith(LSID_PREFIX)) {
            return guid
        }
        if (acronym) {
            return acronym
        }
        return id
    }

    /**
     * Returns list of name/url for where the information about this collection was sourced.
     * @return list of Attribution
     */
    List<Attribution> getAttributionList() {
        def uids = attributions.tokenize(' ')
        List<Attribution> list = []
        uids.each {
            def att = Attribution.findByUid(it as String)
            if (att) {
                list << att
            }
        }
        return list
    }

    /**
     * Adds the specified attribution to this group.
     * @param attributionUid
     */
    void addAttribution(String attributionUid) {
        attributions = attributions ?: ""
        if (!hasAttribution(attributionUid)) {
            attributions += (attributions?' ':'') + attributionUid
        }
    }

    boolean hasAttribution(String attributionUid) {
        return attributions =~ /\b${attributionUid}\b/
    }

    void removeAttribution(String attributionUid) {
        def uids = attributions.tokenize(' ')
        uids.remove attributionUid
        attributions = uids.join(' ')
    }
    
    /*
     * Injects common group attributes into the summary object.
     */
    protected ProviderGroupSummary init(ProviderGroupSummary pgs) {
        pgs.id = dbId()
        pgs.uid = uid
        pgs.name = name
        pgs.acronym = acronym
        pgs.shortDescription = makeAbstract()
        if (guid?.startsWith('urn:lsid:')) {
            pgs.lsid = guid
        }
        return pgs
    }

    static String entityTypeFromUid(String uid) {
        switch (uid[0..1]) {
            case Institution.ENTITY_PREFIX: return Institution.ENTITY_TYPE
            case Collection.ENTITY_PREFIX: return Collection.ENTITY_TYPE
            case DataProvider.ENTITY_PREFIX: return DataProvider.ENTITY_TYPE
            case DataResource.ENTITY_PREFIX: return DataResource.ENTITY_TYPE
            case DataHub.ENTITY_PREFIX: return DataHub.ENTITY_TYPE
        }
    }

    static String urlFormOfEntityType(String entityType) {
        return entityType[0..0].toLowerCase() + entityType[1..entityType.size()-1]
    }

    static ProviderGroup _get(String uid) {
        if (!uid || uid.size() < 3) {return null}
        switch (uid[0..1]) {
            case Institution.ENTITY_PREFIX: return Institution.findByUid(uid)
            case Collection.ENTITY_PREFIX: return Collection.findByUid(uid)
            case DataProvider.ENTITY_PREFIX: return DataProvider.findByUid(uid)
            case DataResource.ENTITY_PREFIX: return DataResource.findByUid(uid)
            case DataHub.ENTITY_PREFIX: return DataHub.findByUid(uid)
            default: return null
        }
    }

    /**
     * Returns true if the entity can be mapped, ie it has lat/lon or can inherit lat/lon.
     * @return
     */
    abstract boolean canBeMapped()

    /**
     * Returns the a summary object that extends ProviderGroupSummary and is specific to the type of entity.
     * @return summary object
     */
    abstract ProviderGroupSummary buildSummary()

    /*
     * The database id is not injected into this class but the subclass that is actually mapped to
     * the database. Therefore all references to the id from this base class must use this method
     * (which is implemented in the subclass) to access the database id.
     */
    abstract long dbId()

    abstract String entityType()

    String urlForm() {
        return ProviderGroup.urlFormOfEntityType(entityType())
    }

    /**
     * Entities are the same if they have the same uid.
     *
     * @param obj to compare
     * @return true if same
     */
    def boolean equals(Object obj) {
        return uid == obj?.uid
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

    List<String> nonEmptyAddressElements(includePostal) {
        def fields = ['street','city','state','postcode']
        if (includePostal) {fields << 'postBox'}
        List<String> elements = []
        fields.each {
            if (this."${it}") {
                elements << this."${it}"
            }
        }
        return elements
    }

    String buildAddress() {
        return nonEmptyAddressElements(false).join(" ")
    }

    def String toString() {
        return nonEmptyAddressElements(true).join(" ")
    }

    def boolean equals(Object obj) {
        return obj instanceof Address &&
                street == obj.street &&
                postBox == obj.postBox &&
                city == obj.city &&
                state == obj.state &&
                postcode == obj.postcode &&
                country == obj.country
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

    def String toString() {
        return ([file,caption,attribution,copyright].findAll {it}).join(", ")
    }

    def boolean equals(Object obj) {
        return obj instanceof Image && file == obj.file && caption == obj.caption &&
                attribution == obj.attribution && copyright == obj.copyright
    }


}
