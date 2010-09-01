package au.org.ala.collectory

import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class AdminController {

    def dataLoaderService, idGeneratorService

    def index = { }

    def loadSupplementary = {
        boolean override = params.override ? params.override : false
        log.info ">>${authenticateService.userDomain().username} loading supplimentary data"
        dataLoaderService.loadSupplementaryData("/data/collectory/bootstrap/sup.json", override, authenticateService.userDomain().username)
//        ActivityLog.log authenticateService.userDomain().username, Action.DATA_LOAD
        redirect(url: "http://localhost:8080/Collectory")  //action: "list")
    }

    def loadAmrrnData = {
        log.info ">>${authenticateService.userDomain().username} loading amrrn data"
        dataLoaderService.loadAmrrnData()
//        ActivityLog.log authenticateService.userDomain().username, Action.DATA_LOAD
        redirect(url: "http://localhost:8080/Collectory")  //action: "list")
    }

    def loadChacmAttributions = {
        def targets =
            Collection.findAllByNetworkMembershipIlike("%CHACM%") +
            Institution.findAllByNetworkMembershipIlike("%CHACM%")
        targets.each { pg ->
            println "processing " + pg.name
            pg.addAttribution('at51')
            println pg.attributions
        }
        render 'Done.'
    }

    def setAttributions = {
        // insert BCI and CH* if not there
        if (!Attribution.findByUid('at1')) {
            Attribution at1 = new Attribution(uid: 'at1', name: 'Biodiversity Collections Index', url: 'http://www.biodiveristycollectionsindex.org')
            at1.save()
        }
        if (!Attribution.findByUid('at2')) {
            Attribution at2 = new Attribution(uid: 'at2', name: 'Council of Heads of Australasian Herbaria', url: 'http://www.chah.gov.au/resources/index.html')
            at2.save()
        }
        if (!Attribution.findByUid('at3')) {
            Attribution at3 = new Attribution(uid: 'at3', name: 'Council of Heads of Australian Collections of Microorganisms', url: 'http://www.amrin.org/ResearchNetwork/Participants.aspx')
            at3.save()
        }
        def targets = Collection.list() + Institution.list()
        targets.each { pg ->
            println "processing " + pg.name
            if (pg.guid?.startsWith(ProviderGroup.LSID_PREFIX)) {
                // probably loaded from BCI
                pg.addAttribution 'at1'
            }
            if (pg.isMemberOf('CHAH')) {
                pg.addAttribution 'at2'
            }
            if (pg.isMemberOf('CHACM')) {
                pg.addAttribution 'at3'
            }
            if (pg instanceof Collection && pg.institution) {
                // add institution
                // see if an attribution already exists
                def at = Attribution.findByName(pg.institution.name)
                if (!at) {
                    at = new Attribution(name: pg.institution.name, url: pg.institution.websiteUrl,
                            uid: idGeneratorService.getNextAttributionId()).save()
                }
                pg.addAttribution at.uid
            } else if (pg instanceof Institution) {
                // add itself
                def at = Attribution.findByName(pg.name)
                if (!at) {
                    at = new Attribution(name: pg.name, url: pg.websiteUrl, uid: idGeneratorService.getNextAttributionId()).save()
                }
                pg.addAttribution at.uid
            }
            println pg.attributions
        }
        render 'Done.'
    }

    def updateAmrrnToChacm = {
        def targets =
            Collection.findAllByNetworkMembershipIlike("%AMRRN%") +
            Institution.findAllByNetworkMembershipIlike("%AMRRN%")
        targets.each { pg ->
            println "processing " + pg.name
            print pg.networkMembership + " -> "
            List hubs = JSON.parse(pg.networkMembership).collect { it.toString() }
            hubs.remove 'AMRRN'
            hubs.add 'CHACM'
            pg.networkMembership = (hubs as JSON).toString()
            println pg.networkMembership
            pg.save(flush:true)
        }
        render 'Done.'
    }

    /**
     * Export all tables as JSON
     */
    def export = {
        if (params.table) {
            switch (params.table) {
                case 'contact': render Contact.list() as JSON; break
                case 'contactFor': render ContactFor.list() as JSON; break
                case 'collection': render Collection.list() as JSON; break
                case 'institution': render Institution.list() as JSON; break
                //case 'infoSource': render InfoSource.list() as JSON; break
                case 'providerCode': render ProviderCode.list() as JSON; break
                case 'providerMap': render ProviderMap.list() as JSON; break
                default:
                    def error = ['error','no such table']
                    render error as JSON
            }
        } else {
            def result = [
                    contact: Contact.list(),
                    contactFor: ContactFor.list(),
                    collection: Collection.list(),
                    institution: Institution.list(),
                    //infoSource: InfoSource.list(),
                    providerCode: ProviderCode.list(),
                    providerMap: ProviderMap.list()
            ]
            render result as JSON
        }
    }

    def importJson = {
        dataLoaderService.importJson()
        // some tests
        if (Institution.findByName("Tasmanian Museum and Art Gallery")?.getContacts()?.size() == 1) {
            render "loaded ok"
        } else {
            render "failed to load correctly"
        }

    }

    def testImport = {
        String resp = ""

        def inst1 = Institution.findByName("Tasmanian Museum and Art Gallery")
        resp += inst1.name + "<br>"
        def fors1 = inst1.getContacts()
        fors1.each {resp += '_' + it.contact + "<br>"}

        def col1 = Collection.findByName("Australian National Herbarium")
        resp += col1.name + "<br>"
        def fors2 = col1.getContacts()
        fors2.each {resp += '_' + it.contact + "<br>"}

        def inst2 = Institution.findByAcronym('CSIRO')
        resp += inst2.name + "<br>"
        def children = inst2?.getCollections()
        children?.each {
            resp += '_' + it.name + "<br>"
        }

        render resp
    }
   
}
