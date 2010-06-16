package au.org.ala.collectory

import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import org.springframework.webflow.core.collection.LocalAttributeMap
import grails.converters.JSON

/**
 * Controller handles ProviderGroups of type Collection
 */
class CollectionController {

    def authenticateService, dataLoaderService

    def scaffold = ProviderGroup

    static IDENTITY_FIELDS = ['guid', 'name', 'acronym', 'collectionType', 'focus', 'active']
    final static LinkedHashMap IDENTITY_MAPPING = [include: IDENTITY_FIELDS]
    final static LinkedHashMap DESCRIPTION_MAPPING = [include:['pubDescription', 'techDescription', 'notes', 'keywords']]
    //final static LinkedHashMap REFERENCE_MAPPING = [include:['websiteUrl', 'imageRef.caption', 'imageRef.attribution', 'imageRef.copyright']]
    final static LinkedHashMap SCOPE_MAPPING = [include:['spatialRepresentationType', 'spatialResolution', 'states',
                'geographicDescription', 'wellKnownText', 'eastCoordinate', 'westCoordinate', 'northCoordinate',
                'southCoordinate', 'startDate', 'endDate', 'kingdomCoverage', 'scientificNames']]
    final static LinkedHashMap DATASET_MAPPING = [include:['webServiceUri', 'webServiceProtocol', 'numRecords', 'numRecordsDigitised', 'providerCodes']]
    final static LinkedHashMap LOCATION_MAPPING = [include:['address.street', 'address.postBox', 'address.city',
                'address.state', 'address.postcode', 'address.country', 'latitude', 'longitude', 'altitude', 'state', 'email', 'phone']]
    final static LinkedHashMap REFERENCE_MAPPING = [include:['websiteUrl', 'networkMembership']]

    def index = {
        redirect(action:"list")
    }

    // list all collections
    def list = {
        if (params.message)
            flash.message = params.message
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        //log.debug "Count = " + ProviderGroup.countByGroupType('Institution')
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
        log.info ">>${user} listing my collections"
        render(view: 'myList', model: [providerGroupInstanceList: collectionList])
    }
    
    // show a single collection
    def show = {
        def collectionInstance = ProviderGroup.get(params.id)
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.info ">>${authenticateService.userDomain().username} showing ${collectionInstance.name}"
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
            [collectionInstance: collectionInstance, contact: collectionInstance.getPrimaryContact(), subCollections: collectionInstance.scope.listSubCollections()]
        }
    }

    def loadSupplementary = {
        boolean override = params.override ? params.override : false
        log.info ">>${authenticateService.userDomain().username} loading supplimentary data"
        dataLoaderService.loadSupplementaryData("/data/collectory/bootstrap/sup.json", override, authenticateService.userDomain().username)
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

        def results = ProviderGroup.withCriteria {
            maxResults(params.max?.toInteger())
            firstResult(params.offset?.toInteger())
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
        def total = ProviderGroup.withCriteria {
            eq ('groupType', 'Collection')
            or {
                like ('name', "${params.term}")
                scope {
                    like ('keywords', "%${params.term}%")
                }
                eq ('acronym', "${params.term}")
            }
        }.size()
        def term = params.term
        def criteria = term ? term : "blank"        // for display purposes
/*        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = params.sort ? params.sort : 'name'
        params.order = params.order ? params.order : 'asc'
        params.each {log.debug it}
        def matches = ProviderGroup.findAll("""\
            from ProviderGroup as p where p.acronym=:term \
            or p.name like :liketerm \
            or (p.groupType='Collection' and p.scope.keywords like :liketerm)""", [term:term, liketerm:"%${term}%"], params)
        // def matches = ProviderGroup.findAllByNameIlikeOrAcronymIlike("%"+term+"%", "%"+term+"%", params)
        def total = params.providerGroupInstanceTotal
        if (!total) {
            def all = ProviderGroup.findAll("""\
                from ProviderGroup as p where p.acronym=:term \
                or p.name like :liketerm \
                or (p.groupType='Collection' and p.scope.keywords like :liketerm)""", [term:term, liketerm:"%${term}%"])
            total = all.size()
        }*/
        [providerGroupInstanceList : results, providerGroupInstanceTotal: total, criteria: [criteria], term: term]
    }

    def delete = {
        ProviderGroup providerGroupInstance = ProviderGroup.get(params.id)
        if (providerGroupInstance) {
            def name = providerGroupInstance.name
            log.info ">>${authenticateService.userDomain().username} deleting collection " + name
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
                    def user = authenticateService.userDomain().username
                    log.info ">>${user} creating a new colection"
                    if (user) {
                        Contact c = Contact.findByEmail(user)
                        if (c) {
                            cmd.addAsContact(c, "Creator", true)
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
            on("next") { //CollectionCommand cmd ->
                log.debug ">> colid = " + flow.colid
                bindData(flow.command, params, IDENTITY_MAPPING)
                /* WORKAROUND - you should be able to pass a list of fields to validate (so you only get errors on
                 * this page). This does not work - maybe because this is a command class rather than a domain class. */
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.debug it}
                    failure()
                }
            }.to "description"
            on("cancel").to "cancelEdit"
            on("done") {
                params.each {log.debug it}
                bindData(flow.command, params, IDENTITY_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "updateCollection"
            //on('error')
        }

        // collect descriptive attributes
        description {
            on("next") {
                log.debug ">> colid = " + flow.colid
                bindData(flow.command, params, DESCRIPTION_MAPPING)
                flow.command.bindSubCollections(params)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "scope"
            on("back") {
                bindData(flow.command, params, DESCRIPTION_MAPPING)
                flow.command.bindSubCollections(params)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "ident"
            on("addMore") {         // sub-collections are filled - bind data and redraw so there are 3 blank
                bindData(flow.command, params, DESCRIPTION_MAPPING)
                flow.command.bindSubCollections(params)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "description"
            on("cancel").to "cancelEdit"
            on("done") {
                bindData(flow.command, params, DESCRIPTION_MAPPING)
                flow.command.bindSubCollections(params)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    return
                }
            }.to "updateCollection"
        }

        // collect website and image attributes
        reference {
            on ("next") {
                log.debug ">> colid = " + flow.colid
                bindReference(params, flow)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "institution"
            on("back") {
                bindReference(params, flow)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "location"
            on ("cancel").to "cancelEdit"
            on ("done") {
                params.each{log.debug it}
                bindReference(params, flow)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "updateCollection"
            on ("removeImage") {
                flow.command.imageRef = null
            }.to "reference"
        }

        // collect geo, taxa and temporal scope attributes
        scope {
            on ("next") {
                bindData(flow.command, params, SCOPE_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "dataset"
            on ("back") {
                bindData(flow.command, params, SCOPE_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "description"
            on ("cancel").to "cancelEdit"
            on ("done") {
                bindData(flow.command, params, SCOPE_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "updateCollection"
        }

        // collect dataset attributes
        dataset {
            on ("next") {
                bindData(flow.command, params, DATASET_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "location"
            on("back") {
                bindData(flow.command, params, DATASET_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "scope"
            on ("cancel").to "cancelEdit"
            on ("done") {
                params.each {log.debug it}
                bindData(flow.command, params, DATASET_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "updateCollection"
        }

        // collect address, location and some contact attributes
        location {
            on ("next") {
                bindData(flow.command, params, LOCATION_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "reference"
            on("back") {
                bindData(flow.command, params, LOCATION_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "dataset"
            on ("cancel").to "cancelEdit"
            on ("done") {
                bindData(flow.command, params, LOCATION_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warn it}
                    failure()
                }
            }.to "updateCollection"
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
                }
                log.debug "new inst id=" + flow.newInst.id
                // if we have no id something is wrong
                if (!flow.newInst?.id) {
                    failure()
                } else {
                    // add the user as the contact
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
                    // add new institution to the collection
                    flow.command.addAsParent(flow.newInst.id)
                    // don't leave it in the flow
                    flow.newInst = null
                }
            }.to "institution"
            on("failure") {
                render(view: 'institution', model: [command: flow.command, newInst: flow.newInst])
            }.to "institution"
        }

        // collect contacts
        contacts {
            on ("back") {
                bindContactsData(params, flow)
            }.to "institution"
            on ("cancel").to "cancelEdit"
            on ("done") {
                bindContactsData(params, flow)
            }.to "updateCollection"
            on ("create") {
                bindContactsData(params, flow)
            }.to "createContact"
            on ("remove") {
                bindContactsData(params, flow)
            }.to "removeContact"
            on ("add") {
                bindContactsData(params, flow)
            }.to "addContact"
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
                        log.info ">>${authenticateService.userDomain().username} created collection ${flow.command.name} with id ${id}"
                        params.id = id
                    } else {
                        failure()
v                    }
                } else {
                    log.debug ">> colid = " + flow.colid
                    // save changes
                    flow.command.save(authenticateService.userDomain().username)
                    log.info ">>${authenticateService.userDomain().username} saved collection ${flow.command.name}"
                }
            }
            on("success").to "done"
            on("error").to "ident"
        }

        // exit the flow showing the modified collection
        done {
            action {
                params.each {log.debug it}
                //log.debug ">> colid = " + flow.colid
                def id = params.id
                flow.clear()
                flash.id = id
                log.debug ">> flash.id = " + flash.id
            }
            on("success").to "exitToShow"
            on("failure").to "exitToList"
        }
        
        // exit because the specified collection doesn't exist
        noSuchCollection {
            redirect(controller:"collection", action:"list", params: [message: "Cannot edit a collection with no id specified"])
        }

        // exit because the user cancelled the edit
        cancelEdit {
            action {
                // no need to discard model as it's not directly managed by hibernate
                // make sure the modified model is removed from flow
                def id = params.id
                def mode = flow.mode
                flow.clear()
                if (mode == 'create') {
                    finish()
                } else {
                    flash.id = id
                    log.info ">> exiting to " + flash.id
                }
            }
            on("finish").to "exitToList"
            on("success").to "exitToShow"
            on("failure").to "exitToList"
        }

        exitToShow {
            redirect(controller:"collection", id:flash.id, action:"show")
        }

        exitToList {
            redirect(controller:"collection", action:"list")
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
    boolean bindReference(GrailsParameterMap params, LocalAttributeMap flow) {
        bindData(flow.command, params, REFERENCE_MAPPING)
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
    }

    /**
     * Handle multiple changes to ContactFor fields.
     *
     * @param params
     * @param flow
     * @return
     */
    boolean bindContactsData(GrailsParameterMap params, LocalAttributeMap flow) {
        log.debug "start"
        params.each {log.debug it}
        log.debug "end"
        flow.command.getContacts().each {cf ->
            cf.role = params."role_${cf.id}"
            cf.administrator = params."admin_${cf.id}" ? params."admin_${cf.id}" : false
            cf.primaryContact = params."primary_${cf.id}" ? params."primary_${cf.id}" : false
        }
        return true
    }

}
