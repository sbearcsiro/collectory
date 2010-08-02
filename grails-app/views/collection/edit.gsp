
<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><cl:homeLink/></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1>${fieldValue(bean: providerGroupInstance, field: "name")}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${providerGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${providerGroupInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" enctype="multipart/form-data">
                <g:hiddenField name="id" value="${providerGroupInstance?.id}" />
                <g:hiddenField name="version" value="${providerGroupInstance?.version}" />
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
                              <label for="description"><g:message code="providerGroup.description.label" default="Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'techDescription', 'errors')}">
                                <g:textArea name="description" cols="40" rows="5" value="${providerGroupInstance?.techDescription}" />
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="description"><g:message code="providerGroup.description.label" default="Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'pubDescription', 'errors')}">
                                <g:textArea name="description" cols="40" rows="5" value="${providerGroupInstance?.pubDescription}" />
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
                        
<!-- address -->            <tr class="prop">
                                <td valign="top" class="name">
                                  <g:message code="providerGroup.address.label" default="Address" />
                                </td>
                                <td valign="top">
                                  <table class="shy">
                                    <tr class='prop'>
                                      <td valign="top" class="name">
                                        <label for="address.street"><g:message code="providerGroup.address.street.label" default="Street" /></label>
                                      </td>
                                      <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'address.street', 'errors')}">
                                          <g:textField name="address.street" maxlength="128" value="${providerGroupInstance?.address?.street}" />
                                      </td>
                                    </tr>
                                    <tr class='prop'>
                                      <td valign="top" class="name">
                                        <label for="address.postBox"><g:message code="providerGroup.address.postBox.label" default="Post box" /></label>
                                      </td>
                                      <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'address.postBox', 'errors')}">
                                          <g:textField name="address.postBox" maxlength="128" value="${providerGroupInstance?.address?.postBox}" />
                                      </td>
                                    </tr>
                                    <tr class='prop'>
                                      <td valign="top" class="name">
                                        <label for="address.city"><g:message code="providerGroup.address.city.label" default="City" /></label>
                                      </td>
                                      <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'address.city', 'errors')}">
                                          <g:textField name="address.city" maxlength="128" value="${providerGroupInstance?.address?.city}" />
                                      </td>
                                    </tr>
                                    <tr class='prop'>
                                      <td valign="top" class="name">
                                        <label for="address.state"><g:message code="providerGroup.address.state.label" default="State or territory" /></label>
                                      </td>
                                      <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'address.state', 'errors')}">
                                          <g:textField name="address.state" maxlength="128" value="${providerGroupInstance?.address?.state}" />
                                      </td>
                                    </tr>
                                    <tr class='prop'>
                                      <td valign="top" class="name">
                                        <label for="address.postcode"><g:message code="providerGroup.address.postcode.label" default="Postcode" /></label>
                                      </td>
                                      <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'address.street', 'errors')}">
                                          <g:textField name="address.postcode" maxlength="128" value="${providerGroupInstance?.address?.postcode}" />
                                      </td>
                                    </tr>
                                    <tr class='prop'>
                                      <td valign="top" class="name">
                                        <label for="address.country"><g:message code="providerGroup.address.country.label" default="Country" /></label>
                                      </td>
                                      <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'address.country', 'errors')}">
                                          <g:textField name="address.country" maxlength="128" value="${providerGroupInstance?.address?.country}" />
                                      </td>
                                    </tr>
                                  </table>

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
                                    <g:textField name="state" maxlength="45" value="${providerGroupInstance?.state}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="websiteUrl"><g:message code="providerGroup.websiteUrl.label" default="Website Url" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'websiteUrl', 'errors')}">
                                    <g:textField name="websiteUrl" value="${providerGroupInstance?.websiteUrl}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="logoRef"><g:message code="providerGroup.logoRef.label" default="Logo Ref" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'logoRef', 'errors')}">
                                    
                                </td>
                            </tr>
                        
<!-- imageRef -->           <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="imageRef"><g:message code="providerGroup.imageRef.label" default="Image Ref" /></label>
                                </td>
                                <td valign="top">
                                  <table class='shy'>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="collection.imageRef.file.label" default="File" /></td>
                                        <td valign="top" class="value">
                                          <input type="file" id="imageRef.file" name="imageRef.file" value="${fieldValue(bean: collectionInstance, field: 'imageRef.file')}"/>
                                        </td>
                                    </tr>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="collection.imageRef.file.label" default="Caption" /></td>
                                        <td valign="top" class="value">
                                          <g:textField name="imageRef.caption" value="${fieldValue(bean: collectionInstance, field: 'imageRef.caption')}"/>
                                        </td>
                                    </tr>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="collection.imageRef.file.label" default="Attribution" /></td>
                                        <td valign="top" class="value">
                                          <g:textField name="imageRef.attribution" value="${fieldValue(bean: collectionInstance, field: 'imageRef.attribution')}"/>
                                        </td>
                                    </tr>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="collection.imageRef.file.label" default="Copyright" /></td>
                                        <td valign="top" class="value">
                                          <g:textField name="imageRef.copyright" value="${fieldValue(bean: collectionInstance, field: 'imageRef.copyright')}"/>
                                        </td>
                                    </tr>

                                  </table>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="email"><g:message code="providerGroup.email.label" default="Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${providerGroupInstance?.email}" />
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
                        
<!-- ALA Partner -->        <tr class="prop">
                                <td valign="top" class="name">
                                  <g:message code="providerGroup.isALAPartner.label" default="Institution is an ALA Partner" />
                                </td>
                                <td valign="top">
                                    <g:formatBoolean boolean="${providerGroupInstance?.isALAPartner}" /> (This reflects the status of the owning institution.)
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="dateCreated"><g:message code="providerGroup.dateCreated.label" default="Date Created" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'dateCreated', 'errors')}">
                                    <g:datePicker name="dateCreated" precision="day" value="${providerGroupInstance?.dateCreated}" noSelection="['': '']" />
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
                                  <label for="collectionType"><g:message code="providerGroup.collectionType.label" default="Collection Type" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'collectionType', 'errors')}">
                                    <g:select name="collectionType" from="${providerGroupInstance.constraints.collectionType.inList}" value="${providerGroupInstance?.collectionType}" valueMessagePrefix="providerGroup.collectionType" noSelection="['': '']" />
                                </td>
                            </tr>
                        
                            <!--  tr class="prop">
                                <td valign="top" class="name">
                                  <label for="providerCollectionCode"><g:message code="providerGroup.providerCollectionCode.label" default="Provider Collection Code" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'providerCodes', 'errors')}">
                                    <g:textField name="providerCollectionCode" maxlength="45" value="${providerGroupInstance?.providerCodes}" />
                                </td>
                            </tr-->
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="collectionNumRecords"><g:message code="providerGroup.collectionNumRecords.label" default="Collection Num Records" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'collectionNumRecords', 'errors')}">
                                    <g:textField name="collectionNumRecords" value="${fieldValue(bean: providerGroupInstance, field: 'collectionNumRecords')}" />
                                </td>
                            </tr>
                        
<!-- Institution -->        <tr class="prop">
                                <td valign="top" class="name">
                                  <g:message code="providerGroup.parents.label" default="Institutions" />
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'parents', 'errors')}">
                                  <!-- show an inner table with delete links and one add link -->
                                  <table class="shy">
                                    <g:each in="${providerGroupInstance.parents}" var="i">
                                      <tr class='prop'>
                                        <td valign="middle" class="name">
                                          <g:link controller="institution" action="show" id="${i.id}">${i?.name}</g:link>
                                        </td>
                                        <td valign="top">
                                          <span class="bodyButton"><g:actionSubmit name="${i?.id}" class="remove" action="removeInstitution" value="${i.id}"
                                                  onclick="return confirm('Remove ${i?.name} as the institution that holds this collection?');" /></span>
                                        </td>
                                      </tr>
                                    </g:each>
                                    <tr>
                                      <td></td>
                                      <td>
                                        <span class="bodyButton"><g:actionSubmit class="add" action="addInstitution" value="${message(code: 'institution.button.add.label', default: 'Add an institution')}" /></span>
                                        <span class="bodyButton" onClick="document.getElementById('inst').style.display=''">New</span>
                                        <div id="inst" style="display:none;">
                                          Enter institution name:
                                          <span class="bodyButton" onClick="document.getElementById('inst').style.display='none'">Cancel</span>
                                        </div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="contacts"><g:message code="providerGroup.contacts.label" default="Contacts" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: providerGroupInstance, field: 'contacts', 'errors')}">
                                    
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
