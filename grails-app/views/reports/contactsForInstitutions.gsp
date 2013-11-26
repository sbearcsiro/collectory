<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Registry database reports - contacts for institutions</title>
    </head>
    <body>
        <div class="nav">
            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list">Reports</g:link></span></li>
            </ul>
        </div>
        <div class="body">
            <h1>Contact emails for all institutions (${contacts.size()})</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table class="table table-striped table-bordered">
                <colgroup><col width="45%"/><col width="5%"/><col width="23%"/><col width="27%"/></colgroup>
                <g:each var="cfc" in="${contacts}">
                  <tr>
                    <td><g:link controller="institution" action="show" id="${cfc.entityUid}">${cfc.entityName}</g:link></td>
                    <td>${cfc.entityAcronym}</td>
                    <td style="color:blue;">${cfc.contactName}</td>
                    <td>${cfc.contactEmail}</td>
                  </tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
