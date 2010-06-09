
<%@ page import="au.org.ala.collectory.CollectionCommand" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
          <g:if test="${mode == 'create'}">
            <h1>Creating a new collection</h1>
          </g:if>
          <g:else>
            <h1>Editing: ${command.name}</h1>
          </g:else>
        </div>
        <div id="identForm" class="body">
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="identForm" url="[action:'editCollection']">
                <g:hiddenField name="id" value="${command?.id}" />
                <!-- event field is used by submit buttons to pass the web flow event (rather than using the text of the button as the event name) -->
                <g:hiddenField id="event" name="_eventId" value="next" />
                <div class="dialog">
                  <cl:navButtons exclude='back' />
                    <table>
                        <tbody>

                          <tr class="prop">
                              <td valign="top" class="name">
                                <label for="guid"><g:message code="providerGroup.guid.label" default="Guid" />
                                  <br/><span class=hint>* required field</span>
                                </label>
                              </td>
                              <td valign="top" class="value ${hasErrors(bean: command, field: 'guid', 'errors')}">
                                <g:textField name="guid" maxlength="45" value="${command?.guid}" />
                                <cl:helpText code="collection.guid"/>
                              </td>
                              <cl:helpTD/>
                          </tr>

                          <tr class="prop">
                              <td valign="top" class="name">
                                <label for="name"><g:message code="providerGroup.name.label" default="Name" />
                                  <br/><span class=hint>* required field</span>
                                </label>
                              </td>
                              <td id="previous" valign="top" class="value ${hasErrors(bean: command, field: 'name', 'errors')}">
                                <g:textField name="name" maxlength="128" value="${command?.name}" />
                                <cl:helpText code="collection.name"/>
                              </td>
                            <cl:helpTD/>
                          </tr>

                          <tr class="prop">
                              <td valign="top" class="name">
                                <label for="acronym"><g:message code="providerGroup.acronym.label" default="Acronym" /></label>
                              </td>
                              <td valign="top" class="value ${hasErrors(bean: command, field: 'acronym', 'errors')}">
                                  <g:textField name="acronym" maxlength="45" value="${command?.acronym}" />
                                  <cl:helpText code="collection.acronym"/>
                              </td>
                            <cl:helpTD/>
                          </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="collectionType"><g:message code="providerGroup.collectionType.label" default="Collection Type" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'collectionType', 'errors')}">
                                <g:select name="collectionType" from="${command.constraints.collectionType.inList}" value="${command?.collectionType}" valueMessagePrefix="providerGroup.collectionType" noSelection="['': '']" />
                                <cl:helpText code="collection.collectionType"/>
                            </td>
                          <td><img class="helpButton" alt="help" src="${resource(dir:'images/skin', file:'help.gif')}" onclick="toggleHelp(this);"/></td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="active"><g:message code="providerGroup.sources.active.label" default="Active" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'active', 'errors')}">
                                <g:select name="active" from="${command.constraints.active.inList}" value="${command?.active}" valueMessagePrefix="infoSource.active" noSelection="['': '']" />
                                <cl:helpText code="collection.active"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="focus"><g:message code="providerGroup.focus.label" default="Focus" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'focus', 'errors')}">
                                <g:textArea name="focus" cols="40" rows="5" value="${command?.focus}" />
                                <cl:helpText code="collection.focus"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        </tbody>
                    </table>
                </div>
            </g:form>
        </div>
    </body>
</html>
