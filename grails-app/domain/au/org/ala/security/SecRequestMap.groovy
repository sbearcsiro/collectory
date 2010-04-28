package au.org.ala.security

/**
 * Request Map domain class.
 */
class SecRequestMap {

	String url
	String configAttribute

	static constraints = {
		url(blank: false, unique: true)
		configAttribute(blank: false)
	}
}
