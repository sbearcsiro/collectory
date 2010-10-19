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
                <colgroup><col width="40%"/><col width="50%"/><col width="10%"/></colgroup>

                <tr class="reportGroupTitle"><td>ALA Partner Institutions (${reports.partners.size()})</td>
                  <!-- put first member on same line as title -->
                  <td colspan="2">
                    <g:if test="${reports.partners.size() > 0}"><cl:showOrEdit entity="${reports.partners[0]}"/></g:if><g:else>None</g:else>
                  </td></tr>
                <g:each var="p" in="${reports.partners}" status="i">
                  <!-- skip first member -->
                  <g:if test="${i > 0}"><tr><td></td><td colspan="2"><cl:showOrEdit entity="${p}"/></td></tr></g:if>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle">
                  <td>CHAH Members (${reports.chahMembers.size()})</td>
                  <td colspan="2"><b>Council of Heads of Australasian Herbaria</b></td>
                </tr>
                <g:each var="p" in="${reports.chahMembers}" status="i">
                  <tr><td></td><td colspan="2"><cl:showOrEdit entity="${p}"/></td></tr>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle">
                  <td>CHAFC Members (${reports.chafcMembers.size()})</td>
                  <td colspan="2"><b>Council of Heads of Australian Faunal Collections</b></td>
                </tr>
                <g:each var="p" in="${reports.chafcMembers}" status="i">
                  <tr><td></td><td><cl:showOrEdit entity="${p}"/></td>
                    <td>
                      <g:if test="${p.ENTITY_TYPE == 'Collection' && p.getPrimaryContact()?.contact?.email}">
                        <a href='#' onclick="return contactCurator('${p.getPrimaryContact()?.contact?.email}','${p.getPrimaryContact()?.contact?.firstName}','${p.uid}','${p.institution?.uid}','${p.name}')">Contact</a>
                      </g:if>
                    </td>
                  </tr>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle">
                  <td>CHAEC Members (${reports.chaecMembers.size()})</td>
                  <td colspan="2"><b>Council of Heads of Australian Entomological Collections</b></td>
                </tr>
                <g:each var="p" in="${reports.chaecMembers}" status="i">
                  <tr><td></td><td><cl:showOrEdit entity="${p}"/></td>
                    <td>
                      <g:if test="${p.ENTITY_TYPE == 'Collection' && p.getPrimaryContact()?.contact?.email}">
                        <a href='#' onclick="return contactCurator('${p.getPrimaryContact()?.contact?.email}','${p.getPrimaryContact()?.contact?.firstName}','${p.uid}','${p.institution?.uid}','${p.name}')">Contact</a>
                      </g:if>
                    </td>
                  </tr>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle">
                  <td>CHACM Members (${reports.amrrnMembers.size()})</td>
                  <td colspan="2"><b>Council of Heads of Australian Collections of Microorganisms</b></td>
                </tr>
                <g:each var="p" in="${reports.amrrnMembers}" status="i">
                  <tr><td></td><td><cl:showOrEdit entity="${p}"/></td>
                    <td>
                      <g:if test="${p.ENTITY_TYPE == 'Collection' && p.getPrimaryContact()?.contact?.email}">
                        <a href='#' onclick="return contactCurator('${p.getPrimaryContact()?.contact?.email}','${p.getPrimaryContact()?.contact?.firstName}','${p.uid}','${p.institution?.uid}','${p.name}')">Contact</a>
                      </g:if>
                    </td>
                  </tr>
                </g:each>

                <tr><td colspan="3"><hr></td></tr>
                <tr class="reportGroupTitle">
                  <td>CAMD Members (${reports.camdMembers.size()})</td>
                  <td colspan="2"><b>Council of Australasian Museum Directors</b></td>
                </tr>
                <g:each var="p" in="${reports.camdMembers}" status="i">
                  <tr><td></td><td colspan="2"><cl:showOrEdit entity="${p}"/></td></tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
