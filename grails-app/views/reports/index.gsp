<%@ page import="au.org.ala.collectory.Contact; au.org.ala.collectory.DataResource; au.org.ala.collectory.DataProvider; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.Institution; au.org.ala.collectory.Collection" %>
<html>
    <head>
        <title>ALA Collections Reports</title>
	<meta name="layout" content="main" />

    </head>
    <body>
      <div class="nav">
          <ul>
          <li><span class="menuButton"><cl:homeLink/></span></li>
          <li><span class="menuButton">Reports</span></li>
          </ul>
      </div>
      <div id="welcome">
        <h1>Natural History Collections Reports</h1>
        <p>Information about the quantity, quality and usage of the ALA's biodiversity collections.</p>
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
    <div class="dashboard">

      <div class="dashCell">
        <div class='header'>
          <h2>General</h2>
          <div class="lead">
            <span class="total">${Collection.count()}</span> collections<br/>
            <span class="total">${DataResource.count()}</span> data resources<br/>
            <span class="total">${Institution.count()}</span> institutions<br/>
            <span class="total">${DataProvider.count()}</span> data providers
          </div>
        </div>
        <div style="clear:both;">
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="data">Measure metadata quality</g:link>
          <span class="linkText">- a few measures of completeness of metadata</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="changes">Show changes</g:link>
          <span class="linkText">- lists the recent changes made to the collection registry.</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="membership">View memberships</g:link>
          <span class="linkText">- lists ALA partners as well as the members of collection networks (hubs).</span></p>
        </div>
      </div>

      <div class="dashCell">
        <h2>Collections</h2>
        <div style="clear:both;">
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="collections">List all collections</g:link>
          <span class="linkText">- lists collections with permalinks and some attributes</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="codes">List provider codes</g:link>
          <span class="linkText">- controls the mapping to biocache records.</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="attributions">List attributions</g:link>
          <span class="linkText">- lists the sources of information for collections.</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="missingRecords">List missing records</g:link>
          <span class="linkText">- lists collections where the number of digitised records declared significantly exceeds the number of biocache records.</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="classification">Show classifications</g:link>
          <span class="linkText">- shows how collections are classified according to their keywords into the filter groups used on the collections map page.</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="collectionTypes">Show material types</g:link>
          <span class="linkText">- shows the type keywords associated with each collection, eg preserved, living, tissue.</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="taxonomicHints">Show taxonomic hints</g:link>
          <span class="linkText">- shows the hints for each collection. These are used to help match names when processing occurrence records.</span></p>
        </div>
      </div>

      <div class="dashCell">
      <h2>Institutions</h2>
        <div style="clear:both;">
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="institutions">List all institutions</g:link>
          <span class="linkText">- lists institutions with permalinks and some attributes</span></p>
        </div>
      </div>

      <div class="dashCell">
        <h2>Data providers & resources</h2>
        <div style="clear:both;">
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="providers">List all data providers and resources</g:link>
          <span class="linkText">- list of all data providers, data resources and data hubs</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="rights">Show data resource rights and permissions</g:link>
          <span class="linkText">- list rights, license details and permissions details for data resources</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="harvesters">Show data mobilisation parameters</g:link>
          <span class="linkText">- list mobilisation, harvesting and connection parameters for data resources</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="resources">Show other resource parameters</g:link>
          <span class="linkText">- list links for public archives that are available for download</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="dataLinks">Show data interactions</g:link>
          <span class="linkText">- show which providers/resources provide data records for which institutions/collections</span></p>
        </div>
      </div>

      <div class="dashCell">
        <h2>Contacts</h2>
        <div style="clear:both;">
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="contacts">List all contacts</g:link></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="duplicateContacts">Show duplicate contacts</g:link></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="contactsForCouncilMembers">Show contacts for member collections</g:link>
          <span class="linkText">- lists all collections that are members of councils and their contact emails.</span></p>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="contactsForCollections">Show contacts for all collections</g:link>
          <p class="pageLink"><g:link class="mainLink" controller="reports" action="contactsForInstitutions">Show contacts for all institutions</g:link>
        </div>
      </div>

    </div>
    </cl:ifGranted>

    <cl:ifNotGranted role="${ProviderGroup.ROLE_ADMIN}">
      <p>Your must have the admin role (ROLE_COLLECTION_ADMIN) to view reports.</p>
    </cl:ifNotGranted>

    </body>
</html>