<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title><g:message code="profile.base.label" default="My profile" /></title>
    </head>
    <body>
        <div class="nav">
            <h1 style="display:inline;">Editing my profile (${contact.email})</h1><span style="float:right;" class="menuButton"><cl:homeLink/></span>
        </div>
        <div id="baseForm" class="body">
            <g:if test="${message}">
            <div class="message">${message}</div>
            </g:if>
            <g:hasErrors bean="${contact}">
            <div class="errors">
                <g:renderErrors bean="${contact}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" action="updateProfile">
                <g:hiddenField name="id" value="${contact?.id}" />
                <g:hiddenField name="version" value="${contact.version}" />
                <div class="dialog custom-edit">
                  <h2 style="padding-top:10px;">My profile</h2>

                  <div>
                    <table style="border: none;">
                      <tbody>
                          <tr class="prop">
                              <td>
                                <table class="shy">
                                  <tr>
                                    <td style="width:90px;" class="${hasErrors(bean: contact, field: 'title', 'errors')}">
                                        <g:select name="title" from="${contact.constraints.title.inList}" value="${contact?.title}" valueMessagePrefix="contact.title" noSelection="['': '']" />
                                    </td>
                                    <td class="${hasErrors(bean: contact, field: 'firstName', 'errors')}">
                                        <g:textField name="firstName" maxlength="45" value="${contact?.firstName}" />
                                    </td>
                                    <td class="${hasErrors(bean: contact, field: 'lastName', 'errors')}">
                                        <g:textField name="lastName" maxlength="45" value="${contact?.lastName}" />
                                    </td>
                                  </tr>
                                </table>
                              </td>
                          </tr>
                        
                          <tr class="prop">
                              <td>
                                <table class="shy">
                                  <tr>
                                    <td style="vertical-align:middle;color:gray;">phone:</td>
                                    <td class="${hasErrors(bean: contact, field: 'phone', 'errors')}">
                                        <g:textField name="phone" maxlength="45" value="${contact?.phone}" />
                                    </td>
                                    <td style="vertical-align:middle;color:gray;">mobile:</td>
                                    <td class="${hasErrors(bean: contact, field: 'mobile', 'errors')}">
                                        <g:textField name="mobile" maxlength="45" value="${contact?.mobile}" />
                                    </td>
                                    <td style="vertical-align:middle;color:gray;">fax:</td>
                                    <td class="${hasErrors(bean: contact, field: 'fax', 'errors')}">
                                        <g:textField name="fax" maxlength="45" value="${contact?.fax}" />
                                    </td>
                                  </tr>
                                </table>
                              </td>
                          </tr>
                      </tbody>
                    </table>
                  </div>

                  <div class="repeats">
                    <g:each var="cr" in="${contactRels}">
                      <g:set var="uid" value="${cr.cf.entityUid}"/>
                      <g:set var="entity" value="${ProviderGroup.textFormOfEntityType(uid)}"/>
                      <h2>Contact for ${cr.entityName} (${uid})</h2>
                      <p>
                        Describe your role within this ${entity}?
                        <g:textField name="${uid}_role" maxlength="45" value="${cr.cf.role}" />
                      </p>
                      <p>
                        Would you like to be notified by email of any significant events in this ${entity}?
                        <g:checkBox name="${uid}_notify" value="${cr.cf.notify}" onchange="toggleFreq(this);"/>
                      </p>
                      <p id="${uid}_freq" style="display:${cr.cf.notify ? 'block':'none'}">
                        How often would you like to receive notifications?
                        <g:radio name="${uid}_frequency" value="each"/> Each event
                        <g:radio name="${uid}_frequency" value="daily" checked="checked"/> Daily
                        <g:radio name="${uid}_frequency" value="weekly"/> Weekly
                      </p>
                    </g:each>
                  </div>

                </div>

                <div class="buttons">
                    <span class="button"><input type="submit" name="_action_updateProfile" value="Update" class="save"></span>
                    <span class="button"><input type="submit" name="_action_cancelProfile" value="Cancel" class="cancel"></span>
                </div>
            </g:form>
        </div>
    <script type="text/javascript">
      function toggleFreq(obj) {
        var id = obj.id.substring(0, obj.id.indexOf('_')) + '_freq';
        var display = obj.checked ? 'block':'none';
        $('p#' + id).css('display',display);
      }
    </script>
    </body>
</html>
