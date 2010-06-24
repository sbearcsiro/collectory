<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Registry database reports</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list">Reports</g:link></span>
        </div>
        <div class="body">
            <h1>Institutions report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <div id="full">
                <table>
                  <colgroup><col width="80%"/><col width="10%"/><col width="10%"/></colgroup>
                  <tr><td>Columns show whether the institution is an ALA partner and has a primary contact.</td>
                    <td colspan="2"><a href="#"
                          onclick="document.getElementById('names-only').style.display='block';document.getElementById('full').style.display='none'">
                    (Show names only)</a></td></tr>
                  <tr class="reportGroupTitle"><td>All institutions</td><td>ALA</td><td>Cont</td></tr>
                  <g:each var='c' in="${ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION, [sort: 'name'])}">
                    <tr>
                      <td><g:link controller="institution" action="show" id="${c.id}">${fieldValue(bean: c, field: "name")}</g:link></td>
                      <td>${c.isALAPartner?'Y':' '}</td>
                      <td>${c.getPrimaryContact()?'Y':' '}</td>
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
                  <tr class="reportGroupTitle"><td colspan="3">All institutions</td></tr>
                  <g:each var='c' in="${ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_INSTITUTION, [sort: 'name'])}">
                    <tr>
                      <td>${fieldValue(bean: c, field: "name")}</td>
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
