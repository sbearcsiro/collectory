package au.org.ala.collectory
/*
 * Tests the parent-child relationships between groups
 */

import grails.test.*

class GroupHierarchyTests extends GrailsUnitTestCase {

    ProviderGroup csiro
    ProviderGroup anic
    ProviderGroup moths

    protected void setUp() {
        super.setUp()
        csiro = new ProviderGroup(
                guid: "7654723458",
                name: "CSIRO",
                groupType: "Institution")

        csiro.address = new Address(state: 'ACT')

        anic = new ProviderGroup(
                guid: "urn:lsid:biocol.org:col:32981",
                name: "ANIC",
                groupType: "Collection ProviderGroup")

        moths = new ProviderGroup(
                guid: "dfghskfgh",
                name: "Lepidoptera",
                groupType: "Collection")
    }

    protected void tearDown() {
        super.tearDown()
    }

    void testParentChild() {
        anic.addToChildren(moths)
        moths.addToParents(anic)

        assertEquals 1, anic.children.size()
        assertEquals 1, moths.parents?.size()
        assertTrue moths.parents.contains(anic)
        assertNotNull moths.parents.find { it == anic}
    }

    void testHierarchy() {
        csiro.addToChildren anic
        anic.addToParents csiro

        anic.addToChildren moths
        moths.addToParents anic

        assertNotNull moths.parents.find {it == anic}.parents.find {it == csiro}
        assertNotNull csiro.children.find {it == anic}.children.find {it == moths}

    }

    void testIsALAPartnerInheritance() {
        csiro.isALAPartner = true
        moths.isALAPartner = false

        moths.addToParents(csiro)
        csiro.addToChildren(moths)

        assertTrue moths.getIsALAPartner()
        assertTrue moths.isALAPartner
    }
}
