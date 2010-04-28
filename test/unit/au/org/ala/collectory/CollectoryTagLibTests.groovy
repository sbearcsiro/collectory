package au.org.ala.collectory

import grails.test.*

class CollectoryTagLibTests extends TagLibUnitTestCase {

    protected void setUp() {
        super.setUp()
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testRoleIfPresent() {
        tagLib.roleIfPresent(role: 'Manager') { role ->
            out << role
        }
        assertEquals ' - Manager', tagLib.out.toString()
    }

    void testAdminIfPresent() {
        tagLib.adminIfPresent(admin: true) { admin ->
            out << admin
        }
        assertEquals '(Authorised to edit this collection)', tagLib.out.toString()
    }
    
}
