<%@ page import="au.org.ala.collectory.Collection" %>
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
            <h1>Provider codes report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <colgroup><col width="40%"/><col width="10%"/><col width="50%"/></colgroup>

                <tr class="reportGroupTitle"><td>Codes</td><td colspan="2">${Collection.count()} collections shown.</td></tr>
                <g:each var='c' in="${codeSummaries}">
                  <tr><td><g:link controller="public" action="show" id="${c.uid}" fragment="statistics">${c.name}</g:link></td><td>${c.derivedInstCodes.join(',')}</td><td>${c.derivedCollCodes.join(',')}</td></tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
