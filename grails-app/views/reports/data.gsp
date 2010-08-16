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
            <h1>Data report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <colgroup><col width="40%"/><col width="10%"/><col width="50%"/></colgroup>

                <tr class="reportGroupTitle"><td colspan="3">Totals</td></tr>
                <tr><td>Collections</td><td>${reports.totalCollections}</td><td></td></tr>
                <tr><td>Institutions</td><td>${reports.totalInstitutions}</td><td></td></tr>
                <tr><td>Contacts</td><td>${reports.totalContacts}</td><td></td></tr>

                <tr class="reportGroupTitle"><td colspan="3">Collection data quality</td></tr>
                <tr><cl:totalAndPercent label="Collections with no collection type" without="${reports.collectionsWithType}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no focus" without="${reports.collectionsWithFocus}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no description" without="${reports.collectionsWithDescriptions}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no keywords" without="${reports.collectionsWithKeywords}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no provider codes" without="${reports.collectionsWithProviderCodes}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no geo. description" without="${reports.collectionsWithGeoDescription}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no size" without="${reports.collectionsWithNumRecords}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no digitised size" without="${reports.collectionsWithNumRecordsDigitised}" total="${reports.totalCollections}"/></tr>

                <tr class="reportGroupTitle"><td colspan="3">Contact summary</td></tr>
                <tr><cl:totalAndPercent label="Collections with no contacts" with="${reports.collectionsWithoutContacts}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Collections with no email contacts" with="${reports.collectionsWithoutEmailContacts}" total="${reports.totalCollections}"/></tr>
                <tr><cl:totalAndPercent label="Institutions with no contacts" with="${reports.institutionsWithoutContacts}" total="${reports.totalInstitutions}"/></tr>
                <tr><cl:totalAndPercent label="Institutions with no email contacts" with="${reports.institutionsWithoutEmailContacts}" total="${reports.totalInstitutions}"/></tr>

              </table>
            </div>
        </div>
    </body>
</html>
