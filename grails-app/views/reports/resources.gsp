<%@ page import="au.org.ala.collectory.DataHub; au.org.ala.collectory.DataResource; au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="${grailsApplication.config.ala.skin}" />
    <title>Registry database reports - data resources</title>
</head>
<body>
<div class="nav">
    <ul>
    <li><span class="menuButton"><cl:homeLink/></span></li>
    <li><span class="menuButton"><g:link class="list" action="list">Reports</g:link></span></li>
    </ul>
</div>
<div class="body">
    <h1>Data resources report</h1>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

    <div class="drs">
        <table class="table table-striped table-bordered">
            <colgroup><col width="53%"/><col width="7%"/><col width="40%"/></colgroup>
            <tr class="reportGroupTitle"><td>All resources (${DataResource.count()})</td><td>UID</td><td>Public archive</td></tr>
            <g:each var='c' in="${DataResource.list([sort: 'name'])}">
                <tr>
                    <td><g:link controller="public" action="show" id="${c.uid}">${fieldValue(bean: c, field: "name")}</g:link></td>
                    <td><g:link controller="dataResource" action="show" id="${c.uid}">${c.uid}</g:link></td>
                    <td><cl:publicArchiveLink uid="${c.uid}" available="${c.publicArchiveAvailable}"/></td>
                </tr>
            </g:each>
        </table>
    </div>

</div>
</body>
</html>
