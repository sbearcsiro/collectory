package au.org.ala.collectory

import org.springframework.web.context.request.RequestContextHolder
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class AuthService {

    static transactional = false

    def username() {
        return (RequestContextHolder.currentRequestAttributes()?.getUserPrincipal()?.attributes?.email)?:'not available'
    }

    def isAdmin() {
        return ConfigurationHolder.config.security.cas.bypass ||
                RequestContextHolder.currentRequestAttributes()?.isUserInRole(ProviderGroup.ROLE_ADMIN)
    }

    protected boolean userInRole(role) {
        return ConfigurationHolder.config.security.cas.bypass ||
                RequestContextHolder.currentRequestAttributes()?.isUserInRole(role) ||
                isAdmin()
    }

    protected boolean isAuthorisedToEdit(uid) {
        if (ConfigurationHolder.config.security.cas.bypass || isAdmin()) {
            return true
        } else {
            def email = RequestContextHolder.currentRequestAttributes()?.getUserPrincipal()?.attributes?.email
            if (email) {
                Contact c = Contact.findByEmail(email)
                if (c) {
                    ContactFor cf = ContactFor.findByContactAndEntityUid(c, uid)
                    return cf?.administrator
                }
            }
        }
        return false
    }

}