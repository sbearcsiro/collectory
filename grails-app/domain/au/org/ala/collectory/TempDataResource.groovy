/*
 * Copyright (C) 2011 Atlas of Living Australia
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
 */
package au.org.ala.collectory

import java.sql.Timestamp

/**
 * Represents a temporary data set that has been uploaded to the transient biocache.
 */
class TempDataResource {

    String uid              // with the form drtnnnnn (data resource temporary)
    String name             // the label supplied by the user

    // pseudo-contact
    String email            // from the user credentials
    String firstName
    String lastName

    Date dateCreated        // auto filled by grails
    Date lastUpdated

    int numberOfRecords     // determined from upload

    static constraints = {
        uid(maxSize: 20)
        name(nullable: true, maxSize:1024)
        email(nullable: true, maxSize:256)
        firstName(nullable: true, maxSize: 255)
        lastName(nullable: true, maxSize: 255)
    }

    static mapping = {
        uid index:'uid_idx'
    }

    def getUrlForm() {
        return "tempDataResource"
    }

    def buildSummary() {
        return [name:name, uid:uid, email:email, firstName:firstName, lastName:lastName, dateCreated:dateCreated,
                lastUpdated:lastUpdated, numberOfRecords:numberOfRecords]
    }

    def makeAbstract(length) {
        return ""
    }
}
