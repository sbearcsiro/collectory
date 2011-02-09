package au.org.ala.collectory

import grails.converters.JSON
import au.org.ala.collectory.exception.InvalidUidException
import grails.converters.XML
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import org.codehaus.groovy.grails.web.json.JSONException

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

    /***** CRUD RESTful services ********/

    def addLocation(uid) {
        response.addHeader 'location', ConfigurationHolder.config.grails.serverURL + "/data/co/${uid}"
    }

    def created = {uid ->
        addLocation uid
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
     * Update database from post/put data.
     *
     * If uid specified, it must exist -> update entity
     * Else -> insert entity
     */
    def saveEntity(clazz) {
        def pg = params.pg
        def obj = params.json

        if (pg) {
            // check type
            if (pg.getClass().getSimpleName() == clazz) {
                // update
                crudService."update${clazz}"(pg, obj)
                if (pg.hasErrors()) {
                    badRequest pg.errors
                } else {
                    addLocation params.uid
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
                created pg.uid
            }
        }
    }

    /**
     * Return JSON representation of specified entity
     * or list of entities if no uid specified.
     */
    def getEntity(clazz) {
        if (params.pg) {
            render params.pg as JSON
        } else {
            def summaries = "${clazz}".list().collect {
                it.buildSummary()
            }
            render summaries as JSON
        }
    }

    def getCollection = {
        getEntity('Collection')
    }
    def saveCollection = {
        saveEntity('Collection')
    }
    def getInstitution = {
        getEntity('Institution')
    }
    def saveInstitution = {
        saveEntity('Institution')
    }
    def getDataProvider = {
        getEntity('DataProvider')
    }
    def saveDataProvider = {
        saveEntity('DataProvider')
    }
    def getDataHub = {
        getEntity('DataHub')
    }
    def saveDataHub = {
        saveEntity('DataHub')
    }
    def getDataResource = {
        getEntity('DataResource')
    }
    def saveDataResource = {
        saveEntity('DataResource')
    }


    /********* delete **************************/
    /*
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

    /************* Contact services **********/
    def contactsForCollections = {
        def model = buildContactsModel(request.format, Collection.list([sort:'name']))
        withFormat {
            csv {
                response.addHeader "contentType", "text/csv"
                render buildCsv(model)}
            xml {render model as XML}
            json {render model as JSON}
        }
    }

    def contactsForInstitutions = {
        def model = buildContactsModel(request.format, Institution.list([sort:'name']))
        withFormat {
            csv {
                response.addHeader "contentType", "text/csv"
                render buildCsv(model)}
            xml {render model as XML}
            json {render model as JSON}
        }
    }

    def contactsForDataProviders = {
        def model = buildContactsModel(request.format, DataProvider.list([sort:'name']))
        withFormat {
            csv {
                response.addHeader "contentType", "text/csv"
                render buildCsv(model)}
            xml {render model as XML}
            json {render model as JSON}
        }
    }

    def contactsForDataResources = {
        def model = buildContactsModel(request.format, DataResource.list([sort:'name']))
        withFormat {
            csv {
                response.addHeader "contentType", "text/csv"
                render buildCsv(model)}
            xml {render model as XML}
            json {render model as JSON}
        }
    }

    def contactsForDataHubs = {
        def model = buildContactsModel(request.format, DataHub.list([sort:'name']))
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
                def obj = new ContactForCollection()
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
}

class ContactForCollection {
    String entityName
    String entityUid
    String entityAcronym
    String contactName
    String contactEmail
    String contactPhone
}
