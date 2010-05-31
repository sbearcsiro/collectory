package au.org.ala.collectory

import grails.test.GrailsUnitTestCase

/**
 * Created by IntelliJ IDEA.
 * User: markew
 * Date: May 6, 2010
 * Time: 12:05:48 PM
 * To change this template use File | Settings | File Templates.
 */
class ProviderGroupIntTests extends GrailsUnitTestCase {

    ProviderGroup pg1
    ProviderGroup pg2
    ProviderGroup pg3
    ProviderGroup pg4
    ProviderGroup pg5
    ProviderGroup pg6

    protected void setUp() {
        super.setUp()
        pg1 = new ProviderGroup(guid: '237645', name: 'CSIRO', groupType: ProviderGroup.GROUP_TYPE_INSTITUTION).save()
        pg2 = new ProviderGroup(guid: '237646', name: 'ANU', groupType: ProviderGroup.GROUP_TYPE_INSTITUTION).save()
        pg3 = new ProviderGroup(guid: '237647', name: 'MA', groupType: ProviderGroup.GROUP_TYPE_INSTITUTION).save()
        pg4 = new ProviderGroup(guid: '237648', name: 'UOFA', groupType: ProviderGroup.GROUP_TYPE_INSTITUTION).save()
        pg5 = new ProviderGroup(guid: '237649', name: 'Bees', groupType: ProviderGroup.GROUP_TYPE_COLLECTION).save()
        pg6 = new ProviderGroup(guid: '237650', name: 'Wasps', groupType: ProviderGroup.GROUP_TYPE_COLLECTION).save(flush:true)
   }

    protected void tearDown() {
        super.tearDown()
    }

    void testListInstitutions() {

//        List orderedListOfInstitutions = ProviderGroup.findAllByGroupType('Institution', [sort:'name'])
        List orderedListOfInstitutions = ProviderGroup.listInstitutions()

        assertEquals 4, orderedListOfInstitutions.size()
        assertEquals 'ANU', orderedListOfInstitutions[0].name

    }

    void testGetParentInstitutionsOrderedByName() {
        ProviderGroup col = new ProviderGroup(guid: '1237645', name: 'ANIC', groupType: ProviderGroup.GROUP_TYPE_COLLECTION)
        col.addToParents pg1
        col.addToParents pg2

        List orderedParents = col.getParentInstitutionsOrderedByName()

        assertEquals 2, orderedParents.size()
        assertEquals "ANU", orderedParents[0].name
    }
}
