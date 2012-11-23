package au.org.ala.collectory

import grails.converters.deep.JSON
import org.apache.commons.lang.StringUtils

class AandsController {

    def index = {
        def resConnectionParameters = [:]
        def resContentTypes = [:]
        for (res in DataResource.list()) {
            def connectionParametersJson = res.connectionParameters
            if (connectionParametersJson != null) {
                def obj = JSON.parse(connectionParametersJson)
                resConnectionParameters[res.uid] = obj
            }

            def contentTypesJson = res.contentTypes
            if (contentTypesJson != null) {
                def obj = JSON.parse(contentTypesJson)
                resContentTypes[res.uid] = StringUtils.join(obj, ',')
            }
        }

        [providers: DataProvider.list([sort: 'uid']), resources: DataResource.list(sort: 'uid'), resConnectionParameters: resConnectionParameters, resContentTypes: resContentTypes]
    }
}
