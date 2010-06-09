
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
                <!-- event field is used by submit buttons to pass the web flow event (rather than using the text of the button as the event name) -->
                <g:hiddenField id="event" name="_eventId" value="next" />
                <div class="dialog">
                  <cl:navButtons />
                    <table>
                        <tbody>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="websiteUrl"><g:message code="providerGroup.websiteUrl.label" default="Website Url" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'websiteUrl', 'errors')}">
                                <g:textField name="websiteUrl" maxLength="256" value="${command?.websiteUrl}" />
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <!--label for="imageRef"><g:message code="providerGroup.imageRef.label" default="Representative image" /></label-->
                              Representative<br/>image
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef', 'errors')}">
                              <g:render template="/shared/attributableImage" model="[command: command, directory: 'collection', action: 'editCollection']"/>
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </div>
            </g:uploadForm>
        </div>
    </body>
</html>
