package au.org.ala.collectory

import grails.converters.JSON

class DataHub extends ProviderGroup implements Serializable {

    static final String ENTITY_TYPE = 'DataHub'
    static final String ENTITY_PREFIX = 'dh'

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    String memberInstitutions       // json list of uids of member institutions
    String memberCollections        // json list of uids of member collections
    String members                  // non-overlapping json list of uids of member institutions and collections
                                    //  (suitable for identifying a unique list of occurrence records)

    static constraints = {
        memberCollections(nullable:true)
        memberInstitutions(nullable:true)
        members(nullable:true)
    }

    boolean canBeMapped() {
        return false;
    }

    /**
     * Returns a summary of the data provider including:
     * - id
     * - name
     * - acronym
     * - lsid if available
     * - description
     * - provider codes for matching with biocache records
     *
     * @return CollectionSummary
     */
    ProviderGroupSummary buildSummary() {
        ProviderGroupSummary dps = init(new ProviderGroupSummary())
        //cs.derivedInstCodes = getListOfInstitutionCodesForLookup()
        //cs.derivedCollCodes = getListOfCollectionCodesForLookup()
        return dps
    }

    def listMembers() {
        return members ? JSON.parse(members).collect {it} : []
    }

    long dbId() {
        return id;
    }

    String entityType() {
        return ENTITY_TYPE;
    }

}
