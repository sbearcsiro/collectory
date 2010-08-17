<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <title>ALA Collections Reports</title>
	<meta name="layout" content="main" />

    </head>
    
    <body>
      <div class="nav">
          <span class="menuButton"><cl:homeLink/></span>
      </div>
      <div id="welcome">
        <h3>Natural History Collections Reports</h3> <p>Information about the quantity, quality and usage of the ALA's biodiversity collections.</p>
      </div>

      <cl:isNotLoggedIn>
        <div class="homeCell">
          <h4 class="inline">Please log in</h4>
            <span class="buttons" style="float: right;">
              <g:link controller="login">&nbsp;Log in&nbsp;</g:link>
            </span>
          <p>You must log in to manage collection records</p>
        </div>
      </cl:isNotLoggedIn>

    <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
      <br/><br/><p>These actions are only available to system admins.</p>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="data">View data reports</g:link>
        <p class="mainText">Totals and data quality.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="activity">View activity reports</g:link>
        <p class="mainText">Show user activity.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="membership">View memberships</g:link>
        <p class="mainText">Lists ALA partners as well as the members of collection networks (hubs).</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="collections">List all collections</g:link>
        <p class="mainText">Simple list of all collections.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="public" action="map">Show map of collections</g:link>
        <p class="mainText">Simple map of all collections.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="institutions">List all institutions</g:link>
        <p class="mainText">Simple list of all institutions.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="contacts">List all contacts</g:link>
        <p class="mainText">Simple list of all contacts.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="codes">List provider codes</g:link>
        <p class="mainText">Lists institution and collection codes for collections that have them.</p>
      </div>

    </cl:ifGranted>

    </body>
</html>