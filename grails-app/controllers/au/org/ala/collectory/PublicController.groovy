package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class PublicController {

    def index = { redirect(action: 'map')}

    def list = {
        [collections: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)]
    }

    def show = {
        def collectionInstance = findCollection(params.id)
        //println ">>debug map key " + grailsApplication.config.google.maps.v2.key
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        } else if (collectionInstance.groupType == ProviderGroup.GROUP_TYPE_INSTITUTION) {
            // redirect to show institutions
            redirect(action: 'showInstitution', id: collectionInstance.id)
        } else {
            // lookup number of biocache records
            def instCodes = collectionInstance.getListOfInstitutionCodesForLookup()
            def collCodes = collectionInstance.getListOfCollectionCodesForLookup()
            def count = -1
            if (instCodes || collCodes) {
                def url = new URL(buildBiocacheQueryString(instCodes, collCodes))
                //println "Url = " + url
                def conn = url.openConnection()
                conn.setConnectTimeout 3000
                try {
                    def json = conn.content.text
                    //println "Response = " + json
                    count = JSON.parse(json)?.searchResult?.totalRecords
                    //println "Count = " + count
                } catch (FileNotFoundException e) {
                    log.error "Failed to lookup record count. ${e.getMessage()} URL= ${url}."
                } catch (ConnectException e) {
                    log.error "Failed to lookup record count. ${e.getMessage()} URL= ${url}."
                } catch (ProtocolException e) {
                    log.error "Failed to lookup record count. ${e.getMessage()} URL= ${url}."
                } catch (SocketTimeoutException e) {
                    log.error "Failed to lookup record count. ${e.getMessage()} URL= ${url}."
                } catch (Exception e) {
                    log.error "Failed to lookup record count. ${e.getMessage()} URL= ${url}."
                }
            } else {
                count = 0
            }
            [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts(), numBiocacheRecords: count]
        }
    }

    def listInstitutions = {
        [institutions: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION)]
    }

    def showInstitution = {
        def institution
        if (params.code) {
            institution = ProviderGroup.findByAcronymAndGroupType(params.code, ProviderGroup.GROUP_TYPE_INSTITUTION)
        } else if (params.id) {
            institution = ProviderGroup.get(params.id)
        }
        if (!institution) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'institution.label', default: 'Institution'), params.code ? params.code : params.id])}"
            redirect(action: "list")
        } else {
            [institution: institution]
        }
    }

    def map = {
        //ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'map'
        [collections: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)]
    }

    def mapFeatures = {
        // temp GeoJSON string
        /*def features = """
     { "type": "FeatureCollection",
      "features": [
        { "type": "Feature",
          "geometry": {"type": "Point", "coordinates": [149.114293, -35.274218]},
          "properties": {"name": "ANIC"}
        },
        { "type": "Feature",
          "geometry": {"type": "Point", "coordinates": [151.0414080000, -33.7465780000]},
          "properties": {"name": "Forests NSW Insect Collection"}
        },
        { "type": "Feature",
          "geometry": {"type": "Point", "coordinates": [145.2565400000, -37.8754490000]},
          "properties": {"name": "National Collection of Fungi, Knoxfield Herbarium"}
        },
        { "type": "Feature",
          "geometry": {"type": "Point", "coordinates": [147.3327940000, -42.8862830000]},
          "properties": {"name": "Australian National Fish Collection"}
        }
       ]
       }"""*/
        //println ">> map filters = " + params.filters
        
        def locations = [:]
        def showAll = params.filters == 'all'
        locations.type = "FeatureCollection"
        locations.features = new ArrayList()
        List<CollectionLocation> collections = new ArrayList<CollectionLocation>()
        ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION).each {
            // make 0 values be -1
            def tempLat = it.latitude
            def tempLong = it.longitude
            def name = it.name
            
            def lat = (it.latitude == 0.0) ? -1 : it.latitude
            def lon = (it.longitude == 0.0) ? -1 : it.longitude
            // use parent institution if lat/long not defined
            def inst = it.findPrimaryInstitution()
            if (inst && lat == -1) {lat = inst.latitude}
            if (inst && lon == -1) {lon = inst.longitude}
            // only show if we have lat and long
            if (lat != -1 && lon != -1) {
                // and if matches current filter
                if (showAll || matchKeywords(it.scope, params.filters)) {
                    def loc = [:]
                    loc.type = "Feature"
                    loc.properties = [name: it.name, url: request.getContextPath() + "/public/show/" + it.id]
                    loc.geometry = [type: "Point", coordinates: [it.longitude,it.latitude]]
                    locations.features << loc
                }
            }
        }

        //def json = JSON.parse(features)
        render(locations as JSON)
    }

    private boolean matchKeywords(scope, filterString) {
        // synonyms
        if (filterString =~ "fungi") {
            filterString += "fungal"
        }
        def filters = filterString.tokenize(",")
        for (int i = 0; i < filters.size(); i++) {
            println "Checking filter ${filters[i]} against keywords ${scope?.keywords}"
            if (scope?.keywords =~ filters[i]) {
                return true;
            }
        }
        return false
    }

    private findCollection(id) {
        // try lsid
        if (id instanceof String && id.startsWith('urn:lsid:')) {
            return ProviderGroup.findByGuidAndGroupType(id, ProviderGroup.GROUP_TYPE_COLLECTION)
        }
        // try id
        try {
            NumberFormat.getIntegerInstance().parse(id)
            def result = ProviderGroup.read(id)
            if (result) {return result}
        } catch (ParseException e) {}
        // try acronym
        return ProviderGroup.findByAcronymAndGroupType(id, ProviderGroup.GROUP_TYPE_COLLECTION)
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

}
