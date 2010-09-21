<%@ page import="au.org.ala.collectory.DataHub; au.org.ala.collectory.DataResource; au.org.ala.collectory.DataProvider" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Registry database reports</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><cl:homeLink/></span>
            <span class="menuButton"><g:link class="list" action="list">Reports</g:link></span>
        </div>
        <div class="body">
            <h1>Data providers report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

            <gui:tabView>
              <gui:tab label="Data providers" active="true">
              <div id="dps">
                <table>
                  <colgroup><col width="80%"/><col width="10%"/><col width="10%"/></colgroup>
                  <tr class="reportGroupTitle"><td>All providers</td><td>UID</td><td>Resources</td></tr>
                  <g:each var='c' in="${DataProvider.list([sort: 'name'])}">
                    <tr>
                      <td><g:link controller="dataProvider" action="show" id="${c.uid}">${fieldValue(bean: c, field: "name")}</g:link></td>
                      <td>${c.uid}</td>
                      <td>${c.resources?.size()}</td>
                    </tr>
                  </g:each>
                </table>
              </div>
              </gui:tab>

              <gui:tab label="Data resources">
                <div class="drs">
                  <table>
                    <colgroup><col width="53%"/><col width="7%"/><col width="30%"/><col width="10%"/></colgroup>
                    <tr class="reportGroupTitle"><td>All resources</td><td>UID</td><td>Provider</td><td>Institution</td></tr>
                    <g:each var='c' in="${DataResource.list([sort: 'name'])}">
                      <tr>
                        <td><g:link controller="dataResource" action="show" id="${c.uid}">${fieldValue(bean: c, field: "name")}</g:link></td>
                        <td>${c.uid}</td>
                        <td><cl:ifNotBlank tagName="" value="${c.shortProviderName()}"/></td>
                        <td><cl:acronymOrShortName entity="${c.institution}"/></td>
                      </tr>
                    </g:each>
                  </table>
                </div>
              </gui:tab>

              <gui:tab label="Data hubs">
                <div id="hubs">
                  <table>
                    <colgroup><col width="70%"/><col width="30%"/></colgroup>
                    <tr><td>Data hubs</td><td>UID</td></tr>
                    <tr class="reportGroupTitle"><td colspan="3">All hubs</td></tr>
                    <g:each var='c' in="${DataHub.list([sort: 'name'])}">
                      <tr>
                        <td>${fieldValue(bean: c, field: "name")}</td>
                        <td>${c.uid}</td>
                      </tr>
                    </g:each>
                  </table>
                </div>
              </gui:tab>
           </gui:tabView>
        </div>
    </body>
</html>
