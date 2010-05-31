
<%@ page import="au.org.ala.collectory.InfoSource" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'infoSource.label', default: 'InfoSource')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${infoSourceInstance}">
            <div class="errors">
                <g:renderErrors bean="${infoSourceInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:hiddenField name="id" value="${infoSourceInstance?.id}" />
                <g:hiddenField name="version" value="${infoSourceInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="guid"><g:message code="infoSource.guid.label" default="Guid" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'guid', 'errors')}">
                                    <g:textField name="guid" maxlength="45" value="${infoSourceInstance?.guid}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="acronym"><g:message code="infoSource.acronym.label" default="Acronym" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'acronym', 'errors')}">
                                    <g:textField name="acronym" maxlength="45" value="${infoSourceInstance?.acronym}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="title"><g:message code="infoSource.title.label" default="Title" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'title', 'errors')}">
                                    <g:textField name="title" maxlength="128" value="${infoSourceInstance?.title}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="abstractText"><g:message code="infoSource.abstractText.label" default="Abstract Text" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'abstractText', 'errors')}">
                                    <g:textArea name="abstractText" cols="40" rows="5" value="${infoSourceInstance?.abstractText}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateAvailable"><g:message code="infoSource.dateAvailable.label" default="Date Available" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'dateAvailable', 'errors')}">
                                    <g:datePicker name="dateAvailable" precision="day" value="${infoSourceInstance?.dateAvailable}" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="datasetType"><g:message code="infoSource.datasetType.label" default="Dataset Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'datasetType', 'errors')}">
                                    <g:textField name="datasetType" value="${infoSourceInstance?.datasetType}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="keywords"><g:message code="infoSource.keywords.label" default="Keywords" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'keywords', 'errors')}">
                                    <g:textField name="keywords" value="${infoSourceInstance?.keywords}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="active"><g:message code="infoSource.active.label" default="Active" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'active', 'errors')}">
                                    <g:select name="active" from="${infoSourceInstance.constraints.active.inList}" value="${infoSourceInstance?.active}" valueMessagePrefix="infoSource.active" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="basisOfRecord"><g:message code="infoSource.basisOfRecord.label" default="Basis Of Record" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'basisOfRecord', 'errors')}">
                                    <g:select name="basisOfRecord" from="${infoSourceInstance.constraints.basisOfRecord.inList}" value="${infoSourceInstance?.basisOfRecord}" valueMessagePrefix="infoSource.basisOfRecord" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="language"><g:message code="infoSource.language.label" default="Language" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'language', 'errors')}">
                                    <g:textField name="language" maxlength="2" value="${infoSourceInstance?.language}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="notes"><g:message code="infoSource.notes.label" default="Notes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'notes', 'errors')}">
                                    <g:textArea name="notes" cols="40" rows="5" value="${infoSourceInstance?.notes}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="informationWithheld"><g:message code="infoSource.informationWithheld.label" default="Information Withheld" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'informationWithheld', 'errors')}">
                                    <g:textArea name="informationWithheld" cols="40" rows="5" value="${infoSourceInstance?.informationWithheld}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="generalisations"><g:message code="infoSource.generalisations.label" default="Generalisations" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'generalisations', 'errors')}">
                                    <g:textArea name="generalisations" cols="40" rows="5" value="${infoSourceInstance?.generalisations}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="spatialRepresentationType"><g:message code="infoSource.spatialRepresentationType.label" default="Spatial Representation Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'spatialRepresentationType', 'errors')}">
                                    <g:select name="spatialRepresentationType" from="${infoSourceInstance.constraints.spatialRepresentationType.inList}" value="${infoSourceInstance?.spatialRepresentationType}" valueMessagePrefix="infoSource.spatialRepresentationType" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="spatialResolution"><g:message code="infoSource.spatialResolution.label" default="Spatial Resolution" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'spatialResolution', 'errors')}">
                                    <g:textField name="spatialResolution" value="${infoSourceInstance?.spatialResolution}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="rights"><g:message code="infoSource.rights.label" default="Rights" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'rights', 'errors')}">
                                    <g:textField name="rights" value="${infoSourceInstance?.rights}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="rightsHolder"><g:message code="infoSource.rightsHolder.label" default="Rights Holder" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'rightsHolder', 'errors')}">
                                    <g:textField name="rightsHolder" value="${infoSourceInstance?.rightsHolder}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="security"><g:message code="infoSource.security.label" default="Security" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'security', 'errors')}">
                                    <g:textField name="security" value="${infoSourceInstance?.security}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="licenseType"><g:message code="infoSource.licenseType.label" default="License Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'licenseType', 'errors')}">
                                    <g:select name="licenseType" from="${infoSourceInstance.constraints.licenseType.inList}" value="${infoSourceInstance?.licenseType}" valueMessagePrefix="infoSource.licenseType" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="restrictions"><g:message code="infoSource.restrictions.label" default="Restrictions" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'restrictions', 'errors')}">
                                    <g:textField name="restrictions" value="${infoSourceInstance?.restrictions}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="citation"><g:message code="infoSource.citation.label" default="Citation" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'citation', 'errors')}">
                                    <g:textField name="citation" value="${infoSourceInstance?.citation}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="providerAgreement"><g:message code="infoSource.providerAgreement.label" default="Provider Agreement" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'providerAgreement', 'errors')}">
                                    <g:textField name="providerAgreement" value="${infoSourceInstance?.providerAgreement}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="states"><g:message code="infoSource.states.label" default="States" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'states', 'errors')}">
                                    <g:textField name="states" value="${infoSourceInstance?.states}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="geographicDescription"><g:message code="infoSource.geographicDescription.label" default="Geographic Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'geographicDescription', 'errors')}">
                                    <g:textField name="geographicDescription" value="${infoSourceInstance?.geographicDescription}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="wellKnownText"><g:message code="infoSource.wellKnownText.label" default="Well Known Text" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'wellKnownText', 'errors')}">
                                    <g:textField name="wellKnownText" value="${infoSourceInstance?.wellKnownText}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="eastCoordinate"><g:message code="infoSource.eastCoordinate.label" default="East Coordinate" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'eastCoordinate', 'errors')}">
                                    <g:textField name="eastCoordinate" value="${fieldValue(bean: infoSourceInstance, field: 'eastCoordinate')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="westCoordinate"><g:message code="infoSource.westCoordinate.label" default="West Coordinate" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'westCoordinate', 'errors')}">
                                    <g:textField name="westCoordinate" value="${fieldValue(bean: infoSourceInstance, field: 'westCoordinate')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="northCoordinate"><g:message code="infoSource.northCoordinate.label" default="North Coordinate" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'northCoordinate', 'errors')}">
                                    <g:textField name="northCoordinate" value="${fieldValue(bean: infoSourceInstance, field: 'northCoordinate')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="southCoordinate"><g:message code="infoSource.southCoordinate.label" default="South Coordinate" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'southCoordinate', 'errors')}">
                                    <g:textField name="southCoordinate" value="${fieldValue(bean: infoSourceInstance, field: 'southCoordinate')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="startDate"><g:message code="infoSource.startDate.label" default="Start Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'startDate', 'errors')}">
                                    <g:textField name="startDate" maxlength="45" value="${infoSourceInstance?.startDate}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="endDate"><g:message code="infoSource.endDate.label" default="End Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'endDate', 'errors')}">
                                    <g:textField name="endDate" maxlength="45" value="${infoSourceInstance?.endDate}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="kingdomCoverage"><g:message code="infoSource.kingdomCoverage.label" default="Kingdom Coverage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'kingdomCoverage', 'errors')}">
                                    <g:textArea name="kingdomCoverage" cols="40" rows="5" value="${infoSourceInstance?.kingdomCoverage}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="accessParameters"><g:message code="infoSource.accessParameters.label" default="Access Parameters" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'accessParameters', 'errors')}">
                                    <g:textArea name="accessParameters" cols="40" rows="5" value="${infoSourceInstance?.accessParameters}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateLastModified"><g:message code="infoSource.dateLastModified.label" default="Date Last Modified" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'dateLastModified', 'errors')}">
                                    <g:datePicker name="dateLastModified" precision="day" value="${infoSourceInstance?.dateLastModified}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="userLastModified"><g:message code="infoSource.userLastModified.label" default="User Last Modified" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'userLastModified', 'errors')}">
                                    <g:textArea name="userLastModified" cols="40" rows="5" value="${infoSourceInstance?.userLastModified}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="webServiceProtocol"><g:message code="infoSource.webServiceProtocol.label" default="Web Service Protocol" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'webServiceProtocol', 'errors')}">
                                    <g:textField name="webServiceProtocol" value="${infoSourceInstance?.webServiceProtocol}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="webServiceUri"><g:message code="infoSource.webServiceUri.label" default="Web Service Uri" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'webServiceUri', 'errors')}">
                                    <g:textField name="webServiceUri" value="${infoSourceInstance?.webServiceUri}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="collections"><g:message code="infoSource.collections.label" default="Collections" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'collections', 'errors')}">
                                    
<ul>
<g:each in="${infoSourceInstance?.collections?}" var="c">
    <li><g:link controller="providerGroup" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="providerGroup" action="create" params="['infoSource.id': infoSourceInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'providerGroup.label', default: 'ProviderGroup')])}</g:link>

                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
