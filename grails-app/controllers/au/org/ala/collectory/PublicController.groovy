package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import grails.util.GrailsUtil
import org.codehaus.groovy.grails.commons.GrailsApplication

/**
 * Handles all the public pages generated from the collectory.
 *
 * This includes:
 * Natural History Collections page - with map of collection locations (map)
 * Display pages for collection, institution, data provider and data resource (show)
 *
 * Handles ajax requests for data for those pages.
 */
class PublicController {

    def authService

    def delay = 3000    // testing delay for responses
    def sleep = {
        if (GrailsUtil.getEnvironment() == GrailsApplication.ENV_DEVELOPMENT) {  // in case we forget to remove
            this.sleep(delay)
        }
    }

    def index = { redirect(action: 'map')}

    /**
     * Shows the public page for any entity when passed a UID.
     *
     * If the id is not a UID it will be assumed to be a collection and will be treated as:
     * 1. lsid if it starts with uri:lsid:
     * 2. database id if it is a number
     * 3. acronym if it matches a collection
     */
    def show = {
        // is it a UID
        if (params.id instanceof String && params.id.startsWith(Institution.ENTITY_PREFIX)) {
            forward(action: 'showInstitution', params: params)
        } else if (params.id instanceof String && params.id.startsWith('dp')) {
            forward(action: 'showDataProvider', params: params)
        } else if (params.id instanceof String && params.id.startsWith('dr')) {
            forward(action: 'showDataResource', params: params)
        } else {
            // assume it's a collection
            def collectionInstance = findCollection(params.id)
            if (!collectionInstance) {
                flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params?.id])}"
                redirect(controller: "public", action: "map")
            } else {
                ActivityLog.log authService.username(), authService.isAdmin(), collectionInstance.uid, Action.VIEW
                [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts(),
                        biocacheRecordsAvailable: collectionInstance.providerMap]
            }
        }
    }

    /**
     * json call to retrieve a summary of biocache records
     *
     * @return total number + decade breakdown as Google data table
     */
    def biocacheRecords = {
        // lookup number of biocache records
        def baseUrl = ConfigurationHolder.config.biocache.baseURL
        def url = baseUrl + "occurrences/searchForUID.JSON?pageSize=0&q=" + params.uid

        def count = 0
        def conn = new URL(url).openConnection()
        conn.setConnectTimeout 2000
        try {
            def json = conn.content.text
            def searchResult = JSON.parse(json)?.searchResult
            def result = [totalRecords: searchResult?.totalRecords, decades: buildDecadeDataTableFromFacetResults(searchResult?.facetResults)]
   // sleep delay
            render result as JSON
        } catch (SocketTimeoutException e) {
            log.warn "Timed out looking up record count. URL= ${url}."
            def result = [error:"Timed out looking up record count.", totalRecords: 0, decades: null]
            render result as JSON
        } catch (Exception e) {
            log.warn "Failed to lookup record count. ${e.getClass()} ${e.getMessage()} URL= ${url}."
            def error = ["error":"Failed to lookup record count. ${e.getClass()} ${e.getMessage()} URL= ${url}."]
            render error as JSON
        }
    }

    /**
     * Returns JSON in Google charts DataTable format showing breakdown of records by decade.
     *
     * Makes request to biocache service for breakdown data.
     */
    def decadeBreakdown = {
        response.setHeader("Pragma","no-cache")
        response.setDateHeader("Expires",1L)
        response.setHeader("Cache-Control","no-cache")
        response.addHeader("Cache-Control","no-store")
        def instance = ProviderGroup._get(params.id)
        //println ">>debug map key " + grailsApplication.config.google.maps.v2.key
        if (!instance) {
            log.error "Unable to find entity for id = ${params.id}"
            def error = ["error":"unable to find entity for id = " + params.id]
            render error as JSON
        } else {
            /* get decade breakdown */
            def decadeUrl = ConfigurationHolder.config.biocache.baseURL + "breakdown/collection/decades/${instance.generatePermalink()}.json";
            //println decadeUrl
            def conn = new URL(decadeUrl).openConnection()
            conn.setConnectTimeout 1500
            def dataTable = null
            def json
            try {
                json = conn.content.text
                //println "Response = " + json
                def decades = JSON.parse(json)?.decades
                dataTable = buildDecadeDataTable(decades)
                //println "dataTable = " + dataTable
            } catch (SocketTimeoutException e) {
                log.warn "Timed out getting decade breakdown. URL= ${url}."
                def result = [error:"Timed out getting decade breakdown.", dataTable: null]
                render result as JSON
            } catch (Exception e) {
                log.error "Failed to lookup decade breakdown. ${e.getMessage()} URL= ${decadeUrl}."
            }
            if (dataTable) {
                render dataTable
            } else {
                log.warn "unable to build data table from decade json = " + json
                def error = ["error":"Unable to build data table from decade json"]
                render error as JSON
            }
        }
    }

    /**
     * Returns JSON in Google charts DataTable format showing breakdown of records by taxonomic group.
     *
     * Makes request to biocache service for breakdown data.
     * Chooses the taxon rank based on the spread of records and the threshold value supplied in the request.
     */
    def taxonBreakdown = {
        response.setHeader("Pragma","no-cache")
        response.setDateHeader("Expires",1L)
        response.setHeader("Cache-Control","no-cache")
        response.addHeader("Cache-Control","no-store")
        def threshold = params.threshold ?: 20
        def instance = ProviderGroup._get(params.id)
        if (!instance) {
            log.error "Unable to find entity for id = ${params.id}"
            def error = ["error":"unable to find entity for id = " + params.id]
            render error as JSON
        } else {
            /* get taxon breakdown */
            def taxonUrl = ConfigurationHolder.config.biocache.baseURL + "breakdown/uid/taxa/${threshold}/${instance.uid}.json";
            def conn = new URL(taxonUrl).openConnection()
            conn.setConnectTimeout 1500
            def dataTable = null
            def json
            try {
                json = conn.content.text
                //println "Response = " + json
                def breakdown = JSON.parse(json)?.breakdown
                if (breakdown && breakdown.toString() != "null") {
                    dataTable = buildPieChartDataTable(breakdown,"all","")
                    if (dataTable) {
                        render dataTable
                    } else {
                        log.warn "unable to build data table from taxa json = " + json
                        def error = ["error":"Unable to build data table from taxa json"]
                        render error as JSON
                    }
                } else {
                    log.warn "no data returned from taxa json = " + json
                    def error = ["error":"No data returned from taxa json"]
                    render error as JSON
                }
            } catch (SocketTimeoutException e) {
                log.warn "Timed out getting taxa breakdown."
                def result = [error:"Timed out getting taxa breakdown.", dataTable: null]
                render result as JSON
            } catch (Exception e) {
                log.error "Failed to lookup taxa breakdown. ${e.getMessage()} URL= ${taxonUrl}."
            }
        }
    }

    /**
     * Returns JSON in Google charts DataTable format showing breakdown of records for the specified taxonomic group.
     *
     * Makes request to biocache service for namerank breakdown data.
     *
     */
    def rankBreakdown = {
        response.setHeader("Pragma","no-cache")
        response.setDateHeader("Expires",1L)
        response.setHeader("Cache-Control","no-cache")
        response.addHeader("Cache-Control","no-store")
        def instance = ProviderGroup._get(params.id)
        if (!instance) {
            log.error "Unable to find entity for id = ${params.id}"
            def error = ["error":"unable to find entity for id = " + params.id]
            render error as JSON
        } else {
            /* get rank breakdown */
            def rankUrl = ConfigurationHolder.config.biocache.baseURL + "breakdown/uid/namerank/${instance.uid}.json?name=${params.name}&rank=${params.rank}"
            def conn = new URL(rankUrl).openConnection()
            conn.setConnectTimeout 1500
            def dataTable = null
            def json
            try {
                json = conn.content.text
                //println "Response = " + json
                def breakdown = JSON.parse(json)?.breakdown
                if (breakdown && breakdown.toString() != "null") {
                    dataTable = buildPieChartDataTable(breakdown,params.rank,params.name)
                    if (dataTable) {
                        //sleep delay
                        render dataTable
                    } else {
                        log.warn "unable to build data table from taxa json = " + json
                        def error = ["error":"Unable to build data table from taxa json"]
                        render error as JSON
                    }
                }
            } catch (SocketTimeoutException e) {
                log.warn "Timed out getting rank breakdown."
                def result = [error:"Timed out getting rank breakdown.", dataTable: null]
                render result as JSON
            } catch (Exception e) {
                log.error "Failed to lookup taxa breakdown. ${e.getMessage()} URL= ${rankUrl}."
            }
        }
    }

    def recordsMapService = {
        // lookup urls for displaying records map and legend
        def baseUrl = ConfigurationHolder.config.spatial.baseURL
        def uidType = 'collectionUid'
        if (params.uid?.size() > 2) {
            switch (params.uid[0..1]) {
                case DataResource.ENTITY_PREFIX: uidType = 'dataResourceUid'; break
                case DataProvider.ENTITY_PREFIX: uidType = 'dataProviderUid'; break
                case Institution.ENTITY_PREFIX: uidType = 'institutionUid'; break
             }
        }
        def url = baseUrl + "alaspatial/ws/density/map?${uidType}=" + params.uid
        def conn = new URL(url).openConnection()
        conn.setConnectTimeout 2000
        conn.addRequestProperty("accept","application/json")
        def json
        try {
            json = conn.content.text
            def mapResponse = JSON.parse(json)
            def mapType = mapResponse.type
            def legendUrl = mapResponse.legendUrl
            def mapUrl = mapResponse.mapUrl
            if (mapType == 'basemap' || mapType == '' || mapUrl.endsWith('mapaus1_white.png')) {
                // means no data available
                legendUrl = resource(dir:'images/map',file:'mapping-data-not-available.png')
            }
            if (mapType == 'points') {
                legendUrl = resource(dir:'images/map',file:'single-occurrences.png')
            }
            def result = [mapUrl: mapUrl, legendUrl: legendUrl, type: mapType]
      //sleep delay
            render result as JSON
        } catch (SocketTimeoutException e) {
            log.warn "Timed out getting records map urls. ${e.getMessage()}"
            def result = [error:"Timed out getting records map urls.", dataTable: null]
            render result as JSON
        } catch (Exception e) {
            log.warn "failed to get records map urls - json = ${json} ${e.getMessage()}"
            def error = ["error":"failed to get records map urls"]
            render error as JSON
        }
    }

    /**
     * Shows the public page for an institution.
     */
    def showInstitution = {
        def institution = findInstitution(params.id)
        if (!institution) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'institution.label', default: 'Institution'), params.code ? params.code : params.id])}"
            redirect(controller: "public", action: "map")
        } else {
            ActivityLog.log authService.username(), authService.isAdmin(), institution.uid, Action.VIEW
            [institution: institution]
        }
    }

    /**
     * Shows the public page for a data provider.
     */
    def showDataProvider = {
        def instance = ProviderGroup._get(params.id)
        if (!instance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataProvider.label', default: 'Data provider'), params.code ? params.code : params.id])}"
            redirect(controller: "public", action: "map")
        } else {
            ActivityLog.log authService.username(), authService.isAdmin(), instance.uid, Action.VIEW
            [instance: instance]
        }
    }

    /**
     * Shows the public page for a data resource.
     */
    def showDataResource = {
        def instance = ProviderGroup._get(params.id)
        if (!instance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataResource.label', default: 'Data resource'), params.code ? params.code : params.id])}"
            redirect(controller: "public", action: "map")
        } else {
            // lookup number of biocache records
            /*def baseUrl = ConfigurationHolder.config.biocache.baseURL
            def url = baseUrl + "occurrences/searchForUID.JSON?pageSize=0&q=" + instance.generatePermalink()

            def count = 0
            def conn = new URL(url).openConnection()
            conn.setConnectTimeout 1500
            try {
                def json = conn.content.text
                count = JSON.parse(json)?.searchResult?.totalRecords
            } catch (Exception e) {
                log.error "Failed to lookup record count. ${e.getClass()} ${e.getMessage()} URL= ${url}."
            }*/

            ActivityLog.log authService.username(), authService.isAdmin(), instance.uid, Action.VIEW
            [instance: instance]
        }
    }

    /**
     * Displays main page for Natural History Collections.
     *
     * Although an initial list of collections is placed in the model, the data is sourced by ajax callback. The initial
     * list is used if the callback fails.
     */
    def map = {
        ActivityLog.log authService.username(), authService.isAdmin(), Action.LIST, 'map'
        def partnerCollections = Collection.list([sort:"name"]).findAll {
            it.isALAPartner()
        }
        [collections: partnerCollections]
    }

    def map3 = {
        ActivityLog.log authService.username(), authService.isAdmin(), Action.LIST, 'map'
        def partnerCollections = Collection.list([sort:"name"]).findAll {
            it.isALAPartner()
        }
        [collections: partnerCollections]
    }

    /**
     * Returns GEOJson for populating the map based on the selected filters.
     */
    def mapFeatures = {
        //log.info ">>Map features action called"
        def locations = [:]
        def showAll = params.filters == 'all'
        locations.type = "FeatureCollection"
        locations.features = new ArrayList()
        List<CollectionLocation> collections = new ArrayList<CollectionLocation>()
        Collection.list([sort:"name"]).each {
            // only show ALA partners
            if (it.isALAPartner()) {
                // make 0 values be -1
                def lat = (it.latitude == 0.0) ? -1 : it.latitude
                def lon = (it.longitude == 0.0) ? -1 : it.longitude
                // use parent institution if lat/long not defined
                def inst = it.getInstitution()
                if (inst && lat == -1) {lat = inst.latitude}
                if (inst && lon == -1) {lon = inst.longitude}
                // only show if we have lat and long
                //if (lat != -1 && lon != -1) {
                    // and if matches current filter
                    if (showAll || Classification.matchKeywords(it.keywords, params.filters)) {
                        def loc = [:]
                        loc.type = "Feature"
                        loc.properties = [
                                name: it.name,
                                acronym: it.acronym,
                                uid: it.uid,
                                isMappable: it.canBeMapped(),
                                address: it.address?.buildAddress(),
                                desc: it.makeAbstract(),
                                url: request.getContextPath() + "/public/show/" + it.uid]
                        loc.geometry = [type: "Point", coordinates: [lon,lat]]
                        locations.features << loc
                    }
                //}
            }
        }

        //def json = JSON.parse(features)
        render(locations as JSON)
    }

    private boolean matchNetwork(pg, filterString) {
        def filters = filterString.tokenize(",")
        for (int i = 0; i < filters.size(); i++) {
            //println "Checking filter ${filters[i]} against network membership ${pg?.networkMembership}"
            if (pg?.isMemberOf(filters[i])) {
                return true;
            }
        }
        return false
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

    private findInstitution(id) {
        // try lsid
        if (id instanceof String && id.startsWith(ProviderGroup.LSID_PREFIX)) {
            return Institution.findByGuid(id)
        }
        // try uid
        if (id instanceof String && id.startsWith(Institution.ENTITY_PREFIX)) {
            return Institution.findByUid(id)
        }
        // try id
        try {
            NumberFormat.getIntegerInstance().parse(id)
            def result = Institution.read(id)
            if (result) {return result}
        } catch (ParseException e) {}
        // try acronym
        return Institution.findByAcronym(id)
    }

    private String buildBiocacheQueryString(instCodes, collCodes) {
        // must have at least one value to build a query
        if (instCodes || collCodes) {
            def instClause = instCodes ? buildSearchClause("inst", instCodes) : ""
            //println instClause
            def collClause = collCodes ? buildSearchClause("coll", collCodes) : ""
            //println collClause
            def baseUrl = ConfigurationHolder.config.biocache.baseURL
            def url = baseUrl + "searchForUID.JSON?pageSize=0" + instClause + collClause
        } else {
            return ""
        }
    }

    private String buildSearchClause(String field, List valueList) {
        def result = ""
        valueList.eachWithIndex {it, i ->
            result += "&${field}=${it}"
        }
        return result
    }


    /**
     * // input of form: [count:1, fieldValue:null1870, prefix:null, label:1870],
     *                   [count:16, fieldValue:null1880, prefix:null, label:1880],
     *                   [count:44, fieldValue:null1890, prefix:null, label:1890]
       // output of form: {"cols":[
            {"id":"","label":"","pattern":"","type":"string"},
            {"id":"","label":"","pattern":"","type":"number"}],
         "rows":[
            {"c":[{"v":"1870","f":null},{"v":1,"f":null}]},
            {"c":[{"v":"1880","f":null},{"v":16,"f":null}]},
            {"c":[{"v":"1890","f":null},{"v":44,"f":null}]}
            ],
        "p":null}
     *
     * @param input
     * @return
     */
    private String buildDecadeDataTable(input) {
        int maximum = 0
        boolean stagger = input.size() > 6
        String result = """{"cols":[{"id":"","label":"","pattern":"","type":"string"},{"id":"","label":"","pattern":"","type":"number"}],"rows":["""
        input.eachWithIndex {it, index ->
            maximum = Math.max(maximum, it.count) as Integer
            String label = (stagger && (index % 2) == 0) ? "" : it.label + "s"
            result += '{"c":[{"v":"' + label + '","f":null},{"v":' + it.count + ',"f":null}]}'
            result += (index == input.size() - 1) ? "" : ","
        }
        result += '],"p":{"max":' + maximum + '}}'
        return result
    }

    /**
     * // input of form:
     * searchResult.facetResults.fieldResult[fieldName:'occurrence_date']
     *  [
     * {fieldValue: 1850-01-01T12:00:00Z,count: 0,label: 1850-01-01T12:00:00Z,prefix: null},
     * {fieldValue: 1860-01-01T12:00:00Z,count: 0,label: 1860-01-01T12:00:00Z,prefix: null},
     * {fieldValue: 1870-01-01T12:00:00Z,count: 2,label: 1870-01-01T12:00:00Z,prefix: null}
     *  ]
     *
     * // output of form: {"cols":[
     *      {"id":"","label":"","pattern":"","type":"string"},
     *      {"id":"","label":"","pattern":"","type":"number"}],
     *   "rows":[
     *      {"c":[{"v":"1870","f":null},{"v":1,"f":null}]},
     *      {"c":[{"v":"1880","f":null},{"v":16,"f":null}]},
     *      {"c":[{"v":"1890","f":null},{"v":44,"f":null}]}
     *      ],
     *  "p":null}
     *
     * @param input
     * @return
     */
    private String buildDecadeDataTableFromFacetResults(facetResults) {
        def decades = facetResults.find {it.fieldName == "occurrence_date"}
        def input = decades?.fieldResult
        if (!input) {return ""}
        int maximum = 0
        boolean stagger = input.size() > 6
        boolean started = false
        String result = """{"cols":[{"id":"","label":"","pattern":"","type":"string"},{"id":"","label":"","pattern":"","type":"number"}],"rows":["""
        input.eachWithIndex {it, index ->
            // don't show the 'before' set
            // don't show decades with no records at the start
            if (it.label != "before" && !(it.count == 0 && !started)) {
                maximum = Math.max(maximum, it.count) as Integer
                String label = (stagger && (index % 2) == 0) ? "" : it.label[0..3] + "s"
                result += '{"c":[{"v":"' + label + '","f":null},{"v":' + it.count + ',"f":null}]}'
                result += (index == input.size() - 1) ? "" : ","
                started = true
            }
        }
        result += '],"p":{"max":' + maximum + '}}'
        return result
    }

    def stripGenusName(name) {
        def list = name.tokenize(" ")
        if (list.size() > 1) {
            list = list - list[0]
        }
        return list.join(" ")
    }

    /**
     * // input of form: [count:1, fieldValue:null1870, prefix:null, label:1870],
     *                   [count:16, fieldValue:null1880, prefix:null, label:1880],
     *                   [count:44, fieldValue:null1890, prefix:null, label:1890]
     *
     * // output: Two columns. The first column should be a string, and contain the slice label.
     *                         The second column should be a number, and contain the slice value.
     *
     * e.g. {"cols":[
     * {"id":"","label":"Class","pattern":"","type":"string"},{"id":"","label":"No. specimens","pattern":"","type":"number"}],
     * "rows":[
     *  {"c":[{"v":"Insecta","f":null},{"v":2129,"f":null}]},
     *  {"c":[{"v":"Trebouxiophyceae","f":null},{"v":3407,"f":null}]},
     *  {"c":[{"v":"Magnoliopsida","f":null},{"v":859,"f":null}]},
     *  {"c":[{"v":"Diplopoda","f":null},{"v":134,"f":null}]},
     *  {"c":[{"v":"Actinopterygii","f":null},{"v":88,"f":null}]},
     *  {"c":[{"v":"Arachnida","f":null},{"v":54,"f":null}]},
     *  {"c":[{"v":"Malacostraca","f":null},{"v":5,"f":null}]}]
     * "p":null}
     *
     * @param input
     * @param scope the rank of the group being displayed if this is a drill-down
     * @param name of the group being displayed if this is a drill-down
     * @return
     */
    private String buildPieChartDataTable(input,scope,name) {
        boolean stripGenus = input.rank == "species" && scope != "all"
        String result = """{"cols":[{"id":"","label":"${input.rank}","pattern":"","type":"string"},{"id":"","label":"No. specimens","pattern":"","type":"number"}],"rows":["""
        def list = input.taxa.collect {
            def label = it.label
            if (stripGenus) {
                label = stripGenusName(label)
            }
            [label: label, count: it.count]
        }
        list.eachWithIndex {it, index ->
            result += '{"c":[{"v":"' + it.label + '","f":null},{"v":' + it.count + ',"f":null}]}'
            result += (index == list.size() - 1) ? "" : ","
        }
        result += '],"p":{"rank":"' + input.rank + '","scope":"' + scope + '","name":"' + name + '"}}'
        return result
    }

}
