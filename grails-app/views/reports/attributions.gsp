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
            <h1>Attributions report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

            <gui:tabView>
              <gui:tab label="Collections" active="true">
              <div class="dialog">
                <table>
                  <tr class="reportGroupTitle"><td colspan="2">Attributions for collections</td></tr>
                  <g:each var='c' in="${collAttributions}">
                    <tr><td><g:link controller="public" action="show" id="${c.pgs.uid}">${c.pgs.name}</g:link></td>
                    <g:each var='a' in="${c.attribs}" status="i">
                      <g:if test="${i>0}"><tr></tr><td></td></g:if>
                      <td>
                        <g:if test="${a?.url}">
                          <a href="${a.url}" target="_blank" class="external_icon">${a.name}</a>
                        </g:if>
                        <g:else>
                          ${a?.name}
                        </g:else>
                      </td></tr>
                    </g:each>
                  </g:each>
                </table>
              </div>
              </gui:tab>

              <gui:tab label="Institutions">
              <div class="dialog">
                <table>
                  <tr class="reportGroupTitle"><td colspan="2">Attributions for institutions</td></tr>
                  <g:each var='c' in="${instAttributions}">
                    <tr><td><g:link controller="public" action="show" id="${c.pgs.uid}">${c.pgs.name}</g:link></td>
                    <g:each var='a' in="${c.attribs}" status="i">
                      <g:if test="${i>0}"><td></td></g:if>
                      <td>
                        <g:if test="${a?.url}">
                          <a href="${a.url}" target="_blank" class="external_icon">${a.name}</a>
                        </g:if>
                        <g:else>
                          ${a?.name}
                        </g:else>
                      </td></tr>
                    </g:each>
                  </g:each>
                </table>
              </div>
              </gui:tab>
            </gui:tabView>
          </div>
    </body>
</html>
