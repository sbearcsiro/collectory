<%@ page import="au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.CollectionCommand" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
          <h1>Editing: ${fieldValue(bean: command, field: "name")}</h1>
        </div>
        <div class="body">
            <g:if test="${message}">
            <div class="message">${message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:hasErrors bean="${newInst}">
            <div class="errors">
                <g:renderErrors bean="${newInst}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" enctype="multipart/form-data" action="editCollection">
                <g:hiddenField name="id" value="${command?.id}" />
                <!-- event field is used by submit buttons to pass the web flow event (rather than using the text of the button as the event name) -->
                <g:hiddenField id="event" name="_eventId" value="next" />
                <div class="dialog">
                  <cl:navButtons />
                  <p class="wizardHeading">Indicate the institutions that administer this collection</p>

<!-- current -->        <span style="margin-left:50px;"><g:message code="providerGroup.existingContacts.label" default="Current institutions" /></span>
                        <table style="width:80%;border:1px solid #CCC;margin-left:auto;margin-right:auto;margin-bottom:20px;">
                            <tbody>

                          <g:each in="${command.parents}" var="i" status="row">
                            <tr class="prop">
                              <td valign="top" class="name">${i?.name}</td>
                              <td valign="top" class="name">${i?.acronym}</td>
                              <td valign="top" class="name">
                                <g:if test="${i?.isALAPartner}">
                                  ALA partner
                                </g:if>
                              </td>
                              <td style="width:130px;">
                                <span class="bodyButton"><g:link id="${i?.id}" class="removeAction" action="editCollection" event="remove"
                                        onclick="return confirm('Remove ${i?.name} as an institution that administers this collection?');">Remove</g:link></span>
                              </td>
                            </tr>
                          </g:each>
                        </tbody>
                    </table>

<!--add existing--> <span style="margin-left:50px;"><g:message code="providerGroup.addAContact.label" default="Add a known institution as an administrator of this collection" /></span>

                    <table style="width:80%;border:1px solid #CCC;margin-left:auto;margin-right:auto;margin-bottom:20px;padding-left:20px;">

                      <tr class="prop">
                        <td valign="top" class="name">Select</td>
                        <td valign="top" class="value">
                          <g:select name="addInstitution" from="${ProviderGroup.listInstitutions()}" optionKey="id" noSelection="${['null':'Select one to add']}" />
                        </td>
                      </tr>

<!-- add button -->   <tr>
                        <td>
                          <input type="submit" style="color:#222;" onclick="return anySelected('addInstitution','You must select an institution to add.');" class="addAction" value="Add institution"/>
                        </td>
                      </tr>

                      </table>


<!-- add new -->      <span style="margin-left:50px;">Register a new institution and add as an administrator of this collection</span>
                      <table style="width:80%;border:1px solid #CCC;margin-left:auto;margin-right:auto;margin-bottom:20px;padding-left:20px;">

<!-- Name-->          <tr class="prop">
                        <td valign="top" class="name">
                          <label for="name"><g:message code="institution.name.label" default="Name" /></label>
                          <br/><span class=hint>* required field</span>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: newInst, field: 'name', 'errors')}">
                            <g:textField name="name" maxlength="128" value="${fieldValue(bean: newInst, field:'name')}"/>
                        </td>
                      </tr>

<!-- Guid -->         <tr class="prop">
                        <td valign="top" class="name">
                          <label for="guid"><g:message code="institution.guid.label" default="Guid" /></label>
                          <br/><span class="hint">(if known)</span>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: newInst, field: 'guid', 'errors')}">
                            <g:textField name="guid" maxlength="45" value="${fieldValue(bean: newInst, field:'guid')}"/>
                        </td>
                      </tr>

<!-- Acronym-->       <tr class="prop">
                        <td valign="top" class="name">
                          <label for="acronym"><g:message code="institution.acronym.label" default="Acronym" /></label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: newInst, field: 'acronym', 'errors')}">
                            <g:textField name="acronym" maxlength="45" value="${fieldValue(bean: newInst, field:'acronym')}"/>
                        </td>
                      </tr>

<!-- Inst type-->     <tr class="prop">
                        <td valign="top" class="name">
                          <label for="institutionType"><g:message code="institution.institutionType.label" default="Institution Type" /></label>
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: newInst, field: 'institutionType', 'errors')}">
                          <g:select name="institutionType" from="${ProviderGroup.constraints.institutionType.inList}" valueMessagePrefix="providerGroup.institutionType" noSelection="['': '']"  value="${fieldValue(bean: newInst, field:'institutionType')}"/>
                        </td>
                      </tr>

                      <tr><td>
                        <input type="submit" style="color:#222" onclick="return document.getElementById('event').value = 'create'" class="addAction" value="Add institution"/>
                      </td></tr>
                    </table>
                </div>
            </g:form>
        </div>
    </body>
</html>
