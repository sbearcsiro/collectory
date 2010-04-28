import au.org.ala.collectory.ProviderGroup
import au.org.ala.collectory.Image
import au.org.ala.collectory.Contact
import au.org.ala.security.Logon
import au.org.ala.security.Role
import au.org.ala.security.SecRequestMap

class BootStrap {

    def dataLoaderService
    def authenticateService


    def init = { servletContext ->
        ///*
        dataLoaderService.loadBCIData("/Users/markew/data/BCI/lookup_lsid.csv")

        // load some images for testing
        ProviderGroup csiro = ProviderGroup.findByName('CSIRO')
        if (csiro) {
            csiro.logoRef = new Image(file: '20050920_csiro50.gif')
        }
        ProviderGroup uofa = ProviderGroup.findByName('University of Adelaide')
        if (uofa) {
            uofa.logoRef = new Image(file: 'uofa_home.gif')
        }
        ProviderGroup anic = ProviderGroup.findByAcronym('ANIC')
        if (anic) {
            anic.logoRef = new Image(file: 'p8em.jpg')
        }

        // add a test user for security checking
        ProviderGroup ame = ProviderGroup.findByName('Australian Museum - Entomology')
        Contact test = new Contact(firstName: 'Mark', lastName: 'Woolston', email: 'mark.woolston@csiro.au').save(flush: true)
        ame.addToContacts test, 'Test', true

        /* add some access control */

        // roles
        Role admin = new Role(authority: 'ROLE_ADMIN', description: 'Allows full control of all collectory data').save(flush: true)
        Role supplier = new Role(authority: 'ROLE_SUPPLIER', description: 'Can edit collections that have a matching contact with admin rights').save(flush: true)

        // url mapping
        new SecRequestMap(url: '/collection/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)
        new SecRequestMap(url: '/institution/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)
        new SecRequestMap(url: '/contact/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)
        new SecRequestMap(url: '/providerGroup/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)

        // logons
        Logon mark = new Logon(username: 'mark.woolston@csiro.au', userRealName: 'MEW', enabled: true)
        mark.passwd = authenticateService?.encodePassword('test')
        mark.save(flush: true)
        admin.addToPeople mark
        //*/
    }

    def destroy = {
    }
} 