package au.org.ala.collectory
/*  represents a parent-child link between groups - used to create a heirarchy
 *  eg a collection belongs to an institution
 *
 *  - based on collectory data model version 5
 */

class GroupLink {

    long parentId
    long childId

}
