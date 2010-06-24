
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
            <g:if test="${message}">
            <div class="message">${message}</div>
            </g:if>
            <g:hasErrors bean="${command}">
            <div class="errors">
                <g:renderErrors bean="${command}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" enctype="multipart/form-data" action="editCollection">
                <g:hiddenField name="id" value="${command?.id}" />
                <!-- event field is used by submit buttons to pass the web flow event (rather than using the text of the button as the event name) -->
                <g:hiddenField id="event" name="_eventId" value="next" />
                <div class="dialog">
                  <cl:navButtons />
                    <table>
                        <tbody>

<!-- address -->            <tr class="prop">
                              <td valign="top" class="name">
                                <g:message code="providerGroup.address.label" default="Address" />
                              </td>
                              <td valign="top">
                                <table class="shy">
                                  <tr class='prop'>
                                    <td valign="top" class="name">
                                      <label for="address.street"><g:message code="providerGroup.address.street.label" default="Street" /></label>
                                    </td>
                                    <td valign="top" class="value ${hasErrors(bean: command, field: 'address.street', 'errors')}">
                                        <g:textField name="address.street" maxlength="128" value="${command?.address?.street}" />
                                    </td>
                                  </tr>
                                  <tr class='prop'>
                                    <td valign="top" class="name">
                                      <label for="address.postBox"><g:message code="providerGroup.address.postBox.label" default="Post box" /></label>
                                    </td>
                                    <td valign="top" class="value ${hasErrors(bean: command, field: 'address.postBox', 'errors')}">
                                        <g:textField name="address.postBox" maxlength="128" value="${command?.address?.postBox}" />
                                    </td>
                                  </tr>
                                  <tr class='prop'>
                                    <td valign="top" class="name">
                                      <label for="address.city"><g:message code="providerGroup.address.city.label" default="City" /></label>
                                    </td>
                                    <td valign="top" class="value ${hasErrors(bean: command, field: 'address.city', 'errors')}">
                                        <g:textField name="address.city" maxlength="128" value="${command?.address?.city}" />
                                    </td>
                                  </tr>
                                  <tr class='prop'>
                                    <td valign="top" class="name">
                                      <label for="address.state"><g:message code="providerGroup.address.state.label" default="State or territory" /></label>
                                    </td>
                                    <td valign="top" class="value ${hasErrors(bean: command, field: 'address.state', 'errors')}">
                                        <g:textField name="address.state" maxlength="128" value="${command?.address?.state}" />
                                    </td>
                                  </tr>
                                  <tr class='prop'>
                                    <td valign="top" class="name">
                                      <label for="address.postcode"><g:message code="providerGroup.address.postcode.label" default="Postcode" /></label>
                                    </td>
                                    <td valign="top" class="value ${hasErrors(bean: command, field: 'address.street', 'errors')}">
                                        <g:textField name="address.postcode" maxlength="128" value="${command?.address?.postcode}" />
                                    </td>
                                  </tr>
                                  <tr class='prop'>
                                    <td valign="top" class="name">
                                      <label for="address.country"><g:message code="providerGroup.address.country.label" default="Country" /></label>
                                    </td>
                                    <td valign="top" class="value ${hasErrors(bean: command, field: 'address.country', 'errors')}">
                                        <g:textField name="address.country" maxlength="128" value="${command?.address?.country}" />
                                    </td>
                                  </tr>
                                </table>

                              </td>
                          </tr>

                          <tr class="prop">
                              <td valign="top" class="name">
                                <label for="latitude"><g:message code="providerGroup.latitude.label" default="Latitude" />
                                  <br/><span class=hint>(decimal degrees)</span>
                                </label>
                              </td>
                              <td valign="top" class="value ${hasErrors(bean: command, field: 'latitude', 'errors')}">
                                <g:textField name="latitude" value="${fieldValue(bean: command, field: 'latitude')}" />
                                <cl:helpText code="collection.latitude"/>
                            </td>
                            <cl:helpTD/>
                          </tr>

                          <tr class="prop">
                              <td valign="top" class="name">
                                <label for="longitude">
                                  <g:message code="providerGroup.longitude.label" default="Longitude" />
                                  <br/><span class=hint>(decimal degrees)</span>
                                </label>
                              </td>
                              <td valign="top" class="value ${hasErrors(bean: command, field: 'longitude', 'errors')}">
                                <g:textField name="longitude" value="${fieldValue(bean: command, field: 'longitude')}" />
                                <cl:helpText code="collection.longitude"/>
                            </td>
                            <cl:helpTD/>
                          </tr>

                          <tr class="prop">
                              <td valign="top" class="name">
                                <label for="state"><g:message code="providerGroup.state.label" default="State" />
                                  <br/><span class=hint>(where the collection<br>resides)</span>
                                </label>
                              </td>
                              <td valign="top" class="value ${hasErrors(bean: command, field: 'state', 'errors')}">
                                  <g:select name="state" from="${command.constraints.state.inList}" value="${command?.state}" valueMessagePrefix="providerGroup.state" noSelection="['': '']" />
                                  <cl:helpText code="collection.state"/>
                              </td>
                              <cl:helpTD/>
                          </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="email"><g:message code="providerGroup.email.label" default="Email" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'email', 'errors')}">
                                <g:textField name="email" maxLength="256" value="${command?.email}" />
                                <cl:helpText code="collection.email"/>
                            </td>
                            <cl:helpTD/>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                              <label for="phone"><g:message code="providerGroup.phone.label" default="Phone" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: command, field: 'phone', 'errors')}">
                                <g:textField name="phone" maxlength="45" value="${command?.phone}" />
                                <cl:helpText code="collection.phone"/>
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
