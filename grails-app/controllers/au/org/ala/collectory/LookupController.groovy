package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON

class LookupController {

    def index = { }

    def findInstitution = {
        def inst
        if (params.id) {
            inst = find(params.id, ProviderGroup.GROUP_TYPE_INSTITUTION)
        } else if (params.code) {
            def results = ProviderGroup.createCriteria().list() {
                eq ('groupType', 'Institution')
                or {
                    like ('internalProviderCodes', "%\"${params.code}\"%")
                    like ('internalProviderCodes', "%\"any\"%")
                    like ('providerCodes', "%\"${params.code}\"%")
                    eq ('acronym', "${params.code}")
                }
            }
            // TODO: double check as the above is a bit loose
            //goodResults = results.collect {if (it.matches)}
            // TODO: handle multiple hits
            if (results.size() > 0) {
                inst = results[0]
            }
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
