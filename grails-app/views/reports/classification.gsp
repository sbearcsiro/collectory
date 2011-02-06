<%@ page import="au.org.ala.collectory.Classification; au.org.ala.collectory.Collection" %>
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
            <h1>Collection classification (in relation to map filter categories)</h1>
            <p>${Collection.count()} collections shown. Collections in <span style="color:red;">red</span> are missing keywords that allow classification.</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <col width="55%"/><col width="9%"/><col width="9%"/><col width="9%"/><col width="9%"/><col width="9%"/>

                <tr class="reportGroupTitle"><th>Collection</th><th>Acronym</th><th>Herbaria</th><th>Fauna</th><th>Ento</th><th>Microbes</th></tr>
                <g:each var='c' in="${collections}" status="i">
                  <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>
                      <g:if test="${Classification.matchKeywords(c.keywords, 'plants,fauna,entomology,microbes')}">
                        <cl:showOrEdit entity="${c}"/>
                      </g:if>
                      <g:else>
                        <span class="dataWarning"><cl:showOrEdit entity="${c}"/></span>
                      </g:else>
                    </td>
                    <td style="text-align:center;color:gray;">${c.acronym}</td>
                    <td style="text-align:center;"><cl:reportClassification keywords="${c.keywords}" filter="plants"/></td>
                    <td style="text-align:center;"><cl:reportClassification keywords="${c.keywords}" filter="fauna"/></td>
                    <td style="text-align:center;"><cl:reportClassification keywords="${c.keywords}" filter="entomology"/></td>
                    <td style="text-align:center;"><cl:reportClassification keywords="${c.keywords}" filter="microbes"/></td>
                  </tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
