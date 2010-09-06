package au.org.ala.collectory

import grails.converters.JSON
import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.commons.ConfigurationHolder

/**
 * This is a base class for all provider group entities types.
 *
 * It provides common code for shared attributes like contacts.
 */
class ProviderGroupController {

    static String entityName = "ProviderGroup"
    static String entityNameLower = "providerGroup"

    /**
     * Edit base attributes.
     * @param id - the database id
     */
    def edit = {
        def pg = get(params.id)
        if (!pg) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityName), params.id])}"
            redirect(action: "list")
        } else {
            params.page = params.page ?: '/shared/base'
            println params.page
            render(view:params.page, model:[command: pg, target: params.target])
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
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}".label, default: entityName), params.id])}"
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
                flash.message = "Contact was created but could not be added to the ${entityNameLower}. Please add contact from existing."
                redirect(action: "edit", params: [page:"/shared/showContacts"], id: pg.id)
            }
        }
    }

    def removeContact = {
        def pg = get(params.id)
        if (!pg) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityName), params.id])}"
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

    protected ProviderGroup get(id) {
        switch (entityName) {
            case Collection.ENTITY_TYPE:
                return (id?.toString()?.startsWith(Collection.ENTITY_PREFIX)) ? Collection.findByUid(params.id) : Collection.get(params.id)
            case Institution.ENTITY_TYPE:
                return (id?.toString()?.startsWith(Institution.ENTITY_PREFIX)) ? Institution.findByUid(params.id) : Institution.get(params.id)
            case DataProvider.ENTITY_TYPE:
                return (id?.toString()?.startsWith(DataProvider.ENTITY_PREFIX)) ? DataProvider.findByUid(params.id) : DataProvider.get(params.id)
            case DataResource.ENTITY_TYPE:
                return (id?.toString()?.startsWith(DataResource.ENTITY_PREFIX)) ? DataResource.findByUid(params.id) : DataResource.get(params.id)
            case DataHub.ENTITY_TYPE:
                return (id?.toString()?.startsWith(DataHub.ENTITY_PREFIX)) ? DataHub.findByUid(params.id) : DataHub.get(params.id)
        }
    }

    /**
     * Update images
     */
    def updateImages = {
        //params.each {println it}
        def pg = get(params.id)
        def target = params.target ?: "imageRef"
        if (pg) {
            if (params.version) {
                def version = params.version.toLong()
                if (pg.version > version) {
                    pg.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: "${entityNameLower}.label", default: entityName)] as Object[], "Another user has updated this ${entityNameLower} while you were editing")
                    render(view: "images", model: [command: pg])
                    return
                }
            }
            // special handling for uploading image
            // we need to account for:
            //  a) upload of new image
            //  b) change of metadata for existing image
            // removing an image is handled separately
            MultipartFile file = params.imageFile
            if (file?.size) {  // will only have size if a file was selected
                // save the chosen file
                def content = request.getFile('imageFile')
                if (content && file.size < 200000) {   // limit file to 200Kb
                    def filename = file.getOriginalFilename()
                    log.debug "filename=${filename}"

                    // update filename
                    pg."${target}" = new Image(file: filename)

                    def colDir = new File(ConfigurationHolder.config.repository.location.images as String, entityNameLower)
                    colDir.mkdirs()
                    File f = new File(colDir, filename)
                    log.debug "saving ${filename} to ${f.absoluteFile}"
                    content.transferTo(f)
                    ActivityLog.log username(), isAdmin(), Action.UPLOAD_IMAGE, filename
                } else {
                    println "reject file of size ${file.size}"
                    pg.errors.reject('image.too.big', 'The image you selected is too large. Images are limited to 200KB.')
                    pg.errors.rejectValue('imageRef.file', 'image.too.big')
                }
            }
            // handle too big error (cause setting props clears the error)
            if (pg.hasErrors()) {
                pg.errors.each{println it}
                render(view: "images", model: [command: pg, target: target])
            } else {
                pg.properties = params
                pg.userLastModified = username()
                if (!pg.hasErrors() && pg.save(flush: true)) {
                    flash.message = "${message(code: 'default.updated.message', args: [message(code: "${entityNameLower}.label", default: entityName), pg.uid])}"
                    redirect(action: "show", id: pg.id)
                }
                else {
                    render(view: "images", model: [command: pg])
                }
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: "${entityNameLower}.label", default: entityName), params.id])}"
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
