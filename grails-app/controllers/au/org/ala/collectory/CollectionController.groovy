package au.org.ala.collectory

import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap
import org.springframework.webflow.core.collection.LocalAttributeMap

/**
 * Controller handles ProviderGroups of type Collection
 */
class CollectionController {

    def authenticateService

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
        flow.command.websiteUrl = params.websiteUrl
        MultipartFile file = params.imageFile
        if (file.size) {  // will only have size if a file was selected
            def filename = file.getOriginalFilename()
            log.info "filename=${filename}"
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
                log.info "saving ${filename} to ${f.absoluteFile}"
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

    def index = {
        redirect(action:"list")
    }

    // list all collections
    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        //println "Count = " + ProviderGroup.countByGroupType('Institution')
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
            log.info "Showing ${collectionInstance.name} with numRecords = ${collectionInstance.scope.numRecords}"
            [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts()]
        }
    }

    // search for collections using the supplied search term
    def searchList = {
        params.each {println it}
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = "name"
        if (!params.order) params.order = "asc"

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
        params.each {println it}
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

    // not currently used - see editCollection flow
    def save = {
        log.info "Entered save action"
        def collectionInstance = new ProviderGroup(params)
        collectionInstance.dateLastModified = new Date()
        collectionInstance.userLastModified = authenticateService.userDomain().username
        log.info "Collection name is ${collectionInstance.name}"
        if (collectionInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'collection.label', default: 'Collection'), collectionInstance.id])}"
            redirect(action: "show", id: collectionInstance.id)
        }
        else {
            render(view: "create", model: [providerGroupInstance: collectionInstance])
        }
    }

    // not currently used - see editCollection flow
    def update = {
        log.info "Entered update action"
        params.sort{it.key}.each {
            log.info it
        }
        if (!params.children) log.info "No children"
        params.children.each {
            log.info "Child: ${it}, ${it.class}"
        }
        if (!params.parents) log.info "No parents"
        params.parents.each {
            log.info "Parent: ${it}, ${it.class}"
        }

        def providerGroupInstance = ProviderGroup.get(params.id)
        if (providerGroupInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (providerGroupInstance.version > version) {

                    providerGroupInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'providerGroup.label', default: 'ProviderGroup')] as Object[], "Another user has updated this ProviderGroup while you were editing")
                    render(view: "edit", model: [providerGroupInstance: providerGroupInstance])
                    return
                }
            }
            providerGroupInstance.properties = params

            log.info ">> params: file=${params.imageRef?.file} caption=${params.imageRef?.caption}"
            if (params.imageRef?.file) {
                log.info "Filename=${params.imageRef.file.getOriginalFilename()}"
                Image image = providerGroupInstance.imageRef
                if (image) {
                    // update
                    if (params.imageRef.file != image.file) {
                        request.getFile("file")?.transferTo(new File('/devt/logs/filename.png'))
                    }
                    image.properties = params.imageRef
                } else {
                    // add new
                    Image temp = new Image();
                    temp.properties = params.imageRef
                    providerGroupInstance.imageRef = temp //new Image(params.imageRef)
                }
            }
            log.info ">> ImageRef: file=${providerGroupInstance.imageRef?.file} caption=${providerGroupInstance.imageRef?.caption}"

            log.info "Updated values"
            if (!providerGroupInstance.children) log.info "No children"
            providerGroupInstance.children.each {
                log.info "Child: ${it}, ${it.class}"
            }
            if (!providerGroupInstance.parents) log.info "No parents"
            providerGroupInstance.parents.each {
                log.info "Parent: ${it}, ${it.class}"
            }

            if (!providerGroupInstance.hasErrors() && providerGroupInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'collection.label', default: 'Collection'), providerGroupInstance.name])}"
                redirect(action: "show", id: providerGroupInstance.id)
            }
            else {
                render(view: "edit", model: [providerGroupInstance: providerGroupInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
            redirect(action: "list")
        }
    }

    // not currently used - see editCollection flow
    def edit = {
        log.info "> entered edit"
        params.each {
            log.info it
        }
        def providerGroupInstance = ProviderGroup.get(params.id)
        if (!providerGroupInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
            redirect(action: "list")
        }
        else {
            [providerGroupInstance: providerGroupInstance]
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
                log.info "> entered start"
                def mode = params.mode == "create" ? "create" : "edit"
                log.info "> mode=" + mode
                CollectionCommand cmd = new CollectionCommand()
                if (mode == "edit") {
                    flow.colid = params.long("id")
                    log.info ">> colid = " + flow.colid

                    if (!cmd.load(flow.colid)) {
                        flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), flow.colid])}"
                        failure()
                    } else {
                        log.info "Editing collection ${cmd.name} with provider codes ${cmd.providerCodes} and names ${cmd.scientificNames}"
                    }
                } else {
                    log.info "Creating collection"
                    // add the user as the contact of the collection they are creating
                    def user = authenticateService.userDomain().username
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
            on(NumberFormatException).to "noSuchCollection"
        }

        // collect identity attributes
        ident {
            on("next") { //CollectionCommand cmd ->
                log.info ">> colid = " + flow.colid
                bindData(flow.command, params, IDENTITY_MAPPING)
                /* WORKAROUND - you should be able to pass a list of fields to validate (so you only get errors on
                 * this page). This does not work - maybe because this is a command class rather than a domain class. */
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.info it}
                    failure()
                }
            }.to "description"
            on("cancel").to "cancelEdit"
            on("done") {
                bindData(flow.command, params, IDENTITY_MAPPING)
                flow.command.validate()
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    failure()
                }
            }.to "updateCollection"
            //on('error')
        }

        // collect descriptive attributes
        description {
            on("next") {
                log.info ">> colid = " + flow.colid
                bindData(flow.command, params, DESCRIPTION_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "scope"
            on("back") {
                bindData(flow.command, params, DESCRIPTION_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "ident"
            on("cancel").to "cancelEdit"
            on("done") {
                bindData(flow.command, params, DESCRIPTION_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "updateCollection"
        }

        // collect website and image attributes
        reference {
            on ("next") {
                log.info ">> colid = " + flow.colid
                bindReference(params, flow)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "institution"
            on("back") {
                bindReference(params, flow)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "location"
            on ("cancel").to "cancelEdit"
            on ("done") {
                params.each{log.info it}
                bindReference(params, flow)
                log.info "filename: " + flow.command.imageRef?.file
                log.info "attribution: " + flow.command.imageRef?.attribution
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
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
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "dataset"
            on ("back") {
                bindData(flow.command, params, SCOPE_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "description"
            on ("cancel").to "cancelEdit"
            on ("done") {
                bindData(flow.command, params, SCOPE_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "updateCollection"
        }

        // collect dataset attributes
        dataset {
            on ("next") {
                bindData(flow.command, params, DATASET_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "location"
            on("back") {
                bindData(flow.command, params, DATASET_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "scope"
            on ("cancel").to "cancelEdit"
            on ("done") {
                params.each {log.info it}
                bindData(flow.command, params, DATASET_MAPPING)
                log.info "Command obj>numRecords = " + flow.command.numRecords
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "updateCollection"
        }

        // collect address, location and some contact attributes
        location {
            on ("next") {
                bindData(flow.command, params, LOCATION_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "reference"
            on("back") {
                bindData(flow.command, params, LOCATION_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
                    return
                }
            }.to "dataset"
            on ("cancel").to "cancelEdit"
            on ("done") {
                bindData(flow.command, params, LOCATION_MAPPING)
                if (flow.command.hasErrors()) {
                    flow.command.errors.each {log.warning it}
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
                log.info "> entered addInstitution"
                params.each {log.info it}
                if (params.addInstitution == null || params.addInstitution == 'null'|| params.addInstitution == '') {
                    failure()
                } else {
                    log.info "Adding id: ${params.addInstitution}"
                    flow.command.addAsParent(params.long("addInstitution"))
                }
            }
            on("success").to "institution"
            on("failure") {
                log.info ">>>failure"
                //flow.command.errors.rejectValue('command.addInstitution', 'collectionCommand.addInstitution.noInstitutionSelected')
                //flow.command.errors.reject('collectionCommand.addInstitution.noInstitutionSelected', null, 'You must select an institution first')
            }.to "institution"
        }

        // removes an institution as a parent
        removeInstitution {
            action {
                log.info "> entered removeInstitution"
                params.each {log.info it}
                log.info "Removing id: ${params.id}"
                flow.command.removeAsParent(params.long("id"))
            }
            on("success").to "institution"
        }

        // creates a new institution record with the current user as an editor and adds the institution as a parent
        createInstitution {
            action {
                log.info "> entered createInstitution"
                params.each {log.info it}
                ProviderGroup inst = new ProviderGroup(params)
                inst.groupType = ProviderGroup.GROUP_TYPE_INSTITUTION
                flow.newInst=inst
            }
            on("success") {
                // add to db immediately (need id to link the contact)
                flow.newInst.dateLastModified = new Date()
                flow.newInst.userLastModified = authenticateService.userDomain().username
                flow.newInst.save(flush: true)
                flow.newInst.validate()
                if (flow.newInst.hasErrors()) {
                    flow.newInst.errors.each {log.info it}
                    failure() // TODO: need correct error handling
                }
                log.info "new inst id=" + flow.newInst.id
                // add the user as the contact
                def user = authenticateService.userDomain().username
                log.info user
                if (user) {
                    Contact c = Contact.findByEmail(user)
                    if (c) {
                        flow.newInst.addToContacts(c, "Editor", true, user)
                        // save contact
                        flow.newInst.save(flush: true)
                    }
                }
                // add new institution to the collection
                flow.command.addAsParent(flow.newInst.id)
                // don't leave it in the flow
                flow.newInst = null
            }.to "institution"
            on("failure") {
                // TODO: return errors
                flash.message = "error"
            }.to "institution"
        }

        // collect contacts
        contacts {
            on ("back").to "institution"
            on ("cancel").to "cancelEdit"
            on ("done").to "updateCollection"
            on ("create").to "createContact"
            on ("remove").to "removeContact"
            on ("add").to "addContact"
            on ("next").to "contacts"  // safety net - should not happen
        }

        // adds an existing contact
        addContact {
            action {
                log.info "> entered addContact"
                params.each {log.info it}
                log.info "Adding id: ${params.addContact}"
                Contact contact = Contact.get(params.addContact)
                if (contact) {
                    flow.command.addAsContact(contact, params.role, (params.isAdmin == 'true'))
                }
            }
            on("success").to "contacts"
        }

        // removes a contact
        removeContact {
            action {
                log.info "> entered removeContact"
                params.each {log.info it}
                log.info "Removing id: ${params.id}"
                Contact contact = Contact.get(params.id)
                if (contact) {
                    flow.command.removeAsContact(contact)
                }
            }
            on("success").to "contacts"
        }

        // creates a new contact record and adds the contact to the collection
        createContact {
            action {
                //log.info "> entered createContact"
                //params.each {log.info it}
                Contact contact = new Contact(params)
                contact.dateLastModified = new Date()
                contact.userLastModified = authenticateService.userDomain().username
                // save immediately - review this decision
                contact.save()
                flow.command.addAsContact(contact, params.role2, (params.isAdmin2 as String == 'true'))
            }
            on("success").to "contacts"
            on("failure") {
                // TODO: return errors
                flash.message = "error"
            }.to "contacts"
        }

        // save the edit changes
        updateCollection {
            action {
                log.info "> saving changes"
                def mode = flow.mode
                if (mode == "create") {
                    log.info "creating collection"
                    if (flow.command.create(authenticateService.userDomain().username)) {
                        log.info "> created ${flow.command.name} with acronym ${flow.command.acronym} and id ${flow.command.id}"
                        flow.colid = flow.command.id
                    } else {
                        error()
                    }
                } else {
                    log.info ">> colid = " + flow.colid
                    // save changes
                    flow.command.save(authenticateService.userDomain().username)
                    log.info "> saved ${flow.command.name} with acronym ${flow.command.acronym} and id ${flow.command.id}"
                }
            }
            on("success").to "done"
            on("error").to "ident"
        }

        // exit the flow showing the modified collection
        done {
            action {
                log.info ">> colid = " + flow.colid
                def id = flow.colid
                flow.clear()
                flash.id = id
                log.info ">> flash.id = " + flash.id
            }
            on("success").to "exitToShow"
            on("failure").to "exitToList"
        }
        
        // exit because the specified collection doesn't exist
        noSuchCollection {
            redirect(controller:"collection", action:"list")
        }

        // exit because the user cancelled the edit
        cancelEdit {
            action {
                // no need to discard model as it's not directly managed by hibernate
                log.info ">> colid = " + flow.colid
                // make sure the modified model is removed from flow
                def id = flow.colid
                def mode = flow.mode
                flow.clear()
                if (mode == 'create') {
                    finish()
                } else {
                    flash.id = id
                    log.info ">> flash.id = " + flash.id
                }
            }
            on("finish").to "exitToList"
            on("success").to "exitToShow"
            on("failure").to "exitToList"
        }

        exitToShow {
            redirect(controller:"collection", action:"show", params: [id: flash.id])
        }

        exitToList {
            redirect(controller:"collection", action:"list")
        }
    }

}
