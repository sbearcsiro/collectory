package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder

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
                // lookup number of biocache records
                def baseUrl = ConfigurationHolder.config.biocache.baseURL
                def url = baseUrl + "occurrences/searchForUID.JSON?pageSize=0&q=" + collectionInstance.generatePermalink()

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

                ActivityLog.log username(), isAdmin(), collectionInstance.uid, Action.VIEW
                [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts(),
                        numBiocacheRecords: count, percentBiocacheRecords: percent]
            }
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
            conn.setConnectTimeout 3000
            def dataTable = null
            def json
            try {
                json = conn.content.text
                //println "Response = " + json
                def decades = JSON.parse(json)?.decades
                dataTable = buildDataTable(decades)
                //println "dataTable = " + dataTable
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
            conn.setConnectTimeout 3000
            def dataTable = null
            def json
            try {
                json = conn.content.text
                //println "Response = " + json
                def breakdown = JSON.parse(json)?.breakdown
                if (breakdown && breakdown.toString() != "null") {
                    dataTable = buildPieChartDataTable(breakdown)
                    if (dataTable) {
                        render dataTable
                    } else {
                        log.warn "unable to build data table from taxa json = " + json
                        def error = ["error":"Unable to build data table from taxa json"]
                        render error as JSON
                    }
                }
            } catch (Exception e) {
                log.error "Failed to lookup taxa breakdown. ${e.getMessage()} URL= ${taxonUrl}."
            }
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
            ActivityLog.log username(), isAdmin(), institution.uid, Action.VIEW
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
            ActivityLog.log username(), isAdmin(), instance.uid, Action.VIEW
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
            def baseUrl = ConfigurationHolder.config.biocache.baseURL
            def url = baseUrl + "occurrences/searchForUID.JSON?pageSize=0&q=" + instance.generatePermalink()

            def count = 0
            def conn = new URL(url).openConnection()
            conn.setConnectTimeout 3000
            try {
                def json = conn.content.text
                count = JSON.parse(json)?.searchResult?.totalRecords
            } catch (Exception e) {
                log.error "Failed to lookup record count. ${e.getClass()} ${e.getMessage()} URL= ${url}."
            }

            ActivityLog.log username(), isAdmin(), instance.uid, Action.VIEW
            [instance: instance, numBiocacheRecords: count]
        }
    }

    /**
     * Displays main page for Natural History Collections.
     *
     * Although an initial list of collections is placed in the model, the data is sourced by ajax callback. The initial
     * list is used if the callback fails.
     */
    def map = {
        ActivityLog.log username(), isAdmin(), Action.LIST, 'map'
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
                                id: it.id,
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
    private String buildDataTable(input) {
        int maximum = 0
        boolean stagger = input.size() > 6
        String result = """{"cols":[{"id":"","label":"","pattern":"","type":"string"},{"id":"","label":"","pattern":"","type":"number"}],"rows":["""
        input.eachWithIndex {it, index ->
            maximum = Math.max(maximum, it.count)
            String label = (stagger && (index % 2) == 0) ? "" : it.label + "s"
            result += '{"c":[{"v":"' + label + '","f":null},{"v":' + it.count + ',"f":null}]}'
            result += (index == input.size() - 1) ? "" : ","
        }
        result += '],"p":{"max":' + maximum + '}}'
        return result
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
     * @return
     */
    private String buildPieChartDataTable(input) {
        String result = """{"cols":[{"id":"","label":"${input.rank}","pattern":"","type":"string"},{"id":"","label":"No. specimens","pattern":"","type":"number"}],"rows":["""
        def list = input.taxa.collect {
            [label: it.label, count: it.count]
        }
        list.eachWithIndex {it, index ->
            result += '{"c":[{"v":"' + it.label + '","f":null},{"v":' + it.count + ',"f":null}]}'
            result += (index == list.size() - 1) ? "" : ","
        }
        result += '],"p":{"rank":"' + input.rank + '"}}'
        return result
    }

    private String username() {
        return (request.getUserPrincipal()?.attributes?.email)?:'not available'
    }

    private boolean isAdmin() {
        return (request.isUserInRole(ProviderGroup.ROLE_ADMIN))
    }

}
