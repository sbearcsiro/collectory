package au.org.ala.collectory

class DataHub extends ProviderGroup implements Serializable {

    static final String ENTITY_TYPE = 'DataHub'
    static final String ENTITY_PREFIX = 'dh'

    static constraints = {
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

    long dbId() {
        return id;
    }

    String entityType() {
        return ENTITY_TYPE;
    }

}
