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
            <h1>Contact emails for all collections</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table>
                <colgroup><col width="45%"/><col width="5%"/><col width="23%"/><col width="27%"/></colgroup>
                <g:each var="cfc" in="${contacts}">
                  <tr>
                    <g:if test="${cfc.collectionName.endsWith('Collection')}">
                      <g:set var="name" value="${cfc.collectionName - 'Collection'}"/>
                    </g:if>
                    <g:else>
                      <g:set var="name" value="${cfc.collectionName}"/>
                    </g:else>
                    <td><g:link controller="collection" action="show" id="${cfc.collectionUid}">${name}</g:link></td>
                    <td>${cfc.collectionAcronym}</td>
                    <td style="color:blue;">${cfc.contactName}</td>
                    <td>${cfc.contactEmail}</td>
                  </tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
