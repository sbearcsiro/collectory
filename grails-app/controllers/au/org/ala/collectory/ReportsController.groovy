package au.org.ala.collectory

import au.org.ala.security.Logon

class ReportsController {

    def authenticateService

    def index = {
        redirect action: list, params: params
    }

    def list = {
        render(view: "index")
    }

    def data = {
        ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'data'
        [reports: new ReportCommand('data')]
    }

    def activity = {
        ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'activity'
        [reports: new ReportCommand('activity')]
    }

    def membership = {
        ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'membership'
        [reports: new ReportCommand('membership')]
    }

    def collections = {
        ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'collections'
        [reports: new ReportCommand('collections')]
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
        ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'map'
        locations.each {println "> ${it.latitude},${it.longitude} ${it.streetAddress} ${it.name}"}
        [locations: locations]
    }

    def institutions = {
        ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'institutions'
    }

    def contacts = {
        ActivityLog.log authenticateService.userDomain().username, Action.REPORT, 'contacts'
    }

    class ReportCommand {
        int totalCollections
        int totalInstitutions
        int totalContacts
        int totalLogons

        def collectionsWithType
        def collectionsWithFocus
        def collectionsWithKeywords
        def collectionsWithProviderCodes
        def collectionsWithGeoDescription
        def collectionsWithNumRecords
        def collectionsWithNumRecordsDigitised
        def collectionsWithDescriptions

        def collectionsWithoutContacts
        def collectionsWithoutEmailContacts
        def institutionsWithoutContacts
        def institutionsWithoutEmailContacts

        def collectionsWithInfosource

        def totalLogins
        def uniqueLogins
        def uniqueLoginList
        def supplierLogins
        def uniqueSupplierLogins
        def curatorViews
        def curatorPreviews
        def curatorEdits
        def lastLogin

        def partners
        def chahMembers
        def chaecMembers
        def chafcMembers
        def amrrnMembers
        def camdMembers

        def execQuery = { query ->
            def answer = ProviderGroup.executeQuery(query)
            if (answer) {
                return answer[0]
            } else {
                return null
            }
        }

        def countNotNull = { field ->
            def query = "select count(*) from ProviderGroup as pg where "
            if (field instanceof List) {
                field.each {query += "pg.${it} <> NULL and "}
            } else {
                query += "pg.${field} <> NULL and "
            }
            query += "pg.groupType = '${ProviderGroup.GROUP_TYPE_COLLECTION}'"
            def answer = execQuery(query)
            if (!answer) answer = 0
            return answer
        }

        def countNotUnknown = { field ->
            def query = """select count(*) from ProviderGroup as pg \
                where pg.${field} <> -1 \
                and pg.groupType = '${ProviderGroup.GROUP_TYPE_COLLECTION}'"""
            def answer = execQuery(query)
            if (!answer) answer = 0
            return answer
        }

        ReportCommand(String set) {
            switch (set) {
                case 'data':
                totalCollections = ProviderGroup.countByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION)
                totalInstitutions = ProviderGroup.countByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION)
                totalContacts = Contact.count()
                totalLogons = Logon.count()

                /* sql: select count(*) from collectory.provider_group
                    where not exists (select * from collectory.contact_for
                    where contact_for.entity_id = provider_group.id)
                    and provider_group.group_type = 'Collection';*/
                collectionsWithoutContacts = execQuery("select count(*) from ProviderGroup as pg \
                    where not exists (select id from ContactFor as cf \
                    where cf.entityId = pg.id) \
                    and pg.groupType = '${ProviderGroup.GROUP_TYPE_COLLECTION}'")

                institutionsWithoutContacts = execQuery("select count(*) from ProviderGroup as pg \
                    where not exists (select id from ContactFor as cf \
                    where cf.entityId = pg.id) \
                    and pg.groupType = '${ProviderGroup.GROUP_TYPE_INSTITUTION}'")

                /* sql: select count(*) from collectory.provider_group
                    where not exists (select * from collectory.contact_for, collectory.contact
                    where contact_for.entity_id = provider_group.id
                    and contact.id = contact_for.contact_id
                    and contact.email <> '')
                    and provider_group.group_type = 'Collection'; */
                collectionsWithoutEmailContacts = execQuery("select count(*) from ProviderGroup as pg \
                    where not exists (select id from ContactFor as cf \
                    where cf.entityId = pg.id \
                    and cf.contact.email <> '') \
                    and pg.groupType = '${ProviderGroup.GROUP_TYPE_COLLECTION}'")

                institutionsWithoutEmailContacts = execQuery("select count(*) from ProviderGroup as pg \
                    where not exists (select id from ContactFor as cf \
                    where cf.entityId = pg.id \
                    and cf.contact.email <> '') \
                    and pg.groupType = '${ProviderGroup.GROUP_TYPE_INSTITUTION}'")

                /* sql: select count(*) from collectory.provider_group
                    where exists (select * from collectory.info_source as src
                    where src.id = provider_group.info_source_id)
                    and provider_group.group_type = 'Collection'; */
                collectionsWithInfosource = countNotNull("infoSource")

                collectionsWithType = countNotNull("scope.collectionType")
                collectionsWithFocus = countNotNull("focus")
                collectionsWithKeywords = countNotNull("scope.keywords")
                collectionsWithProviderCodes = ProviderMap.count()
                collectionsWithGeoDescription = countNotNull("scope.geographicDescription")
                collectionsWithNumRecords = countNotUnknown("scope.numRecords")
                collectionsWithNumRecordsDigitised = countNotUnknown("scope.numRecordsDigitised")
                collectionsWithDescriptions = countNotNull(["pubDescription", "techDescription"])
                break

                case 'activity':
                totalLogins = ActivityLog.countByAction(Action.LOGIN.toString())
                lastLogin = ActivityLog.find("from ActivityLog where  action=? order by timestamp desc limit 1", [Action.LOGIN.toString()])
                uniqueLogins = ActivityLog.executeQuery("select count(distinct user) from ActivityLog where action='${Action.LOGIN.toString()}'")[0]
                uniqueLoginList = ActivityLog.executeQuery("select distinct user from ActivityLog where action='${Action.LOGIN.toString()}'")

                supplierLogins = ActivityLog.countByActionAndRoles(Action.LOGIN.toString(), 'ROLE_SUPPLIER')
                uniqueSupplierLogins = ActivityLog.executeQuery("select count (distinct user) from ActivityLog where action='${Action.LOGIN.toString()}' and roles = 'ROLE_SUPPLIER'")[0]
                // select count(*) from activity_log where administrator_for_entity = 1 and roles = "ROLE_SUPPLIER" and action = "viewed";
                curatorViews = ActivityLog.executeQuery("select count(*) from ActivityLog where action='${Action.VIEW.toString()}'" +
                        " and administratorForEntity = 1 and not roles like '%ROLE_ADMIN%'")[0]
                curatorPreviews = ActivityLog.executeQuery("select count(*) from ActivityLog where action='${Action.PREVIEW.toString()}'" +
                        " and administratorForEntity = 1 and not roles like '%ROLE_ADMIN%'")[0]
                curatorEdits = ActivityLog.executeQuery("select count(*) from ActivityLog where action='${Action.EDIT_SAVE.toString()}'" +
                        " and administratorForEntity = 1 and not roles like '%ROLE_ADMIN%'")[0]
                break
                
                case 'membership':
                partners = ProviderGroup.findAllByIsALAPartnerAndGroupType(true, ProviderGroup.GROUP_TYPE_INSTITUTION)

                chahMembers = ProviderGroup.findAllByNetworkMembershipIlike("%CHAH%",[sort:'name'])
                chaecMembers = ProviderGroup.findAllByNetworkMembershipIlike("%CHAEC%",[sort:'name'])
                chafcMembers = ProviderGroup.findAllByNetworkMembershipIlike("%CHAFC%",[sort:'name'])
                amrrnMembers = ProviderGroup.findAllByNetworkMembershipIlike("%AMRRN%",[sort:'name'])
                camdMembers = ProviderGroup.findAllByNetworkMembershipIlike("%CAMD%",[sort:'name'])
                break

            }
        }
    }
}
