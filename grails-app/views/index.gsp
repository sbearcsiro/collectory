<html>
    <head>
        <title>ALA Collections Management</title>
	<meta name="layout" content="main" />

    </head>
    
    <body>
      <div id="welcome">
        <h3>Natural History Collections Management</h3> <p>Information about Australian biodiversity collections can be added and updated here.</p>
      </div>

      <g:isNotLoggedIn>
        <div class="homeCell">
          <h4 class="inline">Please log in</h4>
            <span class="buttons" style="float: right;">
              <g:link controller="login">&nbsp;Log in&nbsp;</g:link>
            </span>
          <p>You must log in to manage collection records</p>
        </div>
      </g:isNotLoggedIn>

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

    <g:ifAllGranted role="ROLE_ADMIN">
      <br/><br/><p>These actions are only available to system admins.</p>

      <div class="homeCell">
        <g:link class="mainLink" controller="reports" action="show">View reports</g:link>
        <p class="mainText">Browse summaries of Registry contents and usage.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="role" action="list">Manage roles</g:link>
        <p class="mainText">Define who can do what by role.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="logon" action="list">Manage logons</g:link>
        <p class="mainText">Create and maintain user accounts.</p>
      </div>

      <div class="homeCell">
        <g:link class="mainLink" controller="secRequestMap" action="list">Manage url security</g:link>
        <p class="mainText">Restrict access to specific urls.</p>
      </div>
    </g:ifAllGranted>
      <!--div class="homeCell">
        <h4 class="inline">Add an institution</h4>
          <p></p>
          <span class="buttons" >
            <g:link controller="institution" action="list">Show institutions</g:link>
          </span>
      </div>

      <div class="homeCell">
        <h4 class="inline">Add a contact person</h4>
          <p></p>
          <span class="buttons" >
            <g:link controller="contact" action="create">Add a contact</g:link>
          </span>
      </div-->

      

    </body>
</html>