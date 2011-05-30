package au.org.ala.collectory

import grails.converters.JSON
import au.org.ala.collectory.exception.InvalidUidException

class DataResourceController extends ProviderGroupController {

    DataResourceController() {
        entityName = "DataResource"
        entityNameLower = "dataResource"
    }

    def index = {
        redirect(action:"list")
    }

    // list all entities
    def list = {
        if (params.message)
            flash.message = params.message
        params.max = Math.min(params.max ? params.int('max') : 50, 100)
        params.sort = params.sort ?: "name"
        ActivityLog.log username(), isAdmin(), Action.LIST
        [instanceList: DataResource.list(params), entityType: 'DataResource', instanceTotal: DataResource.count()]
    }

    def show = {
        def instance = get(params.id)
        if (!instance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'dataResource.label', default: 'Data resource'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.debug "Ala partner = " + instance.isALAPartner
            ActivityLog.log username(), isAdmin(), instance.uid, Action.VIEW

            [instance: instance, contacts: instance.getContacts(), changes: getChanges(instance.uid)]
        }
    }

    def updateRights = {
        def pg = get(params.id)
        if (pg) {
            if (params.version) {
                def version = params.version.toLong()
                if (pg.version > version) {
                    pg.errors.rejectValue("version", "default.optimistic.locking.failure",
                            [message(code: "${pg.urlForm()}.label", default: pg.entityType())] as Object[],
                            "Another user has updated this ${pg.entityType()} while you were editing")
                    render(view: "description", model: [command: pg])
                    return
                }
            }

            pg.properties = params
            pg.userLastModified = username()
            if (!pg.hasErrors() && pg.save(flush: true)) {
                flash.message =
                  "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
                redirect(action: "show", id: pg.id)
            }
            else {
                render(view: "description", model: [command: pg])
            }
        } else {
            flash.message =
                "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    /**
     * Update descriptive attributes that are specific to resources.
     *
     * Called by the base class method for updating descriptions.
     */
    @Override def entitySpecificDescriptionProcessing(Object pg, Object params) {
        pg.displayName = params.displayName
        params.remove('displayName')
    }

    /**
     * Get the instance for this entity based on either uid or DB id.
     *
     * @param id UID or DB id
     * @return the entity of null if not found
     */
    protected ProviderGroup get(id) {
        if (id.size() > 2) {
            if (id[0..1] == DataResource.ENTITY_PREFIX) {
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
        return DataResource.get(dbId)
    }

}
