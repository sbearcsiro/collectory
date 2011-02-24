package au.org.ala.collectory

import grails.converters.JSON

import grails.converters.XML
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.codehaus.groovy.grails.web.servlet.HttpHeaders
import java.text.DateFormat
import java.text.SimpleDateFormat

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
        println "saving data hub"
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
    def contactsForEntity = {
        def contacts = params.pg.getContacts().collect {
            [name: it.contact.buildName(), role: it.role, primaryContact: it.primaryContact, email: it.contact.email,
                    phone: it.contact.phone, uri: "${ConfigurationHolder.config.grails.serverURL}/ws/${params.pg.urlForm()}/${params.pg.uid}/contact/${it.id}"]
        }
        addContentLocation "/ws/${params.entity}/${params.pg.uid}/contact"
        addVaryAcceptHeader()
        withFormat {
            csv {
                def out = new StringWriter()
                out << "name, role, primary contact, email, phone\n"
                contacts.each {
                    out << "\"${it.name}\",\"${it.role}\",${it.primaryContact},${it.email?:""},${it.phone?:""}\n"
                }
                response.addHeader "contentType", "text/csv"
                render out.toString()
            }
            xml {render contacts as XML}
            json {render contacts as JSON}
        }
    }

    def contactForEntity = {
        if (params.id) {
            def cf = ContactFor.get(params.id)
            def contact = [title: cf.contact.title, firstName: cf.contact.firstName, lastName: cf.contact.lastName, role: cf.role, primaryContact: cf.primaryContact, email: cf.contact.email, phone: cf.contact.phone, fax: cf.contact.fax, mobile: cf.contact.mobile]
            addContentLocation "/ws/${params.entity}/${params.pg.uid}/contact/${params.id}"
            addVaryAcceptHeader()
            withFormat {
                csv {
                    def out = new StringWriter()
                    out << "title, first name, last name, role, primary contact, email, phone, fax, mobile\n"
                    out << "\"${contact.title?:""}\",\"${contact.firstName?:""}\",\"${contact.lastName?:""}\",\"${contact.role}\",${contact.primaryContact},${contact.email?:""},${contact.phone?:""},${contact.fax?:""},${contact.mobile?:""}\n"
                    response.addHeader "contentType", "text/csv"
                    render out.toString()
                }
                xml {render contact as XML}
                json {render contact as JSON}
            }
        } else {
            forward(action:'contactsForEntity')
        }
    }

    def contactsForEntities = {
        def domain = grailsApplication.getClassForName("au.org.ala.collectory.${capitalise(params.entity)}")
        def model = buildContactsModel(request.format, domain.list([sort:'name']))
        addVaryAcceptHeader()
        withFormat {
            csv {
                response.addHeader "contentType", "text/csv"
                render buildCsv(model)}
            xml {render model as XML}
            json {render model as JSON}
        }
    }

    def static buildContactsModel(format, list) {
        if (format == 'xml') {
            return list.collect {
                def obj = new ContactForEntity()
                obj.entityName = it.name
                obj.entityUid = it.uid
                obj.entityAcronym = it.acronym ?: ""
                obj.contactName = it.primaryContact?.contact?.buildName() ?: ""
                obj.contactEmail = it.primaryContact?.contact?.email ?: ""
                obj.contactPhone = it.primaryContact?.contact?.phone ?: ""
                return obj
            }
        } else {
            return list.collect {
                def map = [:]
                map.entityName = it.name
                map.entityUid = it.uid
                map.entityAcronym = it.acronym ?: ""
                map.contactName = it.primaryContact?.contact?.buildName() ?: ""
                map.contactEmail = it.primaryContact?.contact?.email ?: ""
                map.contactPhone = it.primaryContact?.contact?.phone ?: ""
                return map
            }
        }
    }

    private def buildCsv(model) {
        def out = new StringWriter()
        out << "entity name, entity UID, entity acronym, contact name, contact email, contact phone\n"
        model.each {
            out << "\"${it.entityName}\",${it.entityUid},${it.entityAcronym ?:""},${it.contactName?:""},${it.contactEmail?:""},${it.contactPhone?:""}\n"
        }
        return out.toString()
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
        def csv = "collectionCode,institutionCode,collectionUid,collectionName,institutionUid,institutionName,taxonomicHints\n"
        ProviderMap.list().each {
            def collectionCodes = it.collectionCodes
            def institutionCodes = it.institutionCodes
            // write record for each combo
            collectionCodes.each { coll ->
                institutionCodes.each { inst ->
                    csv += coll.code + "," +
                            inst.code + "," +
                            it.collection.uid + "," +
                            it.collection.name + "," +
                            it.collection.institution?.uid + "," +
                            it.collection.institution?.name + "," +
                            encodeHints(it.collection.listTaxonomyHints()) + "\n"
                }
            }
        }
        render csv
    }

    private String encodeHints(hints) {
        def result = hints.collect {
            it.rank + ":" + it.name
        }
        return result.join(';')
    }
}

class ContactForEntity {
    String entityName
    String entityUid
    String entityAcronym
    String contactName
    String contactEmail
    String contactPhone
}
