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

/**
 *  Represents an organisational group in the collectory, such as an
 *  institution or collection.
 *
 *  - based on collectory data model version 4
 *
 *  NOTE: class name changed to Grp as ProviderGroup is a reserved word in many
 *  persistence languages
 *
 * .@history 2010-04-23 MEW Replaced String location with BigDecimal latitude, longitude and String altitude 
 *
 */

class ProviderGroup {

    static final int NO_INFO_AVAILABLE = -1 

    // general attributes
    String guid                 // this is not the DB id but a known identifier
                                // such as an LSID or institution code
    String name
    String acronym              //
    String groupType            // what sort of entity this is - eg institution, collection, project
    String description
    String focus                //
    //String address
    Address address
    BigDecimal latitude = 0     // decimal latitude
    BigDecimal longitude = 0    // decimal longitude
    String altitude             // may include units eg 700m
    String state
    String websiteUrl
    Image logoRef              // identifies the entity's logo within the image store
    Image imageRef             // the main image to represent the entity
    String email
    String phone
    boolean isALAPartner
    Date dateCreated
    Date dateFirstDataReceived
    String notes
    static embedded = ['address', 'logoRef', 'imageRef']

    // institution attributes
    String institutionType      // the type of institution, eg herbarium, library

    // collection attributes
    String collectionType       // type of collection e.g live, preserved, tissue, DNA
    String providerCollectionCode       // the code used for this entity by the owning institution
    int collectionNumRecords

    // project attributes
    Date projectStart
    Date projectEnd

    static hasMany = [ /*contacts: Contact,*/ parents: ProviderGroup, children: ProviderGroup ]
                                // the contacts for this entity
                                // its parent Groups
                                // its child groups

    /* this causes stack overflow from circular validations - means we need to handle cascading deletes manually */
    //static belongsTo = ProviderGroup

    static constraints = {
        guid(blank:false, unique:true, maxSize:45)
        name(blank:false, maxSize:128)
        acronym(nullable:true, maxSize:45)
        groupType(blank:false, maxSize:45, inList: ["Institution", "Collection", "Collection ProviderGroup"])
        description(nullable:true, maxSize:2048)
        focus(nullable:true, maxSize:2048)
        address(nullable:true)
        latitude()
        longitude()
        altitude(nullable:true)
        state(nullable:true, maxSize:45)
        websiteUrl(nullable:true, maxSize:256)
        logoRef(nullable:true, maxSize:256)
        imageRef(nullable:true, maxSize:256)
        email(nullable:true, maxSize:256)
        phone(nullable:true, maxSize:45)
        isALAPartner()
        dateCreated(nullable:true)
        dateFirstDataReceived(nullable:true)
        notes(nullable:true, maxSize:2048)

        institutionType(nullable:true, maxSize:45)

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
        collectionNumRecords(min:NO_INFO_AVAILABLE)

        projectStart(nullable:true)
        projectEnd(nullable:true)
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
    void addToContacts(Contact contact, String role, boolean isAdministrator) {
        //def initialCount = ContactFor.count()
        def cf = new ContactFor()
        cf.contact = contact
        cf.entityId = this.id
        cf.entityType = "ProviderGroup"
        cf.role = role?.empty ? null : role
        cf.administrator = isAdministrator
        cf.save(flush: true)
        if (cf.hasErrors()) {
            cf.errors.each {println it.toString()}
        }
        println "ContactFor count = " + ContactFor.count()
        //assert ContactFor.count() == initialCount + 1
    }

    /**
     * Gets a list of contacts along with their role and admin status for this group
     *
     */
    List<ContactFor> getContacts() {
        ContactFor.findAllByEntityId(this.id)
    }

    /**
     * Deletes the linkage between the contact and this group
     */
    void deleteFromContacts(Contact contact) {
        // TODO: add entityType to the search
        ContactFor.findByEntityIdAndContact(this.id, contact)?.delete()
    }

}

/**
 * Standardised form of an address.
 *
 * Used 'in-line' in ProviderGroup, ie does not create a separate table.
 */
class Address {
    String street           // includes number eg 186 Tinaroo Creek Road
    String postBox          // eg PO Box 2104
    String city
    String state            // full name eg Queensland
    String postcode
    String country
}

/**
 * Standardised form of an image reference.

 *
 * Used 'in-line' in ProviderGroup, ie does not create a separate table.
 */
class Image {
    String file
    String caption
    String attribution
    String copyright

    static constraints = {
        file(blank:false)
    }
}
