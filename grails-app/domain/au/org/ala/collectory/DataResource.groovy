package au.org.ala.collectory

class DataResource extends ProviderGroup implements Serializable {

    static final String ENTITY_TYPE = 'DataResource'
    static final String ENTITY_PREFIX = 'dr'

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    static mapping = {
        sort: 'name'
    }

    String displayName
    String rights
    String citation
    String citableAgent
    String informationWithheld
    String dataGeneralizations
    DataProvider dataProvider
    Institution institution         // optional link to the institution whose records are served by this resource

    static constraints = {
        displayName(nullable:true, maxSize:1024)
        rights(nullable:true, maxSize:4096)
        citation(nullable:true, maxSize:4096)
        citableAgent(nullable:true, maxSize:2048)
        dataProvider(nullable:true)
        institution(nullable:true)
        dataGeneralizations(nullable:true, maxSize:2048)
        informationWithheld(nullable:true, maxSize:2048)
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
        drs.dataProvider = dataProvider?.name
        drs.dataProviderId = dataProvider?.id
        drs.dataProviderUid = dataProvider?.uid

        def consumers = listConsumers()
        consumers.each {
            def pg = ProviderGroup._get(it)
            if (pg) {
                if (it[0..1] == 'co') {
                    drs.relatedCollections << [uid: pg.uid, name: pg.name]
                } else {
                    drs.relatedInstitutions << [uid: pg.uid, name: pg.name]
                }
            }
        }
        // for backward compatibility
        if (drs.relatedInstitutions) {
            drs.institution = drs.relatedInstitutions[0].name
            drs.institutionUid = drs.relatedInstitutions[0].uid
        }
        return drs
    }

    /**
     * Return the provider's address if the resource does not have one. If dp has no address try related entities.
     * @return
     */
    @Override def resolveAddress() {
        def addr = super.resolveAddress() ?: dataProvider?.resolveAddress()
        if (!addr) {
            def pg = listConsumers().find {
                def related = _get(it)
                return related && related.resolveAddress()
            }
            if (pg) {
                addr = _get(pg).resolveAddress()
            }
        }
        return addr
    }

    /**
     * Returns the entity that is responsible for creating this resource - the data provider if there is one.
     * @return
     */
    @Override def createdBy() {
        return dataProvider ? dataProvider.createdBy() : super.createdBy()
    }

    /**
     * Return the provider's logo if the resource does not have one.
     * @return
     */
    @Override def buildLogoUrl() {
        if (logoRef) {
            return super.buildLogoUrl()
        }
        else {
            return dataProvider?.buildLogoUrl()
        }
    }

    /**
     * Returns the best available primary contact.
     * @return
     */
    @Override
    ContactFor inheritPrimaryContact() {
        return getPrimaryContact() ?: dataProvider?.inheritPrimaryContact()
    }

    long dbId() {
        return id;
    }

    String entityType() {
        return ENTITY_TYPE;
    }

    String shortProviderName(int len) {
        return dataProvider?.name?.length() > len ? dataProvider.name[0..len] + ".." : dataProvider?.name
    }

    String shortProviderName() {
        return shortProviderName(30)
    }
}
