
<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'providerGroup.label', default: 'ProviderGroup')}" />
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
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'providerGroup.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="guid" title="${message(code: 'providerGroup.guid.label', default: 'Guid')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'providerGroup.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="acronym" title="${message(code: 'providerGroup.acronym.label', default: 'Acronym')}" />
                        
                            <g:sortableColumn property="groupType" title="${message(code: 'providerGroup.groupType.label', default: 'Group Type')}" />
                        
                            <g:sortableColumn property="pubDescription" title="${message(code: 'providerGroup.pubDescription.label', default: 'Pub Description')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${providerGroupInstanceList}" status="i" var="providerGroupInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${providerGroupInstance.id}">${fieldValue(bean: providerGroupInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: providerGroupInstance, field: "guid")}</td>
                        
                            <td>${fieldValue(bean: providerGroupInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: providerGroupInstance, field: "acronym")}</td>
                        
                            <td>${fieldValue(bean: providerGroupInstance, field: "groupType")}</td>
                        
                            <td>${fieldValue(bean: providerGroupInstance, field: "pubDescription")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${providerGroupInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
