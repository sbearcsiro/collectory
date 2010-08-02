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
            <h1>Memberships report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <colgroup><col width="40%"/><col width="10%"/><col width="50%"/></colgroup>

                <tr class="reportGroupTitle"><td>ALA Partner Institutions (${reports.partners.size()})</td>
                  <!-- put first member on same line as title -->
                  <td colspan="2">
                    <g:if test="${reports.partners.size() > 0}">${reports.partners[0].name}</g:if><g:else>None</g:else>
                  </td></tr>
                <g:each var="p" in="${reports.partners}" status="i">
                  <!-- skip first member -->
                  <g:if test="${i > 0}"><tr><td></td><td colspan="2">${p.name}</td></tr></g:if>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle"><td>CHAH Members (${reports.chahMembers.size()})</td>
                  <!-- put first member on same line as title -->
                  <td colspan="2">
                    <g:if test="${reports.chahMembers.size() > 0}">${reports.chahMembers[0].name}</g:if><g:else>None</g:else>
                  </td></tr>
                <!-- skip first member -->
                <g:each var="p" in="${reports.chahMembers}" status="i">
                  <g:if test="${i > 0}"><tr><td></td><td colspan="2">${p.name}</td></tr></g:if>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle"><td>CHAFC Members (${reports.chafcMembers.size()})</td>
                  <!-- put first member on same line as title -->
                  <td colspan="2">
                    <g:if test="${reports.chafcMembers.size() > 0}">${reports.chafcMembers[0].name}</g:if><g:else>None</g:else>
                  </td></tr>
                <g:each var="p" in="${reports.chafcMembers}" status="i">
                  <!-- skip first member -->
                  <g:if test="${i > 0}"><tr><td></td><td colspan="2">${p.name}</td></tr></g:if>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle"><td>CHAEC Members (${reports.chaecMembers.size()})</td>
                  <!-- put first member on same line as title -->
                  <td colspan="2">
                    <g:if test="${reports.chaecMembers.size() > 0}">${reports.chaecMembers[0].name}</g:if><g:else>None</g:else>
                  </td></tr>
                <g:each var="p" in="${reports.chaecMembers}" status="i">
                  <!-- skip first member -->
                  <g:if test="${i > 0}"><tr><td></td><td colspan="2">${p.name}</td></tr></g:if>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle"><td>AMRRN Members (${reports.amrrnMembers.size()})</td>
                  <!-- put first member on same line as title -->
                  <td colspan="2">
                    <g:if test="${reports.amrrnMembers.size() > 0}">${reports.amrrnMembers[0].name}</g:if><g:else>None</g:else>
                  </td></tr>
                <g:each var="p" in="${reports.amrrnMembers}" status="i">
                  <!-- skip first member -->
                  <g:if test="${i > 0}"><tr><td></td><td colspan="2">${p.name}</td></tr></g:if>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle"><td>CAMD Members (${reports.camdMembers.size()})</td>
                  <!-- put first member on same line as title -->
                  <td colspan="2">
                    <g:if test="${reports.camdMembers.size() > 0}">${reports.camdMembers[0].name}</g:if><g:else>None</g:else>
                  </td></tr>
                <g:each var="p" in="${reports.camdMembers}" status="i">
                  <!-- skip first member -->
                  <g:if test="${i > 0}"><tr><td></td><td colspan="2">${p.name}</td></tr></g:if>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
