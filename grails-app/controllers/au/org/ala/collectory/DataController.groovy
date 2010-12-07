package au.org.ala.collectory

import grails.converters.JSON
import au.org.ala.collectory.exception.InvalidUidException
import org.codehaus.groovy.grails.web.json.JSONObject
import grails.converters.XML

class DataController {

    def crudService, authService, emlRenderService
    
    def index = { }

    /***** CRUD RESTful services ********/

    /**
     * Return JSON representation of specified entity
     * or list of entities if no uid specified.
     */
    def getCollection = {
        if (params.uid) {
            def pg = Collection._get(params.uid)
            if (pg) {
                render pg as JSON
            } else {
                def error = ['error': "cannot find collection with uid = ${params.uid}"]
                render error as JSON
            }
        } else {
            def summaries = Collection.list().collect {

                it.buildSummary()
            }
            render summaries as JSON
        }
    }

    /**
     * Update database from post data.
     *
     * If uid specified and exists -> update entity
     * Else -> insert entity (checking uid if it is specified)
     */
    def saveCollection = {
        def obj = request.JSON
        def uid = obj.uid
        def pg = (uid) ? ProviderGroup._get(uid) : null
        try {
            if (pg) {
                // exists - check type
                if (pg instanceof Collection) {
                    // update
                    crudService.updateCollection(pg, obj)
                    def message
                    if (pg.hasErrors()) {
                        message = pg.errors
                    } else {
                        message = ['message':'updated collection', 'dp': pg]
                    }
                    render message as JSON
                } else {
                    def error = ['error': "entity with uid = ${uid} is not a collection"]
                    render error as JSON
                }
            } else {
                // doesn't exist insert
                try {
                    pg = crudService.insertCollection(obj)
                    def message
                    if (pg.hasErrors()) {
                        message = pg.errors
                    } else {
                        message = ['message':'inserted collection', 'dp': pg]
                    }
                    render message as JSON
                } catch (InvalidUidException e) {
                    def error = ['error': "${e.getMessage()} (${uid}) - uids must be obtained from the collectory"]
                    render error as JSON
                }
            }
        } catch (Exception e) {
            def error = ['error': e.getMessage()]
            render error as JSON
        }
    }

    /**
     * Return JSON representation of specified entity
     * or list of entities if no uid specified.
     */
    def getInstitution = {
        if (params.uid) {
            def pg = Institution._get(params.uid)
            if (pg) {
                render pg as JSON
            } else {
                def error = ['error': "cannot find institution with uid = ${params.uid}"]
                render error as JSON
            }
        } else {
            def summaries = Institution.list().collect {
                it.buildSummary()
            }
            render summaries as JSON
        }
    }

    /**
     * Update database from post data.
     *
     * If uid specified and exists -> update entity
     * Else -> insert entity (checking uid if it is specified)
     */
    def saveInstitution = {
        def obj = request.JSON
        def uid = obj.uid
        def pg = (uid) ? ProviderGroup._get(uid) : null
        if (pg) {
            // exists - check type
            if (pg instanceof Institution) {
                // update
                crudService.updateInstitution(pg, obj)
                def message
                if (pg.hasErrors()) {
                    message = pg.errors
                } else {
                    message = ['message':'updated institution', 'dp': pg]
                }
                render message as JSON
            } else {
                def error = ['error': "entity with uid = ${uid} is not an institution"]
                render error as JSON
            }
        } else {
            // doesn't exist insert
            try {
                pg = crudService.insertInstitution(obj)
                def message
                if (pg.hasErrors()) {
                    message = pg.errors
                } else {
                    message = ['message':'inserted institution', 'dp': pg]
                }
                render message as JSON
            } catch (InvalidUidException e) {
                def error = ['error': "${e.getMessage()} (${uid}) - uids must be obtained from the collectory"]
                render error as JSON
            }
        }
    }

    /**
     * Return JSON representation of specified entity
     * or list of entities if no uid specified.
     */
    def getDataProvider = {
        if (params.uid) {
            def dp = DataProvider._get(params.uid)
            if (dp) {
                render dp as JSON
            } else {
                def error = ['error': "cannot find data provider with uid = ${params.uid}"]
                render error as JSON
            }
        } else {
            def summaries = DataProvider.list().collect {
                it.buildSummary()
            }
            render summaries as JSON
        }
    }

    /**
     * Update database from post data.
     *
     * If uid specified and exists -> update entity
     * Else -> insert entity (checking uid if it is specified)
     */
    def saveDataProvider = {
        def obj = request.JSON
        def uid = obj.uid
        def dp = (uid) ? ProviderGroup._get(uid) : null
        if (dp) {
            // exists - check type
            if (dp instanceof DataProvider) {
                // update
                crudService.updateDataProvider(dp, obj)
                def message
                if (dp.hasErrors()) {
                    message = dp.errors
                } else {
                    message = ['message':'updated data provider', 'dp': dp]
                }
                render message as JSON
            } else {
                def error = ['error': "entity with uid = ${uid} is not a data provider"]
                render error as JSON
            }
        } else {
            // doesn't exist insert
            try {
                dp = crudService.insertDataProvider(obj)
                def message
                if (dp.hasErrors()) {
                    message = dp.errors
                } else {
                    message = ['message':'inserted data provider', 'dp': dp]
                }
                render message as JSON
            } catch (InvalidUidException e) {
                def error = ['error': "${e.getMessage()} (${uid}) - uids must be obtained from the collectory"]
                render error as JSON
            }
        }
    }

    /**
     * Return JSON representation of specified entity
     * or list of entities if no uid specified.
     */
    def getDataHub = {
        if (params.uid) {
            def pg = DataHub._get(params.uid)
            if (pg) {
                render pg as JSON
            } else {
                def error = ['error': "cannot find data hub with uid = ${params.uid}"]
                render error as JSON
            }
        } else {
            def summaries = DataHub.list().collect {
                it.buildSummary()
            }
            render summaries as JSON
        }
    }

    /**
     * Update database from post data.
     *
     * If uid specified and exists -> update entity
     * Else -> insert entity (checking uid if it is specified)
     */
    def saveDataHub = {
        def obj = JSON.parse(request.reader.text)
        def uid = obj.uid
        def pg = (uid) ? ProviderGroup._get(uid) : null
        if (pg) {
            // exists - check type
            if (pg instanceof DataHub) {
                // update
                crudService.updateDataHub(pg, obj)
                def message
                if (pg.hasErrors()) {
                    message = pg.errors
                } else {
                    message = ['message':'updated data hub', 'dp': pg]
                }
                render message as JSON
            } else {
                def error = ['error': "entity with uid = ${uid} is not a data hub"]
                render error as JSON
            }
        } else {
            // doesn't exist insert
            try {
                pg = crudService.insertDataHub(obj)
                def message
                if (pg.hasErrors()) {
                    message = pg.errors
                } else {
                    message = ['message':'inserted data hub', 'dp': pg]
                }
                render message as JSON
            } catch (InvalidUidException e) {
                def error = ['error': "${e.getMessage()} (${uid}) - uids must be obtained from the collectory"]
                render error as JSON
            }
        }
    }

    /**
     * Return JSON representation of specified entity
     * or list of entities if no uid specified.
     */
    def getDataResource = {
        if (params.uid) {
            def dr = DataResource._get(params.uid)
            if (dr) {
                render dr as JSON
            } else {
                def error = ['error': "cannot find data resource with uid = ${params.uid}"]
                render error as JSON
            }
        } else {
            def summaries = DataResource.list().collect {
                it.buildSummary()
            }
            render summaries as JSON
        }
    }

    /**
     * Update database from post data.
     *
     * If uid specified and exists -> update entity
     * Else -> insert entity (checking uid if it is specified)
     */
    def saveDataResource = {
        def obj = request.JSON
        def uid = obj.uid
        def pg = (uid) ? ProviderGroup._get(uid) : null
        if (pg) {
            // exists - check type
            if (pg instanceof DataResource) {
                // update
                crudService.updateDataResource(pg, obj)
                def message
                if (pg.hasErrors()) {
                    message = pg.errors
                } else {
                    message = ['message':'updated data resource', 'dp': pg]
                }
                render message as JSON
            } else {
                def error = ['error': "entity with uid = ${uid} is not a data resource"]
                render error as JSON
            }
        } else {
            // doesn't exist insert
            try {
                pg = crudService.insertDataResource(obj)
                def message
                if (pg.hasErrors()) {
                    message = pg.errors
                } else {
                    message = ['message':'inserted data resource', 'dp': pg]
                }
                render message as JSON
            } catch (InvalidUidException e) {
                def error = ['error': "${e.getMessage()} (${uid}) - uids must be obtained from the collectory"]
                render error as JSON
            }
        }
    }

    def delete = {
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
                def error = 'no such resource ' + params.id
                response.status = 400
                render error
            }
        } else {
            def error = 'you must specify a resource'
            response.status = 400
            render error
        }
    }
}
