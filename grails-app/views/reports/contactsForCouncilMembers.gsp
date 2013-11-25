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
            <h1>Contact emails for collections belonging to councils</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <table class="table table-striped table-bordered">
                <colgroup><col width="60%"/><col width="40%"/></colgroup>

                <tr class="reportGroupTitle"><td colspan="2">CHAFC Members (${chafc.size()})</td>
                <g:each var="p" in="${chafc}">
                  <tr>
                    <td><g:link controller="collection" action="show" id="${p.id}">${p.name}</g:link></td>
                    <g:if test="${p.email}">
                      <td>${p.email}</td>
                    </g:if>
                    <g:elseif test="${p.contact}">
                      <td style="color:blue;">(${p.contact})</td>
                    </g:elseif>
                    <g:else>
                      <td style="color:red;">none</td>
                    </g:else>
                  </tr>
                </g:each>

                <tr class="reportGroupTitle"><td colspan="2">CHAEC Members (${chaec.size()})</td>
                <g:each var="p" in="${chaec}">
                  <tr>
                    <td><g:link controller="collection" action="show" id="${p.id}">${p.name}</g:link></td>
                    <g:if test="${p.email}">
                      <td>${p.email}</td>
                    </g:if>
                    <g:elseif test="${p.contact}">
                      <td style="color:blue;">(${p.contact})</td>
                    </g:elseif>
                    <g:else>
                      <td style="color:red;">none</td>
                    </g:else>
                  </tr>
                </g:each>

                <tr class="reportGroupTitle"><td colspan="2">CHACM Members (${chacm.size()})</td>
                <g:each var="p" in="${chacm}">
                  <tr>
                    <td><g:link controller="collection" action="show" id="${p.id}">${p.name}</g:link></td>
                    <g:if test="${p.email}">
                      <td>${p.email}</td>
                    </g:if>
                    <g:elseif test="${p.contact}">
                      <td style="color:blue;">(${p.contact})</td>
                    </g:elseif>
                    <g:else>
                      <td style="color:red;">none</td>
                    </g:else>
                  </tr>
                </g:each>

              </table>
            </div>
        </div>
    </body>
</html>
