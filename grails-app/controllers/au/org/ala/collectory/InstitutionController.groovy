package au.org.ala.collectory

import grails.converters.JSON
import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class InstitutionController {

//    def authenticateService

    def scaffold = Institution

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        [institutionInstanceList: Institution.list(params),
                institutionInstanceTotal: Institution.count()]
    }

    def show = {
        def institutionInstance = get(params.id)
        if (!institutionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'institution.label', default: 'Institution'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.info "Ala partner = " + institutionInstance.isALAPartner
            ActivityLog.log username(), institutionInstance.uid, Action.VIEW
            [institutionInstance: institutionInstance, contacts: institutionInstance.getContacts()]
        }
    }

    def editInstitutionFlow = {
        start {
            action {
                def institutionInstance = get(params.id)
                if (!institutionInstance) {
                    flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'institution.label', default: 'Institution'), params.id])}"
                    redirect(action: "list")
                }
                else {
                    flow.providerGroupInstance = institutionInstance
                }
            }
            on("success").to "showEdit"
            on("failure").to "exitToList"
        }

        showEdit {
            render(view: "/institution/edit", model: [providerGroupInstance: flow.providerGroupInstance])
            on("done").to "done"
            on("cancel").to "cancel"
            /* TODO: removing images destroys changes as we are not binding params to the model - need a command object solution */
            on ("removeImage") {
                flow.providerGroupInstance.imageRef = null
            }.to "showEdit"
            on ("removeLogo") {
                flow.providerGroupInstance.logoRef = null
            }.to "showEdit"
            on ("create").to "createContact"
            on ("remove").to "removeContact"
            on ("add").to "addContact"
        }

        done {
            action {
                log.debug "Entered done event"
                //params.each {println it}

                def children = params.children
                children.each {
                    log.debug "Child: ${it}, ${it.class}"
                }
                params.parents.each {
                    log.debug "Parent: ${it}, ${it.class}"
                }
                Institution inst = Institution.get(params.id)
                if (inst) {
                    inst.refresh()  // this seems necessary to get the current version
                    log.debug "db version = ${inst.version}"
                    log.debug "params version = ${params.version}"
                    if (params.version && inst.version > params.version.toLong()) {
                        log.warn "Attempted to save a stale institution record - ${inst.name} version ${inst.version}"
                        inst.errors.rejectValue("version", "default.optimistic.locking.failure",
                                [message(code: 'providerGroup.label', default: 'ProviderGroup')] as Object[],
                                "Another user has updated this ProviderGroup while you were editing. New values have been refreshed. You will need to reapply your changes.")
                        flow.providerGroupInstance.discard()
                        flow.providerGroupInstance = inst
                        return error()
                    } else {
                        // update values
                        // need to create an address obj if one doesn't exist
                        if (inst.address == null && (params.address?.street || params.address.city)) {
                            log.debug "creating new address"
                            inst.address = new Address()
                        }
                        if (inst.address) {
                            inst.properties['address.street', 'address.postBox', 'address.city', 'address.state', 'address.postcode', 'address.country'] = params
                        }

                        // lat and long are shown as blank if the value is -1, and come back as blank which will be rejected
                        inst.latitude = params.latitude ? new BigDecimal(params.latitude) : ProviderGroup.NO_INFO_AVAILABLE
                        inst.longitude = params.longitude ? new BigDecimal(params.longitude) : ProviderGroup.NO_INFO_AVAILABLE

                        inst.properties['guid', 'name', 'acronym', 'websiteUrl', 'logoRef', 'imageRef', 'isALAPartner',
                                'institutionType', 'state', 'email', 'phone', 'pubDescription', 'techDescription', 'focus'] = params

                        // handle removed images
                        // file name is only in params if it has been added - cannot detect deleteion from the params
                        // therefore use the hidden field in params
                        println "_logoRef = " + params._logoFile
                        if (!params._logoFile) {
                            inst.logoRef = null
                        }
                        println "_imageRef = " + params._imageFile
                        if (!params._imageFile) {
                            inst.imageRef = null
                        }

                        // network membership can be returned as a String if there is a single value or a String []
                        if (params.networkMembership) {
                            def list
                            if (params.networkMembership instanceof String[]) {
                                list = params.networkMembership.toList()
                            } else {
                                list = new ArrayList() << params.networkMembership
                            }
                            inst.networkMembership = (list as JSON).toString();
                        }

                        // handle images
                        MultipartFile logoFile = params.logoFile
                        if (logoFile?.size) {  // will only have size if a file was selected
                            def filename = logoFile.getOriginalFilename()
                            log.debug "filename=${filename}"
                            // update filename
                            if (inst.logoRef) {
                                inst.logoRef.file = filename
                            } else {
                                inst.logoRef = new Image(file: filename)
                            }
                            // save the chosen file
                            def mhsr = request.getFile('logoFile')
                            if (!mhsr?.empty && mhsr.size < 1024*200) {   // limit file to 200Kb
                                def externalStore = ConfigurationHolder.config.repository.location.images
                                def colDir = new File(externalStore, "institution")
                                colDir.mkdirs()
                                File f = new File(colDir, filename)
                                log.debug "saving ${filename} to ${f.absoluteFile}"
                                mhsr.transferTo(f)
                                ActivityLog.log username(), Action.UPLOAD_IMAGE, filename
                            } else {
                                // TODO: handle error message
                            }
                        }
                        if (inst.logoRef) {
                            // just handle changes in the image metadata
                            inst.logoRef.caption = params.logoRef?.caption
                            inst.logoRef.attribution = params.logoRef?.attribution
                            inst.logoRef.copyright = params.logoRef?.copyright
                        }

                        MultipartFile file = params.imageFile
                        if (file?.size) {  // will only have size if a file was selected
                            def filename = file.getOriginalFilename()
                            log.debug "filename=${filename}"
                            // update filename
                            if (inst.imageRef) {
                                inst.imageRef.file = filename
                            } else {
                                inst.imageRef = new Image(file: filename)
                            }
                            // save the chosen file
                            def mhsr = request.getFile('imageFile')
                            if (!mhsr?.empty && mhsr.size < 1024*200) {   // limit file to 200Kb
                                def externalStore = ConfigurationHolder.config.repository.location.images
                                def colDir = new File(externalStore, "institution")
                                colDir.mkdirs()
                                File f = new File(colDir, filename)
                                log.debug "saving ${filename} to ${f.absoluteFile}"
                                mhsr.transferTo(f)
                            } else {
                                // TODO: handle error message
                            }
                        }
                        if (inst.imageRef) {
                            // just handle changes in the image metadata
                            inst.imageRef.caption = params.imageRef?.caption
                            inst.imageRef.attribution = params.imageRef?.attribution
                            inst.imageRef.copyright = params.imageRef?.copyright
                        }

                        // save
                        inst.userLastModified = 'temp'//authenticateService.userDomain().username
                        if (!inst.hasErrors() && inst.save(flush: true)) {
                            flash.message = "${message(code: 'default.updated.message', args: [message(code: 'providerGroup.label', default: 'Institution'), inst.name])}"
                            ActivityLog.log username(), inst.uid, Action.EDIT_SAVE
                            [id: params.id, url: request.getContextPath() + '/institution/show']
                        } else {
                            return error()
                        }
                    }
                } else {
                    flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
                    redirect(action: "list")
                }
            }
            on("success").to "exitToShow"
            on("error").to "showEdit"
        }

        // adds an existing contact
        addContact {
            action {
                log.info "> entered addContact"
                params.each {log.info it}
                log.info "Adding id: ${params.addContact}"
                Contact contact = Contact.get(params.addContact)
                if (contact) {
                    flow.providerGroupInstance.addToContacts(contact, params.role, (params.isAdmin == 'true'), (params.isPrimary == 'true'), authenticateService.userDomain().username)
                }
            }
            on("success").to "showEdit"
        }

        // removes a contact
        removeContact {
            action {
                log.info "> entered removeInstitution"
                params.each {log.info it}
                log.info "Removing id: ${params.id}"
                Contact contact = Contact.get(params.id)
                if (contact) {
                    flow.providerGroupInstance.deleteFromContacts(contact)
                }
                flow.providerGroupInstance
            }
            on("success").to "showEdit"
        }

        // creates a new contact record and adds the contact to the collection
        createContact {
            action {
                //log.info "> entered createContact"
                //params.each {log.info it}
                Contact contact = new Contact(params)
                // these field names changed so they don't clash with the same field in the main model
                contact.phone = params.c_phone
                contact.email = params.c_email
                contact.notes = params.c_notes
                contact.userLastModified = authenticateService.userDomain().username
                // save immediately - review this decision
                contact.save()
                ActivityLog.log username(), contact.id, Action.CREATE_CONTACT
                flow.providerGroupInstance.addToContacts(contact, params.role2, (params.isAdmin2 as String == 'true'), (params.isPrimary2 as String == 'true'), authenticateService.userDomain().username)
            }
            on("success").to "showEdit"
            on("failure") {
                render( view: "/institution/edit")
            }.to "showEdit"
        }

        cancel {
            action {
                log.info "Cancelling"
//                ActivityLog.log authenticateService.userDomain().username as String, flow.providerGroupInstance?.id, Action.EDIT_CANCEL
                flow.providerGroupInstance.discard()
                [id: params.id, url: request.getContextPath() + '/institution/show']
            }
            on("success").to "exitToShow"
        }

        exitToShow() /* workaround - see http://jira.codehaus.org/browse/GRAILS-5811  to be fixed in Grails 1.3.3 {
            redirect(controller:"institution", action:"show", params: [id: params.id])
        }*/

        exitToList {
            redirect(controller:"institution", action:"list")
        }

    }

    def delete = {
        def providerGroupInstance = get(params.id)
        if (providerGroupInstance) {
            /* need to remove it as a parent from all children
               - in practice this means removing all rows of the link table that reference this institution
               - however we should stick within the domain model and use remove methods
             */
            providerGroupInstance.children.each {
                it.removeFromParents providerGroupInstance
                it.userLastModified = 'temp'//authenticateService.userDomain().username
                it.save()  // necessary?
            }
            // remove contact links (does not remove the contact)
            ContactFor.findAllByEntityUid(providerGroupInstance.uid).each {
                it.delete()
            }
            // now delete
            try {
//                ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.DELETE
                providerGroupInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
            redirect(action: "list")
        }
    }

    private Institution get(id) {
        if (params.id?.toString()?.startsWith(Institution.ENTITY_PREFIX)) {
            return Institution.findByUid(params.id)
        } else {
            return Institution.get(params.id)
        }
    }

    private String username() {
        return (request.getUserPrincipal()?.attributes?.email)?:'not available'
    }

}