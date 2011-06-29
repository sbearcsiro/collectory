<%@ page import="au.org.ala.collectory.DataHub; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataResource; au.org.ala.collectory.resources.Profile" %>
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
            <g:form method="post" name="contributionForm" action="contribution">
                <g:hiddenField name="id" value="${command?.id}" />
                <g:hiddenField name="version" value="${command.version}" />
                <div class="dialog">
                    <table>
                        <tbody>

                        <!-- contributor -->
                        <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
                          <tr class="prop">
                              <td valign="top" class="name">
                                <label for="contributor"><g:message code="dataResource.contributor.label" default="Is contributor" /></label>
                              </td>
                              <td valign="top" class="value ${hasErrors(bean: command, field: 'contributor', 'errors')}">
                                  <g:checkBox name="contributor" value="${command?.contributor}" />
                              </td>
                          </tr>
                        </cl:ifGranted>

                        <!-- status -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="status"><g:message code="dataResource.status.label" default="Status" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'status', 'errors')}">
                                <g:select name="status"
                                        from="${['public','registered','in negotiation','harvested']}"
                                        value="${command.status}"
                                        noSelection="['':'none']"/>
                                <cl:helpText code="dataResource.status"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- last harvested -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <g:message code="dataResource.rights.label" default="Last harvested" />
                            </td>
                            <td valign="top" class="value">
                                ${fieldValue(bean: command, field: "lastHarvested")}
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- harvest frequency -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="harvestFrequency"><g:message code="dataResource.harvestFrequency.label" default="Harvest frequency" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'harvestFrequency', 'errors')}">
                                <g:select name="harvestFrequency"
                                        from="${['daily','weekly','monthly','six monthly','manual']}"
                                        value="${command.harvestFrequency}"
                                        noSelection="['':'never']"/>
                                <cl:helpText code="dataResource.harvestFrequency"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- notes -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="harvestingNotes"><g:message code="dataResource.harvestingNotes.label" default="Harvesting notes" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'harvestingNotes', 'errors')}">
                                <g:textArea name="harvestingNotes" cols="40" rows="${cl.textAreaHeight(text:command.harvestingNotes)}" value="${command?.harvestingNotes}" />
                                <cl:helpText code="dataResource.harvestingNotes"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- harvest parameters -->
                        <h2>Connection parameters</h2>
                        <cl:connectionParameters bean="command" connectionParameters="${command.connectionParameters}"/>

                      </tbody>
                    </table>
                </div>

                <div class="buttons">
                    <span class="button"><input type="submit" name="_action_updateContribution" value="Update" class="save"></span>
                    <span class="button"><input type="submit" name="_action_cancel" value="Cancel" class="cancel"></span>
                </div>
            </g:form>
        </div>
        <script type="text/javascript">
            function changeProtocol() {
                var protocol = $('#protocolSelector').attr('value');
                // clear all
                $('tr.labile').css('display','none');
                $('tr.labile input').attr('disabled','true');
                // show the selected
                $('tr#'+protocol).removeAttr('style');
                $('tr#'+protocol+' input').removeAttr('disabled');
            }
        </script>
    </body>
</html>
