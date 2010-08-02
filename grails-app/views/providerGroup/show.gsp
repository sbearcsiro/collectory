
<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'providerGroup.label', default: 'ProviderGroup')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.guid.label" default="Guid" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "guid")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.name.label" default="Name" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "name")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.acronym.label" default="Acronym" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "acronym")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.groupType.label" default="Group Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "groupType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.pubDescription.label" default="Pub Description" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "pubDescription")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.techDescription.label" default="Tech Description" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "techDescription")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.focus.label" default="Focus" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "focus")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.address.label" default="Address" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "address")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.latitude.label" default="Latitude" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "latitude")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.longitude.label" default="Longitude" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "longitude")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.altitude.label" default="Altitude" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "altitude")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.state.label" default="State" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "state")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.websiteUrl.label" default="Website Url" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "websiteUrl")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.logoRef.label" default="Logo Ref" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "logoRef")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.imageRef.label" default="Image Ref" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "imageRef")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.email.label" default="Email" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "email")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.phone.label" default="Phone" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "phone")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.isALAPartner.label" default="Is ALAP artner" /></td>
                            
                            <td valign="top" class="value"><g:formatBoolean boolean="${providerGroupInstance?.isALAPartner}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.dateCreated.label" default="Date Created" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${providerGroupInstance?.dateCreated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.dateLastModified.label" default="Date Last Modified" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${providerGroupInstance?.dateLastModified}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.userLastModified.label" default="User Last Modified" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "userLastModified")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.dateFirstDataReceived.label" default="Date First Data Received" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${providerGroupInstance?.dateFirstDataReceived}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.notes.label" default="Notes" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "notes")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.networkMembership.label" default="Network Membership" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "networkMembership")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.institutionType.label" default="Institution Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "institutionType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.providerCodes.label" default="Provider Codes" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "providerCodes")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.internalProviderCodes.label" default="Internal Provider Codes" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "internalProviderCodes")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.internalInstitutionCodes.label" default="Internal Institution Codes" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "internalInstitutionCodes")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.projectStart.label" default="Project Start" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${providerGroupInstance?.projectStart}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.projectEnd.label" default="Project End" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${providerGroupInstance?.projectEnd}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.scope.label" default="Scope" /></td>
                            
                            <td valign="top" class="value"><g:link controller="collectionScope" action="show" id="${providerGroupInstance?.scope?.id}">${providerGroupInstance?.scope?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.infoSource.label" default="Info Source" /></td>
                            
                            <td valign="top" class="value"><g:link controller="infoSource" action="show" id="${providerGroupInstance?.infoSource?.id}">${providerGroupInstance?.infoSource?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.parents.label" default="Parents" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${providerGroupInstance.parents}" var="p">
                                    <li><g:link controller="providerGroup" action="show" id="${p.id}">${p?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.children.label" default="Children" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${providerGroupInstance.children}" var="c">
                                    <li><g:link controller="providerGroup" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.collectionSummary.label" default="Collection Summary" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "collectionSummary")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.contacts.label" default="Contacts" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "contacts")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.institutionSummary.label" default="Institution Summary" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "institutionSummary")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.listOfCollectionCodesForLookup.label" default="List Of Collection Codes For Lookup" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "listOfCollectionCodesForLookup")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.listOfInstitutionCodesForLookup.label" default="List Of Institution Codes For Lookup" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "listOfInstitutionCodesForLookup")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.mappable.label" default="Mappable" /></td>
                            
                            <td valign="top" class="value"><g:formatBoolean boolean="${providerGroupInstance?.mappable}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.parentInstitutionsOrderedByName.label" default="Parent Institutions Ordered By Name" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "parentInstitutionsOrderedByName")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.primaryContact.label" default="Primary Contact" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "primaryContact")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.safeChildren.label" default="Safe Children" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "safeChildren")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.trimLength.label" default="Trim Length" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: providerGroupInstance, field: "trimLength")}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${providerGroupInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
