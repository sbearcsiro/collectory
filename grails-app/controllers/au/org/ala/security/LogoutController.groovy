package au.org.ala.security

import au.org.ala.collectory.ActivityLog
/**
 * Logout Controller (Example).
 */
class LogoutController {

    /**
     * Dependency injection for the authentication service.
     */
    def authenticateService

	/**
	 * Index action. Redirects to the Spring security logout uri.
	 */
	def index = {
		// put any pre-logout code here
        ActivityLog.log(authenticateService.userDomain().username, au.org.ala.collectory.Action.LOGOUT)
		redirect(uri: '/j_spring_security_logout')
	}
}
