package au.org.ala.collectory

import org.codehaus.groovy.grails.plugins.springsecurity.AuthorizeTools

class CollectoryTagLib {

    def authenticateService

    static namespace = 'cl'

    def roleIfPresent = { attrs, body ->
        out << (attrs.role == '' ? '' : ' - ' + attrs.role)
    }

    def adminIfPresent = { attrs, body ->
        //out << 'Is admin = ' + attrs.isAdministrator
        out << (attrs.admin ? '(Authorised to edit this collection)' : '')
    }

    def isAuth = { attrs, body ->
        boolean authorised = false
        //String debugString = '<br/>Debug: '
        if (AuthorizeTools.ifAllGranted('ROLE_ADMIN')) {
            authorised = true
        } else {
            //debugString += 'User is ' + attrs.user
            Contact c = Contact.findByEmail(attrs.user)
            if (c) {
                //debugString += '<br/>Contact matched ' + c.buildName()
                ContactFor cf = ContactFor.findByContactAndEntityId(c, attrs.collection)
                //if (cf) {
                //    debugString += '<br/>Contact is for this collection'
                //}
                //debugString += '<br/>Contact ' + (cf.adminstrator ? 'is' : 'is not') + ' an administrator'
                authorised = cf?.administrator
            //} else {
            //    Contact.findAll().each() {
            //        debugString += '<br/>' + it.email + (it.email?.contains(attrs.user) ? ' *' : ' -')
            //    }
            }
        }
        if (authorised) {
            out << body()
        } else {
            out << ' You are not authorised to change this collection '// + debugString
        }
    }

    def showObject = { attrs ->
        def obj = attrs.obj
        out << obj?.class
    }
}
