<html>
    <head>
        <title>ALA Collections Management</title>
	<meta name="layout" content="main" />

    </head>
    
    <body>
      <div id="welcome">
        <h3>ALA Collections Management</h3> <p>Information about Australian biodiversity collections can be added and updated here.</p>
      </div>
      <div class="homeCell">
        <h4 class="inline">View all collections</h4>
          <span class="buttons" style="float: right;">
            <g:link controller="collection" action="list">View collections</g:link>
          </span>
        <p>Browse all current collections and update collection descriptions.</p>
      </div>

      <div class="homeCell">
        <h4 class="inline">Search for collections</h4>
          <span class="buttons" >
            <a href="">Search for collections</a>
          </span>
        <p>Search for collections by name, type, institution or location.</p>
      </div>

      <div class="homeCell">
        <h4 class="inline">Add a collection</h4>
          <span class="buttons" >
            <g:link controller="create" action="create">Add a collection</g:link>
          </span>
        <p></p>
      </div>

    <g:ifAllGranted role="ROLE_ADMIN">
      <br/><br/><p>These actions are only available to system admins.</p>

      <div class="homeCell">
        <h4 class="inline">Manage roles</h4>
          <span class="buttons" >
            <g:link controller="role" action="list">Manage roles</g:link>
          </span>
        <p>Define who can do what by role.</p>
      </div>

      <div class="homeCell">
        <h4 class="inline">Manage logons</h4>
          <span class="buttons" >
            <g:link controller="logon" action="list">Manage logons</g:link>
          </span>
        <p>Create and maintain user accounts.</p>
      </div>

      <div class="homeCell">
        <h4 class="inline">Manage url security</h4>
          <span class="buttons" >
            <g:link controller="secRequestMap" action="list">Map urls</g:link>
          </span>
        <p>Restrict access to specific urls.</p>
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