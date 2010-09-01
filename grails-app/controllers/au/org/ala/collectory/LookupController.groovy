package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class LookupController {

    def idGeneratorService

    //static allowedMethods = [citation:'POST']

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

    def institution = {
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

    /**
     * Return a collection summary as JSON.
     * Param can be:
     *  1. database id
     *  2. uid
     *  3. lsid
     *  4. acronym
     */
    def summary = {
        Collection collectionInstance = findCollection(params.id)
        println ">> summary id = " + params.id
        if (collectionInstance) {
            render collectionInstance.buildSummary() as JSON
        } else {
            log.error "Unable to find collection for id = ${params.id}"
            def error = ["error":"unable to find collection for id = " + params.id]
            render error as JSON
        }
    }

    def citation = {
        // input is a json object of the form ['co123','in23','dp45']
        def content = request.reader.text
        //println "Got request " + content
        if (content) {
            List<String> uids = JSON.parse(content) as List<String>
            List<String> result = uids.collect {
                // get each pg
                def pg = ProviderGroup._get(it)
                if (pg) {
                    return buildCitation(pg).toString()
                } else {
                    return "UID ${it} not known".toString()
                }
            }
            //result.each {println it}
            render (result) as JSON
        } else {
            render (["error":"no uids posted"]) as JSON
        }
    }

    def testCitation = {
        def data = URLEncoder.encode("['co123','in23','dp45']","UTF-8")

        def url = new URL("http://localhost:8080/Collectory/admin/citation")
        def conn = url.openConnection()
        conn.requestMethod = "POST"

        conn.setDoOutput(true)
        conn.setDoInput(true)
        def writer = new OutputStreamWriter(conn.getOutputStream())
        writer.write(data)
        writer.flush()

        def result = conn.content.text

        writer.close()
        conn.disconnect()

        render (result) as JSON
    }

    String buildCitation(ProviderGroup pg) {
        def template = ConfigurationHolder.config.citation.template
        template = template.replaceAll("@entityName@",pg.name)
        return template.replaceAll("@link@",makeLink(pg.generatePermalink()))
    }

    String makeLink(uid) {
        def urlPath = ProviderGroup.urlFormOfEntityType(ProviderGroup.entityTypeFromUid(uid))
        return "${ConfigurationHolder.config.grails.serverURL}/pub/${urlPath}/${uid}"
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

    def generateCollectionUid = {
        def resultMap = ['uid':idGeneratorService.getNextCollectionId()]
        render resultMap as JSON
    }

    def generateInstitutionUid = {
        def resultMap = ['uid':idGeneratorService.getNextInstitutionId()]
        render resultMap as JSON
    }

    def generateDataProviderUid = {
        def resultMap = ['uid':idGeneratorService.getNextDataProviderId()]
        render resultMap as JSON
    }

    def generateDataResourceUid = {
        def resultMap = ['uid':idGeneratorService.getNextDataResourceId()]
        render resultMap as JSON
    }

    def generateDataHubUid = {
        def resultMap = ['uid':idGeneratorService.getNextDataHubId()]
        render resultMap as JSON
    }
}
