package au.org.ala.collectory

import grails.converters.JSON
import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.commons.ConfigurationHolder

/**
 * This is a base class for all provider group entities types.
 *
 * It provides common code for shared attributes like contacts.
 */
abstract class ProviderGroupController {

    static String entityName = "ProviderGroup"
    static String entityNameLower = "providerGroup"

    def idGeneratorService

    /**
     * Edit base attributes.
     * @param id - the database id
     */
    def edit = {
        def pg = get(params.id)
        if (!pg) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "list")
        } else {
            params.page = params.page ?: '/shared/base'
            render(view:params.page, model:[command: pg, target: params.target])
        }
    }

    def editAttributions = {
        def pg = get(params.id)
        if (!pg) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "list")
        } else {
            render(view: '/shared/attributions', model:[BCI: pg.hasAttribution('at1'), CHAH: pg.hasAttribution('at2'),
                    CHACM: pg.hasAttribution('at3'), command: pg])
        }
    }

    /**
     * Create a new entity instance.
     *
     */
    def create = {
        ProviderGroup pg
        switch (entityName) {
            case Collection.ENTITY_TYPE:
                pg = new Collection(uid: idGeneratorService.getNextCollectionId(), name: 'enter name', userLastModified: username())
                if (params.institutionUid && Institution.findByUid(params.institutionUid)) {
                    pg.institution = Institution.findByUid(params.institutionUid)
                }
                break
            case Institution.ENTITY_TYPE:
                pg = new Institution(uid: idGeneratorService.getNextInstitutionId(), name: 'enter name', userLastModified: username()); break
            case DataProvider.ENTITY_TYPE:
                pg = new DataProvider(uid: idGeneratorService.getNextDataProviderId(), name: 'enter name', userLastModified: username()); break
            case DataResource.ENTITY_TYPE:
                pg = new DataResource(uid: idGeneratorService.getNextDataResourceId(), name: 'enter name', userLastModified: username())
            if (params.dataProviderUid && DataProvider.findByUid(params.dataProviderUid)) {
                pg.dataProvider = DataProvider.findByUid(params.dataProviderUid)
            }
            break
            case DataHub.ENTITY_TYPE:
                pg = new DataHub(uid: idGeneratorService.getNextDataHubId(), name: 'enter name', userLastModified: username()); break
        }
        if (!pg.hasErrors() && pg.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: "${pg.urlForm()}", default: pg.urlForm()), pg.uid])}"
            redirect(action: "show", id: pg.id)
        } else {
            flash.message = "Failed to create new ${entityName}"
            redirect(controller: 'admin', action: 'index')
        }
    }

    def cancel = {
        println "Cancel - returnTo = ${params.returnTo}"
        if (params.returnTo) {
            redirect(uri: params.returnTo)
        } else {
            redirect(action: "show", id: params.id)
        }
    }

    /**
     * Update base attributes
     */
    def updateBase = {BaseCommand cmd ->
        if(cmd.hasErrors()) {
            cmd.errors.each {println it}
            cmd.id = params.id as int   // these do not seem to be injected
            cmd.version = params.version as int
            render(view:'/shared/base', model: [command: cmd])
        } else {
            def pg = get(params.id)
            if (pg) {
                if (params.version) {
                    def version = params.version.toLong()
                    if (pg.version > version) {
                        pg.errors.rejectValue("version", "default.optimistic.locking.failure",
                                [message(code: "${pg.urlForm()}.label", default: pg.entityType())] as Object[],
                                "Another user has updated this ${pg.entityType()} while you were editing")
                        render(view: "/shared/base", model: [command: pg])
                        return
                    }
                }

                // special handling for membership
                pg.networkMembership = toJson(params.networkMembership)
                params.remove('networkMembership')

                pg.properties = params
                pg.userLastModified = username()
                if (!pg.hasErrors() && pg.save(flush: true)) {
                    flash.message =
                        "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
                    redirect(action: "show", id: pg.id)
                }
                else {
                    render(view: "/shared/base", model: [command: pg])
                }
            } else {
                flash.message =
                    "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
    }

    /**
     * Update descriptive attributes
     */
    def updateDescription = {
        def pg = get(params.id)
        if (pg) {
            if (params.version) {
                def version = params.version.toLong()
                if (pg.version > version) {
                    pg.errors.rejectValue("version", "default.optimistic.locking.failure",
                            [message(code: "${pg.urlForm()}.label", default: pg.entityType())] as Object[],
                            "Another user has updated this ${pg.entityType()} while you were editing")
                    render(view: "description", model: [command: pg])
                    return
                }
            }

            // do any entity specific processing
            entitySpecificDescriptionProcessing(pg, params)

            pg.properties = params
            pg.userLastModified = username()
            if (!pg.hasErrors() && pg.save(flush: true)) {
                flash.message =
                  "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
                redirect(action: "show", id: pg.id)
            }
            else {
                render(view: "description", model: [command: pg])
            }
        } else {
            flash.message =
                "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    def entitySpecificDescriptionProcessing(pg, params) {
        // default is to do nothing
        // sub-classes override to do specific processing
    }
    
    /**
     * Update location attributes
     */
    def updateLocation = {LocationCommand cmd ->
        if(cmd.hasErrors()) {
            cmd.id = params.id as int   // these do not seem to be injected
            cmd.version = params.version as int
            render(view:'/shared/location', model: [command: cmd])
        } else {
            def pg = get(params.id)
            if (pg) {
                if (params.version) {
                    def version = params.version.toLong()
                    if (pg.version > version) {
                        pg.errors.rejectValue("version", "default.optimistic.locking.failure",
                                [message(code: "${pg.urlForm()}.label", default: pg.entityType())] as Object[],
                                "Another user has updated this ${pg.entityType()} while you were editing")
                        render(view: "/shared/location", model: [command: pg])
                        return
                    }
                }

                // special handling for lat & long
                if (!params.latitude) { params.latitude = -1 }
                if (!params.longitude) { params.longitude = -1 }

                // special handling for embedded address - need to create address obj if none exists and we have data
                if (!pg.address && [params.address.street, params.address.postBox, params.address.city,
                    params.address.state, params.address.postcode, params.address.country].join('').size() > 0) {
                    pg.address = new Address()
                }

                pg.properties = params
                pg.userLastModified = username()
                if (!pg.hasErrors() && pg.save(flush: true)) {
                    flash.message =
                      "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
                    redirect(action: "show", id: pg.id)
                } else {
                    render(view: "/shared/location", model: [command: pg])
                }
            } else {
                flash.message =
                    "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
    }

    def updateContactRole = {
        params.each {println it}
        def contactFor = ContactFor.get(params.contactForId)
        if (contactFor) {
            contactFor.properties = params
            contactFor.userLastModified = username()
            if (!contactFor.hasErrors() && contactFor.save(flush: true)) {
                flash.message = "${message(code: 'contactRole.updated.message', args: [params.id])}"
                redirect(action: "edit", id: params.id, params: [page: '/shared/showContacts'])
            } else {
                render(view: '/shared/contactRole', model: [command: ProviderGroup._get(params.id), cf: contactFor])
            }

        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contactFor.label', default: "Contact for ${entityNameLower}"), params.contactForId])}"
            redirect(action: "show", id: params.id)
        }
    }

    def addContact = {
        def pg = get(params.id)
        if (!pg) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "list")
        } else {
            Contact contact = Contact.get(params.addContact)
            if (contact) {
                pg.addToContacts(contact, "editor", true, false, username())
                redirect(action: "edit", params: [page:"/shared/showContacts"], id: params.id)
            }
        }
    }

    def addNewContact = {
        def pg = get(params.id)
        def contact = Contact.get(params.contactId)
        if (contact && pg) {
            // add the contact to the collection
            pg.addToContacts(contact, "editor", true, false, username())
            redirect(action: "edit", params: [page:"/shared/showContacts"], id: pg.id)
        } else {
            if (!pg) {
                flash.message = "Contact was created but ${entityNameLower} could not be found. Please edit ${entityNameLower} and add contact from existing."
                redirect(action: "list")
            } else {
                // contact must be null
                flash.message = "Contact was created but could not be added to the ${pg.urlForm()}. Please add contact from existing."
                redirect(action: "edit", params: [page:"/shared/showContacts"], id: pg.id)
            }
        }
    }

    def removeContact = {
        def pg = get(params.id)
        if (!pg) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "list")
        } else {
            ContactFor cf = ContactFor.get(params.idToRemove)
            if (cf) {
                cf.delete()
                redirect(action: "edit", params: [page:"/shared/showContacts"], id: params.id)
            }
            /*Contact contact = Contact.get(params.contactIdToRemove)
            if (contact) {
                collection.deleteFromContacts(contact)
                redirect(action: "edit", params: [page:"/shared/showContacts"], id: params.id)
            }*/
        }
    }

    def editRole = {
        def contactFor = ContactFor.get(params.id)
        if (!contactFor) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'contactFor.label', default: "Contact for ${entityNameLower}"), params.id])}"
            redirect(action: "list")
        } else {
            ProviderGroup pg = ProviderGroup._get(contactFor.entityUid)
            if (pg) {
                render(view: '/shared/contactRole', model: [command: pg, cf: contactFor, returnTo: params.returnTo])
            } else {
                // TODO:
            }
        }
    }

    /**
     * Get the instance for this entity based on either uid or DB id.
     * All sub-classes must implement this method.
     *
     * @param id UID or DB id
     * @return the entity of null if not found
     */
    abstract protected ProviderGroup get(id)

    /**
     * Update images
     */
    def updateImages = {
        def pg = get(params.id)
        def target = params.target ?: "imageRef"
        if (pg) {
            if (params.version) {
                def version = params.version.toLong()
                if (pg.version > version) {
                    pg.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: "${pg.urlForm()}.label", default: pg.entityType())] as Object[], "Another user has updated this ${pg.urlForm()} while you were editing")
                    render(view: "/shared/images", model: [command: pg, target: target])
                    return
                }
            }
            // special handling for uploading image
            // we need to account for:
            //  a) upload of new image
            //  b) change of metadata for existing image
            // removing an image is handled separately
            MultipartFile file
            switch (target) {
                case 'imageRef': file = params.imageFile; break
                case 'logoRef': file = params.logoFile; break
            }
            if (file?.size) {  // will only have size if a file was selected
                // save the chosen file
                if (file.size < 200000) {   // limit file to 200Kb
                    def filename = file.getOriginalFilename()
                    log.debug "filename=${filename}"

                    // update filename
                    pg."${target}" = new Image(file: filename)
                    String subDir = pg.urlForm()

                    def colDir = new File(ConfigurationHolder.config.repository.location.images as String, subDir)
                    colDir.mkdirs()
                    File f = new File(colDir, filename)
                    log.debug "saving ${filename} to ${f.absoluteFile}"
                    file.transferTo(f)
                    ActivityLog.log username(), isAdmin(), Action.UPLOAD_IMAGE, filename
                } else {
                    println "reject file of size ${file.size}"
                    pg.errors.rejectValue('imageRef', 'image.too.big', 'The image you selected is too large. Images are limited to 200KB.')
                    render(view: "/shared/images", model: [command: pg, target: target])
                    return
                }
            }
            pg.properties = params
            pg.userLastModified = username()
            if (!pg.hasErrors() && pg.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
                redirect(action: "show", id: pg.id)
            } else {
                render(view: "/shared/images", model: [command: pg, target: target])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityName), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    def removeImage = {
        def pg = get(params.id)
        if (pg) {
            if (params.version) {
                def version = params.version.toLong()
                if (pg.version > version) {
                    pg.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: "${pg.urlForm()}.label", default: pg.entityType())] as Object[], "Another user has updated this ${pg.entityType()} while you were editing")
                    render(view: "/shared/images", model: [command: pg])
                    return
                }
            }

            if (params.target == 'logoRef') {
                pg.logoRef = null
            } else {
                pg.imageRef = null
            }
            pg.userLastModified = username()
            if (!pg.hasErrors() && pg.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
                redirect(action: "show", id: pg.id)
            } else {
                render(view: "/shared/images", model: [command: pg])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    def updateAttributions = {
        def pg = get(params.id)
        if (pg) {
            if (params.version) {
                def version = params.version.toLong()
                if (pg.version > version) {
                    pg.errors.rejectValue("version", "default.optimistic.locking.failure",
                            [message(code: "${pg.urlForm()}.label", default: pg.entityType())] as Object[],
                            "Another user has updated this ${pg.entityType()} while you were editing")
                    render(view: "description", model: [command: pg])
                    return
                }
            }

            if (params.BCI && !pg.hasAttribution('at1')) {
                pg.addAttribution 'at1'
            }
            if (!params.BCI && pg.hasAttribution('at1')) {
                pg.removeAttribution 'at1'
            }
            if (params.CHAH && !pg.hasAttribution('at2')) {
                pg.addAttribution 'at2'
            }
            if (!params.CHAH && pg.hasAttribution('at2')) {
                pg.removeAttribution 'at2'
            }
            if (params.CHACM && !pg.hasAttribution('at3')) {
                pg.addAttribution 'at3'
            }
            if (!params.CHACM && pg.hasAttribution('at3')) {
                pg.removeAttribution 'at3'
            }

            if (pg.isDirty()) {
                pg.userLastModified = username()
                if (!pg.hasErrors() && pg.save(flush: true)) {
                    flash.message =
                      "${message(code: 'default.updated.message', args: [message(code: "${pg.urlForm()}.label", default: pg.entityType()), pg.uid])}"
                    redirect(action: "show", id: pg.id)
                }
                else {
                    render(view: "description", model: [command: pg])
                }
            } else {
                redirect(action: "show", id: pg.id)
            }
        } else {
            flash.message =
                "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityNameLower), params.id])}"
            redirect(action: "show", id: params.id)
        }
    }

    protected String username() {
        return (request.getUserPrincipal()?.attributes?.email) ? request.getUserPrincipal()?.attributes?.email :'not available'
    }

    protected boolean isAdmin() {
        return (request.isUserInRole(ProviderGroup.ROLE_ADMIN))
    }

    protected String toJson(param) {
        if (!param) {
            return ""
        }
        if (param instanceof String) {
            // single value
            return ([param] as JSON).toString()
        }
        def list = param.collect {
            it.toString()
        }
        return (list as JSON).toString()
    }

    protected String toSpaceSeparatedList(param) {
        if (!param) {
            return ""
        }
        if (param instanceof String) {
            // single value
            return param
        }
        return param.join(' ')
    }

}
