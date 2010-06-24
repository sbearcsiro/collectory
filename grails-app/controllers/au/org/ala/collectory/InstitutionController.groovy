package au.org.ala.collectory

import org.springframework.web.multipart.MultipartFile
import grails.converters.JSON

class InstitutionController {

    def authenticateService

    def scaffold = ProviderGroup

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.sort = "name"
        //println "Count = " + ProviderGroup.countByGroupType('Institution')
        [institutionInstanceList: ProviderGroup.findAllByGroupType("Institution", params),
                institutionInstanceTotal: ProviderGroup.countByGroupType('Institution')]
    }

    def show = {
        def institutionInstance = ProviderGroup.get(params.id)
        if (!institutionInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'institution.label', default: 'Institution'), params.id])}"
            redirect(action: "list")
        }
        else {
            log.info "Ala partner = " + institutionInstance.isALAPartner
            ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.VIEW
            [institutionInstance: institutionInstance, contacts: institutionInstance.getContacts()]
        }
    }

    def editInstitutionFlow = {
        start {
            action {
                //log.info "> entered start"
                def institutionInstance = ProviderGroup.get(params.id)
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
            on(NumberFormatException).to "exitToList"
        }

        showEdit {
            render(view: "/institution/edit", model: [providerGroupInstance: flow.providerGroupInstance])
            on("done").to "done"
            on("cancel").to "cancel"
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
                def children = params.children
                children.each {
                    log.debug "Child: ${it}, ${it.class}"
                }
                params.parents.each {
                    log.debug "Parent: ${it}, ${it.class}"
                }
                def providerGroupInstance = ProviderGroup.get(params.id)
                if (providerGroupInstance) {
                    providerGroupInstance.refresh()  // this seems necessary to get the current version
                    log.debug "db version = ${providerGroupInstance.version}"
                    log.debug "params version = ${params.version}"
                    if (params.version && providerGroupInstance.version > params.version.toLong()) {
                        log.warn "Attempted to save a stale institution record - ${providerGroupInstance.name} version ${providerGroupInstance.version}"
                        providerGroupInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                                [message(code: 'providerGroup.label', default: 'ProviderGroup')] as Object[],
                                "Another user has updated this ProviderGroup while you were editing. New values have been refreshed. You will need to reapply your changes.")
                        flow.providerGroupInstance.discard()
                        flow.providerGroupInstance = providerGroupInstance
                        return error()
                    } else {
                        // update values
                        // need to create an address obj if one doesn't exist
                        if (providerGroupInstance.address == null && (params.address?.street || params.address.city)) {
                            log.debug "creating new address"
                            providerGroupInstance.address = new Address()
                        }
                        if (providerGroupInstance.address) {
                            providerGroupInstance.properties['address.street', 'address.postBox', 'address.city', 'address.state', 'address.postcode', 'address.country'] = params
                        }

                        // lat and long are shown as blank if the value is -1, and come back as blank which will be rejected
                        providerGroupInstance.latitude = params.latitude ? params.latitude : ProviderGroup.NO_INFO_AVAILABLE
                        providerGroupInstance.longitude = params.longitude ? params.longitude : ProviderGroup.NO_INFO_AVAILABLE

                        providerGroupInstance.properties['guid', 'name', 'acronym', 'websiteUrl', 'logoRef', 'imageRef', 'isALAPartner',
                                'institutionType', 'state', 'email', 'phone'] = params

                        // network membership can be returned as a String if there is a single value or a String []
                        if (params.networkMembership) {
                            def list
                            if (params.networkMembership instanceof String[]) {
                                list = params.networkMembership.toList()
                            } else {
                                list = new ArrayList() << params.networkMembership
                            }
                            providerGroupInstance.networkMembership = (list as JSON).toString();
                        }

                        // handle images
                        MultipartFile logoFile = params.logoFile
                        if (logoFile.size) {  // will only have size if a file was selected
                            def filename = logoFile.getOriginalFilename()
                            log.debug "filename=${filename}"
                            // update filename
                            if (providerGroupInstance.logoRef) {
                                providerGroupInstance.logoRef.file = filename
                            } else {
                                providerGroupInstance.logoRef = new Image(file: filename)
                            }
                            // save the chosen file
                            def mhsr = request.getFile('logoFile')
                            if (!mhsr?.empty && mhsr.size < 1024*200) {   // limit file to 200Kb
                                def webRootDir = servletContext.getRealPath("/")
                                def colDir = new File(webRootDir, "images/institution")
                                colDir.mkdirs()
                                File f = new File(colDir, filename)
                                log.debug "saving ${filename} to ${f.absoluteFile}"
                                mhsr.transferTo(f)
                                ActivityLog.log authenticateService.userDomain().username as String, Action.UPLOAD_IMAGE, filename
                            } else {
                                // TODO: handle error message
                            }
                        }
                        if (providerGroupInstance.logoRef) {
                            // just handle changes in the image metadata
                            providerGroupInstance.logoRef.caption = params.logoRef?.caption
                            providerGroupInstance.logoRef.attribution = params.logoRef?.attribution
                            providerGroupInstance.logoRef.copyright = params.logoRef?.copyright
                        }

                        MultipartFile file = params.imageFile
                        if (file.size) {  // will only have size if a file was selected
                            def filename = file.getOriginalFilename()
                            log.debug "filename=${filename}"
                            // update filename
                            if (providerGroupInstance.imageRef) {
                                providerGroupInstance.imageRef.file = filename
                            } else {
                                providerGroupInstance.imageRef = new Image(file: filename)
                            }
                            // save the chosen file
                            def mhsr = request.getFile('imageFile')
                            if (!mhsr?.empty && mhsr.size < 1024*200) {   // limit file to 200Kb
                                def webRootDir = servletContext.getRealPath("/")
                                def colDir = new File(webRootDir, "images/institution")
                                colDir.mkdirs()
                                File f = new File(colDir, filename)
                                log.debug "saving ${filename} to ${f.absoluteFile}"
                                mhsr.transferTo(f)
                            } else {
                                // TODO: handle error message
                            }
                        }
                        if (providerGroupInstance.imageRef) {
                            // just handle changes in the image metadata
                            providerGroupInstance.imageRef.caption = params.imageRef?.caption
                            providerGroupInstance.imageRef.attribution = params.imageRef?.attribution
                            providerGroupInstance.imageRef.copyright = params.imageRef?.copyright
                        }

                        // save
                        providerGroupInstance.dateLastModified = new Date()
                        providerGroupInstance.userLastModified = authenticateService.userDomain().username
                        if (!providerGroupInstance.hasErrors() && providerGroupInstance.save(flush: true)) {
                            flash.message = "${message(code: 'default.updated.message', args: [message(code: 'providerGroup.label', default: 'Institution'), providerGroupInstance.name])}"
                            ActivityLog.log authenticateService.userDomain().username as String, providerGroupInstance.id, Action.EDIT_SAVE
                            return success()
                        }
                        else {
                            return error()
                        }
                    }
                } else {
                    flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'providerGroup.label', default: 'ProviderGroup'), params.id])}"
                    redirect(action: "list")
                }
            }
            on("success").to "exitToList"
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
                ActivityLog.log authenticateService.userDomain().username as String, contact.id, Action.CREATE_CONTACT
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
                ActivityLog.log authenticateService.userDomain().username as String, flow.providerGroupInstance?.id, Action.EDIT_CANCEL
                flow.providerGroupInstance.discard()
/*                log.info "flow.pg.id=" + flow.providerGroupInstance?.id
                def returnId = flow.providerGroupInstance?.id
                log.info "rid=" + returnId
                flow.clear()
                log.info "flow.pg.id=" + flow.providerGroupInstance?.id
                session.rid = returnId
                log.info "session.rid=" + session.rid*/
            }
            on("success").to "exitToList"
        }

        exitToShow {
            redirect(controller:"institution", action:"show", params: [id: session.rid])
        }

        exitToList {
            redirect(controller:"institution", action:"list")
        }

    }

    def delete = {
        def providerGroupInstance = ProviderGroup.get(params.id)
        if (providerGroupInstance) {
            /* need to remove it as a parent from all children
               - in practice this means removing all rows of the link table that reference this institution
               - however we should stick within the domain model and use remove methods
             */
            providerGroupInstance.children.each {
                it.removeFromParents providerGroupInstance
                it.dateLastModified = new Date()
                it.userLastModified = authenticateService.userDomain().username
                it.save()  // necessary?
            }
            // remove contact links (does not remove the contact)
            ContactFor.findAllByEntityIdAndEntityType(providerGroupInstance.id, ProviderGroup.ENTITY_TYPE).each {
                it.delete()
            }
            // now delete
            try {
                ActivityLog.log authenticateService.userDomain().username as String, params.id as long, Action.DELETE
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
}
