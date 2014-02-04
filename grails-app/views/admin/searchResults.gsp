<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder" %>
<html>
    <head>
        <title>ALA Collections Management Search Results</title>
	<meta name="layout" content="${grailsApplication.config.ala.skin}" />

    </head>

    <body>
      <div class="resultsPage">
        <div class="pageTitle">
          <h1>Search results</h1>
          <g:if test="${results.total == 0}">
            <span>Your search returned no results.</span>
          </g:if>
          <g:else>
            <p>Click <em>(View)</em> to display the public page.
              Click the name or <em>(Edit)</em> to enter the editor's view of the information.</p>
          </g:else>
        </div>

        <g:if test="${results.collections}">
          <div class="resultsGroup">
            <h2>Collections</h2>
            <ul>
              <g:each var="c" in="${results.collections}">
                <li><span class="resultsName"><g:link controller="collection" action="show" id="${c.uid}">${c.name}</g:link></span>
                  <g:link controller="public" action="show" id="${c.uid}">(View)</g:link>
                  <g:link controller="collection" action="show" id="${c.uid}">(Edit)</g:link>
                </li>
              </g:each>
            </ul>
          </div>
        </g:if>

        <g:if test="${results.institutions}">
          <div class="resultsGroup">
            <h2>Institutions</h2>
            <ul>
              <g:each var="c" in="${results.institutions}">
                <li><span class="resultsName"><g:link controller="institution" action="show" id="${c.uid}">${c.name}</g:link></span>
                  <g:link controller="public" action="show" id="${c.uid}">(View)</g:link>
                  <g:link controller="institution" action="show" id="${c.uid}">(Edit)</g:link>
                </li>
              </g:each>
            </ul>
          </div>
        </g:if>

        <g:if test="${results.dataProviders}">
          <div class="resultsGroup">
            <h2>Data providers</h2>
            <ul>
              <g:each var="c" in="${results.dataProviders}">
                <li><span class="resultsName"><g:link controller="dataProvider" action="show" id="${c.uid}">${c.name}</g:link></span>
                  <g:link controller="public" action="show" id="${c.uid}">(View)</g:link>
                  <g:link controller="dataProvider" action="show" id="${c.uid}">(Edit)</g:link>
                </li>
              </g:each>
            </ul>
          </div>
        </g:if>

        <g:if test="${results.dataResources}">
          <div class="resultsGroup">
            <h2>Data resources</h2>
            <ul>
              <g:each var="c" in="${results.dataResources}">
                <li><span class="resultsName"><g:link controller="dataResource" action="show" id="${c.uid}">${c.name}</g:link></span>
                  <g:link controller="public" action="show" id="${c.uid}">(View)</g:link>
                  <g:link controller="dataResource" action="show" id="${c.uid}">(Edit)</g:link>
                </li>
              </g:each>
            </ul>
          </div>
        </g:if>

      </div>

    </body>
</html>