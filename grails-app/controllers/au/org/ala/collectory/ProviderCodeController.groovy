package au.org.ala.collectory

import org.codehaus.groovy.grails.commons.ConfigurationHolder

class ProviderCodeController {

    static scaffold = true

    def authService
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

}
