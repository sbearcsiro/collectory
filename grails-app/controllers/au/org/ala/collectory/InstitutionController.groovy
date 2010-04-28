package au.org.ala.collectory

class InstitutionController {

    def scaffold = ProviderGroup

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        //println "Count = " + ProviderGroup.countByGroupType('Institution')
        [institutionInstanceList: ProviderGroup.findAllByGroupType("Institution", params),
                institutionInstanceTotal: ProviderGroup.countByGroupType('Institution')]
    }

    def show = {
        def institutionInstance = ProviderGroup.get(params.id)
        if (!institutionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'institution.label', default: 'Institution'), params.id])}"
            redirect(action: "list")
        }
        else {
            [institutionInstance: institutionInstance, contacts: institutionInstance.getContacts()]
        }
    }

}
