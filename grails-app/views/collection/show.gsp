
<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<%@ page import="au.org.ala.collectory.ContactInContext" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1>${fieldValue(bean: collectionInstance, field: "name")}</h1>
            <g:if test="${fieldValue(bean: collectionInstance, field: 'logoRef')}">
              <img src='<g:resource dir="images/collection/" file="${fieldValue(bean: collectionInstance, field: 'logoRef.file')}"/>' />
            </g:if>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name" style="width: 300px"><g:message code="collection.name.label" default="Name" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "name")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.guid.label" default="Guid" /></td>

                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "guid")}</td>

                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.acronym.label" default="Acronym" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "acronym")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.description.label" default="Description" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "description")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.focus.label" default="Focus" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "focus")}</td>
                            
                        </tr>
                    
<!-- Address -->        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.address.label" default="Address" /></td>
                            
                            <td valign="top" class="value">
                              ${fieldValue(bean: collectionInstance, field: "address.street")}
                              ${fieldValue(bean: collectionInstance, field: "address.postBox")}
                              ${fieldValue(bean: collectionInstance, field: "address.city")}
                              ${fieldValue(bean: collectionInstance, field: "address.state")}
                              ${fieldValue(bean: collectionInstance, field: "address.postcode")}
                              <g:if test="${fieldValue(bean: collectionInstance, field: 'address.country') != 'Australia'}">
                                ${fieldValue(bean: collectionInstance, field: "address.country")}
                              </g:if>
                            </td>
                            
                        </tr>
                    
<!-- Latitude -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.latitude.label" default="Latitude" /></td>

                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "latitude")}&deg;</td>

                        </tr>

<!-- Longitude -->      <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.longitude.label" default="Longitude" /></td>

                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "longitude")}&deg;</td>

                        </tr>

<!-- Altitude -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.altitude.label" default="Altitude" /></td>

                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "altitude")}</td>

                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.state.label" default="State" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "state")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.website_url.label" default="Websiteurl" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "websiteUrl")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.image_ref.label" default="Imageref" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "imageRef")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.email.label" default="Email" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "email")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.phone.label" default="Phone" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "phone")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.isALAPartner.label" default="Is ALA Partner" /></td>
                            
                            <td valign="top" class="value"><g:formatBoolean boolean="${collectionInstance?.isALAPartner}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.dateCreated.label" default="Date Created" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${collectionInstance?.dateCreated}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.dateFirstDataReceived.label" default="Date First Data Received" /></td>
                            
                            <td valign="top" class="value"><g:formatDate date="${collectionInstance?.dateFirstDataReceived}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.notes.label" default="Notes" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "notes")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.collectionType.label" default="Collection Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "collectionType")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.providerCollectionCode.label" default="Provider Collection Code" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "providerCollectionCode")}</td>
                            
                        </tr>
                    
<!-- Num records -->    <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.collectionNumRecords.label" default="Collection Num Records" /></td>
                            
                            <td valign="top" class="value">
                              <g:if test="${fieldValue(bean: collectionInstance, field: 'collectionNumRecords') == '-1'}" >
                                No value available
                              </g:if>
                              <g:else>
                                ${fieldValue(bean: collectionInstance, field: "collectionNumRecords")}
                              </g:else>
                            </td>
                            
                        </tr>
                    
<!-- Institutions -->   <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.institutions.label" default="Institutions" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${collectionInstance.parents}" var="p">
                                    <li><g:link controller="institution" action="show" id="${p.id}">${p?.name}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
<!-- Contacts -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.contacts.label" default="Contacts" /></td>
                            
                        <td valign="top" style="text-align: left;" class="value">
                            <ul>
                            <g:each in="${contacts}" var="c">
                                <li><g:link controller="contact" action="show" id="${c?.contact?.id}">
                                  ${c?.contact?.buildName()}<cl:roleIfPresent role='${c?.role}' /> <cl:adminIfPresent admin='${c?.administrator}' /></g:link></li>
                            </g:each>
                            </ul>
                        </td>

                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
              <cl:isAuth user="${loggedInUserInfo(field:'username')}" collection="${collectionInstance?.id}">
                <g:form>
                    <g:hiddenField name="id" value="${collectionInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
              </cl:isAuth>
            </div>
        </div>
    </body>
</html>
