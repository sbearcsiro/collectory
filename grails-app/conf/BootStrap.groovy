import au.org.ala.collectory.ProviderGroup
import au.org.ala.collectory.Image
import au.org.ala.collectory.Contact
import grails.util.GrailsUtil
import grails.converters.JSON
import au.org.ala.custom.marshalling.DomainClassWithUidMarshaller

class BootStrap {
    def grailsApplication
    def dataLoaderService
    def authenticateService

    def init = { servletContext ->
        // custom marshaller to put UID into the JSON representation of associations
        JSON.registerObjectMarshaller( new DomainClassWithUidMarshaller(false, grailsApplication), 2)
    }

    def destroy = {
    }

    void loadTestData() {
        ///*
        dataLoaderService.loadBCIData("/data/collectory/bootstrap/lookup_lsid.csv")

        // load some images for testing
        ProviderGroup csiro = ProviderGroup.findByName('Australian Commonwealth Scientific and Research Organization (CSIRO)')
        if (csiro) {
            csiro.logoRef = new Image(file: '20050920_csiro50.gif')
        }
        ProviderGroup uofa = ProviderGroup.findByName('University of Adelaide')
        if (uofa) {
            uofa.logoRef = new Image(file: 'uofa_home.gif')
        }
        ProviderGroup anic = ProviderGroup.findByAcronym('ANIC')
        if (anic) {
            anic.imageRef = new Image(file: 'p8em.jpg')
        }
        ProviderGroup ame = ProviderGroup.findByName('Australian Museum - Entomology')
        if (ame) {
            ame.imageRef = new Image(file: 'section-insects.jpg')
        }
        ProviderGroup amh = ProviderGroup.findByName('Australian Museum - Herpetology')
        if (amh) {
            amh.imageRef = new Image(file: 'SHU-3562_small.jpg',
                    caption:"Baby Crocodile from the Australian Museum's Surviving Australia exhibition",
                    attribution:'Carl Bento',
                    copyright:'� Australian Museum')
        }
        ProviderGroup adt = ProviderGroup.findByName('Antarctic Division Herbarium')

        /*ProviderGroup anu = new ProviderGroup(guid: '9999', name: 'Australian National University',
                address: new Address(street: 'Acton', postBox: 'GPO Box 1700', city: 'Canberra', state: 'ACT', postcode: '2601'),
                latitude: -35.762000, longitude: 149.114000, institutionType: 'university',
                logoRef: new Image(file: 'ANURGB_REV.gif'),
                imageRef: new Image(file: 'student_hub.jpg', copyright: '� ANU'),
                groupType: ProviderGroup.GROUP_TYPE_INSTITUTION,
                userLastModified: 'bootstrap').save(flush:true)
        if (anu?.hasErrors) {
            anu.errors.each {println it}
        }*/

        // add a test user for security checking
        Contact test = new Contact(firstName: 'Mark', lastName: 'Woolston', email: 'mark.woolston@csiro.au', userLastModified: 'bootstrap').save(flush: true)
        [ame, anic, adt].each {
            it?.addToContacts test, 'Tester', true, false, 'bootstrap'
        }

        // save changes
        [csiro, uofa, anic, ame, amh].each {
            it?.userLastModified = 'bootstrap'
            it?.save(flush:true)
        }

        /* add some access control

        // roles
        Role admin = new Role(authority: ProviderGroup.ROLE_ADMIN, description: 'Allows full control of all collectory data').save(flush: true)
        Role supplier = new Role(authority: ProviderGroup.ROLE_EDITOR, description: 'Can edit collections that have a matching contact with admin rights').save(flush: true)

        // url mapping
        new SecRequestMap(url: '/collection/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)
        new SecRequestMap(url: '/institution/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)
        new SecRequestMap(url: '/contact/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)
        new SecRequestMap(url: '/providerGroup/**', configAttribute: 'ROLE_ADMIN, ROLE_SUPPLIER').save(flush: true)
        new SecRequestMap(url: '/logon/**', configAttribute: ProviderGroup.ROLE_ADMIN).save(flush: true)
        new SecRequestMap(url: '/role/**', configAttribute: ProviderGroup.ROLE_ADMIN).save(flush: true)
        new SecRequestMap(url: '/secRequestMap/**', configAttribute: ProviderGroup.ROLE_ADMIN).save(flush: true)

        // logons
        Logon mark = new Logon(username: 'mark.woolston@csiro.au', userRealName: 'MEW', enabled: true)
        mark.passwd = authenticateService?.encodePassword('test')
        mark.save(flush: true)
        admin.addToPeople mark

        Logon dena = new Logon(username: 'dena.paris@csiro.au', userRealName: 'Dena Paris', enabled:true)
        dena.passwd = authenticateService?.encodePassword('cs5')
        dena.save(flush: true)
        supplier.addToPeople mark

        Logon dave = new Logon(username: 'david.martin@csiro.au', userRealName: 'Dave Martin', enabled:true)
        dave.passwd = authenticateService?.encodePassword('halfpipe')
        dave.save(flush: true)
        admin.addToPeople dave

        Logon pete = new Logon(username: 'peter.neville@csiro.au', userRealName: 'Peter Neville', enabled:true)
        pete.passwd = authenticateService?.encodePassword('peter')
        pete.save(flush: true)
        admin.addToPeople pete

        Logon donald = new Logon(username: 'donald.hobern@csiro.au', userRealName: 'Donald Hobern', enabled:true)
        donald.passwd = authenticateService?.encodePassword('tomtower')
        donald.save(flush: true)
        admin.addToPeople donald

        Logon lemmy = new Logon(username: 'lemmy@caution.com', userRealName: 'Lemmy Caution', enabled:true)
        lemmy.passwd = authenticateService?.encodePassword('test')
        lemmy.save(flush: true)
        supplier.addToPeople lemmy
*/
    }
} 