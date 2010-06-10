<%@ page import="au.org.ala.collectory.Contact; au.org.ala.collectory.CollectionCommand" %>
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
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:hasErrors bean="${contact}">
            <div class="errors">
                <g:renderErrors bean="${contact}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" action="editCollection">
                <!-- event field is used by submit buttons to pass the web flow event (rather than using the text of the button as the event name) -->
                <g:hiddenField id="event" name="_eventId" value="next" />
                <cl:navButtons exclude="next"/>
                <div class="dialog">
                  <p class="wizardHeading">Choose contacts for this collection</p>

                    <span style="margin-left:50px;"><g:message code="providerGroup.existingContacts.label" default="Current contacts for this collection" /></span>
                    <table style="width:80%;border:1px solid #CCC;margin-left:auto;margin-right:auto;margin-bottom:20px;">
                        <tbody>

<!-- current -->          <g:each in="${command.contacts}" var="i" status="row">
                            <tr class="prop">
                              <td valign="top" class="name">${i?.contact?.buildName()}</td>
                              <td valign="top" class="name">${i?.role}</td>
                              <td valign="top" class="name">
                                <g:if test="${i?.administrator}">
                                  Admin
                                </g:if>
                              </td>
                              <td style="width:130px;">
                                <span class="bodyButton"><g:link id="${i?.contact?.id}" class="removeAction" action="editCollection" event="remove"
                                        onclick="return confirm('Remove ${i?.contact?.buildName()} as a contact for this collection?');">Remove</g:link></span>
                              </td>
                            </tr>
                          </g:each>
                        </tbody>
                    </table>

<!--add existing--> <span style="margin-left:50px;"><g:message code="providerGroup.addAContact.label" default="Add a known contact to this collection" /></span>

                    <table style="width:80%;border:1px solid #CCC;margin-left:auto;margin-right:auto;margin-bottom:20px;padding-left:20px;">

                      <tr class="prop">
                        <td valign="top" class="name">Select</td>
                        <td valign="top" class="value">
                          <g:select name="addContact" from="${Contact.listOrderByLastName()}" optionKey="id" noSelection="${['null':'Select one to add']}" />
                        </td>
                      </tr>
<!-- role -->         <tr class="prop">
                        <td valign="top" class="name">
                          <label for="role">Role<br/><span style="color:#777">e.g. Manager, <br/>Curator, Editor</span></label>
                        </td>
                        <td valign="top" class="value">
                            <g:textField name="role" maxlength="45"/>
                        </td>
                      </tr>

<!-- is admin -->     <tr class="prop">
                      <td class="checkbox">
                        <label for="isAdmin"><g:message code="contactFor.administrator.label" default="Administrator" /></label>
                      </td>
                      <td class="checkbox">
                        <label>
                          <g:checkBox name="isAdmin" value="true" />
                          <span class="hint">Allows the person to edit this collection</span>
                        </label>
                      </td>
                    </tr>

<!-- add button -->   <tr>
                        <td>
                          <input type="submit" style="color:#222;" onclick="return anySelected('addContact','You must select a contact to add.');" class="addAction" value="Add contact"/>
                        </td>
                      </tr>

                      </table>

<!-- add new -->      <span style="margin-left:50px;">Create a new contact and add to this collection</span>
                      <table style="width:80%;border:1px solid #CCC;margin-left:auto;margin-right:auto;margin-bottom:20px;padding-left:20px;">

<!-- title-->           <tr class="prop">
                          <td valign="top" class="name">
                            <label for="title"><g:message code="contact.title.label" default="Title" /></label><br/>
                            <span style="color:#777">e.g. Dr</span>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: contact, field: 'title', 'errors')}">
                              <g:textField name="title" maxlength="10"/>
                          </td>
                        </tr>

<!-- firstName-->       <tr class="prop">
                          <td valign="top" class="name">
                            <label for="firstName"><g:message code="contact.firstName.label" default="First name" /></label>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: contact, field: 'firstName', 'errors')}">
                              <g:textField name="firstName" maxlength="255"/>
                          </td>
                        </tr>

<!-- lastName-->        <tr class="prop">
                          <td valign="top" class="name">
                            <label for="lastName"><g:message code="contact.lastName.label" default="Last name" /></label>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: contact, field: 'lastName', 'errors')}">
                              <g:textField name="lastName" maxlength="255"/>
                          </td>
                        </tr>

<!-- phone-->           <tr class="prop">
                          <td valign="top" class="name">
                            <label for="phone"><g:message code="contact.phone.label" default="Phone" /></label>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: contact, field: 'phone', 'errors')}">
                              <g:textField name="phone" maxlength="45"/>
                          </td>
                        </tr>

<!-- mobile-->          <tr class="prop">
                          <td valign="top" class="name">
                            <label for="mobile"><g:message code="contact.mobile.label" default="Mobile" /></label>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: contact, field: 'mobile', 'errors')}">
                              <g:textField name="mobile" maxlength="45"/>
                          </td>
                        </tr>

<!-- email-->           <tr class="prop">
                          <td valign="top" class="name">
                            <label for="email"><g:message code="contact.email.label" default="Email" /></label>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: contact, field: 'email', 'errors')}">
                              <g:textField name="email" maxlength="45"/>
                          </td>
                        </tr>

<!-- fax-->             <tr class="prop">
                          <td valign="top" class="name">
                            <label for="fax"><g:message code="contact.fax.label" default="Fax" /></label>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: command, field: 'fax', 'errors')}">
                              <g:textField name="fax" maxlength="45"/>
                          </td>
                        </tr>

<!-- notes-->           <tr class="prop">
                          <td valign="top" class="name">
                            <label for="notes"><g:message code="contact.notes.label" default="Notes" /></label>
                          </td>
                          <td valign="top" class="value ${hasErrors(bean: contact, field: 'notes', 'errors')}">
                              <g:textArea name="notes" cols="40" rows="5" maxlength="1024"/>
                          </td>
                        </tr>

<!-- publish-->         <tr class="prop">
                          <td class="checkbox">
                            <label for="publish"><g:message code="contact.publish.label" default="Make public?" /></label>
                          </td>
                          <td class="checkbox">
                              <label>
                                <g:checkBox name="publish" value="true"/>
                                <span class="hint">Contact will be shown on the collection page</span>
                              </label>
                          </td>
                        </tr>

  <!-- role -->         <tr class="prop">
                          <td valign="top" class="name">
                            <label for="role"><g:message code="contactFor.role.label" default="Role" /><br/><span style="color:#777;">e.g. Manager, <br/>Curator, Editor</span></label>
                          </td>
                          <td valign="top" class="value">
                              <g:textField name="role2" maxlength="45"/>
                          </td>
                        </tr>

  <!-- is admin -->     <tr class="prop">
                          <td class="checkbox">
                            <label for="isAdmin2"><g:message code="contactFor.administrator.label" default="Administrator" /></label>
                          </td>
                          <td class="checkbox">
                            <label>
                              <g:checkBox name="isAdmin2" value="true" />
                              <span class="hint">Allows the person to edit this collection</span>
                            </label>
                          </td>
                        </tr>
                        <tr><td>
                          <input type="submit" style="color:#222" onclick="return document.getElementById('event').value = 'create'" class="addAction" value="Add contact"/>
                        </td></tr>
                    </table>
                </div>
            </g:form>
        </div>
    </body>
</html>
