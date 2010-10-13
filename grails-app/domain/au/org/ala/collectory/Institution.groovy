package au.org.ala.collectory

class Institution extends ProviderGroup {

    def idGeneratorService

    static final String ENTITY_TYPE = 'Institution'
    static final String ENTITY_PREFIX = 'in'

    static auditable = [ignore: ['version','dateCreated','lastUpdated','userLastModified']]

    String institutionType      // the type of institution, eg herbarium, library

    String childInstitutions    // space-separated list of UIDs of institutions that this institution administers

    // an institution may have many collections
    static hasMany = [collections: Collection]

    static constraints = {
        institutionType(nullable:true, maxSize:45,
                inList:['aquarium', 'archive', 'botanicGarden', 'conservation', 'fieldStation', 'government',
                        'governmentDepartment', 'herbarium', 'historicalSociety', 'horticulturalInstitution',
                        'independentExpert', 'industry', 'laboratory', 'library', 'management', 'museum',
                        'natureEducationCenter', 'nonUniversityCollege', 'park', 'repository', 'researchInstitute',
                        'school', 'scienceCenter', 'society', 'university', 'voluntaryObserver', 'zoo'])
        collections(nullable:true)
        childInstitutions(nullable:true)
    }

    static transients = ProviderGroup.transients + ['summary','mappable']

    static mapping = {
        sort: 'name'
    }
    
    /**
     * Returns a summary of the institution including:
     * - id
     * - name
     * - acronym
     * - lsid if available
     * - description
     *
     * @return InstitutionSummary
     * @.history 2-8-2010 removed inst codes as these are now related only to collections (can be added back with a different mechanism if required)
     */
    InstitutionSummary buildSummary() {
        InstitutionSummary is = init(new InstitutionSummary()) as InstitutionSummary
        is.collections = collections.collect {[it.uid, it.name]}
        return is
    }

    /**
     * Returns true if:
     *  a) has membership of a collection network (hub) (assumed that all hubs are partners)
     *  b) has isALAPartner set
     *
     * NOTE: restriction on abstract methods
     */
    boolean isALAPartner() {
        if (networkMembership != null && networkMembership != "[]") {
            return true
        } else {
            return this.isALAPartner
        }
    }

    /**
     * Returns true if the group can be mapped.
     *
     * @return
     */
    boolean canBeMapped() {
        return latitude != 0.0 && latitude != -1 && longitude != 0.0 && longitude != -1
    }

    Map inheritedLatLng() {
        return null
    }

    long dbId() { return id }

    String entityType() {
        return ENTITY_TYPE
    }


    /**
     * List of collections held directly by this institution or by an institution that this one administers.
     *
     * @return List of Collection
     */
    def listCollections() {
        if (!childInstitutions) {
            return collections
        }
        def result = collections
        childInstitutions.tokenize(' ').each {
            def i = _get(it)
            if (i) {
                result.addAll i.listCollections()
            }
        }
        return result
    }


    /**
     * List of institutions that include this as a child institution.
     *
     * Note this is not very efficient as the relationship is modelled solely in the parent.
     * @return list of Institution
     */
    def listParents() {
        return Institution.findAll("from Institution as i where i.childInstitutions like :uid",[uid: uid])
    }

    def List<Attribution> getAttributionList() {
        List<Attribution> list = super.getAttributionList();
        // add institution
        list << new Attribution(name: name, url: websiteUrl, uid: uid)
        return list
    }

}
