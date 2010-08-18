package au.org.ala.collectory

class Institution extends ProviderGroup {

    def idGeneratorService

    static final String ENTITY_TYPE = 'Institution'
    static final String ENTITY_PREFIX = 'in'

    String institutionType      // the type of institution, eg herbarium, library

    // an institution may have many collections
    static hasMany = [collections: Collection]
    
    static constraints = {
        institutionType(nullable:true, maxSize:45, inList:['aquarium', 'archive', 'botanicGarden', 'conservation', 'fieldStation', 'government', 'herbarium', 'historicalSociety', 'horticulturalInstitution', 'independentExpert', 'industry', 'laboratory', 'library', 'management', 'museum', 'natureEducationCenter', 'nonUniversityCollege', 'park', 'repository', 'researchInstitute', 'school', 'scienceCenter', 'society', 'university', 'voluntaryObserver', 'zoo'])
        collections(nullable:true)
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
        is.collections = collections.collect {[it.id, it.name]}
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

    /**
     * Returns list of name/url for where the information about this institution was sourced.
     * @return list of Attribution
     */
    List<Attribution> getAttributionList() {
        if (!attributions) {
            attributions = ""
            // build it
            if (guid?.startsWith(LSID_PREFIX)) {
                // probably loaded from BCI
                attributions = 'at1'
            }
            // list itself
            // see if an attribution already exists
            def at = Attribution.findByName(name)
            if (!at) {
                at = new Attribution(name: name, url: websiteUrl, uid: idGeneratorService.getNextAttributionId()).save()
            }
            attributions += (attributions?' ':'') + at.uid
            validate()
            if (hasErrors()) {
                errors.each {println it}
            }
            save(flush:true)
        }
        def uids = attributions.tokenize(' ')
        List<Attribution> list = uids.collect {
            Attribution.findByUid(it)
        }
        return list
    }

    long dbId() { return id }

    String entityType() {
        return ENTITY_TYPE
    }
}
