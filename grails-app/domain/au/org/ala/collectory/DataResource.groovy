package au.org.ala.collectory

import java.sql.Timestamp

class DataResource extends ProviderGroup implements Serializable {

    static final String ENTITY_TYPE = 'DataResource'
    static final String ENTITY_PREFIX = 'dr'

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    static mapping = {
        sort: 'name'
    }

    String rights
    String citation
    String licenseType
    String licenseVersion
    String resourceType = "records"
    String informationWithheld
    String dataGeneralizations
    boolean contributor = true
    String status
    String harvestingNotes
    String harvestFrequency
    Timestamp lastHarvested
    String connectionParameters     // json string containing parameters based on a connection profile - DIGiR, TAPIR, etc
    DataProvider dataProvider
    Institution institution         // optional link to the institution whose records are served by this resource

    static constraints = {
        rights(nullable:true, maxSize:4096)
        citation(nullable:true, maxSize:4096)
        licenseType(nullable:true, maxSize:45, inList:licenseTypeList)
        licenseVersion(nullable:true, maxSize:45)
        resourceType(maxSize:255, validator: {
            return it in resourceTypeList
        })
        dataProvider(nullable:true)
        institution(nullable:true)
        dataGeneralizations(nullable:true, maxSize:2048)
        informationWithheld(nullable:true, maxSize:2048)
        status(nullable:true)
        harvestingNotes(nullable:true, maxSize:4096)
        harvestFrequency(nullable:true)
        lastHarvested(nullable:true)
        connectionParameters(nullable:true, maxSize:4096)
    }

    static transients = ProviderGroup.transients + ['creativeCommons']

    static resourceTypeList = ["records", "website", "document", "uploads"]
    static creativeCommonsLicenses = ["CC BY", "CC BY-NC", "CC BY-SA", "CC BY-NC-SA"]
    static ccDisplayList = [
        [type:'CC BY',display:'Creative Commons Attribution'],
        [type:'CC BY-NC',display:'Creative Commons Attribution-NonCommercial'],
        [type:'CC BY-SA',display:'Creative Commons Attribution-ShareAlike'],
        [type:'CC BY-NC-SA',display:'Creative Commons Attribution-NonCommercial-ShareAlike'],
        [type:'other',display:'Some other or no license']]
    static licenseTypeList = creativeCommonsLicenses + ["other"]

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
        drs.dataProvider = dataProvider?.name
        drs.dataProviderId = dataProvider?.id
        drs.dataProviderUid = dataProvider?.uid

        drs.hubMembership = listHubMembership().collect { [uid: it.uid, name: it.name] }
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
     * Returns a list of all hubs this resource belongs to.
     *
     * @return list of DataHub
     */
    List listHubMembership() {
        DataHub.list().findAll {it.isDataResourceMember(uid)}
    }

    /**
     * True if this resource uses a CC license.
     * @return
     */
    boolean isCreativeCommons() {
        return licenseType in creativeCommonsLicenses
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
