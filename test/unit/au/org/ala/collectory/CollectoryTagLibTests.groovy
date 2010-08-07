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

    void testNumberIfKnown_NotKnown() {
        tagLib.numberIfKnown(number: -1, body:'&deg;') { number ->
            out << number
        }
        assertEquals '', tagLib.out.toString()
    }

    /*void testFormattedText_1() {
        tagLib.formattedText(body:"line1line2") { result ->
            out << result
        }
    }*/
}
