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
                              <label for="pubDescription"><g:message code="providerGroup.pubDescription.label" default="Public Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'pubDescription', 'errors')}">
                                <g:textArea name="pubDescription" cols="40" rows="5" value="${command?.pubDescription}" />
                                <cl:helpText code="collection.pubDescription"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="techDescription"><g:message code="providerGroup.techDescription.label" default="Technical Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'techDescription', 'errors')}">
                                <g:textArea name="techDescription" cols="40" rows="5" value="${command?.techDescription}" />
                                <cl:helpText code="collection.techDescription"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="keywords"><g:message code="scope.keywords.label" default="Keywords" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'keywords', 'errors')}">
                                <g:textField name="keywords" value="${command?.keywords}" />
                                <cl:helpText code="infoSource.keywords"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- sub-collections -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="notes"><g:message code="scope.subCollections.label" default="Sub-collections" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'scope.subCollections', 'errors')}">
                              <p>Optionally describe any significant collections held within this collection.</p>
                              <table class="shy"><colgroup><col width="50%"/><col width="50%"/></colgroup>
                                <tr><td>Name</td><td>Description</td></tr>
                                <g:each var="sub" in="${command.subCollections}" status="i">
                                  <tr>
                                    <td valign="top"><g:textField name="name_${i}" value="${sub.name.encodeAsHTML()}" /></td>
                                    <td valign="top"><g:textField name="description_${i}" value="${sub.description.encodeAsHTML()}" /></td>
                                  </tr>
                                </g:each>
                                <g:set var="j" value="${command.subCollections.size()}"/>
                                <g:each var="i" in="${[j, j+1, j+2]}">
                                  <tr>
                                    <td valign="top"><g:textField name="name_${i}" value="" /></td>
                                    <td valign="top"><g:textField name="description_${i}" value="" /></td>
                                  </tr>
                                </g:each>
                              </table>
                              <cl:createFlowSubmit event="addMore" value="Add more.." />
                              <cl:helpText code="scope.subCollections"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="notes"><g:message code="providerGroup.notes.label" default="Notes" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'notes', 'errors')}">
                                <g:textArea name="notes" cols="40" rows="5" value="${command?.notes}" />
                                <cl:helpText code="collection.notes"/>
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
