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
    static embedded = ['address', 'logoRef', 'imageRef']

    // collection attributes
    String providerCodes       // the codes used for this entity by the owning institution as a JSON array
                               //  form is: ["code1", "code2"]
    String internalProviderCodes// a set of codes for internal use that override the providerCodes
    String internalInstitutionCode

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

    static transients = ['providerCodeList', 'listOfCollectionCodesForLookup', 'institutionCodeForLookup']

    static constraints = {
        guid(blank:false, unique:true, maxSize:45)
        name(blank:false, maxSize:128)                  // unique:true - ideally should be unique but relax so we can view all BCI data
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

        institutionType(nullable:true, maxSize:45, inList:['aquarium', 'archive', 'botanicGarden', 'conservation', 'fieldStation', 'government', 'herbarium', 'historicalSociety', 'horticulturalInstitution', 'independentExpert', 'industry', 'laboratory', 'library', 'management', 'museum', 'natureEducationCenter', 'nonUniversityCollege', 'park', 'repository', 'researchInstitute', 'school', 'scienceCenter', 'society', 'university', 'voluntaryObserver', 'zoo'])

        providerCodes(nullable:true, maxSize:2048)
        internalProviderCodes(nullable:true, maxSize:2048)
        internalInstitutionCode(nullable:true, maxSize:45)

        projectStart(nullable:true)
        projectEnd(nullable:true)

        scope(nullable:true)            // should be present if type is "Collection"
        infoSource(nullable:true)
    }

    /**
     * Adds a contact for this group using the supplied relationship attributes
     *
     * Contact relationships are handled statically because the relationship has attributes.
     *
     * @param contact the contact
     * @param role the role this contact has for this group
     * @param isAdministrator whether this contact is allowed to administer this group
     */
    void addToContacts(Contact contact, String role, boolean isAdministrator, String modifiedBy) {
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
        return result
    }

    /**
     * Returns true if:
     *  a) is an istitution and isALAPartner flag is true
     *  b) is a collection and any parent institution is a partner
     */
    boolean getIsALAPartner() {
        if (groupType == GROUP_TYPE_COLLECTION && parents.any({it.isALAPartner}) ) {
            return true
        } else {
            return this.isALAPartner
        }
    }

    String toString() {
        return name.substring(0, Math.min(60, name.size()))
    }

    static List listInstitutions() {
        return ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION, [sort:'name'])
    }

    List getParentInstitutionsOrderedByName() {
        return new ArrayList<ProviderGroup>(this.getParents()).sort{item-> item.name}
    }

    /*
     * Returns the list of provider codes that can be used to look up specimen records
     *
     * stored form of codes is: ["code1", "code2"]
     * @return the list of codes - may be empty
     */
    List<String> getListOfCollectionCodesForLookup() {
        String codes = this.internalProviderCodes ? this.internalProviderCodes : this.providerCodes
        if (codes) {
            def jsonArray = JSON.parse(codes)
            return jsonArray.collect {it}
        } else {
            return []
        }
    }

    /**
     * Returns the institution code that can be used to look up specimen records
     *
     * @return code or null
     */
    String getInstitutionCodeForLookup() {
        String code = getInternalInstitutionCode()
        if (!code)
            code = getAcronym()
        return code
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

    static constraints = {
        street(nullable:true)
        postBox(nullable:true)
        city(nullable:true)
        state(nullable:true)
        postcode(nullable:true)
        country(nullable:true)
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
    }
}
