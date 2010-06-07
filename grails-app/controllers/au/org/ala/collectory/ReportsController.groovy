package au.org.ala.collectory

import au.org.ala.security.Logon

class ReportsController {

    def index = { redirect(action: "show", params: params) }

    def show = {
        [reports: new ReportCommand()]
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

        ReportCommand() {
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
            collectionsWithProviderCodes = countNotNull("providerCodes")
            collectionsWithGeoDescription = countNotNull("scope.geographicDescription")
            collectionsWithNumRecords = countNotUnknown("scope.numRecords")
            collectionsWithNumRecordsDigitised = countNotUnknown("scope.numRecordsDigitised")
            collectionsWithDescriptions = countNotNull(["pubDescription", "techDescription"])

        }
    }
}
