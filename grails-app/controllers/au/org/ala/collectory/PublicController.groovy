package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class PublicController {

    def keywordSynonyms = [
        'birds':['ornithology','bird'],
        'fish': ['ichthyology'],
        'frogs': ['amphibians','herpetology','frog'],
        'mammals': ['mammal'],
        'reptiles': ['reptile','herpetology'],
        'invertebrates': ['insect','insects','spiders','arachnids','invertebrate'],
        'plants': ['angiosperms','plant','plantae','herbarium','herbaria'],
        'fungi': ['fungus'],
        'ferns': ['fern'],
        'microbes': ['microbe','microbial','protista']
    ]

    def index = { redirect(action: 'map')}

    def tagTest = {
        [testValue: 'test1']
    }

    def list = {
        [collections: Collection.list([sort:'name'])]
    }

    def show = {
        def collectionInstance = findCollection(params.id)
        //println ">>debug map key " + grailsApplication.config.google.maps.v2.key
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params?.id])}"
            redirect(controller: "public", action: "map")
        } else {
            // lookup number of biocache records
            def baseUrl = ConfigurationHolder.config.biocache.baseURL
            def url = baseUrl + "occurrences/searchForCollection.JSON?pageSize=0&q=" + collectionInstance.generatePermalink()

            def count = -1
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
            def percent = -1
            if (count != -1 && collectionInstance.numRecords > 0) {
                percent = (count*100)/collectionInstance.numRecords
            }

            [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts(),
                    numBiocacheRecords: count, percentBiocacheRecords: percent]
        }
    }

    def breakdown = {
        def collectionInstance = findCollection(params.id)
        //println ">>debug map key " + grailsApplication.config.google.maps.v2.key
        if (!collectionInstance) {
            log.error "Unable to find collection for id = ${params.id}"
            def error = ["error":"unable to find collection for id = " + params.id]
            render error as JSON
        } else {
            /* get decade breakdown */
            def decadeUrl = ConfigurationHolder.config.biocache.baseURL + "breakdown/collection/decades/${collectionInstance.generatePermalink()}.json";
            println decadeUrl
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


    def listInstitutions = {
        [institutions: Institution.list()]
    }

    def showInstitution = {
        def institution = findInstitution(params.id)
        if (!institution) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'institution.label', default: 'Institution'), params.code ? params.code : params.id])}"
            redirect(controller: "public", action: "map")
        } else {
            [institution: institution]
        }
    }

    def map = {
        //ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'map'
        def partnerCollections = Collection.list([sort:"name"]).findAll {
            it.getIsALAPartner() == true
        }
        [collections: partnerCollections]
    }

    def mapFeatures = {
        //log.info ">>Map features action called"
        def locations = [:]
        def showAll = params.filters == 'all'
        locations.type = "FeatureCollection"
        locations.features = new ArrayList()
        List<CollectionLocation> collections = new ArrayList<CollectionLocation>()
        Collection.list([sort:"name"]).each {
            // only show ALA partners
            if (it.getIsALAPartner()) {
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
                    if (showAll || matchTaxa(it.keywords, params.filters)) {
                        def loc = [:]
                        loc.type = "Feature"
                        loc.properties = [
                                name: it.name,
                                id: it.id,
                                isMappable: it.canBeMapped(),
                                address: it.address?.buildAddress(),
                                desc: it.makeAbstract(),
                                url: request.getContextPath() + "/public/show/" + it.id]
                        loc.geometry = [type: "Point", coordinates: [lon,lat]]
                        locations.features << loc
                    }
                //}
            }
        }

        //def json = JSON.parse(features)
        render(locations as JSON)
    }

    def chart = {
        /* temporal:
         * http://chart.apis.google.com/chart
           ?chxl=1:|1950|1960|1970|1980|1990|2000|2010
           &chxr=0,0,4000
           &chxt=y,x
           &chbh=a,4,35
           &chs=300x225
           &cht=bvs
           &chco=A2C180
           &chd=s:uZOQLVS
           &chdlp=l
           &chtt=Specimens+added+per+decade */

        /* percent digitised:
         * http://chart.apis.google.com/chart
           ?chs=300x150
           &cht=gm
           &chd=t:70
           &chtt=Percent+of+specimen+records+digitised
           &chts=676767,12 */

        /* taxa:
         * http://chart.apis.google.com/chart
           ?chs=400x150
           &cht=p3
           &chco=7777CC|76A4FB|3399CC|3366CC
           &chd=s:QEHCVfe
           &chdl=Angiosperms|Dicots|Monocots|Gymnosperms|Pteridophytes|Mosses|Algae
           &chdlp=t
           &chp=12.7
           &chl=Angiosperms|Dicots|Monocots|Gymnosperms|Pteridophytes|Mosses|Algae
           &chma=175
         */

        // some dummy data for now:
        def data = [:]
        data.decades = ["1950":"1010","1960":"2020","1970":"1515","1980":"2929","1990":"200","2000":"3000","2010":"3300"]
        data.orders = ["Angiosperms":"10,210","Dicots":"8,510","Monocots":"1,700","Gymnosperms":"75","Pteridophytes":"320","Mosses":"250","Algae":"50"]
        render(data as JSON)
    }

    private boolean matchKeywords(keywords, filterString) {
        // synonyms
        if (filterString =~ "fungi") {
            filterString += "fungal"
        }
        def filters = filterString.tokenize(",")
        for (int i = 0; i < filters.size(); i++) {
            println "Checking filter ${filters[i]} against keywords ${scope?.keywords}"
            if (keywords =~ filters[i]) {
                return true;
            }
        }
        return false
    }

    private boolean matchTaxa(keywords, filterString) {
        def filters = filterString.tokenize(",")
        for (filter in filters) {
            //println "Checking filter ${filter} against keywords ${scope?.keywords}"
            if (keywords =~ filter) {
                return true;
            } else {
                // check synonyms
                List synonyms = keywordSynonyms.get(filter)
                for (synonym in synonyms) {
                    if (keywords =~ synonym) {
                        return true;
                    }
                }
            }
        }
        return false
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
            def url = baseUrl + "searchForCollection.JSON?pageSize=0" + instClause + collClause
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
            {"c":[{"v":"1890","f":null},{"v":44,"f":null}]},
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
            def label = (stagger && (index % 2) == 0) ? "" : it.label
            result += '{"c":[{"v":"' + label + '","f":null},{"v":' + it.count + ',"f":null}]}'
            result += (index == input.size()) ? "" : ","
        }
        result += '],"p":{"max":' + maximum + '}}'
        return result
    }
}
