
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
            <g:uploadForm method="post" action="editCollection">
                <g:hiddenField name="id" value="${command?.id}" />
                <!-- event field is used by submit buttons to pass the web flow event (rather than using the text of the button as the event name) -->
                <g:hiddenField id="event" name="_eventId" value="next" />
                <div class="dialog">
                  <cl:navButtons />
                    <table>
                        <tbody>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="numRecords"><g:message code="infoSource.numRecords.label" default="Num Records" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'numRecords', 'errors')}">
                                <g:textField name="numRecords" value="${fieldValue(bean: command, field: 'numRecords')}" />
                                <cl:helpText code="infoSource.numRecords"/>
                              </td>
                              <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="numRecordsDigitised"><g:message code="infoSource.numRecordsDigitised.label" default="Num Records Digitised" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'numRecordsDigitised', 'errors')}">
                                <g:textField name="numRecordsDigitised" value="${fieldValue(bean: command, field: 'numRecordsDigitised')}" />
                                <cl:helpText code="infoSource.numRecordsDigitised"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

<!-- web service -->    <tr class="prop">
                            <td valign="top" class="name">
                              <label for="webServiceUri"><g:message code="infoSource.webServiceUri.label" default="Web Service Uri" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'webServiceUri', 'errors')}">
                                <g:textField name="webServiceUri" value="${fieldValue(bean: command, field: 'webServiceUri')}" />
                                <cl:helpText code="infoSource.numRecords"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

<!-- protocol -->       <tr class="prop">
                            <td valign="top" class="name">
                              <label for="webServiceProtocol"><g:message code="infoSource.webServiceProtocol.label" default="Web Service Protocol" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'webServiceProtocol', 'errors')}">
                                <g:textField name="webServiceProtocol" value="${fieldValue(bean: command, field: 'webServiceProtocol')}" />
                                <cl:helpText code="infoSource.numRecords"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

<!-- codes -->          <tr class="prop">
                            <td valign="top" class="name">
                              <label for="providerCodes"><g:message code="providerGroup.providerCodes.label" default="Collection code" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'providerCodes', 'errors')}">
                                <g:textField name="providerCodes" value="${fieldValue(bean: command, field: 'providerCodes')}" />
                                <cl:helpText code="providerGroup.providerCodes"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                        </tbody>
                    </table>
                </div>
            </g:uploadForm>
        </div>
    </body>
</html>
