<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${entityType}" />
        <g:set var="entityNameLower" value="${cl.controller(type: entityType)}"/>
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><cl:homeLink/></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

            <div class="list">
                <table>
                  <colgroup><col width="45%"/><col width="7%"/><col width="10%"/><col width="3%"/><col width="35%"/></colgroup>
                    <thead>
                        <tr>
                            <g:sortableColumn property="name" title="${message(code: 'dataResource.name.label', default: 'Name')}" />

                            <g:sortableColumn property="uid" title="${message(code: 'providerGroup.uid.label', default: 'UID')}" />

                            <g:sortableColumn property="resourceType" title="${message(code: 'dataResource.resourceType.label', default: 'Type')}" />

                            <th></th>

                            <g:sortableColumn property="dataProvider" title="${message(code: 'dataResource.dataProvider.label', default: 'Provider')}" />

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${instanceList}" status="i" var="instance">
                      <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                        <td><g:link action="show" id="${instance.uid}">${fieldValue(bean: instance, field: "name")}</g:link></td>

                        <td>${fieldValue(bean: instance, field: "uid")}</td>

                        <td>${fieldValue(bean: instance, field: "resourceType")}</td>

                        <td>
                            <g:if test="${instance.isCreativeCommons()}">CC</g:if>
                        </td>

                        <td>${fieldValue(bean: instance.dataProvider, field: "name")}</td>

                      </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>

            <div class="paginateButtons">
                <g:paginate action="list" total="${instanceTotal}" />
            </div>
        </div>
    </body>
</html>
