package au.org.ala.security

import au.org.ala.security.Logon

/**
 * Authority domain class.
 */
class Role {

	static hasMany = [people: Logon]

	/** description */
	String description
	/** ROLE String */
	String authority

	static constraints = {
		authority(blank: false, unique: true)
		description()
	}
}
