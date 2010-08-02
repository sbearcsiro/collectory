
<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'providerGroup.label', default: 'ProviderGroup')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${providerGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${providerGroupInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="guid"><g:message code="providerGroup.guid.label" default="Guid" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'guid', 'errors')}">
                                    <g:textField name="guid" maxlength="45" value="${providerGroupInstance?.guid}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="providerGroup.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" maxlength="128" value="${providerGroupInstance?.name}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="acronym"><g:message code="providerGroup.acronym.label" default="Acronym" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'acronym', 'errors')}">
                                    <g:textField name="acronym" maxlength="45" value="${providerGroupInstance?.acronym}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="groupType"><g:message code="providerGroup.groupType.label" default="Group Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'groupType', 'errors')}">
                                    <g:select name="groupType" from="${providerGroupInstance.constraints.groupType.inList}" value="${providerGroupInstance?.groupType}" valueMessagePrefix="providerGroup.groupType"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="pubDescription"><g:message code="providerGroup.pubDescription.label" default="Pub Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'pubDescription', 'errors')}">
                                    <g:textArea name="pubDescription" cols="40" rows="5" value="${providerGroupInstance?.pubDescription}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="techDescription"><g:message code="providerGroup.techDescription.label" default="Tech Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'techDescription', 'errors')}">
                                    <g:textArea name="techDescription" cols="40" rows="5" value="${providerGroupInstance?.techDescription}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="focus"><g:message code="providerGroup.focus.label" default="Focus" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'focus', 'errors')}">
                                    <g:textArea name="focus" cols="40" rows="5" value="${providerGroupInstance?.focus}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="address"><g:message code="providerGroup.address.label" default="Address" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'address', 'errors')}">
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="latitude"><g:message code="providerGroup.latitude.label" default="Latitude" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'latitude', 'errors')}">
                                    <g:textField name="latitude" value="${fieldValue(bean: providerGroupInstance, field: 'latitude')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="longitude"><g:message code="providerGroup.longitude.label" default="Longitude" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'longitude', 'errors')}">
                                    <g:textField name="longitude" value="${fieldValue(bean: providerGroupInstance, field: 'longitude')}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="altitude"><g:message code="providerGroup.altitude.label" default="Altitude" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'altitude', 'errors')}">
                                    <g:textField name="altitude" value="${providerGroupInstance?.altitude}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="state"><g:message code="providerGroup.state.label" default="State" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'state', 'errors')}">
                                    <g:select name="state" from="${providerGroupInstance.constraints.state.inList}" value="${providerGroupInstance?.state}" valueMessagePrefix="providerGroup.state" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="websiteUrl"><g:message code="providerGroup.websiteUrl.label" default="Website Url" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'websiteUrl', 'errors')}">
                                    <g:textArea name="websiteUrl" cols="40" rows="5" value="${providerGroupInstance?.websiteUrl}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="logoRef"><g:message code="providerGroup.logoRef.label" default="Logo Ref" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'logoRef', 'errors')}">
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="imageRef"><g:message code="providerGroup.imageRef.label" default="Image Ref" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'imageRef', 'errors')}">
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="email"><g:message code="providerGroup.email.label" default="Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'email', 'errors')}">
                                    <g:textArea name="email" cols="40" rows="5" value="${providerGroupInstance?.email}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="phone"><g:message code="providerGroup.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" maxlength="45" value="${providerGroupInstance?.phone}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="isALAPartner"><g:message code="providerGroup.isALAPartner.label" default="Is ALAP artner" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'isALAPartner', 'errors')}">
                                    <g:checkBox name="isALAPartner" value="${providerGroupInstance?.isALAPartner}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateLastModified"><g:message code="providerGroup.dateLastModified.label" default="Date Last Modified" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'dateLastModified', 'errors')}">
                                    <g:datePicker name="dateLastModified" precision="day" value="${providerGroupInstance?.dateLastModified}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="userLastModified"><g:message code="providerGroup.userLastModified.label" default="User Last Modified" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'userLastModified', 'errors')}">
                                    <g:textArea name="userLastModified" cols="40" rows="5" value="${providerGroupInstance?.userLastModified}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="dateFirstDataReceived"><g:message code="providerGroup.dateFirstDataReceived.label" default="Date First Data Received" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'dateFirstDataReceived', 'errors')}">
                                    <g:datePicker name="dateFirstDataReceived" precision="day" value="${providerGroupInstance?.dateFirstDataReceived}" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="notes"><g:message code="providerGroup.notes.label" default="Notes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'notes', 'errors')}">
                                    <g:textArea name="notes" cols="40" rows="5" value="${providerGroupInstance?.notes}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="networkMembership"><g:message code="providerGroup.networkMembership.label" default="Network Membership" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'networkMembership', 'errors')}">
                                    <g:textArea name="networkMembership" cols="40" rows="5" value="${providerGroupInstance?.networkMembership}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="institutionType"><g:message code="providerGroup.institutionType.label" default="Institution Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'institutionType', 'errors')}">
                                    <g:select name="institutionType" from="${providerGroupInstance.constraints.institutionType.inList}" value="${providerGroupInstance?.institutionType}" valueMessagePrefix="providerGroup.institutionType" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="providerCodes"><g:message code="providerGroup.providerCodes.label" default="Provider Codes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'providerCodes', 'errors')}">
                                    <g:textArea name="providerCodes" cols="40" rows="5" value="${providerGroupInstance?.providerCodes}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="internalProviderCodes"><g:message code="providerGroup.internalProviderCodes.label" default="Internal Provider Codes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'internalProviderCodes', 'errors')}">
                                    <g:textArea name="internalProviderCodes" cols="40" rows="5" value="${providerGroupInstance?.internalProviderCodes}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="internalInstitutionCodes"><g:message code="providerGroup.internalInstitutionCodes.label" default="Internal Institution Codes" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'internalInstitutionCodes', 'errors')}">
                                    <g:textField name="internalInstitutionCodes" maxlength="45" value="${providerGroupInstance?.internalInstitutionCodes}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="projectStart"><g:message code="providerGroup.projectStart.label" default="Project Start" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'projectStart', 'errors')}">
                                    <g:datePicker name="projectStart" precision="day" value="${providerGroupInstance?.projectStart}" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="projectEnd"><g:message code="providerGroup.projectEnd.label" default="Project End" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'projectEnd', 'errors')}">
                                    <g:datePicker name="projectEnd" precision="day" value="${providerGroupInstance?.projectEnd}" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="scope"><g:message code="providerGroup.scope.label" default="Scope" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'scope', 'errors')}">
                                    <g:select name="scope.id" from="${au.org.ala.collectory.CollectionScope.list()}" optionKey="id" value="${providerGroupInstance?.scope?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="infoSource"><g:message code="providerGroup.infoSource.label" default="Info Source" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'infoSource', 'errors')}">
                                    <g:select name="infoSource.id" from="${au.org.ala.collectory.InfoSource.list()}" optionKey="id" value="${providerGroupInstance?.infoSource?.id}" noSelection="['null': '']" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="collectionSummary"><g:message code="providerGroup.collectionSummary.label" default="Collection Summary" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'collectionSummary', 'errors')}">
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="institutionSummary"><g:message code="providerGroup.institutionSummary.label" default="Institution Summary" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'institutionSummary', 'errors')}">
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="mappable"><g:message code="providerGroup.mappable.label" default="Mappable" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'mappable', 'errors')}">
                                    <g:checkBox name="mappable" value="${providerGroupInstance?.mappable}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="primaryContact"><g:message code="providerGroup.primaryContact.label" default="Primary Contact" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'primaryContact', 'errors')}">
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="trimLength"><g:message code="providerGroup.trimLength.label" default="Trim Length" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'trimLength', 'errors')}">
                                    
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
