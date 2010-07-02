package au.org.ala.collectory

class PublicController {

    def index = { redirect(action: 'list')}

    def list = {
        [collections: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)]
    }

    def show = {
        def collectionInstance = ProviderGroup.get(params.id)
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
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
        locations.each {println "> ${it.latitude},${it.longitude} ${it.streetAddress} ${it.name}"}
        [locations: locations, collections: ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)]
    }

}
