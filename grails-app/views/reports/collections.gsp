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
            <h1>Collections report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

            <gui:tabView>
              <gui:tab label="Names only">
              <div id="names-only">
                <table>
                  <colgroup><col width="80%"/><col width="10%"/><col width="10%"/></colgroup>
                  <tr><td colspan="3">Simple name list (for copy and paste)</td></tr>
                  <tr class="reportGroupTitle"><td colspan="3">All collections</td></tr>
                  <g:each var='c' in="${ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION, [sort: 'name'])}">
                    <tr>
                      <td>${fieldValue(bean: c, field: "name")}</td>
                      <td></td>
                      <td></td>
                    </tr>
                  </g:each>
                </table>
              </div>
              </gui:tab>

              <gui:tab label="Attributes" active="true">
                <div class="dialog">
                  <table>
                    <colgroup><col width="70%"/><col width="10%"/><col width="10%"/><col width="10%"/></colgroup>
                    <tr><td colspan="4">Columns show whether the collection has an institution, has a primary contact and is an ALA partner.</td></tr>
                    <tr class="reportGroupTitle"><td>All collections</td><td>Inst</td><td>Cont</td><td>ALA</td></tr>
                    <g:each var='c' in="${ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION, [sort: 'name'])}">
                      <tr>
                        <td><g:link controller="collection" action="show" id="${c.id}">${fieldValue(bean: c, field: "name")}</g:link></td>
                        <td>${c.findPrimaryInstitution()?'Y':' '}</td>
                        <td>${c.getPrimaryContact()?'Y':' '}</td>
                        <td>${c.getIsALAPartner()?'Y':' '}</td>
                      </tr>
                    </g:each>
                  </table>
                </div>
              </gui:tab>

              <gui:tab label="Permalinks">
                <div id="permalinks">
                  <table>
                    <colgroup><col width="70%"/><col width="30%"/></colgroup>
                    <tr><td colspan="2">Optimal permanent links for the public collection pages.</td></tr>
                    <tr class="reportGroupTitle"><td colspan="3">All collections</td></tr>
                    <g:each var='c' in="${ProviderGroup.findAllByGroupType(ProviderGroup.GROUP_TYPE_COLLECTION, [sort: 'name'])}">
                      <tr>
                        <td>${fieldValue(bean: c, field: "name")}</td>
                        <td><cl:permalink type="collection" id="${c.generatePermalink()}"/></td>
                      </tr>
                    </g:each>
                  </table>
                </div>
              </gui:tab>
           </gui:tabView>
        </div>
    </body>
</html>
