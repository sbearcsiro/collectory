
<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'institution.label', default: 'Institution')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1>${fieldValue(bean: institutionInstance, field: "name")}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.guid.label" default="Guid" /></td>
                                
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "guid")}</td>
                                
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.acronym.label" default="Acronym" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "acronym")}</td>
                            
                        </tr>

<!-- Networks -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.networkMembership.label" default="Is a member of" /></td>
                            <td valign="top" class="value"><cl:JSONListAsStrings json='${institutionInstance.networkMembership}'/></td>
                        </tr>

<!-- Address -->        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.address.label" default="Address" /></td>

                            <td valign="top" class="value">
                              ${fieldValue(bean: institutionInstance, field: "address.street")}
                              ${fieldValue(bean: institutionInstance, field: "address.postBox")}
                              ${fieldValue(bean: institutionInstance, field: "address.city")}
                              ${fieldValue(bean: institutionInstance, field: "address.state")}
                              ${fieldValue(bean: institutionInstance, field: "address.postcode")}
                              <g:if test="${fieldValue(bean: institutionInstance, field: 'address.country') != 'Australia'}">
                                ${fieldValue(bean: institutionInstance, field: "address.country")}
                              </g:if>
                            </td>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.state.label" default="State" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "state")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.website_url.label" default="Websiteurl" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "websiteUrl")}</td>
                            
                        </tr>
                    
<!-- Logo -->           <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.logo_ref.label" default="Logo Image" /></td>
                            <td valign="top">
                              <g:if test="${fieldValue(bean: institutionInstance, field: 'logoRef.file')}">
                                <table class='shy'>
                                  <tr>
                                    <td colspan="2">
                                      <img alt="${fieldValue(bean: institutionInstance, field: "logoRef.file")}"
                                              src="${resource(absolute: "true", dir:'data/institution', file:institutionInstance.logoRef.file)}" />
                                    </td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name" style="width:10%"><g:message code="institution.logo_ref.file.label" default="File" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "logoRef.file")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="institution.logo_ref.file.label" default="Caption" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "logoRef.caption")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="institution.logo_ref.file.label" default="Attribution" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "logoRef.attribution")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="institution.logo_ref.file.label" default="Copyright" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "logoRef.copyright")}</td>
                                  </tr>
                                </table>
                              </g:if>
                            </td>
                        </tr>

<!-- ImageRef -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.image_ref.label" default="Representative Image" /></td>
                            <td valign="top">
                              <g:if test="${fieldValue(bean: institutionInstance, field: 'imageRef.file')}">
                                <table class='shy'>
                                  <tr>
                                    <td colspan="2">
                                      <img alt="${fieldValue(bean: institutionInstance, field: "imageRef.file")}"
                                              src="${resource(absolute: "true", dir:'data/institution', file:institutionInstance.imageRef.file)}" />
                                    </td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name" style="width:10%"><g:message code="institution.image_ref.file.label" default="File" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "imageRef.file")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="institution.image_ref.file.label" default="Caption" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "imageRef.caption")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="institution.image_ref.file.label" default="Attribution" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "imageRef.attribution")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="institution.image_ref.file.label" default="Copyright" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "imageRef.copyright")}</td>
                                  </tr>
                                </table>
                              </g:if>
                            </td>
                        </tr>

<!-- Latitude -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.latitude.label" default="Latitude" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${institutionInstance.latitude}' degree='true'/></td>
                        </tr>

<!-- Longitude -->      <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.longitude.label" default="Longitude" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${institutionInstance.longitude}' degree='true'/></td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.email.label" default="Email" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "email")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.phone.label" default="Phone" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "phone")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.isALAPartner.label" default="Is ALA Partner" /></td>
                            
                            <td valign="top" class="value"><g:formatBoolean boolean="${institutionInstance?.isALAPartner}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.dateCreated.label" default="Date Created" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${institutionInstance?.dateCreated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.dateFirstDataReceived.label" default="Date First Data Received" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${institutionInstance?.dateFirstDataReceived}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.notes.label" default="Notes" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "notes")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.institutionType.label" default="Institution Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "institutionType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.children.label" default="Collections" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${institutionInstance.getSafeChildren()}" var="c">
                                    <li><g:link controller="collection" action="show" id="${c.id}">${c?.name}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
<!-- Contacts -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.contacts.label" default="Contacts" /></td>
                            
                        <td valign="top" style="text-align: left;" class="value">
                            <ul>
                            <g:each in="${contacts}" var="c">
                                <li><g:link controller="contact" action="show" id="${c?.contact?.id}">
                                  ${c?.contact?.buildName()}<cl:roleIfPresent role='${c?.role}' /> <cl:adminIfPresent admin='${c?.administrator}' /></g:link></li>
                            </g:each>
                            </ul>
                        </td>

                        </tr>
                    
<!-- last edit -->      <tr class="prop">
                            <td valign="top" class="name">Last edited</td>
                            <td valign="top" class="value">by ${fieldValue(bean: institutionInstance, field: "userLastModified")} on ${fieldValue(bean: institutionInstance, field: "dateLastModified")}</td>
                        </tr>

                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form url="[action:'editInstitution']">
                  <g:hiddenField name="id" value="${institutionInstance?.id}" />
                  <cl:isAuth user="${loggedInUserInfo(field:'username')}" collection="${collectionInstance?.id}">
                    <span class="button"><g:actionSubmit class="edit" action='editInstitution' value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                  </cl:isAuth>
                  <g:ifAllGranted role="ROLE_ADMIN">
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                  </g:ifAllGranted>
                </g:form>
            </div>
        </div>
    </body>
</html>
