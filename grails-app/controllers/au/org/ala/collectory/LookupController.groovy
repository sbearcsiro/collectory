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
        Collection col = ProviderMap.findMatch(inst, coll)
        if (col) {
            render col.buildSummary() as JSON
        } else {
            def error = ["error":"unable to find collection with inst code = ${inst} and coll code = ${coll}"]
            render error as JSON
        }
    }

    def findInstitution = {
        println "entered"
        Institution inst = null
        if (params.id) {
            inst = findInstitution(params.id)
        } else {
            def error = ["error":"no code or id passed in request"]
            render error as JSON
        }
        if (inst) {
            render inst.buildSummary() as JSON
        } else {
            log.error "Unable to find institution. id = ${params.id}"
            def error = ["error":"unable to find institution - id = ${params.id}"]
            render error as JSON
        }
    }

    private findInstitution(id) {
        // try lsid
        if (id instanceof String && id.startsWith('urn:lsid:')) {
            return Institution.findByGuid(id)
        }
        // try uid
        if (id instanceof String && id.startsWith(Institution.ENTITY_PREFIX)) {
            return Institution.findByUid(id)
        }
        // try id
        try {
            NumberFormat.getIntegerInstance().parse(id)
            def result = Institution.read(id)
            if (result) {return result}
        } catch (ParseException e) {}
        // try acronym
        return Institution.findByAcronym(id)
    }

    private findCollection(id) {
        // try lsid
        if (id instanceof String && id.startsWith('urn:lsid:')) {
            return Collection.findByGuid(id)
        }
        // try uid
        if (id instanceof String && id.startsWith(Collection.ENTITY_PREFIX)) {
            return Collection.findByUid(id)
        }
        // try id
        try {
            NumberFormat.getIntegerInstance().parse(id)
            def result = Collection.read(id)
            if (result) {return result}
        } catch (ParseException e) {}
        // try acronym
        return Collection.findByAcronym(id)
    }

}
