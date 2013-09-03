<%@ page import="au.org.ala.collectory.ReportsController.ReportCommand" %>
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
            <h1>User activity report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <colgroup><col width="30%"/><col width="70%"/></colgroup>

                <tr class="reportGroupTitle"><td colspan="2">User activity</td></tr>
                <tr><td>Curator views</td><td>${reports.curatorViews}</td></tr>
                <tr><td>Curator previews</td><td>${reports.curatorPreviews}</td></tr>
                <tr><td>Curator edits</td><td>${reports.curatorEdits}</td></tr>
                <tr><td>Admin views</td><td>${reports.adminViews}</td></tr>
                <tr><td>Admin previews</td><td>${reports.adminPreviews}</td></tr>
                <tr><td>Admin edits</td><td>${reports.adminEdits}</td></tr>
                <tr><td>Recent activity</td><td></td></tr>
                <g:each var='l' in='${reports.latestActivity}'>
                  <tr><td colspan="2">${l.toString()}</td></tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
