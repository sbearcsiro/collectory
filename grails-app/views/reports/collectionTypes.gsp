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
            <h1>Collection types</h1>
            <p>${Collection.count()} collections shown. Collections in <span style="color:#dd3102;">red</span> have no type specified.
            The noun(s) shown in the last column are what will be used on pages that describe the collection.</p>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <col width="49%"/><col width="7%"/><col width="7%"/><col width="7%"/><col width="20%"/><col width="10%"/>

                <tr class="reportGroupTitle"><th>Collection</th><th>preserved</th><th>cellcultures</th><th>living</th><th>other</th><th>noun</th></tr>
                <g:each var='c' in="${collections}" status="i">
                  <g:set var="types" value="${c.listCollectionTypes()}"/>
                  <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>
                      <g:if test="${types.size() > 0}">
                        <cl:showOrEdit entity="${c}"/>
                      </g:if>
                      <g:else>
                        <span class="dataWarning"><cl:showOrEdit entity="${c}"/></span>
                      </g:else>
                    </td>
                    <td style="text-align:center;"><cl:tick isTrue="${types.contains('preserved')}"/></td>
                    <td style="text-align:center;"><cl:tick isTrue="${types.contains('cellcultures')}"/></td>
                    <td style="text-align:center;"><cl:tick isTrue="${types.contains('living')}"/></td>
                    <td style="text-align:center;">${(types - ["preserved","cellcultures","living"]).join(', ')}</td>
                    <td><cl:nounForTypes types="${types}"/></td>
                  </tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
