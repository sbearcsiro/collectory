<%@ page import="au.org.ala.collectory.DataResource" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title><g:message code="dataResource.base.label" default="Edit data resource metadata" /></title>
    </head>
    <body>
        <div class="nav">
        <h1>Editing: ${command.name}</h1>
        </div>
        <div id="baseForm" class="body">
            <g:if test="${message}">
            <div class="message">${message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="baseForm" action="base">
                <g:hiddenField name="id" value="${command?.id}" />
                <g:hiddenField name="version" value="${command.version}" />
                <div class="dialog">
                    <table>
                        <tbody>

                        <!-- citation -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="citation"><g:message code="dataResource.citation.label" default="Citation" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'citation', 'errors')}">
                                <g:textArea name="citation" cols="40" rows="${cl.textAreaHeight(text:command.citation)}" value="${command.citation}" />
                                <cl:helpText code="dataResource.citation"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- rights -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="rights"><g:message code="dataResource.rights.label" default="Rights" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'rights', 'errors')}">
                                <g:textArea name="rights" cols="40" rows="${cl.textAreaHeight(text:command.rights)}" value="${command?.rights}" />
                                <cl:helpText code="dataResource.rights"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- license -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="licenseType"><g:message code="dataResource.licenseType.label" default="License type" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'licenseType', 'errors')}">
                                <g:select name="licenseType"
                                        from="${DataResource.ccDisplayList}"
                                        optionKey="type"
                                        optionValue="display"
                                        value="${command.licenseType}"/>
                                <cl:helpText code="dataResource.licenseType"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- license version -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="licenseVersion"><g:message code="dataResource.licenseVersion.label" default="License version" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'licenseVersion', 'errors')}">
                                <g:select name="licenseVersion"
                                        from="${['','2.5','3.0']}"
                                        value="${command.licenseVersion}"/>
                                <cl:helpText code="dataResource.licenseVersion"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- permissions document -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="permissionsDocument"><g:message code="dataResource.permissionsDocument.label" default="Permissions document" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'permissionsDocument', 'errors')}">
                                <g:textField name="permissionsDocument" value="${command?.permissionsDocument}" />
                                <cl:helpText code="dataResource.permissionsDocument"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- download limit -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="downloadLimit"><g:message code="dataResource.downloadLimit.label" default="Download limit" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'downloadLimit', 'errors')}">
                                <g:textField name="downloadLimit" value="${fieldValue(bean:command,field:'downloadLimit')}" />
                                <cl:helpText code="dataResource.downloadLimit"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                      </tbody>
                    </table>
                </div>

                <div class="buttons">
                    <span class="button"><input type="submit" name="_action_updateRights" value="Update" class="save"></span>
                    <span class="button"><input type="submit" name="_action_cancel" value="Cancel" class="cancel"></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
