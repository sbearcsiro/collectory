<%@ page import="au.org.ala.collectory.Collection; au.org.ala.collectory.Institution" %><html>
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
            <h1>Attributions report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <p><a href="#institutions">Jump to institutions</a></p>

            <div class="dialog" id="collections">
                <table>
                    <tr class="reportGroupTitle"><td>Attributions for collections</td><td>${Collection.count()} collections shown.</td></tr>
                    <g:each var='c' in="${collAttributions}">
                        <tr><td><g:link controller="public" action="show" id="${c.pgs.uid}">${c.pgs.name}</g:link></td>
                        <g:each var='a' in="${c.attribs}" status="i">
                            <g:if test="${i>0}"><tr></tr><td></td></g:if>
                            <td>
                                <g:if test="${a?.url}">
                                    <a href="${a.url}" target="_blank" class="external_icon">${a.name}</a>
                                </g:if>
                                <g:else>
                                    ${a?.name}
                                </g:else>
                            </td></tr>
                        </g:each>
                    </g:each>
                </table>
            </div>

            <div class="dialog" id="institutions">
                <table>
                    <tr class="reportGroupTitle"><td>Attributions for institutions</td><td>${Institution.count()} institutions shown.</td></tr>
                    <g:each var='c' in="${instAttributions}">
                        <tr><td><g:link controller="public" action="show" id="${c.pgs.uid}">${c.pgs.name}</g:link></td>
                        <g:each var='a' in="${c.attribs}" status="i">
                            <g:if test="${i>0}"><td></td></g:if>
                            <td>
                                <g:if test="${a?.url}">
                                    <a href="${a.url}" target="_blank" class="external_icon">${a.name}</a>
                                </g:if>
                                <g:else>
                                    ${a?.name}
                                </g:else>
                            </td></tr>
                        </g:each>
                    </g:each>
                </table>
            </div>

        </div>
    </body>
</html>
