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

            [instance: instance, contacts: instance.getContacts(), changes: getChanges(instance.uid)]
        }
    }

    def delete = {
        def instance = get(params.id)
        if (instance) {
            if (isAdmin()) {
                /* need to remove it as a parent from all children otherwise they will be deleted */
                def resources = instance.resources as List
                resources.each {
                    instance.removeFromResources it
                    it.userLastModified = username()
                    it.save()  // necessary?
                }
                // remove contact links (does not remove the contact)
                ContactFor.findAllByEntityUid(instance.uid).each {
                    it.delete()
                }
                // now delete
                try {
                    ActivityLog.log username(), isAdmin(), params.id as long, Action.DELETE
                    instance.delete(flush: true)
                    flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'dataProvider.label', default: 'dataProvider'), params.id])}"
                    redirect(action: "list")
                }
                catch (org.springframework.dao.DataIntegrityViolationException e) {
                    flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'dataProvider.label', default: 'dataProvider'), params.id])}"
                    redirect(action: "show", id: params.id)
                }
            } else {
                render("You are not authorised to access this page.")
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataProvider.label', default: 'dataProvider'), params.id])}"
            redirect(action: "list")
        }
    }

    /**
     * Get the instance for this entity based on either uid or DB id.
     *
     * @param id UID or DB id
     * @return the entity of null if not found
     */
    protected ProviderGroup get(id) {
        if (id.size() > 2) {
            if (id[0..1] == DataProvider.ENTITY_PREFIX) {
                return ProviderGroup._get(id)
            }
        }
        // else must be long id
        long dbId
        try {
            dbId = Long.parseLong(id)
        } catch (NumberFormatException e) {
            return null
        }
        return DataProvider.get(dbId)
    }

}
