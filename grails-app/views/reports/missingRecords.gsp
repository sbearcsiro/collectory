<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Registry database reports</title>
    </head>
    <body>
        <div class="nav">
            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list">Reports</g:link></span></li>
            </ul>
        </div>
        <div class="body">
            <h1>Missing records</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <h4>Collections where the claimed number of digitised records significantly exceeds the number of bio-cache records.</h4>
              <table class="table table-striped table-bordered">
                <colgroup><col width="50%"/><col width="30%"/><col width="20%"/></colgroup>
                <thead>
                  <th>Collection</th><th>No. declared to be digitised</th><th>No. biocache records</th>
                </thead>

                <g:each var='m' in="${mrs}">
                  <tr>
                    <td><g:link controller="public" action="show" id="${m.collection.uid}">${m.collection.name}</g:link></td>
                    <td>${m.claimed}</td>
                    <td>${m.biocacheCount}</td>
                  </tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
