<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title><g:message code="collection.base.label" default="Edit collection metadata" /></title>
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

                        <!-- public description -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="pubDescription"><g:message code="providerGroup.pubDescription.label" default="Public Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'pubDescription', 'errors')}">
                                <g:textArea name="pubDescription" cols="40" rows="${cl.textAreaHeight(text:command.pubDescription)}" value="${command.pubDescription}" />
                                <cl:helpText code="collection.pubDescription"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- tech description -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="techDescription"><g:message code="providerGroup.techDescription.label" default="Technical Description" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'techDescription', 'errors')}">
                                <g:textArea name="techDescription" cols="40" rows="${cl.textAreaHeight(text:command.techDescription)}" value="${command?.techDescription}" />
                                <cl:helpText code="collection.techDescription"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- focus -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="focus"><g:message code="providerGroup.focus.label" default="Focus" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'focus', 'errors')}">
                                <g:textArea name="focus" cols="40" rows="${cl.textAreaHeight(text:command.focus)}" value="${command?.focus}" />
                                <cl:helpText code="collection.focus"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- type -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="collectionType"><g:message code="collection.collectionType.label" default="Collection Type" /></label>
                            </td>
                            <td valign="top" class="checkbox ${hasErrors(bean: command, field: 'collectionType', 'errors')}">
                                <cl:checkboxSelect name="collectionType" from="${command.collectionTypes}" value="${command.listCollectionTypes()}" multiple="yes" valueMessagePrefix="collection.collectionType" noSelection="['': '']" />
                                <cl:helpText code="collection.collectionType"/>
                            </td>
                          <td><img class="helpButton" alt="help" src="${resource(dir:'images/skin', file:'help.gif')}" onclick="toggleHelp(this);"/></td>
                        </tr>

                        <!-- growth status -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="active"><g:message code="providerGroup.sources.active.label" default="Status" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: infoSourceInstance, field: 'active', 'errors')}">
                                <g:select name="active" from="${command.constraints.active.inList}" value="${command?.active}" valueMessagePrefix="infoSource.active" noSelection="['': '']" />
                                <cl:helpText code="collection.active"/>
                            </td>
                          <cl:helpTD/>
                        </tr>

                        <!-- start date -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="startDate">Start date</label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'startDate', 'errors')}">
                                <g:textField name="startDate" maxlength="45" value="${command?.startDate}" />
                                <cl:helpText code="collection.startDate"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                        <!-- end date -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="endDate">End date</label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'endDate', 'errors')}">
                                <g:textField name="endDate" maxlength="45" value="${command?.endDate}" />
                                <cl:helpText code="collection.endDate"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                        <!-- keywords -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="keywords"><g:message code="collection.keywords.label" default="Keywords" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'keywords', 'errors')}">
                                <g:textField name="keywords" value="${command?.listKeywords().join(',')}" />
                                <cl:helpText code="collection.keywords"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        <!-- sub-collections -->
                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="subCollections"><g:message code="scope.subCollections.label" default="Sub-collections" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'scope.subCollections', 'errors')}">
                              <p>Optionally describe any significant collections held within this collection.</p>
                              <table class="shy"><colgroup><col width="50%"/><col width="50%"/></colgroup>
                                <tr><td>Name</td><td>Description</td></tr>
                                <g:set var="subcollections" value="${command.listSubCollections()}"/>
                                <g:each var="sub" in="${subcollections}" status="i">
                                  <tr>
                                    <td valign="top"><g:textField name="name_${i}" value="${sub.name.encodeAsHTML()}" /></td>
                                    <td valign="top"><g:textField name="description_${i}" value="${sub.description.encodeAsHTML()}" /></td>
                                  </tr>
                                </g:each>
                                <g:set var="j" value="${subcollections.size()}"/>
                                <g:each var="i" in="${[j, j+1, j+2]}">
                                  <tr>
                                    <td valign="top"><g:textField name="name_${i}" value="" /></td>
                                    <td valign="top"><g:textField name="description_${i}" value="" /></td>
                                  </tr>
                                </g:each>
                              </table>
                              <cl:helpText code="scope.subCollections"/>
                              </td>
                              <cl:helpTD/>
                        </tr>

                        </tbody>
                    </table>
                </div>

                <div class="buttons">
                    <span class="button"><input type="submit" name="_action_updateDescription" value="Update" class="save"></span>
                    <span class="button"><input type="submit" name="_action_cancel" value="Cancel" class="cancel"></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
