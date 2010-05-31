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

/*
    void testNumberIfKnown() {
        tagLib.numberIfKnown(number: -12) { number ->
            out << number
            '&deg;'
        }
        assertEquals '-12&deg;', tagLib.out.toString()
    }
*/

    /*void testIdList() {
        List list = [new IdHelper(name: 'wally', id: 1), new IdHelper(name: 'wally', id: 2), new IdHelper(name: 'wally', id: 3)]
        assertEquals '[1, 2, 3]', list.collect {it?.id}
    
        tagLib.idList(list: list) { l ->
            out << l
        }
        assertEquals '[1,2,3]', tagLib.out.toString()

    }*/

}
