package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON

class LookupController {

    def index = { }

    def collection = {
        def inst = params.inst
        def coll = params.coll
        if (!inst) {
            def error = ["error":"must specify an institution code as parameter inst"]
            render error as JSON
        }
        if (!coll) {
            def error = ["error":"must specify a collection code as parameter coll"]
            render error as JSON
        }
        def pg = ProviderMap.findMatch(inst, coll)
        if (pg) {
            render pg.getCollectionSummary() as JSON
        } else {
            def error = ["error":"unable to find collection with inst code = ${inst} and coll code = ${coll}"]
            render error as JSON
        }
    }

    def findInstitution = {
        def inst
        if (params.id) {
            inst = find(params.id, ProviderGroup.GROUP_TYPE_INSTITUTION)
        } else if (params.code) {
            inst = ProviderMap.findInstitution(params.code)
        } else {
            def error = ["error":"no code or id passed in request"]
            render error as JSON
        }
        if (inst) {
            render inst.getInstitutionSummary() as JSON
        } else {
            log.error "Unable to find institution. id = ${params.id}, code = ${params.code}"
            def error = ["error":"unable to find institution - id = ${params.id}, code = ${params.code}"]
            render error as JSON
        }
    }

    private find(id, groupType) {
        // try lsid
        if (id instanceof String && id.startsWith('urn:lsid:')) {
            return ProviderGroup.findByGuidAndGroupType(id, groupType)
        }
        // try id
        try {
            NumberFormat.getIntegerInstance().parse(id)
            def result = ProviderGroup.read(id)
            if (result) {return result}
        } catch (ParseException e) {}
        // try acronym
        return ProviderGroup.findByAcronymAndGroupType(id, groupType)
    }

}
