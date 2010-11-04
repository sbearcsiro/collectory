package au.org.ala.collectory

import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class AdminController {

    def dataLoaderService, idGeneratorService, authService

/*
 * Access control
 *
 * All methods require ADMIN role.
 */
    def beforeInterceptor = [action:this.&auth]
    def auth() {
        if (!authService.userInRole(ProviderGroup.ROLE_ADMIN)) {
            render "You are not authorised to access this page."
            return false
        }
    }
/*
 End access control
 */

    def index = { }

    def loadSupplementary = {
        boolean override = params.override ? params.override : false
        log.info ">>${authService.username()} loading supplimentary data"
        dataLoaderService.loadSupplementaryData("/data/collectory/bootstrap/sup.json", override, authService.username())
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
            Attribution at1 = new Attribution(uid: 'at1', name: 'Biodiversity Collections Index', url: 'http://www.biodiversitycollectionsindex.org')
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
        def targets = []
        if (params.id) {
            def target = ProviderGroup._get(params.id)
            if (target) {
                targets << target
            }
        } else {
            targets = Collection.list() + Institution.list()
        }
        targets.each { pg ->
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
        }
        render 'Done.'
    }

    def removeInstitutionAttributions = {
        def targets = []
        if (params.id) {
            def target = ProviderGroup._get(params.id)
            if (target) {
                targets << target
            }
        } else {
            targets = Collection.list() + Institution.list()
        }
        targets.each { pg ->
            if (pg.attributions) {
                def uids = pg.attributions.tokenize(' ')
                def newUids = []
                uids.each {
                    if (it in ['at1','at2','at3']) {
                        newUids << it
                    }
                }
                pg.attributions = newUids.join(' ')
            }
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

    def importDataProviders = {
        int beforeCount = DataProvider.count()
        def result = dataLoaderService.importDataProviders("/data/collectory/bootstrap/data_providers.txt")
        int afterCount = DataProvider.count()
        render "Done - ${afterCount-beforeCount} providers created."
        render """
        ${beforeCount} providers before<br/>
        ${result.headerLines} header line found<br/>
        ${result.dataLines} lines of data found<br/>
        ${result.exists} lines of data match existing records<br/>
        ${result.updates} existing records were updated<br/>
        ${result.inserts} records inserted<br/>
        ${result.failures} lines of data could not be processed<br/>
        ${afterCount} providers after"""
    }

    def importDataResources = {
        int beforeCount = DataResource.count()
        def result = dataLoaderService.importDataResources("/data/collectory/bootstrap/data_resources.txt")
        int afterCount = DataResource.count()
        render """
        ${beforeCount} resources before<br/>
        ${result.headerLines} header line found<br/>
        ${result.dataLines} lines of data found<br/>
        ${result.exists} lines of data match existing records<br/>
        ${result.updates} existing records were updated<br/>
        ${result.inserts} records inserted<br/>
        ${result.failures} lines of data could not be processed<br/>
        ${afterCount} resources after"""
    }
}
