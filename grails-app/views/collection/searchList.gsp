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
            <span class="menuButton"><cl:homeLink/></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="list" action="myList"><g:message code="default.myList.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="collection.searchList.label" args="${criteria}" default="Collections" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:render template="collectionList"
                    model="[collectionInstanceList: providerGroupInstanceList.findAll{it.groupType == ProviderGroup.GROUP_TYPE_COLLECTION}]"
                    params="[term: '${term}']"/>
            <g:if test="${providerGroupInstanceList.findAll{it.groupType == ProviderGroup.GROUP_TYPE_INSTITUTION}.size() > 0}">
              <h1><g:message code="institution.searchList.label" args="${criteria}" default="Institutions" /></h1>
              <g:render template="/shared/institutionList" model="[institutionInstanceList: providerGroupInstanceList.findAll{it.groupType == ProviderGroup.GROUP_TYPE_INSTITUTION}]"/>
            </g:if>
            <div class="paginateButtons">
                <g:paginate controller="collection" action="searchList" params="${[term:term]}" total="${providerGroupInstanceTotal}" />
            </div>
        </div>
    </body>
</html>