package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON

class PublicController {

    def index = { redirect(action: 'map')}

    def list = {
        [collections: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)]
    }

    def show = {
        def collectionInstance = findCollection(params.id)
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        } else if (collectionInstance.groupType == ProviderGroup.GROUP_TYPE_INSTITUTION) {
            // redirect to show institutions
            redirect(action: 'showInstitution', id: collectionInstance.id)
        } else {
            [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts()]
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
        List<CollectionLocation> locations = new ArrayList<CollectionLocation>()
        ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION).each {
            def loc = new CollectionLocation()
            if (it.latitude != -1 && it.latitude != 0 && it.longitude != -1 && it.longitude != 0) {
                loc.latitude = it.latitude
                loc.longitude = it.longitude
            } else if (it.address && !it.address.isEmpty()) {
                loc.streetAddress = [it.address?.street, it.address?.city, it.address?.state, it.address?.country].join(',')
            }
            if (!loc.isEmpty()) {
                loc.name = it.name
                loc.link = it.id
                locations << loc
            }
        }
        //ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'map'
        //locations.each {println "> ${it.latitude},${it.longitude} ${it.streetAddress} ${it.name}"}
        [collections: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)]
        //[locations: locations, collections: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)]
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

        def locations = [:]
        locations.type = "FeatureCollection"
        locations.features = new ArrayList()
        List<CollectionLocation> collections = new ArrayList<CollectionLocation>()
        ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION).each {
            if (it.latitude != -1 && it.latitude != 0 && it.longitude != -1 && it.longitude != 0) {
                def loc = [:]
                loc.type = "Feature"
                loc.properties = [name: it.name]
                loc.geometry = [type: "Point", coordinates: [it.longitude,it.latitude]]
                locations.features << loc
            }
        }

        //def json = JSON.parse(features)
        render(locations as JSON)
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
}
