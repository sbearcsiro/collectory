<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <title>ALA Collections Management</title>
	<meta name="layout" content="fluid" />

    </head>
    
    <body>

        <div id="nav">
            <ul id="nav-primary" class="left">
                  <li class="nav-item active">
                          <g:link controller="admin" action="home" class="active" accesskey="2">home</g:link>
                  </li>
            </ul>
            <ul id="nav-secondary" class="right">
                  <li class="nav-item">
                          <a href="${ConfigurationHolder.config.ala.baseURL}" accesskey="3">ala</a>
                  </li>
                  <li class="nav-item">
                          <a href="${ConfigurationHolder.config.grails.serverURL}" accesskey="4">collections</a>
                  </li>
                  <li class="nav-item">
                      <cl:isLoggedIn>
                          <a href="http://auth.ala.org.au/cas/logout?url=${ConfigurationHolder.config.grails.serverURL}/admin/home">logout</a>
                      </cl:isLoggedIn>
                      <cl:isNotLoggedIn>
                          <a href="http://auth.ala.org.au/cas/login?service=${ConfigurationHolder.config.security.cas.serverName}/${ConfigurationHolder.config.security.cas.context}/admin">login</a>
                      </cl:isNotLoggedIn>
                  </li>
            </ul>
        </div>

        <div class="login-info">
            <cl:isLoggedIn>
                <span id="logged-in">Logged in as <cl:loggedInUsername/></span>
            </cl:isLoggedIn>
        </div>


      <div class="floating-content">

          <!--div style="float:right;">
            <g:link class="mainLink" controller="public" action="map">View public site</g:link>
          </div-->
          <div id="welcome">
              <img width="130" height="109" src="${resource(dir:'images/admin',file:'swift-moth.gif')}"/>
              <div>
                  <span style="font-size:12px;">Update our information about</span>
                    <h1>Natural History Collections and their Institutions</h1>
                    <p>Descriptions of Australian biodiversity collections can be added and updated here.</p>
              </div>
          </div>

          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>

          <cl:isNotLoggedIn>
            <div class="homeCell">
              <h4 class="inline">Please log in</h4>
                <span style="" class="buttons" style="float: right;">
                  <a href="${ConfigurationHolder.config.security.cas.loginUrl}?service=${ConfigurationHolder.config.grails.serverURL}/admin">&nbsp;Log in&nbsp;</a>
                </span>
              <p>You must log in to manage collection records</p>
            </div>
          </cl:isNotLoggedIn>
          <div style="clear:both;"></div>

          <div id="buttons">
          <div class='link-group'>
              <h2>Collections</h2>
              <g:link class="mainLink" controller="collection" action="list">View all collections</g:link>
              <g:link class="mainLink" controller="collection" action="myList" id="68">View my collections</g:link>
              <g:link class="mainLink" controller="collection" action="create-notyet">Add a collection</g:link>
              <span>Search for collections</span>
              <g:form action="search">
                <g:textField class="mainText" name="term"/><span class="search-button-wrapper">
                  <g:actionSubmitImage width="24" src="${resource(dir:'images/admin',file:'search.png')}" action="search" value="Search"/></span>
              </g:form>
          </div>

          <div class='link-group'>
              <h2>Institutions</h2>
              <g:link class="mainLink" controller="institution" action="list">View all institutions</g:link>
              <g:link class="mainLink" controller="institution" action="myList" id="68">View my institutions</g:link>
              <g:link class="mainLink" controller="institution" action="create-notyet">Add an institution</g:link>
              <span>Search for institutions</span>
              <g:form action="search">
                <g:textField class="mainText" name="term"/><span class="search-button-wrapper">
                  <g:actionSubmitImage src="${resource(dir:'images/admin',file:'search.png')}" action="search" value="Search"/></span>
              </g:form>
          </div>


          <div class='link-group'>
              <h2>Data sets</h2>
              <g:link class="mainLink" controller="dataResource" action="list">View all data resources</g:link>
              <g:link class="mainLink" controller="dataProvider" action="list">View all data providers</g:link>
              <g:link class="mainLink" controller="institution" action="create-notyet">Add a data resource</g:link>
              <span>Search for data sets</span>
              <g:form action="search">
                <g:textField class="mainText" name="term"/><span class="search-button-wrapper">
                  <g:actionSubmitImage src="${resource(dir:'images/admin',file:'search.png')}" action="search" value="Search"/></span>
              </g:form>
          </div>

          <div class='link-group'>
              <h2>Profile</h2>
              <g:link class="mainLink" controller="contact" action="showProfile">Edit my profile</g:link>
              <p class="mainText">View and edit your contact details, roles, notifications, etc.</p>
          </div>

          <g:if test="${request.isUserInRole(ProviderGroup.ROLE_ADMIN)}">

          <div class='link-group admin'>
              <h2>Admin</h2>
              <g:link class="mainLink" controller="reports" action="home">View reports</g:link>
              <g:link class="mainLink" controller="contact" action="list">Manage contacts</g:link>
              <g:link class="mainLink" controller="admin" action="export">Export all data as JSON</g:link>
          </div>

          <div class='link-group admin'>
              <h2>Codes and maps</h2>
              <g:link class="mainLink" controller="providerCode" action="list">Manage provider codes</g:link>
              <p class="mainText">Edit the list of available collection and institution codes.</p>
              <g:link class="mainLink" controller="providerMap" action="list">Manage provider maps</g:link>
              <p class="mainText">Allocate collection and institution codes to collections.</p>
          </div>
          </g:if>
        </div>

        <div style="clear: both;"></div>

      </div>
      <script type="text/javascript">
          $('.link-group').hover(
                  function() {
                      $(this).addClass('link-group-highlight');
                  },
                  function() {
                      $(this).removeClass('link-group-highlight');
                  }
          );
      </script>
    </body>
</html>