<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name='robots' content='noindex,nofollow' />
<meta name="app.version" content="${g.meta(name:'app.version')}"/>
<meta name="app.build" content="${g.meta(name:'app.build')}"/>

<title><g:layoutTitle default="Atlas of Living Australia %naquo; Collectory" /></title>
 
<link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" type="text/css" media="screen"/>
<link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
<link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon">

<script language="JavaScript" type="text/javascript" src="${grailsApplication.config.ala.baseURL}/wp-content/themes/ala/scripts/jquery-1.4.2.min.js"></script>
<link rel="EditURI" type="application/rsd+xml" title="RSD" href="${grailsApplication.config.ala.baseURL}/xmlrpc.php?rsd" />
<link rel="wlwmanifest" type="application/wlwmanifest+xml" href="${grailsApplication.config.ala.baseURL}/wp-includes/wlwmanifest.xml" />
<link rel='index' title='Atlas of Living Australia' href='${grailsApplication.config.ala.baseURL}' />

<r:require modules="application, collectory"/>
<r:layoutResources/>
<g:layoutHead />
</head>
 
<body class="yui-skin-sam" onload="${pageProperty(name:'body.onload')}">
 
<div id="page">
 
	<div id="header">
		<h1 id="blog-title"><a href="${grailsApplication.config.ala.baseURL}">Atlas of Living Australia</a>
		    <span id="blog-url">&lt;${grailsApplication.config.ala.baseURL}&gt;</span></h1>
		<h2 id="blog-description">A biodiversity data management system for Australia</h2>


	</div><!-- end header -->

<div id="content" class="clearfix">

    <div class="login-info">
        <cl:loginoutLink2011 showUser="true" fixedAppUrl="${grailsApplication.config.grails.serverURL}/manage"/>
    </div>
    
	<div id="content-full-width" class="clearfix"  style="clear:both;">
			<div id="post-2"  class="post">
				<g:layoutBody />
			</div>
	  </div>
</div><!-- end content -->
	
<div id="footer">
	
	<div id="legal">
		<p><a href="${grailsApplication.config.ala.baseURL}">Atlas of Living Australia</a> &copy; 2010 </p>
	</div>
	   <div id="webdemar">
		<p> <a href="${grailsApplication.config.ala.baseURL}">ala site</a> |
		    <cl:emailLink email="support@ala.org.au">support</cl:emailLink> |
            <a href="${grailsApplication.config.ala.baseURL}/about/media-centre/terms-of-use/">terms of use</a>
        </p>
	</div>
		
	<div class="clear" id="footerClear"></div>
	
</div><!-- end footer -->
 
</div><!-- end page -->
 <script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
    var pageTracker = _gat._getTracker("UA-4355440-1");
    pageTracker._initData();
    pageTracker._trackPageview();
</script>
<r:layoutResources/>
</body>
</html>
