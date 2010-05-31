
<%@ page import="au.org.ala.collectory.InfoSource" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'infoSource.label', default: 'InfoSource')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'infoSource.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="guid" title="${message(code: 'infoSource.guid.label', default: 'Guid')}" />
                        
                            <g:sortableColumn property="acronym" title="${message(code: 'infoSource.acronym.label', default: 'Acronym')}" />
                        
                            <g:sortableColumn property="title" title="${message(code: 'infoSource.title.label', default: 'Title')}" />
                        
                            <g:sortableColumn property="abstractText" title="${message(code: 'infoSource.abstractText.label', default: 'Abstract Text')}" />
                        
                            <g:sortableColumn property="dateAvailable" title="${message(code: 'infoSource.dateAvailable.label', default: 'Date Available')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${infoSourceInstanceList}" status="i" var="infoSourceInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${infoSourceInstance.id}">${fieldValue(bean: infoSourceInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: infoSourceInstance, field: "guid")}</td>
                        
                            <td>${fieldValue(bean: infoSourceInstance, field: "acronym")}</td>
                        
                            <td>${fieldValue(bean: infoSourceInstance, field: "title")}</td>
                        
                            <td>${fieldValue(bean: infoSourceInstance, field: "abstractText")}</td>
                        
                            <td><g:formatDate date="${infoSourceInstance.dateAvailable}" /></td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${infoSourceInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
