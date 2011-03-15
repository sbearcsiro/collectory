package au.org.ala.collectory

import grails.converters.JSON

import grails.converters.XML
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.codehaus.groovy.grails.web.servlet.HttpHeaders
import java.text.DateFormat
import java.text.SimpleDateFormat
import groovy.xml.MarkupBuilder

class DataController {

    def crudService, authService, emlRenderService
    
    def index = { }

    /** make sure that uid params point to an existing entity and json is parsable **/
    def beforeInterceptor = this.&check

    def check() {
        def uid = params.uid
        if (uid) {
            // it must exist
            def pg = ProviderGroup._get(uid)
            if (pg) {
                params.pg = pg
                // if entity is specified, the instance must be of type entity
                if (params.entity && pg.urlForm() != params.entity) {
                    // exists but wrong type (eg /dataHub/dp20)
                    notFound "entity with uid = ${uid} is not a ${params.entity}"
                    return false
                }
            } else {
                // doesn't exist
                notFound "no entity with uid = ${uid}"
                return false
            }
        }
        if (request.method == 'POST' || request.method == "PUT") {
            if (request.getContentLength() == 0) {
                // no payload so return OK as entity exists (if specified)
                success "no post body"
                return false
            }
            try {
                params.json = request.JSON
            } catch (Exception e) {
                println "exception caught ${e}"
                // allow empty body
                if (request.getContentLength() > 0) {
                    badRequest 'cannot parse request body as JSON'
                    return false
                }
            }
        }
        return true
    }

    /******* Web Services Catalogue *******/

    def catalogue = { }

    /***** CRUD RESTful services ********/

    /**
     * format for RFC 1123 date string -- "Sun, 06 Nov 1994 08:49:37 GMT"
     */
    final static String RFC1123_PATTERN = "EEE, dd MMM yyyy HH:mm:ss z";

    /**
      * DateFormat to be used to format dates
      */
    final static DateFormat rfc1123Format = new SimpleDateFormat(RFC1123_PATTERN)
    static {
        rfc1123Format.setTimeZone(TimeZone.getTimeZone("GMT"));
    }
    
    def addLocation(relativeUri) {
        response.addHeader 'location', ConfigurationHolder.config.grails.serverURL + relativeUri
    }

    def addContentLocation(relativeUri) {
        response.addHeader 'content-location', ConfigurationHolder.config.grails.serverURL + relativeUri
    }

    def created = {clazz, uid ->
        addLocation "/ws/${clazz}/${uid}"
        render(status:201, text:'inserted entity')
    }

    def badRequest = {text ->
        render(status:400, text: text)
    }

    def success = { text ->
        render(status:200, text: text)
    }

    def notFound = { text ->
        render(status:404, text: text)
    }

    def notAllowed = {
        response.addHeader 'allow','POST'
        render(status:405, text: 'Only POST supported')
    }

    /**
     * Should be added for any uri that returns multiple formats based on content negotiation.
     * (So the content can be correctly cached by proxies.)
     */
    def addVaryAcceptHeader = {
        response.addHeader HttpHeaders.VARY, HttpHeaders.ACCEPT
    }

    def addLastModifiedHeader = { when ->
        response.addHeader HttpHeaders.LAST_MODIFIED, rfc1123Format.format(when)
    }

    private capitalise(word) {
        switch (word?.size()) {
            case 0: return ""
            case 1: return word[0].toUpperCase()
            default: return word[0].toUpperCase() + word [1..-1]
        }
    }

    /**
     * Update database from post/put data.
     *
     * If uid specified, it must exist -> update entity
     * Else -> insert entity
     *
     * @param entity - controller form of domain class, eg dataProvider
     * @param uid - optional uid of an instance of entity
     * @param pg - optional instance specified by uid (added in beforeInterceptor)
     * @param json - the body of the request
     */
    def saveEntity = {
        def pg = params.pg
        def obj = params.json
        def urlForm = params.entity
        def clazz = capitalise(urlForm)

        if (pg) {
            // check type
            if (pg.getClass().getSimpleName() == clazz) {
                // update
                crudService."update${clazz}"(pg, obj)
                if (pg.hasErrors()) {
                    badRequest pg.errors
                } else {
                    addContentLocation "/ws/${pg.urlForm()}/${params.uid}"
                    success "updated ${clazz}"
                }
            } else {
                badRequest "entity with uid = ${params.uid} is not ${clazz == 'Institution'? 'an' : 'a'} ${clazz}"
            }
        } else {
            // doesn't exist insert
            pg = crudService."insert${clazz}"(obj)
            if (pg.hasErrors()) {
                badRequest pg.errors
            } else {
                created pg.urlForm(), pg.uid
            }
        }
    }

    /**
     * Return JSON representation of specified entity
     * or list of entities if no uid specified.
     *
     * @param entity - controller form of domain class, eg dataProvider
     * @param uid - optional uid of an instance of entity
     * @param pg - optional instance specified by uid (added in beforeInterceptor)
     */
    def getEntity = {
        def urlForm = params.entity
        def clazz = capitalise(urlForm)
        if (params.pg) {
            addContentLocation "/ws/${urlForm}/${params.pg.uid}"
            addLastModifiedHeader params.pg.lastUpdated
            render crudService."read${clazz}"(params.pg)
        } else {
            addContentLocation "/ws/${urlForm}"
            def domain = grailsApplication.getClassForName("au.org.ala.collectory.${clazz}")
            def summaries = domain.list([sort:'name']).collect {
                [name: it.name, uri: it.buildUri(), uid: it.uid]
            }
            render summaries as JSON
        }
    }

    /**
     * Return headers as if GET had been called - but with no payload.
     *
     * @param entity - controller form of domain class, eg dataProvider
     * @param uid - optional uid of an instance of entity
     * @param pg - optional instance specified by uid (added in beforeInterceptor)
     */
    def head = {
        if (params.entity && params.pg) {
            addContentLocation "/ws/${params.pg.urlForm()}/${params.pg.uid}"
            addLastModifiedHeader params.pg.lastUpdated
            render ""
        }
    }

    /********* delete **************************
     *
     * Disabled until we can more easily restore deleted entities.
     *
     */
    def delete = {
        if (true) {
            render(status:405, text:'delete is currently unavailable')
            return
        }
        // check role
        if (authService.isAdmin()) {
            if (params.uid) {
                def pg = ProviderGroup._get(params.uid)
                if (pg) {
                    def name = pg.name
                    pg.delete()
                    def message = ['message':"deleted ${name}"]
                    render message as JSON
                } else {
                    def error = ['error': "no uid specified"]
                    render error as JSON
                }
            }
        } else {
            def error = ['error': "only ADMIN can invoke this service"]
            render error as JSON
        }
    }

    /************ EML services *************/

    def eml = {
        if (params.id) {
            def dr = DataResource.findByUid(params.id)
            if (dr) {
                response.contentType = 'text/xml'
                render emlRenderService.emlForResource(dr)
            } else {
                notFound 'no such resource ' + params.id
            }
        } else {
            badRequest 'you must specify a resource'
        }
    }

    /************* Data Hub services *********/
    def institutionsForDataHub = {
        def ozcamConsumers = []
        DataProvider._get('dp20').resources.each { dr ->
            dr.listConsumers().each { inst ->
                if (inst[0..1] == 'in') {
                    def pg = ProviderGroup._get(inst)
                    if (pg) {
                        ozcamConsumers << [name: pg.name, uri: pg.buildUri()]
                    }
                }
            }
        }
        ozcamConsumers.sort {it.name}
        render ozcamConsumers as JSON
    }

    def collectionsForDataHub = {
        def ozcamConsumers = []
        DataProvider._get('dp20').resources.each { dr ->
            dr.listConsumers().each { con ->
                if (con[0..1] == 'in') {
                    def pg = ProviderGroup._get(con)
                    if (pg) {
                        pg.collections.each { co ->
                            if (co.providerMap) {
                                ozcamConsumers << [name: co.name, uri: co.buildUri()]
                            }
                        }
                    }
                } else {
                    // must be a collection
                    def pg = ProviderGroup._get(con)
                    if (pg) {
                        ozcamConsumers << [name: pg.name, uri: pg.buildUri()]
                    }
                }
            }
        }
        ozcamConsumers.sort {it.name}
        render ozcamConsumers as JSON
    }


    /************* Contact services **********/

    static final String CONTACT_HEADER = "title, first name, last name, email, phone, fax, mobile, publish, dateCreated, lastUpdated\n"

    /**
     * Returns a single contact (independent of any entity).
     * URI form: /contacts/{id}
     * @param id the database id of the contact
     */
    def contacts = {
        if (params.id) {
            addContentLocation "/ws/contacts/${params.id}"
            addVaryAcceptHeader()
            def cm = buildContactModel(Contact.get(params.id))
            withFormat {
                csv {render (contentType: 'text/csv', text: CONTACT_HEADER + mapToCsv(cm))}
                xml {render (contentType: 'text/xml', text: objToXml(cm, 'contact'))}
                json {render cm as JSON}
            }
        } else {
            addContentLocation "/ws/contacts"
            addVaryAcceptHeader()
            withFormat {
                csv {render (contentType: 'text/csv',
                        text: CONTACT_HEADER + Contact.list().collect { mapToCsv(buildContactModel(it)) }.join(''))}
                xml {render (contentType: 'text/xml', text: objToXml(Contact.list().collect { buildContactModel(it) }, 'contacts'))}
                json {render Contact.list().collect { buildContactModel(it) } as JSON}
            }
        }
    }

    def buildContactModel(contact) {
        return new LinkedHashMap(
            [title: contact.title, firstName: contact.firstName, lastName: contact.lastName, email: contact.email, phone: contact.phone,
             fax: contact.fax, mobile: contact.mobile, publish: contact.publish, dateCreated: contact.dateCreated, lastUpdated: contact.lastUpdated])
    }

    def buildContactForModel(cf, urlContext) {
        return new LinkedHashMap(
            [contact: buildContactModel(cf.contact), role: cf.role, primaryContact: cf.primaryContact,
                    editor: cf.administrator, notify: cf.notify, dateCreated: cf.dateCreated, lastUpdated: cf.dateLastModified,
                    uri: "${ConfigurationHolder.config.grails.serverURL}/ws/${urlContext}/${cf.entityUid}/contacts/${cf.id}"])
    }

    /**
     * Returns all contacts for a single entity.
     * URI form: /{entity}/{uid}/contacts
     * @param entity an entity type in url form ie one of collection, institution, dataProvider, dataResource, dataHub
     * @param uid the entity instance
     */
    def contactsForEntity = {
        def contactList = params.pg.getContacts().collect { buildContactForModel(it, params.pg.urlForm()) }
        addContentLocation "/ws/${params.entity}/${params.pg.uid}/contacts"
        addVaryAcceptHeader()
        withFormat {
            csv {
                def out = new StringWriter()
                out << "name, role, primary contact, editor, notify, email, phone\n"
                contactList.each {
                    out << "\"${it.name}\",\"${it.role}\",${it.primaryContact},${it.editor},${it.notify},${it.email?:""},${it.phone?:""}\n"
                }
                response.addHeader "Content-Type", "text/csv"
                render out.toString()
            }
            xml {render (contentType: 'text/xml', text: objToXml(contactList, 'contactFors'))}
            json {render contactList as JSON}
        }
    }

    /**
     * Returns a single contact for a single entity.
     * URI form: /{entity}/{uid}/contacts/{id}
     * @param entity an entity type in url form ie one of collection, institution, dataProvider, dataResource, dataHub
     * @param uid the entity instance
     * @param id the database id of the contact relationship (contactFor)
     */
    def contactForEntity = {
        if (params.id) {
            def cm = buildContactForModel(ContactFor.get(params.id), params.pg.urlForm())
            addContentLocation "/ws/${params.entity}/${params.pg.uid}/contacts/${params.id}"
            addVaryAcceptHeader()
            withFormat {
                csv {
                    def out = new StringWriter()
                    out << "title, first name, last name, role, primary contact, editor, notify, email, phone, fax, mobile\n"
                    out << "\"${cm.contact.title?:""}\",\"${cm.contact.firstName?:""}\",\"${cm.contact.lastName?:""}\",\"${cm.role}\",${cm.primaryContact},${cm.editor},${cm.notify},${cm.contact.email?:""},${cm.contact.phone?:""},${cm.contact.fax?:""},${cm.contact.mobile?:""}\n"
                    render (contentType: 'text/csv', text: out.toString())
                }
                xml {render (contentType: 'text/xml', text: objToXml(cm, 'contactFor'))}
                json {render cm as JSON}
            }
        } else {
            forward(action:'contactsForEntity')
        }
    }

    static final String SHORT_CONTACTS_HEADER = "entity name, entity UID, entity acronym, contact name, contact email, contact phone\n"

    /**
     * Returns all contacts for all entities of the specified type.
     * URI form: /{entity}/contacts
     * @param entity an entity type in url form ie one of collection, institution, dataProvider, dataResource, dataHub
     */
    def contactsForEntities = {
        def domain = grailsApplication.getClassForName("au.org.ala.collectory.${capitalise(params.entity)}")
        def model = buildContactsModel(domain.list([sort:'name']))
        addContentLocation "/ws/${params.entity}/contacts"
        addVaryAcceptHeader()
        withFormat {
            csv {
                render (contentType: 'text/csv',
                        text: SHORT_CONTACTS_HEADER + listToCsv(model))
            }
            xml {render (contentType: 'text/xml', text: objToXml(model, 'contacts'))}
            json {
                render model as JSON
            }
        }
    }

    def static buildContactsModel(list) {
        return list.collect {
            def map = [:]
            map.entityName = it.name
            map.entityUid = it.uid
            map.entityAcronym = it.acronym ?: ""
            map.contactName = it.primaryContact?.contact?.buildName() ?: ""
            map.contactEmail = it.primaryContact?.contact?.email ?: ""
            map.contactPhone = it.primaryContact?.contact?.phone ?: ""
            map.uri = it.primaryContact ? "${ConfigurationHolder.config.grails.serverURL}/ws/${ProviderGroup.urlFormFromUid(it.uid)}/${it.uid}/contacts/${it.primaryContact?.id}" : ''

            return map
        }
    }

    /**
     * Returns a json list of contacts to be notified on significant entity events.
     * @param uid of the entity
     */
    def notifyList = {
        if (params.uid) {
            def contactFors = ContactFor.findAllByEntityUidAndNotify(params.uid, true).collect {
                buildContactForModel(it, ProviderGroup.urlFormFromUid(params.uid))
            }
            render contactFors as JSON
        } else {
            badRequest "must specify a uid"
        }
    }

    /**
     * Write-only service that accepts notification payloads.
     *
     * Example payload:
     * { event: 'user annotation', id: 'ann03468', uid: 'co13' }
     */
    def notify = {
        println "notify"
        if (request.method != 'POST') {
            println "not allowed"
            notAllowed()
        } else {
            println params.json
            def payload = params.json
            def uid = payload.uid
            def event = payload.event
            def id = payload.id
            def action = payload.action
            if (!(uid && event && id && action)) {
                println "bad request"
                badRequest 'must specify a uid, an event and an event id'
            } else {
                println "OK"
                // register the event
                ActivityLog.log([user: 'notify-service', isAdmin: false, action: "${action}d ${id}", entityUid: uid])
                success "notification accepted"
            }
        }
    }

    /**** html fragment services ****/
    def getFragment = {
        def pg = ProviderGroup._get(params.uid)
        if (!pg) {
            def message = "${message(code: 'default.not.found.message', args: [message(code: 'entity.label', default: 'Entity'), params.uid])}"
            render message
        } else {
            render(view: "${params.entity}Fragment", model: [instance: pg])
        }
    }

    /** temporary dump of map of coll code/inst code pairs with mapped collection and institution data **/
    def codeMapDump = {
        def csv = "collectionCode,institutionCode,collectionUid,collectionName,institutionUid,institutionName," +
                "dataProviderUid,dataProviderName,dataHubUid,dataHubName,taxonomicHints\n"
        ProviderMap.list().each {
            def collectionCodes = it.collectionCodes
            def institutionCodes = it.institutionCodes
            // write record for each combo
            collectionCodes.each { coll ->
                institutionCodes.each { inst ->
                    csv += coll.code + "," +
                            inst.code + "," +
                            it.collection.uid + "," +
                            "\"" + it.collection.name + "\"," +
                            it.collection.institution?.uid + "," +
                            "\"" + it.collection.institution?.name + "\"," +
                            "dp20,OZCAM (Online Zoological Collections of Australian Museums) Provider," +
                            "dh1,Online Zoological Collections of Australian Museums," +
                            encodeHints(it.collection.listTaxonomyHints()) + "\n"
                }
            }
        }
        render(contentType: 'text/csv', text:csv)
    }

    private String encodeHints(hints) {
        def result = hints.collect {
            it.rank + ":" + it.name
        }
        return result.join(';')
    }

    /**
     * Converts a map or list to 'tight' xml string, ie keys become element names <keyName> rather than <entry key='keyName'>..
     * @param obj the map or list to represent
     * @param root the container element
     * @return XML string
     */
    def objToXml(obj, root) {
        def writer = new StringWriter()
        MarkupBuilder xml = new MarkupBuilder(writer)
        xml."${root}" {
            toXml(obj,xml, (root[-1] == 's') ? root[0..-2] : 'item')
        }
        return writer.toString()
    }

    /* called recursively to build xml */
    def toXml(obj, xml, listElement) {
        if (obj instanceof List) {
            obj.each { item ->
                xml."${listElement}" { toXml(item, xml, listElement) }
            }
        } else {
            obj.each { key, value ->
                if (value && value instanceof Map) {
                    xml."${key}" {toXml(value, xml, listElement)}
                } else {
                    xml."${key}"(value)
                }
            }
        }
    }

    def listToCsv(list) {
        def out = new StringWriter()
        list.each {
            out << mapToCsv(it)
        }
        return out.toString()
    }

    /**
     * Converts a map to a csv row
     * @param map the map to represent
     * @return csv string
     */
    def mapToCsv(map) {
        def out = new StringWriter()
        def list = map.collect {key, value -> value}
        list.eachWithIndex {it, idx ->
            out << toCsvItem(it)
            if (idx == list.size() - 1) {
                out << '\n'
            } else {
                out << ','
            }
        }
        return out.toString()
    }

    String toCsvItem(item) {
        if (!item) return ""
        return '"' + item + '"'
    }

}

class ContactForEntity {
    String entityName
    String entityUid
    String entityAcronym
    String contactName
    String contactEmail
    String contactPhone
    String uri
}
