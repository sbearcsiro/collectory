<%@ page import="au.org.ala.collectory.DataHub; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataResource; au.org.ala.collectory.resources.Profile" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title><g:message code="dataResource.base.label" default="Edit data resource metadata" /></title>
        <link rel="stylesheet" href="${resource(dir:'css/smoothness',file:'jquery-ui-1.8.14.custom.css')}" type="text/css" media="screen"/>
        <link rel="stylesheet" href="${resource(dir:'css/smoothness',file:'jquery-ui-timepicker.css')}" type="text/css" media="screen"/>
        <g:javascript library="jquery-1.5.1.min"/>
        <g:javascript library="jquery-ui-1.8.14.custom.min"/>
        <g:javascript library="jquery.ui.timepicker"/>
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
                <g:hiddenField name="uid" value="${command?.uid}" />
                <g:hiddenField name="version" value="${command.version}" />
                <div class="dialog">
                    <table>
                        <tbody>

                        <!-- status -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="status"><g:message code="dataResource.status.label" default="Status" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'status', 'errors')}">
                                <g:select name="status"
                                        from="${DataResource.statusList}"
                                        value="${command.status}"/>
                                <cl:helpText code="dataResource.status"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- last checked -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="lastChecked"><g:message code="dataResource.lastChecked.label" default="Last checked" /></label>
                            </td>
                            <td valign="top" class="value">
                                <g:textField name="lastChecked" value="${command.lastChecked}"/>
                                <cl:helpText code="dataResource.lastChecked"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- data currency -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="dataCurrency"><g:message code="dataResource.dataCurrency.label" default="Data currency" /></label>
                            </td>
                            <td valign="top" class="value">
                                <g:textField name="dataCurrency" value="${command.dataCurrency}"/>
                                <cl:helpText code="dataResource.dataCurrency"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- harvest frequency -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="harvestFrequency"><g:message code="dataResource.harvestFrequency.label" default="Harvest frequency" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'harvestFrequency', 'errors')}">
                                <g:textField name="harvestFrequency" value="${command.harvestFrequency}"/>
                                <cl:helpText code="dataResource.harvestFrequency"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- mob notes -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="mobilisationNotes"><g:message code="dataResource.mobilisationNotes.label" default="Mobilisation notes" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'harvestingNotes', 'errors')}">
                                <g:textArea name="mobilisationNotes" cols="40" rows="${cl.textAreaHeight(text:command.mobilisationNotes)}" value="${command?.mobilisationNotes}" />
                                <p>Remember to add your initials and the date of contact.</p>
                                <cl:helpText code="dataResource.mobilisationNotes"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- harvest notes -->
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
                        <tr><td colspan="3"><b>Connection parameters</b></td></tr>
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
            function instrument() {
                var availableTags = [
                    "institutionCode",
                    "collectionCode",
                    "catalogNumber",
                    "occurrenceID",
                    "recordNumber"
                ];
                function split( val ) {
                    return val.split( /,\s*/ );
                }
                function extractLast( term ) {
                    return split( term ).pop();
                }

                $( "input#termsForUniqueKey:enabled" )
                    // don't navigate away from the field on tab when selecting an item
                    .bind( "keydown", function( event ) {
                        if ( event.keyCode === $.ui.keyCode.TAB &&
                                $( this ).data( "autocomplete" ).menu.active ) {
                            event.preventDefault();
                        }
                    })
                    .autocomplete({
                        minLength: 0,
                        source: function( request, response ) {
                            // delegate back to autocomplete, but extract the last term
                            response( $.ui.autocomplete.filter(
                                availableTags, extractLast( request.term ) ) );
                        },
                        focus: function() {
                            // prevent value inserted on focus
                            return false;
                        },
                        select: function( event, ui ) {
                            var terms = split( this.value );
                            // remove the current input
                            terms.pop();
                            // add the selected item
                            terms.push( ui.item.value );
                            // add placeholder to get the comma-and-space at the end
                            terms.push( "" );
                            this.value = terms.join( ", " );
                            return false;
                        }
                    });
            }
            function changeProtocol() {
                var protocol = $('#protocolSelector').attr('value');
                // remove autocomplete binding
                $('input#termsForUniqueKey:enabled').autocomplete('destroy');
                $('input#termsForUniqueKey:enabled').unbind('keydown');
                // clear all
                $('tr.labile').css('display','none');
                $('tr.labile input,textArea').attr('disabled','true');
                // show the selected
                $('tr#'+protocol).removeAttr('style');
                $('tr#'+protocol+' input,textArea').removeAttr('disabled');
                // re-enable the autocomplete functionality
                instrument();
            }
            instrument();
            $('[name="start_date"]').datepicker({dateFormat: 'yy-mm-dd'});
        </script>
    </body>
</html>
