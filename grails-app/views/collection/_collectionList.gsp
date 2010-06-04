<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<div class="list">
    <table>
      <colgroup><col width="40%"/><col width="10%"/><col width="50%"/></colgroup>
        <thead>
            <tr>

                <g:sortableColumn property="name" title="${message(code: 'collection.name.label', default: 'Name')}" params="${params}"/>

                <g:sortableColumn property="acronym" title="${message(code: 'collection.acronym.label', default: 'Acronym')}" params="${params}"/>

                <g:sortableColumn property="focus" title="${message(code: 'collection.focus.label', default: 'Focus')}" params="${params}" />

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
