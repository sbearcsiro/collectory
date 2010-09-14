package au.org.ala.collectory

import au.org.ala.collectory.exception.InvalidUidException
import org.codehaus.groovy.grails.web.json.JSONArray

class CrudService {

    static transactional = true
    def idGeneratorService

    static baseStringProperties = ['guid','name','acronym','phone','email','state','pubDescription','techDescription','notes',
                'isALAPartner','focus','attributions','websiteUrl','networkMembership','altitude',
                'street','postBox','postcode','city','state','country','file','caption','attribution','copyright']
    static baseNumberProperties = ['latitude','longitude']
    static baseObjectProperties = ['address', 'imageRef','logoRef']
    static baseJSONArrays = ['networkMembership']

    static dataResourceStringProperties = ['displayName','rights','citation','citableAgent']
    //static dataResourceObjectProperties = ['dataProvider']

    static institutionStringProperties = ['institutionType']

    static collectionStringProperties = ['collectionType','keywords','active','states','geographicDescription',
            'startDate','endDate','kingdomCoverage','scientificNames','subCollections']
    static collectionNumberProperties = ['numRecords','numRecordsDigitised','eastCoordinate','westCoordinate',
            'northCoordinate','southCoordinate']
    static collectionJSONArrays = ['keywords','collectionType','scientificNames','subCollections']

    //static collectionObjectProperties = ['institution','providerMap']

    /**
     * NOTE **** containsKey does not work on JSONObject until version 1.3.4
     * using keySet().contains until then
     */
    def has = {map, key ->
        return map.keySet().contains(key)
    }

    /* data provider */

    def insertDataProvider(obj) {
        def uid
        if (obj.has('uid')) {
            uid = obj.uid
            if (!idGeneratorService.checkValidId(uid)) {
                throw new InvalidUidException("invalid uid")
            }
        } else {
            uid = idGeneratorService.getNextDataProviderId()
        }
        DataProvider dp = new DataProvider(uid: uid)
        updateBaseProperties(dp, obj)
        dp.userLastModified = 'Data services'
        if (!dp.hasErrors()) {
             dp.save(flush: true)
        }
        return dp
    }
    
    def updateDataProvider(dp, obj) {
        updateBaseProperties(dp, obj)
        dp.userLastModified = 'Data services'
        if (!dp.hasErrors()) {
             dp.save(flush: true)
        }
        return dp
    }

    /* data hub */

    def insertDataHub(obj) {
        def uid
        if (obj.has('uid')) {
            uid = obj.uid
            if (!idGeneratorService.checkValidId(uid)) {
                throw new InvalidUidException("invalid uid")
            }
        } else {
            uid = idGeneratorService.getNextDataHubId()
        }
        DataHub dp = new DataHub(uid: uid)
        updateBaseProperties(dp, obj)
        dp.userLastModified = 'Data services'
        if (!dp.hasErrors()) {
             dp.save(flush: true)
        }
        return dp
    }

    def updateDataHub(dp, obj) {
        updateBaseProperties(dp, obj)
        dp.userLastModified = 'Data services'
        if (!dp.hasErrors()) {
             dp.save(flush: true)
        }
        return dp
    }

    /* data resource */

    def insertDataResource(obj) {
        def uid
        if (obj.has('uid')) {
            uid = obj.uid
            if (!idGeneratorService.checkValidId(uid)) {
                throw new InvalidUidException("invalid uid")
            }
        } else {
            uid = idGeneratorService.getNextDataResourceId()
        }
        DataResource dr = new DataResource(uid: uid)
        updateBaseProperties(dr, obj)
        updateDataResourceProperties(dr, obj)
        dr.userLastModified = 'Data services'
        if (!dr.hasErrors()) {
             dr.save(flush: true)
        }
        return dr
    }

    def updateDataResource(dr, obj) {
        updateBaseProperties(dr, obj)
        updateDataResourceProperties(dr, obj)
        dr.userLastModified = 'Data services'
        if (!dr.hasErrors()) {
             dr.save(flush: true)
        }
        return dr
    }

    private void updateDataResourceProperties(DataResource dr, obj) {
        dr.properties[dataResourceStringProperties] = obj
        if (obj.has('dataProvider')) {
            // find it
            DataProvider dp = DataProvider._get(obj.dataProvider.uid) as DataProvider
            if (dp) {
                dr.dataProvider = dp
            }
        }
    }

    /* institution */

    def insertInstitution(obj) {
        def uid
        if (obj.has('uid')) {
            uid = obj.uid
            if (!idGeneratorService.checkValidId(uid)) {
                throw new InvalidUidException("invalid uid")
            }
        } else {
            uid = idGeneratorService.getNextInstitutionId()
        }
        Institution inst = new Institution(uid: uid)
        updateBaseProperties(inst, obj)
        updateInstitutionProperties(inst, obj)
        inst.userLastModified = 'Data services'
        if (!inst.hasErrors()) {
             inst.save(flush: true)
        }
        return inst
    }

    def updateInstitution(inst, obj) {
        updateBaseProperties(inst, obj)
        updateInstitutionProperties(inst, obj)
        inst.userLastModified = 'Data services'
        if (!inst.hasErrors()) {
             inst.save(flush: true)
        }
        return inst
    }

    private void updateInstitutionProperties(Institution inst, obj) {
        inst.properties[institutionStringProperties] = obj
    }

    /* collection */

    def insertCollection(obj) {
        def uid
        if (obj.has('uid')) {
            uid = obj.uid
            if (!idGeneratorService.checkValidId(uid)) {
                throw new InvalidUidException("invalid uid")
            }
        } else {
            uid = idGeneratorService.getNextCollectionId()
        }
        Collection inst = new Collection(uid: uid)
        updateBaseProperties(inst, obj)
        updateCollectionProperties(inst, obj)
        inst.userLastModified = 'Data services'
        if (!inst.hasErrors()) {
             inst.save(flush: true)
        }
        return inst
    }

    def updateCollection(inst, obj) {
        updateBaseProperties(inst, obj)
        updateCollectionProperties(inst, obj)
        inst.userLastModified = 'Data services'
        if (!inst.hasErrors()) {
             inst.save(flush: true)
        }
        return inst
    }

    private void updateCollectionProperties(Collection co, obj) {
        // handle values that might be passed as JSON arrays or string representations of JSON arrays
        collectionJSONArrays.each {
            if (obj.has(it) && obj."${it}" instanceof JSONArray) {
                // convert to string representation
                obj."${it}" = obj."${it}".toString()
            }
        }
        co.properties[collectionStringProperties] = obj
        co.properties[collectionNumberProperties] = obj
        if (obj.has('institution')) {
            if (!obj.institution.has('uid')) {
                co.errors.rejectValue('institution','NO_UID','institution must specify a uid')
            } else {
                // find it
                Institution institution = Institution._get(obj.institution.uid) as Institution
                if (institution) {
                    co.institution = institution
                } else {
                    co.errors.rejectValue('institution','NOT_FOUND',"specified institution (${obj.institution.uid}) does not exist")
                }
            }
        }
        // handle provider codes
        if (obj.has('recordsMapping')) {
            def map = obj.recordsMapping
            // check existing map
            ProviderMap pm = co.id ? ProviderMap.findByCollection(co) : null
            if (pm) {
                // clear codes
                def colls = pm.collectionCodes.collect{it}
                colls.each {pm.removeFromCollectionCodes it}
                def insts = pm.institutionCodes.collect{it}
                insts.each {pm.removeFromInstitutionCodes it}
            } else {
                pm = new ProviderMap()
                pm.collection = co
            }
            // get codes
            if (map.has('institutionCodes')) {
                def instCodes = (map.institutionCodes instanceof String) ? [map.institutionCodes] : map.institutionCodes.collect{it}
                instCodes.each {
                    // does it exist
                    ProviderCode pc = ProviderCode.findByCode(it)
                    if (!pc) {
                        pc = new ProviderCode(code: it)
                    }
                    pm.addToInstitutionCodes(pc)
                }
            }
            if (map.has('collectionCodes')) {
                def collCodes = (map.collectionCodes instanceof String) ? [map.collectionCodes] : map.collectionCodes.collect{it}
                collCodes.each {
                    // does it exist
                    ProviderCode pc = ProviderCode.findByCode(it)
                    if (!pc) {
                        pc = new ProviderCode(code: it)
                    }
                    pm.addToCollectionCodes(pc)
                }
            }
            if (map.has('exact')) {
                pm.exact = map.exact
            }
            if (map.has('warning') && map.warning != 'null' && map.warning != "") {
                pm.warning = map.warning
            }
            if (map.has('matchAnyCollectionCode')) {
                pm.matchAnyCollectionCode = map.matchAnyCollectionCode
            }
            co.providerMap = pm
        }
    }

    private void updateBaseProperties(ProviderGroup pg, obj) {
        adjustEmptyProperties obj
        // handle values that might be passed as JSON arrays or string representations of JSON arrays
        baseJSONArrays.each {
            if (obj.has(it) && obj."${it}" instanceof JSONArray) {
                // convert to string representation
                obj."${it}" = obj."${it}".toString()
            }
        }
        // inject properties (this method does type conversions automatically)
        pg.properties[baseStringProperties] = obj
        pg.properties[baseNumberProperties] = obj
        // only add objects if they exist
        baseObjectProperties.each {
            if (obj.has(it)) {
                pg."${it}" = obj."${it}"
            }
        }
    }

    /**
     * We don't want to create objects in the target if there is no data for them.
     * @param obj
     */
    private void removeNullObjects(obj) {
        baseObjectProperties.each {
            if (obj.has(it) && obj."${it}".toString() == 'null') {
                obj.remove(it)
            }
        }
    }

    /**
     * Null numbers are represented as -1 (as they cannot be null).
     * JSON null objects are changed to Java null.
     * Properties that are objects are processed recursively.
     * @param obj map of properties to adjust
     */
    private void adjustEmptyProperties(obj) {
        // numbers should be set to -1 if the value comes in as null
        baseNumberProperties.each {
            if (obj.has(it) && obj."${it}"?.toString() == 'null') {
                obj."${it}" = -1
            }
        }
        // null objects are copies of JSONObject.NULL - set them to Java null
        [baseStringProperties,dataResourceStringProperties].flatten().each {
            if (obj.has(it) && obj."${it}".toString() == 'null') {
                obj."${it}" = null
            }
        }
        baseObjectProperties.each {
            if (obj.has(it)) {
                if (obj."${it}".toString() == 'null') {
                    obj."${it}" = null
                } else {
                    // adjust nested properties - all known nested props are strings
                    adjustEmptyProperties(obj."${it}")
                }
            }
        }
    }

}
