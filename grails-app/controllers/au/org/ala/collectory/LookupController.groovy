package au.org.ala.collectory

import java.text.ParseException
import java.text.NumberFormat
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import au.com.bytecode.opencsv.CSVWriter

class LookupController {

    def idGeneratorService

    static allowedMethods = [citation:['POST','GET']]

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
     * Returns a summary for any entity when passed a UID.
     *
     * If the id is not a UID it will be assumed to be a collection and will be treated as:
     * 1. lsid if it starts with uri:lsid:
     * 2. database id if it is a number
     * 3. acronym if it matches a collection
     */
    def summary = {
        ProviderGroup instance = ProviderGroup._get(params.id)
        if (!instance) {
            instance = findCollection(params.id)
        }
        if (instance) {
            render instance.buildSummary() as JSON
        } else {
            log.error "Unable to find entity for id = ${params.id}"
            def error = ["error":"unable to find an entity for id = " + params.id]
            render error as JSON
        }
    }

    def citation = {
        // input is a json object of the form ['co123','in23','dp45']
        def uids = null
        switch (request.method) {
            case "POST":
                if (request.JSON) { uids = request.JSON }
                break;
            case "GET":
                if (params.uids) { uids = JSON.parse(params.uids) }
                break;
        }
        if (uids) {
            if (uids.size() > 0 && uids[0] == "all") {
                uids = DataResource.list(sort: "uid").collect { it.uid }
            }
            withFormat {
                text {  // handles text/plain and text/html
                    StringWriter sw = new StringWriter()
                    CSVWriter writer = new CSVWriter(sw)
                    writer.writeNext(["Resource name","Citation","Rights","More information"] as String[])
                    uids.each {
                        // get each pg
                        def pg = ProviderGroup._get(it)
                        if (pg) {
                            writer.writeNext(buildCitation(pg,"array") as String[])
                        }
                    }
                    render sw.toString()
                }
                csv {  // same as text - handles text/csv
                    StringWriter sw = new StringWriter()
                    CSVWriter writer = new CSVWriter(sw)
                    writer.writeNext(["Resource name","Citation","Rights","More information"] as String[])
                    uids.each {
                        // get each pg
                        def pg = ProviderGroup._get(it)
                        if (pg) {
                            writer.writeNext(buildCitation(pg,"array") as String[])
                        }
                    }
                    render sw.toString()
                }
                tsv {  // old
                    String result = "Resource name\tCitation\tRights\tMore information"
                    uids.each {
                        // get each pg
                        def pg = ProviderGroup._get(it)
                        if (pg) {
                            result += "\n" + buildCitation(pg,"tab separated")
                        }
                    }
                    render result
                }
                json {
                    def result = uids.collect {
                        // get each pg
                        def pg = ProviderGroup._get(it)
                        if (pg) {
                            return buildCitation(pg,"map")
                        }
                    }
                    render result as JSON
                }
            }
        } else {
            render ([error:"no uids posted"] as JSON)
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

    def buildCitation(ProviderGroup pg, format) {
        def citation = ConfigurationHolder.config.citation.template
        def rights = ConfigurationHolder.config.citation.rights.template
        def name = pg.name
        if (pg instanceof DataResource) {
            def cit = (pg as DataResource).getCitation()
            citation = cit ? cit : citation
            def rit = (pg as DataResource).getRights()
            rights = rit ? rit : rights
            def nam = (pg as DataResource).getDisplayName()
            name = nam ? name : name
        }
        def link = ConfigurationHolder.config.citation.link.template
        link =  link.replaceAll("@link@",makeLink(pg.generatePermalink()))
        citation =  citation.replaceAll("@entityName@",name)
        switch (format) {
            case "tab separated": return "${name}\t${citation}\t${rights}\t${link}"
            case "map": return ['name': name, 'citation': citation, 'rights': rights, 'link': link]
            case "array": return [name, citation, rights, link]
        }
    }

    String makeLink(uid) {
        return "${ConfigurationHolder.config.grails.serverURL}/public/show/${uid}"
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

    private ProviderGroup findCollection(id) {
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
