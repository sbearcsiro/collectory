
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
            <g:if test="${fieldValue(bean: institutionInstance, field: 'logoRef')}">
              <img src='<g:resource dir="images/institution/" file="${fieldValue(bean: institutionInstance, field: 'logoRef.file')}"/>' />
            </g:if>
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

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.description.label" default="Description" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "description")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.address.label" default="Address" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "address")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.state.label" default="State" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "state")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.website_url.label" default="Websiteurl" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "websiteUrl")}</td>
                            
                        </tr>
                    
<!-- logo -->           <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.logo_ref.label" default="Logo" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: 'logoRef.file')}</td>
                            
                        </tr>

                        <g:if test="${fieldValue(bean: institutionInstance, field: 'logoRef.caption')}">
                          <tr class="prop">
                              <td valign="top" class="name"></td>
                              <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: 'logoRef.caption')}</td>
                          </tr>
                        </g:if>

                        <g:if test="${fieldValue(bean: institutionInstance, field: 'logoRef.attribution')}">
                          <tr class="prop">
                              <td valign="top" class="name"></td>
                              <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: 'logoRef.attribution')}</td>
                          </tr>
                        </g:if>

                        <g:if test="${fieldValue(bean: institutionInstance, field: 'logoRef.copyright')}">
                          <tr class="prop">
                              <td valign="top" class="name"></td>
                              <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: 'logoRef.copyright')}</td>
                          </tr>
                        </g:if>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="institution.image_ref.label" default="Imageref" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: institutionInstance, field: "imageRef")}</td>
                            
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
                                <g:each in="${institutionInstance.children}" var="c">
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
                                  ${c?.contact?.buildName()}<cl:roleIfPresent role='${c?.role}' /> <cl:adminIfPresent admin='${c?.isAdministrator}' /></g:link></li>
                            </g:each>
                            </ul>
                        </td>

                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${institutionInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
