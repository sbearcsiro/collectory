<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">
  <head>
	  <title>Grails Runtime Exception</title>
      <link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" type="text/css" media="screen"/>
      <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
      <g:javascript library="collectory" />
	  <style type="text/css">
	  		.error-message {
	  			border: 1px solid #b2d1ff;
	  			padding: 5px;
	  			background-color:#f3f8fc;
                color: #006dba;
	  		}
	  		.stack {
	  			border: 1px solid black;
	  			padding: 5px;
	  			overflow:auto;
	  			height: 300px;
	  		}
	  		.snippet {
	  			padding: 5px;
	  			background-color:white;
	  			border:1px solid black;
	  			margin:3px;
	  			font-family:courier;
	  		}
            h3 {
                margin-top: 25px;
                margin-bottom: 25px;
            }
            .action {
                font-weight: bold;
            }
	  </style>
  </head>

  <body>
    <div id="page">
      <div id="header" class="clearfix">
          <h1 id="blog-title"><a href="http://www.ala.org.au">Atlas of Living Australia</a>
              <span id="blog-url">&lt;http://www.ala.org.au&gt;</span></h1>
          <h2 id="blog-description">A biodiversity data management system for Australia</h2>
    </div><!-- end header -->

    <div class="oops">
      <h3>An unexpected error has occurred.</h3>
      <p>If this is the first time this page has appeared, <span class="action">try the refresh button in your browser.</span></p>
      <p>If this fails, <span class="action">try to return to the <a href="/Collectory">home page</a> and start again.</span></p>
      <p>If this page is still displayed, <span class="action">please report the incident to ALA support.
      <cl:emailBugLink email="support@ala.org.au" message="${exception?.message}">Click here to email ALA support</cl:emailBugLink>.</span></p>
      <p>The following is useful information that helps us discover what has happened. Please copy it into emails requesting support.</p>
      <p>You might also like to expand the more detailed information by clicking on 'Show stack trace' and copying that text to us as well.</p>
      <p>Thanks for your patience.</p>
    </div>
  	<div class="error-message">
		<strong>Error ${request.'javax.servlet.error.status_code'}:</strong> ${request.'javax.servlet.error.message'?.encodeAsHTML()}<br/>
		<strong>Servlet:</strong> ${request.'javax.servlet.error.servlet_name'}<br/>
		<strong>URI:</strong> ${request.'javax.servlet.error.request_uri'}<br/>
		<g:if test="${exception}">
	  		<strong>Exception Message:</strong> ${exception.message?.encodeAsHTML()} <br />
	  		<strong>Caused by:</strong> ${exception.cause?.message?.encodeAsHTML()} <br />
	  		<strong>Class:</strong> ${exception.className} <br />
	  		<strong>At Line:</strong> [${exception.lineNumber}] <br />
	  		<strong>Code Snippet:</strong><br />
	  		<div class="snippet">
	  			<g:each var="cs" in="${exception.codeSnippet}">
	  				${cs?.encodeAsHTML()}<br />
	  			</g:each>
	  		</div>
		</g:if>
  	</div>

	<g:if test="${exception}">
      <span style="cursor:pointer;" onclick="document.getElementById('stack').style.display = 'block'">Show stack trace</span>
      <div id="stack" style="display:none;">
	    <h2>Stack Trace</h2>
	    <div class="stack">
	      <pre><g:each in="${exception.stackTraceLines}">${it.encodeAsHTML()}<br/></g:each></pre>
	    </div>
      </div>
	</g:if>
  </body>
</html>