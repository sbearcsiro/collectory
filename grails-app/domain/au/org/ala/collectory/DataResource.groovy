package au.org.ala.collectory

class DataResource extends ProviderGroup implements Serializable {

    static final String ENTITY_TYPE = 'DataResource'
    static final String ENTITY_PREFIX = 'dr'

    String displayName
    String rights
    String citation
    String citableAgent

    DataProvider dataProvider

    static constraints = {
        displayName(nullable:true, maxSize:1024)
        rights(nullable:true, maxSize:4096)
        citation(nullable:true, maxSize:4096)
        citableAgent(nullable:true, maxSize:2048)
        dataProvider(nullable:true)
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
     * - data provider name, id and uid
     *
     * @return CollectionSummary
     */
    DataResourceSummary buildSummary() {
        DataResourceSummary drs = init(new DataResourceSummary()) as DataResourceSummary
        drs.displayName = displayName
        drs.dataProvider = dataProvider.name
        drs.dataProviderId = dataProvider.id
        drs.dataProviderUid = dataProvider.uid
        return drs
    }

    long dbId() {
        return id;
    }

    String entityType() {
        return ENTITY_TYPE;
    }

    String shortProviderName() {
        def len = 30
        return dataProvider?.name?.length() > len ? dataProvider.name[0..len] : ""
    }
}
