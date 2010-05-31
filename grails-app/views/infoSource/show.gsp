
<%@ page import="au.org.ala.collectory.InfoSource" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'infoSource.label', default: 'InfoSource')}" />
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
                            <td valign="top" class="name"><g:message code="infoSource.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.guid.label" default="Guid" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "guid")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.acronym.label" default="Acronym" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "acronym")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.title.label" default="Title" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "title")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.abstractText.label" default="Abstract Text" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "abstractText")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.dateAvailable.label" default="Date Available" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${infoSourceInstance?.dateAvailable}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.datasetType.label" default="Dataset Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "datasetType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.keywords.label" default="Keywords" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "keywords")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.active.label" default="Active" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "active")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.basisOfRecord.label" default="Basis Of Record" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "basisOfRecord")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.language.label" default="Language" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "language")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.notes.label" default="Notes" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "notes")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.informationWithheld.label" default="Information Withheld" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "informationWithheld")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.generalisations.label" default="Generalisations" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "generalisations")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.spatialRepresentationType.label" default="Spatial Representation Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "spatialRepresentationType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.spatialResolution.label" default="Spatial Resolution" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "spatialResolution")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.rights.label" default="Rights" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "rights")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.rightsHolder.label" default="Rights Holder" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "rightsHolder")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.security.label" default="Security" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "security")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.licenseType.label" default="License Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "licenseType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.restrictions.label" default="Restrictions" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "restrictions")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.citation.label" default="Citation" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "citation")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.providerAgreement.label" default="Provider Agreement" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "providerAgreement")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.states.label" default="States" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "states")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.geographicDescription.label" default="Geographic Description" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "geographicDescription")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.wellKnownText.label" default="Well Known Text" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "wellKnownText")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.eastCoordinate.label" default="East Coordinate" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "eastCoordinate")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.westCoordinate.label" default="West Coordinate" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "westCoordinate")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.northCoordinate.label" default="North Coordinate" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "northCoordinate")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.southCoordinate.label" default="South Coordinate" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "southCoordinate")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.startDate.label" default="Start Date" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "startDate")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.endDate.label" default="End Date" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "endDate")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.kingdomCoverage.label" default="Kingdom Coverage" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "kingdomCoverage")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.accessParameters.label" default="Access Parameters" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "accessParameters")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.dateCreated.label" default="Date Created" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${infoSourceInstance?.dateCreated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.dateLastModified.label" default="Date Last Modified" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${infoSourceInstance?.dateLastModified}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.userLastModified.label" default="User Last Modified" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "userLastModified")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.webServiceProtocol.label" default="Web Service Protocol" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "webServiceProtocol")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.webServiceUri.label" default="Web Service Uri" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: infoSourceInstance, field: "webServiceUri")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="infoSource.collections.label" default="Collections" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${infoSourceInstance.collections}" var="c">
                                    <li><g:link controller="providerGroup" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${infoSourceInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
