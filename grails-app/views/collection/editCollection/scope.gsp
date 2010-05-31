
<%@ page import="au.org.ala.collectory.CollectionCommand" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body class="yui-skin-sam">
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
                    <table>
                        <tbody>

                        <tr class="prop">
                            <td valign="top" class="checkbox">
                              <cl:label for="kingdomCoverage" source="infoSource" default="Kingdom coverage"/>
                            </td>
                            <td valign="top" class="checkbox">
                                <cl:checkBoxList name="kingdomCoverage" from="${CollectionCommand.kingdoms()}" value="${command?.kingdomCoverage}" />
                                <cl:helpText code="infosource.kingdomCoverage"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="scientificNames" source="infoSource" default="Scientific names"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'endDate', 'errors')}">
                                <!--richui:autoComplete name="scientificNames" controller="collection" action="scinames" title="sci name"/-->
                              <g:textArea name="scientificNames" />
                              <cl:helpText code="infosource.scientificNames"/>
                          </td>
                          <cl:helpTD/>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="states" source="infoSource" default="States"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'states', 'errors')}">
                                <g:textField name="states" value="${command?.states}" />
                                <cl:helpText code="infosource.states"/>
                            </td>
                            <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="geographicDescription" source="infoSource" default="Geographic description"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'geographicDescription', 'errors')}">
                                <g:textField name="geographicDescription" value="${command?.geographicDescription}" />
                                <cl:helpText code="infosource.geographicDescription"/>
                            </td>
                            <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="eastCoordinate" source="infoSource" default="East Coordinate"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'eastCoordinate', 'errors')}">
                              <g:textField name="eastCoordinate" value="${cl.showDecimal(value:fieldValue(bean: command, field: 'eastCoordinate'))}" />
                              <cl:helpText code="infosource.eastCoordinate"/>
                          </td>
                          <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="westCoordinate" source="infoSource" default="West Coordinate"/>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'westCoordinate', 'errors')}">
                              <g:textField name="westCoordinate" value="${cl.showDecimal(value:fieldValue(bean: command, field: 'westCoordinate'))}" />
                              <cl:helpText code="infosource.westCoordinate"/>
                          </td>
                          <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="northCoordinate" source="infoSource" default="North Coordinate"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'northCoordinate', 'errors')}">
                                <g:textField name="northCoordinate" value="${cl.showDecimal(value:fieldValue(bean: command, field: 'northCoordinate'))}" />
                                <cl:helpText code="infosource.northCoordinate"/>
                            </td>
                            <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="southCoordinate" source="infoSource" default="South Coordinate"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'southCoordinate', 'errors')}">
                              <g:textField name="southCoordinate" value="${cl.showDecimal(value:fieldValue(bean: command, field: 'southCoordinate'))}" />
                              <cl:helpText code="infosource.southCoordinate"/>
                          </td>
                          <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="startDate" source="infoSource" default="Start date"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'startDate', 'errors')}">
                                <g:textField name="startDate" maxlength="45" value="${command?.startDate}" />
                                <cl:helpText code="infosource.startDate"/>
                            </td>
                            <cl:helpTD/>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name">
                              <cl:label for="endDate" source="infoSource" default="End date"/>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'endDate', 'errors')}">
                                <g:textField name="endDate" maxlength="45" value="${command?.endDate}" />
                                <cl:helpText code="infosource.endDate"/>
                            </td>
                            <cl:helpTD/>
                        </tr>
                        
                        </tbody>
                    </table>
                </div>
                <cl:navButtons exclude=''/>
            </g:uploadForm>
        </div>
    </body>
</html>
