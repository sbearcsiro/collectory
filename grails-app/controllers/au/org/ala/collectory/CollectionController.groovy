package au.org.ala.collectory

import grails.converters.JSON
import java.text.NumberFormat
import java.text.ParseException
import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class CollectionController {

    def idGeneratorService

    def index = {
        redirect(action:"list")
    }

    // list all collections
    def list = {
        if (params.message)
            flash.message = params.message
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        ActivityLog.log username(), isAdmin(), Action.LIST
        [collInstanceList: Collection.list(params),
                collInstanceTotal: Collection.count()]
    }

    def myList = {
        // do not paginate this list - unlikely to be large
        // get user's contact id
        def userContact = null
        def user = username()
        if (user) {
            userContact = Contact.findByEmail(user)
            def collectionList = []
            def institutionList = []
            if (userContact) {
                ContactFor.findAllByContact(userContact).each {
                    ProviderGroup pg = ProviderGroup._get(it.entityUid)
                    if (pg?.entityType() == Collection.ENTITY_TYPE) {
                        collectionList << pg
                    } else if (pg?.entityType() == Institution.ENTITY_TYPE) {
                        institutionList << pg
                    }
                }
            }
            ActivityLog.log username(), isAdmin(), Action.MYLIST
            log.info ">>${user} listing my collections and institution"
            render(view: 'myList', model: [collections: collectionList, institutions: institutionList])
        }
    }

    // show a single collection
    def show = {
        log.debug ">entered show with id=${params.id}"
        def collectionInstance = findCollection(params.id)
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        } else {
            // lookup number of biocache records - TODO: this code should be shared with public controller
            def baseUrl = ConfigurationHolder.config.biocache.baseURL
            def url = baseUrl + "occurrences/searchForCollection.JSON?pageSize=0&q=" + collectionInstance.generatePermalink()

            def count = 0
            def conn = new URL(url).openConnection()
            conn.setConnectTimeout 3000
            try {
                def json = conn.content.text
                //println "Response = " + json
                count = JSON.parse(json)?.searchResult?.totalRecords
                //println "Count = " + count
            } catch (Exception e) {
                log.error "Failed to lookup record count. ${e.getClass()} ${e.getMessage()} URL= ${url}."
            }
            def percent = 0
            if (count != 0 && collectionInstance.numRecords > 0) {
                percent = (count*100)/collectionInstance.numRecords
            }

            // show it
            log.info ">>${username()} showing ${collectionInstance.name}"
            ActivityLog.log username(), isAdmin(), collectionInstance.uid, Action.VIEW
            [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts(),
                    numBiocacheRecords: count, percentBiocacheRecords: percent]
        }
    }

    /**
     * Return a summary as JSON.
     * Param can be:
     *  1. database id
     *  2. uid
     *  3. lsid
     *  4. acronym
     * @deprecated use /lookup/summary
     */
    def summary = {
        Collection collectionInstance = findCollection(params.id)
        println ">> summary id = " + params.id
        if (collectionInstance) {
            render collectionInstance.buildSummary() as JSON
        } else {
            log.error "Unable to find collection for id = ${params.id}"
            def error = ["error":"unable to find collection for id = " + params.id]
            render error as JSON
        }
    }

    /**
     * Return a summary as JSON.
     * Params are:
     * inst - institution provider code
     * coll - collection provider code
     * @deprecated use /lookup/collection
     */
    def findCollectionFor = {
        def inst = params.inst
        def coll = params.coll
        if (!inst) {
            def error = ["error":"must specify an institution code as parameter inst"]
            render error as JSON
        }
        if (!coll) {
            def error = ["error":"must specify a collection code as parameter coll"]
            render error as JSON
        }
        Collection col = ProviderMap.findMatch(inst, coll)
        if (col) {
            render col.buildSummary() as JSON
        } else {
            def error = ["error":"unable to find collection with inst code = ${inst} and coll code = ${coll}"]
            render error as JSON
        }
    }

    // search for collections using the supplied search term
    def searchList = {
        params.each {log.debug it}
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = "name"
        if (!params.order) params.order = "asc"

        log.info ">>${username()} searching for ${params.term}"
        ActivityLog.log username(), isAdmin(), Action.SEARCH, params.term

        def results = Collection.createCriteria().list(max: params.max, offset: params.offset) {
            order(params.sort, params.order)
            or {
                like ('name', "%${params.term}%")
                like ('keywords', "%${params.term}%")
                eq ('acronym', "${params.term}")
            }
        }

        def term = params.term
        def criteria = term ? term : "blank"        // for display purposes
        [providerGroupInstanceList : results, providerGroupInstanceTotal: results.getTotalCount(), criteria: [criteria], term: term]
    }

    def delete = {
        Collection col = Collection.get(params.id)
        if (col) {
            def name = col.name
            log.info ">>${username()} deleting collection " + name
            ActivityLog.log username(), isAdmin(), col.uid, Action.DELETE
            try {
                // remove it as a child from parent institution
                if (col.institution) {
                    log.info "Removing collection " +  name + " from parent " + col.institution.name
                    col.institution.removeFromChildren col
                    it.userLastModified = username()
                    it.save()
                }
                // remove contact links (does not remove the contact)
                ContactFor.findAllByEntityUid(col.uid).each {
                    log.info "Removing link to contact " + it.contact?.buildName()
                    it.delete()
                }
                // delete collection
                col.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'collection.label', default: 'Collection'), name])}"
                redirect(action: "list")
            } catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'collection.label', default: 'Collection'), name])}"
                redirect(action: "show", id: params.id)
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        }
    }

    /** V2 editing ****************************************************************************************************/

    /**
     * Edit base attributes.
     * @param id - the database id
     */
    def edit = {
        def collection = Collection.get(params.id)
        if (!collection) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        } else {
            println params.page
            params.page = params.page ?: 'base'
            println params.page
            render(view:params.page, model:[command: collection])
        }
    }

    /**
     * Create a new collection.
     *
     */
    def create = {
        // quick and dirty
        def collection = new Collection(uid: idGeneratorService.getNextCollectionId(), name: 'enter name of collection', userLastModified: username())
        if (!collection.hasErrors() && collection.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'collection.label', default: 'Collection'), collection.uid])}"
            redirect(action: "show", id: collection.id)
        } else {
            flash.message = "Failed to create new collection"
            redirect(controller: 'admin', action: 'index')
        }
    }

    /**
     * Update base attributes
     */
    def updateBase = {BaseCommand cmd ->
        if(cmd.hasErrors()) {
            println params.id
            cmd.errors.each {println it}
            cmd.id = params.id as int   // these do not seem to be injected
            cmd.version = params.version as int
            render(view:'base', model: [command: cmd])
        } else {
            def collection = Collection.get(params.id)
            if (collection) {
                if (params.version) {
                    def version = params.version.toLong()
                    if (collection.version > version) {
                        collection.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'collection.label', default: 'Collection')] as Object[], "Another user has updated this collection while you were editing")
                        render(view: "base", model: [command: collectionInstance])
                        return
                    }
                }

                // special handling for membership
                collection.networkMembership = toJson(params.networkMembership)
                params.remove('networkMembership')

                collection.properties = params
                if (!collection.hasErrors() && collection.save(flush: true)) {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: 'collection.label', default: 'Collection'), collection.uid])}"
                    redirect(action: "show", id: collection.id)
                }
                else {
                    render(view: "base", model: [command: collection])
                }
            } else {
                flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
    }

    /**
     * Update location attributes
     */
    def updateLocation = {LocationCommand cmd ->
        params.each {println it}
        if(cmd.hasErrors()) {
            cmd.errors.each {println it}
            cmd.id = params.id as int   // these do not seem to be injected
            cmd.version = params.version as int
            render(view:'location', model: [command: cmd])
        } else {
            def collection = Collection.get(params.id)
            if (collection) {
                if (params.version) {
                    def version = params.version.toLong()
                    if (collection.version > version) {
                        collection.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'collection.label', default: 'Collection')] as Object[], "Another user has updated this collection while you were editing")
                        render(view: "location", model: [command: collectionInstance])
                        return
                    }
                }

                // special handling for lat & long
                if (!params.latitude) { params.latitude = -1 }
                if (!params.longitude) { params.longitude = -1 }

                // special handling for embedded address - need to create address obj if none exists and we have data
                if (!collection.address && [params.address.street, params.address.postBox, params.address.city,
                    params.address.state, params.address.postcode, params.address.country].join('').size() > 0) {
                    collection.address = new Address()
                }

                collection.properties = params
                if (!collection.hasErrors() && collection.save(flush: true)) {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: 'collection.label', default: 'Collection'), collection.uid])}"
                    redirect(action: "show", id: collection.id)
                } else {
                    render(view: "location", model: [command: collection])
                }
            } else {
                flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
    }

    /**
     * Update descriptive attributes
     */
    def updateDescription = {
        params.each {println it}
        def collection = Collection.get(params.id)
        if (collection) {
            if (params.version) {
                def version = params.version.toLong()
                if (collection.version > version) {
                    collection.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'collection.label', default: 'Collection')] as Object[], "Another user has updated this collection while you were editing")
                    render(view: "description", model: [command: collectionInstance])
                    return
                }
            }
            // special handling for collection type
            collection.collectionType = toJson(params.collectionType)
            params.remove('collectionType')

            // special handling for keywords
            def keywords = params.keywords.tokenize(',')
            def trimmedKeywords = keywords.collect {return it.trim()}
            collection.keywords = toJson(trimmedKeywords)
            params.remove('keywords')

            // special handling for sub-collections
            def names = params.findAll { key, value ->
                key.startsWith('name_') && value
            }
            def subs = names.sort().collect { key, value ->
                def idx = key.substring(5)
                def desc = params."description_${idx}"
                return [name: value, description: desc ? desc : ""]
            }
            def subCollections = []
            subs.each {
                subCollections.add it
            }
            collection.subCollections = subCollections as JSON
            params.remove('subCollections')

            collection.properties = params
            if (!collection.hasErrors() && collection.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'collection.label', default: 'Collection'), collection.uid])}"
                redirect(action: "show", id: collection.id)
            }
            else {
                render(view: "description", model: [command: collection])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    /**
     * Update images
     */
    def updateImages = {
        //params.each {println it}
        def collection = Collection.get(params.id)
        if (collection) {
            if (params.version) {
                def version = params.version.toLong()
                if (collection.version > version) {
                    collection.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'collection.label', default: 'Collection')] as Object[], "Another user has updated this collection while you were editing")
                    render(view: "images", model: [command: collectionInstance])
                    return
                }
            }
            // special handling for uploading image
            // we need to account for:
            //  a) upload of new image
            //  b) change of metadata for existing image
            // removing an image is handled separately
            MultipartFile file = params.imageFile
            if (file?.size) {  // will only have size if a file was selected
                // save the chosen file
                def content = request.getFile('imageFile')
                if (content && file.size < 200000) {   // limit file to 200Kb
                    def filename = file.getOriginalFilename()
                    log.debug "filename=${filename}"

                    // update filename
                    collection.imageRef = new Image(file: filename)

                    def colDir = new File(ConfigurationHolder.config.repository.location.images as String, "collection")
                    colDir.mkdirs()
                    File f = new File(colDir, filename)
                    log.debug "saving ${filename} to ${f.absoluteFile}"
                    content.transferTo(f)
                    ActivityLog.log username(), isAdmin(), Action.UPLOAD_IMAGE, filename
                } else {
                    println "reject file of size ${file.size}"
                    collection.errors.reject('image.too.big', 'The image you selected is too large. Images are limited to 200KB.')
                    collection.errors.rejectValue('imageRef.file', 'image.too.big')
                }
            }
            // handle too big error (cause setting props clears the error)
            if (collection.hasErrors()) {
                collection.errors.each{println it}
                render(view: "images", model: [command: collection])
            } else {
                collection.properties = params
                println "hasErrors? ${collection.hasErrors()}"
                if (!collection.hasErrors() && collection.save(flush: true)) {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: 'collection.label', default: 'Collection'), collection.uid])}"
                    redirect(action: "show", id: collection.id)
                }
                else {
                    render(view: "images", model: [command: collection])
                }
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    /**
     * Update geo and taxo range attributes & stats
     */
    def updateRange = {
        def collection = Collection.get(params.id)
        if (collection) {
            if (params.version) {
                def version = params.version.toLong()
                if (collection.version > version) {
                    collection.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'collection.label', default: 'Collection')] as Object[], "Another user has updated this collection while you were editing")
                    render(view: "range", model: [command: collectionInstance])
                    return
                }
            }

            // special handling for numbers
            if (!params.eastCoordinate) { params.eastCoordinate = -1 }
            if (!params.westCoordinate) { params.westCoordinate = -1 }
            if (!params.northCoordinate) { params.northCoordinate = -1 }
            if (!params.southCoordinate) { params.southCoordinate = -1 }
            if (!params.numRecords) { params.numRecords = -1 }
            if (!params.numRecordsDigitised) { params.numRecordsDigitised = -1 }

            // special handling for kingdoms
            collection.kingdomCoverage = toSpaceSeparatedList(params.kingdomCoverage)
            params.remove('kingdomCoverage')
            params.remove('_kingdomCoverage')

            // special handling for sci names
            def scientificNames = params.scientificNames.tokenize(',')
            def trimmedScientificNames = scientificNames.collect {return it.trim()}
            collection.scientificNames = toJson(trimmedScientificNames)
            params.remove('scientificNames')

            collection.properties = params
            if (!collection.hasErrors() && collection.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'collection.label', default: 'Collection'), collection.uid])}"
                redirect(action: "show", id: collection.id)
            } else {
                render(view: "range", model: [command: collection])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    def updateContactRole = {
        params.each {println it}
        def contactFor = ContactFor.get(params.contactForId)
        if (contactFor) {
            //contactFor.role = params.role
            //contactFor.administrator = params.admin
            //contactFor.primaryContact = params.primary
            contactFor.properties = params
            println "role = ${contactFor.role}"
            println "admin = ${contactFor.administrator}"
            println "primary = ${contactFor.primaryContact}"
            if (!contactFor.hasErrors() && contactFor.save(flush: true)) {
                flash.message = "${message(code: 'contactRole.updated.message', args: [params.id])}"
                redirect(action: "edit", id: params.id, params: [page: 'showContacts'])
            } else {
                render(view: 'contactRole', model: [command: ProviderGroup._get(params.id), cf: contactFor])
            }

        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contactFor.label', default: 'Contact for collection'), params.contactForId])}"
            redirect(action: "show", id: params.id)
        }

    }

    def addContact = {
        def collection = Collection.get(params.id)
        if (!collection) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        } else {
            Contact contact = Contact.get(params.addContact)
            if (contact) {
                collection.addToContacts(contact, "editor", true, false, username())
                redirect(action: "edit", params: [page:"showContacts"], id: params.id)
            }
        }
    }

    def addNewContact = {
        def contact = Contact.get(params.contactId)
        def collection = Collection.get(params.collectionId)
        if (contact && collection) {
            // add the contact to the collection
            collection.addToContacts(contact, "editor", true, false, username())
            redirect(action: "edit", params: [page:"showContacts"], id: collection.id)
        } else {
            if (!collection) {
                flash.message = "Contact was created but collection could not be found. Please edit collection and add contact from existing."
                redirect(action: "list")
            } else {
                // contact must be null
                flash.message = "Contact was created but could not be added to the collection. Please add contact from existing."
                redirect(action: "edit", params: [page:"showContacts"], id: collection.id)
            }
        }
    }

    def removeContact = {
        def collection = Collection.get(params.id)
        if (!collection) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        } else {
            ContactFor cf = ContactFor.get(params.idToRemove)
            if (cf) {
                cf.delete()
                redirect(action: "edit", params: [page:"showContacts"], id: params.id)
            }
            /*Contact contact = Contact.get(params.contactIdToRemove)
            if (contact) {
                collection.deleteFromContacts(contact)
                redirect(action: "edit", params: [page:"showContacts"], id: params.id)
            }*/
        }
    }

    def editRole = {
        def contactFor = ContactFor.get(params.id)
        if (!contactFor) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contactFor.label', default: 'Contact for collection'), params.id])}"
            redirect(action: "list")
        } else {
            ProviderGroup pg = ProviderGroup._get(contactFor.entityUid)
            if (pg) {
                render(view: 'contactRole', model: [command: pg, cf: contactFor])
            } else {
                // TODO:
            }
        }
    }

    def cancel = {
        redirect(action: "show", id: params.id)
    }
    
    /** end V2 editing ************************************************************************************************/

    /**
     * Web flow for editing a collection.
     *
     * Collection data is edited over multiple pages in a wizard-like paradigm.
     *
     * Page flow is:
     *      identity
     *      description
     *      scope
     *      dataset
     *      location
     *      reference
     *      institution
     *      contacts
     */
    def editCollectionFlow = {

        start {
            action {
                log.debug "> entered start"
                def mode = params.mode == "create" ? "create" : "edit"
                log.debug "> mode=" + mode
                CollectionCommand cmd = new CollectionCommand()
                if (mode == "edit") {
                    flow.colid = params.long("id")
                    log.debug ">> colid = " + flow.colid
                    if (!flow.colid) {
                        // bad
                        return noId()
                    }
                    if (!cmd.load(flow.colid)) {
                        log.info ">>${username()} shown error when trying to edit collection id=${flow.colid}"
                        flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), flow.colid])}"
                        failure()
                    } else {
                        log.info ">>${username()} editing collection ${cmd.name}"
                    }
                } else {
                    // add the user as the contact of the collection they are creating
                    // but not if they are an ADMIN
                    if (request.isUserInRole(ProviderGroup.ROLE_ADMIN)) {
                        def user = username()
                        log.info ">>${user} creating a new collection"
                        if (user) {
                            Contact c = Contact.findByEmail(user)
                            if (c) {
                                cmd.addAsContact(c, "Creator", true)
                            }
                        }
                    }
                    flow.mode = mode
                }
                [command: cmd]
            }
            on("success").to "ident"
            on("failure").to "cancelEdit"
            on("noId").to "noSuchCollection"
            on(NumberFormatException).to "noSuchCollection"
        }

        // collect identity attributes
        ident {
            on("next", bindIdent).to "description"
            on("cancel").to "cancelEdit"
            on("done", bindIdent).to "updateCollection"
        }

        // collect descriptive attributes
        description {
            on("next", bindDescription).to "scope"
            on("back", bindDescription).to "ident"
            on("addMore", bindDescription).to "description"
            on("cancel").to "cancelEdit"
            on("done", bindDescription).to "updateCollection"
        }

        // collect website and image attributes
        reference {
            on ("next", bindReference).to "institution"
            on("back", bindReference).to "location"
            on ("cancel").to "cancelEdit"
            on ("done", bindReference).to "updateCollection"
            on ("removeImage") {
                flow.command.imageRef = null
            }.to "reference"
        }

        // collect geo, taxa and temporal scope attributes
        scope {
            on ("next", bindScope).to "dataset"
            on ("back", bindScope).to "description"
            on ("cancel").to "cancelEdit"
            on ("done", bindScope).to "updateCollection"
        }

        // collect dataset attributes
        dataset {
            on ("next", bindDataset).to "location"
            on("back", bindDataset).to "scope"
            on ("cancel").to "cancelEdit"
            on ("done", bindDataset).to "updateCollection"
        }

        // collect address, location and some contact attributes
        location {
            on ("next", bindLocation).to "reference"
            on("back", bindLocation).to "dataset"
            on("lookup", bindLocation).to "lookupLatLng"
            on ("cancel").to "cancelEdit"
            on ("done", bindLocation).to "updateCollection"
        }

        // collect parent institution attributes
        institution {
            on ("next").to "contacts"
            on ("back").to "reference"
            on ("cancel").to "cancelEdit"
            on ("done").to "updateCollection"
            on ("create").to "createInstitution"
            on ("remove").to "removeInstitution"
            on ("add").to "addInstitution"
        }

        lookupLatLng {
            action {
                flow.command.latitude = -3
                flow.command.longitude = -3
            }
            on("success").to 'location'
        }

        // adds an existing institution as a parent
        addInstitution {
            action {
                log.debug "> entered addInstitution"
                params.each {log.debug it}
                if (params.addInstitution == null || params.addInstitution == 'null'|| params.addInstitution == '') {
                    failure()
                } else {
                    log.debug "Adding id: ${params.addInstitution}"
                    flow.command.institution = Institution.get(params.long("addInstitution"))
                }
            }
            on("success").to "institution"
            on("failure") {
                log.debug ">>>failure"
                //flow.command.errors.rejectValue('command.addInstitution', 'collectionCommand.addInstitution.noInstitutionSelected')
                //flow.command.errors.reject('collectionCommand.addInstitution.noInstitutionSelected', null, 'You must select an institution first')
            }.to "institution"
        }

        // removes an institution as a parent
        removeInstitution {
            action {
                log.debug "Removing id: ${params.id}"
                flow.command.institution = null
            }
            on("success").to "institution"
        }

        // creates a new institution record with the current user as an editor and adds the institution as a parent
        createInstitution {
            action {
                log.debug "> entered createInstitution"
                params.each {log.debug it}
                Institution inst = new Institution(params)
                inst.uid = idGeneratorService.getNextInstitutionId()
                inst.userLastModified = username() + "(created)"
                inst.validate()
                if (inst.hasErrors()) {
                    flow.newInst = inst
                    failure()
                } else {
                    flow.newInst=inst
                }
            }
            on("success") {
                // add to db immediately (need id to link the contact)
                flow.newInst.save(flush: true)
                if (flow.newInst.hasErrors()) {
                    flow.newInst.errors.each {log.debug it}
                    failure()
                } else {
                    ActivityLog.log username(), isAdmin(), flow.newInst.uid as String, Action.CREATE_INSTITUTION
                    log.debug "new inst id=" + flow.newInst.id
                    // if we have no id something is wrong
                    if (!flow.newInst?.id) {
                        failure()
                    } else {
                        // add the user as the contact
                        // but not if they are ADMIN
                        if (!request.isUserInRole(ProviderGroup.ROLE_ADMIN)) {
                            def user = username()
                            log.debug user
                            if (user) {
                                Contact c = Contact.findByEmail(user)
                                if (c) {
                                    flow.newInst.addToContacts(c, "Editor", true, true, user)
                                    // save contact
                                    flow.newInst.save(flush: true)
                                }
                            }
                        }
                        // add new institution to the collection
                        flow.command.institution = flow.newInst
                        // don't leave it in the flow
                        flow.newInst = null
                    }
                }
            }.to "institution"
            on("failure") {
                render(view: 'institution', model: [command: flow.command, newInst: flow.newInst])
            }.to "institution"
        }

        // collect contacts
        contacts {
            on ("back", bindContactsData).to "institution"
            on ("cancel").to "cancelEdit"
            on ("done", bindContactsData).to "updateCollection"
            on ("create", bindContactsData).to "createContact"
            on ("remove", bindContactsData).to "removeContact"
            on ("add", bindContactsData).to "addContact"
            on ("next").to "contacts"  // safety net - should not happen
        }

        // adds an existing contact
        addContact {
            action {
                log.debug "> entered addContact"
                params.each {log.debug it}
                log.debug "Adding id: ${params.addContact}"
                Contact contact = Contact.get(params.addContact)
                if (contact) {
                    flow.command.addAsContact(contact)
                }
            }
            on("success").to "contacts"
        }

        // removes a contact
        removeContact {
            action {
                params.each {log.debug it}
                log.debug "Removing id: ${params.idToRemove}"
                flow.command.removeAsContact(params.idToRemove as int)
            }
            on("success").to "contacts"
        }

        // creates a new contact record and adds the contact to the collection
        createContact {
            action {
                Contact contact = new Contact(params)
                contact.dateLastModified = new Date()
                contact.userLastModified = username() + "(created)"
                contact.validate()
                if ([params.firstName, params.lastName, params.phone, params.mobile, params.email].join() == "") {
                    contact.errors.reject("contact.fields.noData.message", "Name, phone, mobile and email in new contact cannot all be blank")
                }
                // do our own handling here as the values don't map directly to the command object
                if (contact.hasErrors()) {
                    flow.contact = contact
                    failure()
                } else {
                    // save immediately - review this decision
                    contact.save()
                    ActivityLog.log username(), isAdmin(), contact.id as String, Action.CREATE_CONTACT
                    flow.command.addAsContact(contact)
                }
            }
            on("success").to "contacts"
            on("failure") {
                render(view: 'contacts', model: [command: flow.command, contact: flow.contact])
            }.to "contacts"
        }

        // save the edit changes
        updateCollection {
            action {
                log.debug "> saving changes"
                def mode = flow.mode
                if (mode == "create") {
                    log.info "creating collection: user = ${username()}"
                    long id = flow.command.create('temp', idGeneratorService.getNextCollectionId())//username())
                    if (id) {
                        ActivityLog.log username(), isAdmin(), flow.command.uid as String, Action.CREATE
                        log.info ">>${username()} created collection ${flow.command.name} with id ${id}"
                        params.id = id
                    } else {
                        failure()
v                   }
                } else {
                    log.debug ">> colid = " + flow.colid
                    // save changes
                    long id = flow.command.save(username())
                    if (id == -2) {
                        // row was updated or deleted by another transaction
                        log.warn "Attempted to save a stale collection record - ${flow.command.name} version ${flow.command.version}"
                        // create new command object with fresh values
                        CollectionCommand cmd = new CollectionCommand()
                        cmd.load(flow.command.id)
                        log.info ">>reloading collection ${cmd.name} for editing"
                        flow.command = cmd
                        flow.command.errors.rejectValue("version", "default.optimistic.locking.failure",
                                [message(code: 'collection.label', default: 'collection')] as Object[],
                                "Another user has updated this collection while you were editing. New values have been refreshed. You will need to reapply your changes.")
                        return lockingFailure()
                    } else {
                        ActivityLog.log username(), isAdmin(), flow.command.uid as String, Action.EDIT_SAVE
                        log.info ">>${username()} saved collection ${flow.command.name}"
                    }
                }
            }
            on("success").to "done"
            on("error").to "ident"
            on("lockingFailure").to "ident"
        }

        // exit the flow showing the modified collection
        done {
            action {
                //params.each {log.debug it}
                flow.clear()
                [id: params.id, url: request.getContextPath() + '/collection/show']
            }
            on("success").to "exitToShow"
            on("failure").to "exitToList"
        }

        // exit because the specified collection doesn't exist
        noSuchCollection {
            redirect(controller:"collection", action:"list", params: [message: "Cannot edit a collection with no id specified"])
        }

        // exit because the user cancelled the edit or a fatal error occurred
        cancelEdit {
            action {
                // no need to discard model as it's not directly managed by hibernate
                // make sure the modified model is removed from flow
                def mode = flow.mode
                def uid = flow.command.uid
                flow.clear()
                if (mode == 'create') {
                    ActivityLog.log username(), isAdmin(), uid as String, Action.CREATE_CANCEL
                } else {
                    ActivityLog.log username(), isAdmin(), uid as String, Action.EDIT_CANCEL
                    log.debug ">> exiting to " + params.id
                }
                [id: params.id, url: request.getContextPath() + '/collection/show']
            }
            on("success").to "exitToShow"
            on("failure").to "exitToList"
        }

        exitToShow() /* workaround - see http://jira.codehaus.org/browse/GRAILS-5811  to be fixed in Grails 1.3.3 {
            redirect(controller:"collection", action:"show", params: [id: params.id])
        }*/

        exitToList {
            redirect(controller:"collection", action:"list")
        }
    }

    /**
     * Data binding for the edit web flow
     */

    private bindIdent = {
        // set empty collectionType list explicitly
        if (!params.collectionType) params.collectionType = []
        bindData(flow.command, params, [include: ['guid', 'name', 'acronym', 'collectionType', 'focus', 'active']])
        /* WORKAROUND - you should be able to pass a list of fields to validate (so you only get errors on
         * this page). This does not work - maybe because this is a command class rather than a domain class. */
        flow.command.validate()
        if (flow.command.hasErrors()) {
            flow.command.errors.each {log.warn it}
            failure()
        }
    }

    private bindDescription = {
        bindData(flow.command, params, [include:['pubDescription', 'techDescription', 'notes', 'keywords']])
        flow.command.bindSubCollections(params)
        flow.command.validate()
        if (flow.command.hasErrors()) {
            flow.command.errors.each {log.warn it}
            failure()
        }
    }

    /**
     * Handle file uploads and image metadata changes.
     *
     * If a file was selected (size > 0)
     * then
     *      upload file overwriting any existing file of the same name  // TODO: add collection prefix to avoid clashes
     *      update the file name
     *
     * If an image exists
     * then
     *      update the image metadata
     *
     * @param params
     * @param flow
     * @return
     */
    private bindReference = {
        // must be explicit about network membership because unchecking all means there is no param returned
        if (!params.networkMembership) params.networkMembership = []
        bindData(flow.command, params, [include:['websiteUrl', 'networkMembership']])
        MultipartFile file = params.imageFile
        if (file.size) {  // will only have size if a file was selected
            def filename = file.getOriginalFilename()
            log.debug "filename=${filename}"
            // update filename
            if (flow.command.imageRef) {
                flow.command.imageRef.file = filename
            } else {
                flow.command.imageRef = new Image(file: filename)
            }
            // save the chosen file
            def mhsr = request.getFile('imageFile')
            if (!mhsr?.empty && mhsr.size < 100000*200) {   // limit file to 200Kb
                def externalStore = ConfigurationHolder.config.repository.location.images  //grailsApplication.config.getProperty('imageStore')
                def colDir = new File(externalStore, "collection")
                colDir.mkdirs()
                File f = new File(colDir, filename)
                log.debug "saving ${filename} to ${f.absoluteFile}"
                mhsr.transferTo(f)
                ActivityLog.log username(), isAdmin(), Action.UPLOAD_IMAGE, filename
            } else {
                // TODO: handle error message
            }
        }
        if (flow.command.imageRef) {
            // just handle changes in the image metadata
            flow.command.imageRef.caption = params.imageRef?.caption
            flow.command.imageRef.attribution = params.imageRef?.attribution
            flow.command.imageRef.copyright = params.imageRef?.copyright
            //flow.command.properties['imageRef.caption', 'imageRef.attribution', 'imageRef.copyright'] = params
        }
        flow.command.validate()
        if (flow.command.hasErrors()) {
            flow.command.errors.each {log.warn it}
            failure()
        }
    }

    private bindScope = {
        bindData(flow.command, params, [include:['spatialRepresentationType', 'spatialResolution', 'states',
                'geographicDescription', 'wellKnownText', 'eastCoordinate', 'westCoordinate', 'northCoordinate',
                'southCoordinate', 'startDate', 'endDate', 'kingdomCoverage', 'scientificNames']])
        flow.command.validate()
        if (flow.command.hasErrors()) {
            flow.command.errors.each {log.warn it}
            failure()
        }
    }

    private bindDataset = {
        bindData(flow.command, params, [include:['webServiceUri', 'webServiceProtocol', 'numRecords', 'numRecordsDigitised']])
        flow.command.validate()
        if (flow.command.hasErrors()) {
            flow.command.errors.each {log.warn it}
            failure()
        }
    }

    private bindLocation = {
        bindData(flow.command, params, [include:['address.street', 'address.postBox', 'address.city',
                'address.state', 'address.postcode', 'address.country', 'latitude', 'longitude', 'altitude', 'state', 'email', 'phone']])
        flow.command.validate()
        if (flow.command.hasErrors()) {
            flow.command.errors.each {log.warn it}
            failure()
        }
    }

    /**
     * Handle multiple changes to ContactFor fields.
     */
    private bindContactsData = {
        flow.command.getContacts().each {cf ->
            cf.role = params."role_${cf.id}"
            cf.administrator = params."admin_${cf.id}" ? params."admin_${cf.id}" : false
            cf.primaryContact = params."primary_${cf.id}" ? params."primary_${cf.id}" : false
        }
    }

    private findCollection(id) {
        // try lsid
        if (id instanceof String && id.startsWith(ProviderGroup.LSID_PREFIX)) {
            return Collection.findByGuid(id)
        }
        // try uid
        if (id instanceof String && id.startsWith(Collection.ENTITY_PREFIX)) {
            return Collection.findByUid(id)
        }
        // try id
        try {
            NumberFormat.getIntegerInstance().parse(id)
            def result = Collection.read(id)
            if (result) {return result}
        } catch (ParseException e) {}
        // try acronym
        return Collection.findByAcronym(id)
    }

    private Collection get(id) {
        if (params.id?.toString()?.startsWith(Collection.ENTITY_PREFIX)) {
            return Collection.findByUid(params.id)
        } else {
            return Collection.get(params.id)
        }
    }
    
    private String username() {
        return (request.getUserPrincipal()?.attributes?.email)?:'not available'
    }

    private boolean isAdmin() {
        return (request.isUserInRole(ProviderGroup.ROLE_ADMIN))
    }

    private String toJson(param) {
        if (!param) {
            return ""
        }
        if (param instanceof String) {
            // single value
            return ([param] as JSON).toString()
        }
        def list = param.collect {
            it.toString()
        }
        return (list as JSON).toString()
    }

    private String toSpaceSeparatedList(param) {
        if (!param) {
            return ""
        }
        if (param instanceof String) {
            // single value
            return param
        }
        return param.join(' ')
    }
}

/** V2 command classes **/
class BaseCommand {
    long id
    long version
    String name
    String guid
    String acronym
    Institution institution
    List networkMembership
    String websiteUrl

    static constraints = {
        name(blank:false)
        guid(nullable:true)
        acronym(nullable:true)
        institution(nullable:true)
        networkMembership(nullable:true)
        websiteUrl(nullable:true)
    }
}

class LocationCommand {
    long id
    long version
    Address address
    String latitude
    String longitude
    String state
    String email
    String phone

    static constraints = {
        address(nullable:true)
        state(nullable:true)
        email(nullable:true)
        phone(nullable:true)
    }
}

