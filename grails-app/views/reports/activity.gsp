<%@ page import="au.org.ala.collectory.ReportsController.ReportCommand" %>
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
            <h1>User activity report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <colgroup><col width="40%"/><col width="10%"/><col width="50%"/></colgroup>

                <tr class="reportGroupTitle"><td colspan="3">User activity</td></tr>
                <tr><td>Total logins</td><td>${reports.totalLogins}</td><td></td></tr>
                <tr><td>Unique logins</td><td>${reports.uniqueLogins}</td><td></td></tr>
                <tr><td>Supplier logins</td><td>${reports.supplierLogins}</td><td></td></tr>
                <tr><td>Unique supplier logins</td><td>${reports.uniqueSupplierLogins}</td><td></td></tr>
                <tr><td>Curator views</td><td>${reports.curatorViews}</td><td></td></tr>
                <tr><td>Curator previews</td><td>${reports.curatorPreviews}</td><td></td></tr>
                <tr><td>Curator edits</td><td>${reports.curatorEdits}</td><td></td></tr>

              </table>
            </div>
        </div>
    </body>
</html>
