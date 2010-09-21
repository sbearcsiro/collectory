<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <title>ALA Collections Management</title>
	<meta name="layout" content="main" />

    </head>
    
    <body>
      <div style="float:right;">
        <g:link class="mainLink" controller="public" action="map">View public site</g:link>
        <!--img src="${resource(dir:'images/ala',file:'ala-logo-small-white.gif')}"/-->
      </div>
      <div id="welcome">
        <h3>Natural History Collections Management</h3> <p>Information about Australian biodiversity collections can be added and updated here.</p>
      </div>

      <cl:isNotLoggedIn>
        <div class="homeCell">
          <h4 class="inline">Please log in</h4>
            <span class="buttons" style="float: right;">
              <a href="${ConfigurationHolder.config.security.cas.loginUrl}?service=${ConfigurationHolder.config.grails.serverURL}/admin">&nbsp;Log in&nbsp;</a>
            </span>
          <p>You must log in to manage collection records</p>
        </div>
      </cl:isNotLoggedIn>

      <div class="homeCell">
        <g:link class="mainLink" controller="collection" action="list">View all collections</g:link>
        <p class="mainText">Browse all current collections and update collection descriptions.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="collection" action="myList" id="68">View my collections</g:link>
        <p class="mainText">Browse my collections and update collection descriptions.</p>
      </div>

      <div class="homeCell">
        <span class="mainLink">Search for collections</span>
        <p class="mainText">Enter a part of the name of a collection or its acronym, eg insects, fungi, ANIC</p>
        <g:form controller="collection" action="searchList">
          <g:textField class="mainText" name="term"/><g:submitButton style="margin-left:20px;" name="search" value="Search"/>
        </g:form>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="collection" action="create">Add a collection</g:link>
        <p class="mainText">Describe a collection that is not currently listed.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="institution" action="list">View all institutions</g:link>
        <p class="mainText">Browse the institutions that hold collections.</p>
      </div>

    <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
      <br/><br/><p>These actions are only available to system admins.</p>

      <div class="homeCell">
        <g:link class="mainLink" controller="dataProvider" action="list">View all data providers</g:link>
        <p class="mainText">Browse all current data providers.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="dataResource" action="list">View all data resources</g:link>
        <p class="mainText">Browse all current data resources.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="list">View reports</g:link>
        <p class="mainText">Browse summaries of Registry contents and usage.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="contact" action="list">Manage contacts</g:link>
        <p class="mainText">View and edit all known contacts for collections and institutions.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="providerCode" action="list">Manage provider codes</g:link>
        <p class="mainText">View and edit all known collection and institution codes.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="providerMap" action="list">Manage provider maps</g:link>
        <p class="mainText">View and edit the allocation of collection and institution codes to collections.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="admin" action="export">Export all data as JSON</g:link>
        <p class="mainText">All tables exported verbatim as JSON</p>
      </div>
    </cl:ifGranted>
      
    </body>
</html>