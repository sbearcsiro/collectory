<%@ page import="au.org.ala.collectory.Contact; au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.ala.skin}" />
        <title>Registry database reports</title>
    </head>
    <body>
        <div class="nav">
            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list">Reports</g:link></span></li>
            </ul>
        </div>
        <div class="body">
            <h1>Contacts report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <div id="full">
                <table class="table table-striped table-bordered">
                  <colgroup><col width="80%"/><col width="10%"/><col width="10%"/></colgroup>
                  <tr><td>Columns show whether the contact has an email address and a phone number.</td>
                    <td colspan="2"><a href="#"
                          onclick="document.getElementById('names-only').style.display='block';document.getElementById('full').style.display='none'">
                    (Show names only)</a></td></tr>
                  <tr class="reportGroupTitle"><td>All contacts</td><td>Email</td><td>Phone</td></tr>
                  <g:each var='c' in="${Contact.findAll([sort: 'lastName'])}">
                    <tr>
                      <td><g:link controller="contact" action="show" id="${c.id}">${c.buildName()}</g:link></td>
                      <td>${c.email?'Y':' '}</td>
                      <td>${c.phone?'Y':' '}</td>
                    </tr>
                  </g:each>
                </table>
              </div>
              <div id="names-only" style="display:none;">
                <table>
                  <colgroup><col width="80%"/><col width="10%"/><col width="10%"/></colgroup>
                  <tr><td>Simple name list (for copy and paste)</td>
                    <td colspan="2"><a href="#"
                          onclick="document.getElementById('names-only').style.display='none';document.getElementById('full').style.display='block'">
                    (Show attributes)</a></td></tr>
                  <tr class="reportGroupTitle"><td colspan="3">All contacts</td></tr>
                  <g:each var='c' in="${Contact.findAll([sort: 'lastName'])}">
                    <tr>
                      <td>${c.buildName()}</td>
                      <td></td>
                      <td></td>
                    </tr>
                  </g:each>
                </table>
              </div>
            </div>
        </div>
    </body>
</html>
