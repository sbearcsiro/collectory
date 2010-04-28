package au.org.ala.collectory

class CollectionController {

    def scaffold = ProviderGroup

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        //println "Count = " + ProviderGroup.countByGroupType('Institution')
        [collectionInstanceList: ProviderGroup.findAllByGroupType("Collection", params),
                collectionInstanceTotal: ProviderGroup.countByGroupType('Collection')]
    }

    def show = {
        def collectionInstance = ProviderGroup.get(params.id)
        if (!collectionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params.id])}"
            redirect(action: "list")
        }
        else {
            [collectionInstance: collectionInstance, contacts: collectionInstance.getContacts()]
        }
    }

}
