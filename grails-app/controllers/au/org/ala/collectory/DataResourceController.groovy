package au.org.ala.collectory

import grails.converters.JSON
import au.org.ala.collectory.exception.InvalidUidException
import au.org.ala.collectory.resources.Profile
import java.text.SimpleDateFormat
import au.org.ala.collectory.resources.PP

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

    def updateContribution = {
        def pg = get(params.id)

        // process connection parameters
        def protocol = params.remove('protocol')
        def cp = [:]
        if (protocol) {
            cp.protocol = protocol
        }
        def profile = Profile.valueOf(protocol)
        profile.parameters.each {pp ->
            if (pp.type == 'boolean') {
                // the presence of the param indicates it is checked
                cp."${pp.name}" = params.containsKey(pp.name)
            }
            else if (params."${pp.name}") {
                if (pp.name == 'termsForUniqueKey') {
                    cp."${pp.name}" = params."${pp.name}".tokenize(', ')
                }
                else if (pp.type == 'delimiter') {
                    def str = params."${pp.name}"
                    str = str.replaceAll('HT', PP.HT)
                    str = str.replaceAll('LF', PP.LF)
                    str = str.replaceAll('VT', PP.VT)
                    str = str.replaceAll('FF', PP.FF)
                    str = str.replaceAll('CR', PP.CR)
                    cp."${pp.name}" = str
                }
                else {
                    cp."${pp.name}" = params."${pp.name}"
                }
            }
        }
        params.connectionParameters = (cp as JSON).toString()

        // process dates
        def lastChecked = params.remove('lastChecked')
        if (lastChecked) {
            pg.lastChecked = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S").parse(lastChecked).toTimestamp()
        }
        def dataCurrency = params.remove('dataCurrency')
        if (dataCurrency) {
            pg.dataCurrency = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S").parse(dataCurrency).toTimestamp()
        }

        // update
        genericUpdate pg, 'contribution'
    }

    def updateRights = {
        def pg = get(params.id)
        genericUpdate pg, 'rights'
    }

    /**
     * Update descriptive attributes that are specific to resources.
     *
     * Called by the base class method for updating descriptions.
     */
    @Override def entitySpecificDescriptionProcessing(Object pg, Object params) {
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
