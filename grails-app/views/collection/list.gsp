
<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                  <colgroup><col width="40%"/><col width="10%"/><col width="50%"/></colgroup>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="name" title="${message(code: 'collection.name.label', default: 'Name')}" />

                            <g:sortableColumn property="acronym" title="${message(code: 'collection.acronym.label', default: 'Acronym')}" />

                            <g:sortableColumn property="focus" title="${message(code: 'collection.focus.label', default: 'Focus')}" />

                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${collectionInstanceList}" status="i" var="collectionInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link controller="collection" action="show" id="${collectionInstance.id}">${fieldValue(bean: collectionInstance, field: "name")}</g:link></td>

                            <td>${fieldValue(bean: collectionInstance, field: "acronym")}</td>
                        
                            <td>${fieldValue(bean: collectionInstance, field: "focus")}</td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate controller="collection" action="list" total="${collectionInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
