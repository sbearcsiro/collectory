package au.org.ala.collectory

import grails.converters.JSON

class AdminController {

    def authenticateService, dataLoaderService

    def index = { }

    def loadSupplementary = {
        boolean override = params.override ? params.override : false
        log.info ">>${authenticateService.userDomain().username} loading supplimentary data"
        dataLoaderService.loadSupplementaryData("/data/collectory/bootstrap/sup.json", override, authenticateService.userDomain().username)
        ActivityLog.log authenticateService.userDomain().username, Action.DATA_LOAD
        redirect(url: "http://localhost:8080/Collectory")  //action: "list")
    }

    def loadAmrrnData = {
        log.info ">>${authenticateService.userDomain().username} loading amrrn data"
        dataLoaderService.loadAmrrnData()
        ActivityLog.log authenticateService.userDomain().username, Action.DATA_LOAD
        redirect(url: "http://localhost:8080/Collectory")  //action: "list")
    }

    /**
     * Export all tables as JSON
     */
    def export = {
        println params.table
        if (params.table) {
            switch (params.table) {
                case 'contact': render Contact.list() as JSON; break
                case 'contactFor': render ContactFor.list() as JSON; break
                case 'providerGroup': render ProviderGroup.list() as JSON; break
                case 'collection': render ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION) as JSON; break
                case 'institution': render ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION) as JSON; break
                case 'collectionScope': render CollectionScope.list() as JSON; break
                case 'infoSource': render InfoSource.list() as JSON; break
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
                    providerGroup: ProviderGroup.list(),
                    collectionScope: CollectionScope.list(),
                    infoSource: InfoSource.list(),
                    providerCode: ProviderCode.list(),
                    providerMap: ProviderMap.list()
            ]
            render result as JSON
        }
    }
}
