<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder" %>

<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">
 
<head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 
<title><g:layoutTitle default="Atlas of Living Australia %naquo; Collectory" /></title>
 
<link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" type="text/css" media="screen"/>
<!--link rel="stylesheet" type="text/css" media="print" href="http://www.ala.org.au/wp-content/themes/ala-theme/print.css"-->
 
<!--link rel="stylesheet" type="text/css" href="${resource(dir:'css',file:'superfish.css')}" media="screen" /-->
<!--script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala-theme/lib/js/jquery-1.2.6.min.js"></script>
<script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala-theme/lib/js/superfish.js"></script>
<script type="text/javascript" src="http://www.ala.org.au/wp-content/themes/ala-theme/lib/js/supersubs.js"></script-->
<link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon">

<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/jquery-1.4.2.min.js"></script>
<link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://www.ala.org.au/xmlrpc.php?rsd" />
<link rel="wlwmanifest" type="application/wlwmanifest+xml" href="http://www.ala.org.au/wp-includes/wlwmanifest.xml" /> 
<link rel='index' title='Atlas of Living Australia' href='http://www.ala.org.au' />
<link rel="stylesheet" href="http://www.ala.org.au/wp-content/plugins/contact-form-7/stylesheet.css" type="text/css" />

<link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
<link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />

<g:javascript library="application" />
<g:javascript library="collectory" />
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<!--resource:include components="autoComplete, dateChooser" autoComplete="[skin: 'default']" /-->
<gui:resources components="['tabView']"/>

</head>
 
<body class="yui-skin-sam" onload="${pageProperty(name:'body.onload')}">
 
<div id="page">
 
	<div id="header" class="clearfix">
		<h1 id="blog-title"><a href="http://www.ala.org.au">Atlas of Living Australia</a>
		    <span id="blog-url">&lt;http://www.ala.org.au&gt;</span></h1>
		<h2 id="blog-description">A biodiversity data management system for Australia</h2>


	</div><!-- end header -->
 
<div class="login-info">
    <cl:isLoggedIn>
        <span id="logged-in">Logged in as <cl:loggedInUsername/></span>
        <a href="http://auth.ala.org.au/cas/logout?url=${ConfigurationHolder.config.security.cas.serverName}/${ConfigurationHolder.config.security.cas.context}">Logout</a>
    </cl:isLoggedIn>
    <cl:isNotLoggedIn>
        <a href="http://auth.ala.org.au/cas/login?service=${ConfigurationHolder.config.security.cas.serverName}/${ConfigurationHolder.config.security.cas.context}/admin">Logout</a>
    </cl:isNotLoggedIn>
</div><browser:isMsie><div style="clear:both"></div></browser:isMsie><!-- fix IE float bug-->
  
<div id="content" class="clearfix">
 
	<div id="content-full-width">
 
 
			
			<div id="post-2"  class="post">
			
				<!-- <h3 class="post-title">Home</h3> -->
				
				<!--h3 class="post-title">Welcome to the ALA Collectory</h3-->
				
		        <!--div id="spinner" class="spinner" style="display:none;">
					<img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner" />
				</div-->
				<g:layoutBody />

			</div>
 			
	  </div>
</div><!-- end content -->
	
<div id="footer">
	
	<div id="legal">
		<p><a href="http://www.ala.org.au">Atlas of Living Australia</a> &copy; 2010 </p>
	</div>
	   <div id="webdemar">
		<p> <a href="http://www.ala.org.au">ala site</a> |
		    <cl:emailLink email="support@ala.org.au">support</cl:emailLink> |
            <a href="http://www.ala.org.au/about/media-centre/terms-of-use/">terms of use</a>
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
</body>
</html>
