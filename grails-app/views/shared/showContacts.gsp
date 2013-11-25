<%@ page import="au.org.ala.collectory.Contact; au.org.ala.collectory.ContactFor" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${command.ENTITY_TYPE}"/>
  <g:set var="entityNameLower" value="${command.ENTITY_TYPE.toLowerCase()}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>
<body>
  <div class="nav">
    <h1>Editing: ${command.name}</h1>
  </div>
  <div class="body">
    <g:if test="${flash.message}">
      <div class="message">${flash.message}</div>
    </g:if>
    <div class="dialog emulate-public">
      <h2>Current contacts</h2>
      <g:each var="cf" in="${command.getContacts()}">
        <div class="show-section">
          <!-- Name -->
          <div><span class="contactName">${cf.contact.buildName()}</span></div>
          <table class="shy">
            <colgroup><col width="68%"><col width="32%"></colgroup>
            <!-- details -->
            <tr><td>
              <ul class="detailList">
                <cl:valueOrOtherwise value="${cf.contact.email}"><li>${cf.contact.email}</li></cl:valueOrOtherwise>
                <cl:valueOrOtherwise value="${cf.contact.phone}"><li>Ph: ${cf.contact.phone}</li></cl:valueOrOtherwise>
                <cl:valueOrOtherwise value="${cf.contact.mobile}"><li>Mob: ${cf.contact.mobile}</li></cl:valueOrOtherwise>
                <cl:valueOrOtherwise value="${cf.contact.fax}"><li>Fax: ${cf.contact.fax}</li></cl:valueOrOtherwise>
              </ul>
            </td>
            <td style="padding-bottom:20px;">
              <span class="contactButton buttonRight">
                <g:link class="edit-small" controller="contact" action='edit' id="${cf.contact.id}"
                        params='[returnTo: "/${command.urlForm()}/edit/${command.id}?page=/shared/showContacts"]'>
                  ${message(code: 'default.button.editContact.label', default: "Edit the contact's details")}
                </g:link>
              </span>
            </td></tr>

            <!-- role -->
            <tr><td colspan="2"><span class="label">In this collection:</span></td></tr>
            <tr><td>
                <ul class="detailList">
                  <li><cl:valueOrOtherwise value="${cf.role}" otherwise="No role defined">Role is ${cf.role}</cl:valueOrOtherwise></li>
                  <li><cl:valueOrOtherwise value="${cf.administrator}" otherwise="Not allowed to edit"><img src="${resource(dir:'images/ala', file:'olive-tick.png')}"/>Editor</cl:valueOrOtherwise></li>
                  <li><cl:valueOrOtherwise value="${cf.notify}" otherwise=""><img src="${resource(dir:'images/ala', file:'olive-tick.png')}"/>Notify</cl:valueOrOtherwise></li>
                  <cl:valueOrOtherwise value="${cf.primaryContact}"><li><img src="${resource(dir:'images/ala', file:'olive-tick.png')}"/>Primary contact</li></cl:valueOrOtherwise>
                </ul>
            </td>
            <td>
              <span class="contactButton buttonRight">
                <g:link class="edit-small" action='editRole' id="${cf.id}"
                  params='[returnTo: "/${command.urlForm()}/edit/${command.id}?page=/shared/showContacts"]'>
                  Edit the contact's role in this ${entityNameLower}
                </g:link>
              </span>
            </td></tr>

            <!-- remove -->
            <tr><td></td><td>
              <span class="contactButton">
                <g:link class="removeSmallAction" action='removeContact' id="${command.id}" onclick="return confirm('Remove ${cf.contact?.buildName()} as a contact for this ${entityNameLower}?');"
                        params='[idToRemove: "${cf.id}"]'>Remove the contact for this ${entityNameLower}</g:link>
              </span>
            </td></tr>

          </table>
        </div>
      </g:each>
      <!-- add existing contact -->
      <h2>New contacts</h2>
      <div class="show-section">
        <g:form action="addContact" id="${command.id}">
          <table class="shy">
            <colgroup><col width="68%"><col width="32%"></colgroup>
            <tr><td colspan="2">Choose an existing contact</td></tr>
            <tr><td>
              <g:select name="addContact" from="${Contact.listOrderByLastName()}" optionKey="id" noSelection="${['null':'Select one to add']}" />
            </td><td>
              <input type="submit" onclick="return anySelected('addContact','You must select a contact to add.');" class="addAction" value="Add existing contact"/>
            </td></tr>
          </table>
        </g:form>
        OR:<br/>
        <table class="shy">
          <colgroup><col width="68%"><col width="32%"></colgroup>
          <tr><td>Create a new contact and add them to this ${entityNameLower}:</td>
          <td>
          <span class="button">
            <g:link class="addAction" controller="contact" action='create' params='[returnTo:"/${command.urlForm()}/addNewContact/${command.id}"]' id="${command.id}">${message(code: 'default.button.addContact.label', default: 'Add new contact')}</g:link>
          </span>
          </td></tr>
        </table>
      </div>
    </div>

    <div class="buttons">
      <g:form>
        <g:hiddenField name="id" value="${command.id}"/>
        <span class="button"><g:link class="returnAction" controller="${command.urlForm()}" action='show' id="${command.id}">Return to ${command.name}</g:link></span>
      </g:form>
    </div>
  </div>
</body>
</html>
