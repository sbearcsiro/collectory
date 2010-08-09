package au.org.ala.collectory

import grails.converters.JSON

class AdminController {

    def dataLoaderService

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
        String response = ""

        def inst1 = Institution.findByName("Tasmanian Museum and Art Gallery")
        response += inst1.name + "<br>"
        def fors1 = inst1.getContacts()
        fors1.each {response += '_' + it.contact + "<br>"}

        def col1 = Collection.findByName("Australian National Herbarium")
        response += col1.name + "<br>"
        def fors2 = col1.getContacts()
        fors2.each {response += '_' + it.contact + "<br>"}

        def inst2 = Institution.findByAcronym('CSIRO')
        response += inst2.name + "<br>"
        def children = inst2?.getCollections()
        children?.each {
            response += '_' + it.name + "<br>"
        }

        render response
    }
}
