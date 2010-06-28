package au.org.ala.collectory

import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.plugins.springsecurity.AuthorizeTools

/**
 * Controller handles ProviderGroups of type Collection
 */
class CollectionController {

    def authenticateService, dataLoaderService

    def scaffold = ProviderGroup

    def index = {
        redirect(action:"list")
    }

    // list all collections
    def list = {
        if (params.message)
            flash.message = params.message
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        ActivityLog.log authenticateService.userDomain().username, Action.LIST
        [providerGroupInstanceList: ProviderGroup.findAllByGroupType("Collection", params),
                providerGroupInstanceTotal: ProviderGroup.countByGroupType('Collection')]
    }

    def myList = {
        // do not paginate this list - unlikely to be large
        // TODO: rewrite using HQL   def colls = ProviderGroup.findAll("from ProviderGroup as pg inner join pg.contacts as cf where pg.groupType = 'Collection' and cf.contactId = ${params.id}")
        // get user's contact id
        def userContact = null
        def user = authenticateService.userDomain().username
        if (user) {
            userContact = Contact.findByEmail(user)
        } else {
            redirect(controller: 'login', action: 'auth')
        }
        def collectionList = []
        if (userContact) {
            ContactFor.findAllByContact(userContact).each {
                ProviderGroup pg = ProviderGroup.findById(it.entityId)
                if (pg) {
                    collectionList << pg
                }
            }
        }
        ActivityLog.log authenticateService.userDomain().username, Action.MYLIST
        log.info ">>${user} listing my collections"
        render(view: 'myList', model: [providerGroupInstanceList: collectionList])
    }
    
    // show a single collection
    def show = {
        log.debug ">entered show with id=${params.id}"
        def collectionInstance = ProviderGroup.get(params.id)
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.info ">>${authenticateService.userDomain().username} showing ${collectionInstance.name}"
            ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.VIEW
            [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts()]
        }
    }

    // preview a single collection
    def preview = {
        def collectionInstance = ProviderGroup.get(params.id)
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.info ">>${authenticateService.userDomain().username} previewing ${collectionInstance.name}"
            ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.PREVIEW
            [collectionInstance: collectionInstance, contact: collectionInstance.getPrimaryContact(), subCollections: collectionInstance.scope.listSubCollections()]
        }
    }

    def loadSupplementary = {
        boolean override = params.override ? params.override : false
        log.info ">>${authenticateService.userDomain().username} loading supplimentary data"
        dataLoaderService.loadSupplementaryData("/data/collectory/bootstrap/sup.json", override, authenticateService.userDomain().username)
        ActivityLog.log authenticateService.userDomain().username, Action.DATA_LOAD
        redirect(url: "http://localhost:8080/Collectory")  //action: "list")
    }

    // search for collections using the supplied search term
    def searchList = {
        params.each {log.debug it}
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = "name"
        if (!params.order) params.order = "asc"

        log.info ">>${authenticateService.userDomain().username} searching for ${params.term}"
        ActivityLog.log authenticateService.userDomain().username, Action.SEARCH, params.term

        def results = ProviderGroup.createCriteria().list(max: params.max, offset: params.offset) {
            order(params.sort, params.order)
            eq ('groupType', 'Collection')
            or {
                like ('name', "%${params.term}%")
                scope {
                    like ('keywords', "%${params.term}%")
                }
                eq ('acronym', "${params.term}")
            }
        }

        def term = params.term
        def criteria = term ? term : "blank"        // for display purposes
        [providerGroupInstanceList : results, providerGroupInstanceTotal: results.getTotalCount(), criteria: [criteria], term: term]
    }

    def delete = {
        ProviderGroup providerGroupInstance = ProviderGroup.get(params.id)
        if (providerGroupInstance) {
            def name = providerGroupInstance.name
            log.info ">>${authenticateService.userDomain().username} deleting collection " + name
            ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.DELETE
            try {
                // remove it as a child from all parents
                providerGroupInstance.parents.each {
                    log.info "Removing collection " + name + " from parent " + it.name
                    it.removeFromChildren providerGroupInstance
                    it.dateLastModified = new Date()
                    it.userLastModified = authenticateService.userDomain().username
                    it.save()
                }
                // remove contact links (does not remove the contact)
                ContactFor.findAllByEntityIdAndEntityType(providerGroupInstance.id, ProviderGroup.ENTITY_TYPE).each {
                    log.info "Removing link to contact " + it.contact?.buildName()
                    it.delete()
                }
                // remove collection scope
                log.info "Deleting collection scope for " + name
                providerGroupInstance.scope?.delete()
                // remove infoSource if only one
                InfoSource info = providerGroupInstance.infoSource
                if (info) {
                    if (ProviderGroup.findAllByInfoSource(info).size() == 1) {
                        log.info "Deleting infosource for " + name
                        info.delete()
                    }
                }
                // delete collection
                providerGroupInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'collection.label', default: 'Collection'), name])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'collection.label', default: 'Collection'), name])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        }
    }


    def sciterms = {
        def terms = [1:'john', 2:'jon', 3:'jane', 4:'james', 5:'jamie']

        render(contentType: "text/xml") {
            terms.each { term ->
                result() {
                    name(term.value)
                    id(term.key)
                }
            }
        }
    }

    def create = {
        // handball to editCollection mode="create"
        chain(action:"editCollection", params:[mode:"create"])
    }

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
                        log.info ">>${authenticateService.userDomain().username} shown error when trying to edit collection id=${flow.colid}"
                        flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), flow.colid])}"
                        failure()
                    } else {
                        log.info ">>${authenticateService.userDomain().username} editing collection ${cmd.name}"
                    }
                } else {
                    // add the user as the contact of the collection they are creating
                    // but not if they are an ADMIN
                    if (!AuthorizeTools.ifAllGranted('ROLE_ADMIN')) {
                        def user = authenticateService.userDomain().username
                        log.info ">>${user} creating a new colection"
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

        // adds an existing institution as a parent
        addInstitution {
            action {
                log.debug "> entered addInstitution"
                params.each {log.debug it}
                if (params.addInstitution == null || params.addInstitution == 'null'|| params.addInstitution == '') {
                    failure()
                } else {
                    log.debug "Adding id: ${params.addInstitution}"
                    flow.command.addAsParent(params.long("addInstitution"))
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
                log.debug "> entered removeInstitution"
                params.each {log.debug it}
                log.debug "Removing id: ${params.id}"
                flow.command.removeAsParent(params.long("id"))
            }
            on("success").to "institution"
        }

        // creates a new institution record with the current user as an editor and adds the institution as a parent
        createInstitution {
            action {
                log.debug "> entered createInstitution"
                params.each {log.debug it}
                ProviderGroup inst = new ProviderGroup(params)
                inst.groupType = ProviderGroup.GROUP_TYPE_INSTITUTION
                inst.dateLastModified = new Date()
                inst.userLastModified = authenticateService.userDomain().username + "(created)"
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
                    ActivityLog.log authenticateService.userDomain().username as String, flow.newInst.id as long, Action.CREATE_INSTITUTION
                    log.debug "new inst id=" + flow.newInst.id
                    // if we have no id something is wrong
                    if (!flow.newInst?.id) {
                        failure()
                    } else {
                        // add the user as the contact
                        // but not if they are ADMIN
                        if (!AuthorizeTools.ifAllGranted('ROLE_ADMIN')) {
                            def user = authenticateService.userDomain().username
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
                        flow.command.addAsParent(flow.newInst.id)
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
                contact.userLastModified = authenticateService.userDomain().username + "(created)"
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
                    ActivityLog.log authenticateService.userDomain().username as String, contact.id, Action.CREATE_CONTACT
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
                    log.info "creating collection: user = ${authenticateService.userDomain().username}"
                    long id = flow.command.create(authenticateService.userDomain().username)
                    if (id) {
                        ActivityLog.log authenticateService.userDomain().username as String, id as long, Action.CREATE
                        log.info ">>${authenticateService.userDomain().username} created collection ${flow.command.name} with id ${id}"
                        params.id = id
                    } else {
                        failure()
v                   }
                } else {
                    log.debug ">> colid = " + flow.colid
                    // save changes
                    long id = flow.command.save(authenticateService.userDomain().username)
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
                        //ActivityLog.log authenticateService.userDomain().username as String, flow.command.id, Action.EDIT_SAVE
                        log.info ">>${authenticateService.userDomain().username} saved collection ${flow.command.name}"
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
                flow.clear()
                if (mode == 'create') {
                    ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.CREATE_CANCEL
                } else {
                    ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.EDIT_CANCEL
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
            if (!mhsr?.empty && mhsr.size < 1024*200) {   // limit file to 200Kb
                def webRootDir = servletContext.getRealPath("/")
                def colDir = new File(webRootDir, "images/collection")
                colDir.mkdirs()
                File f = new File(colDir, filename)
                log.debug "saving ${filename} to ${f.absoluteFile}"
                mhsr.transferTo(f)
                ActivityLog.log authenticateService.userDomain().username as String, Action.UPLOAD_IMAGE, filename
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
        bindData(flow.command, params, [include:['webServiceUri', 'webServiceProtocol', 'numRecords', 'numRecordsDigitised', 'providerCodes']])
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

}
