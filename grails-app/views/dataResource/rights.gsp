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

                        <!-- citable agent -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="citableAgent"><g:message code="dataResource.citableAgent.label" default="Citable agent" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'citableAgent', 'errors')}">
                                <g:textArea name="citableAgent" cols="40" rows="${cl.textAreaHeight(text:command.citableAgent)}" value="${command?.citableAgent}" />
                                <cl:helpText code="dataResource.citableAgent"/>
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
                                <cl:helpText code="dataResource.focus"/>
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
