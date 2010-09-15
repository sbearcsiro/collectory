package au.org.ala.collectory

class DataProviderController extends ProviderGroupController {

    DataProviderController() {
        entityName = "DataProvider"
        entityNameLower = "dataProvider"
    }

    def index = {
        redirect(action:"list")
    }

    // list all entities
    def list = {
        if (params.message)
            flash.message = params.message
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = params.sort ?: "name"
        ActivityLog.log username(), isAdmin(), Action.LIST
        [instanceList: DataProvider.list(params), entityType: 'DataProvider', instanceTotal: DataProvider.count()]
    }

    def show = {
        def instance = get(params.id)
        if (!instance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataProvider.label', default: 'Data Provider'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.debug "Ala partner = " + instance.isALAPartner
            ActivityLog.log username(), isAdmin(), instance.uid, Action.VIEW
            [instance: instance, contacts: instance.getContacts()]
        }
    }

}
