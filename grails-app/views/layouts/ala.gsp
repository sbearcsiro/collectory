<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">

<head profile="http://gmpg.org/xfn/11">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

  <title><g:layoutTitle/></title>

    <link rel="stylesheet" href="http://test.ala.org.au/wp-content/themes/ala/style.css" type="text/css" media="screen" />
    <!--link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon"-->
    <link rel="icon" type="image/x-icon" href="http://test.ala.org.au/wp-content/themes/ala/images/favicon.ico" />
    <link rel="shortcut icon" type="image/x-icon" href="http://test.ala.org.au/wp-content/themes/ala/images/favicon.ico" />
	<link rel="stylesheet" type="text/css" media="screen" href="http://test.ala.org.au/wp-content/themes/ala/css/sf.css" />
	<link rel="stylesheet" type="text/css" media="screen" href="http://test.ala.org.au/wp-content/themes/ala/css/superfish.css" /><!-- ?? -->
	<link rel="stylesheet" type="text/css" media="screen" href="http://test.ala.org.au/wp-content/themes/ala/css/highlights.css" />

	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/form.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/jquery-1.4.2.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/ui.core.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/ui.tabs.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/hoverintent-min.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/superfish/superfish.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/jquery.jcarousel.min.js"></script><!-- ?? -->
	<script type="text/javascript">

		// initialise plugins
		jQuery(function(){
			jQuery('ul.sf').superfish( {
				delay:500,
				autoArrows:false,
				dropShadows:false
			});
		});

	</script>
  <meta name='robots' content='noindex,nofollow' />
  <link rel="alternate" type="application/rss+xml" title="Atlas Living Australia NG &raquo; Feed" href="http://test.ala.org.au/feed/" />
  <link rel="alternate" type="application/rss+xml" title="Atlas Living Australia NG &raquo; Comments Feed" href="http://test.ala.org.au/comments/feed/" />
  <link rel='stylesheet' id='external-links-css'  href='http://test.ala.org.au/wp-content/plugins/sem-external-links/sem-external-links.css?ver=20090903' type='text/css' media='all' />
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="http://test.ala.org.au/xmlrpc.php?rsd" />
  <link rel="wlwmanifest" type="application/wlwmanifest+xml" href="http://test.ala.org.au/wp-includes/wlwmanifest.xml" />
  <link rel='index' title='Atlas Living Australia NG' href='http://test.ala.org.au/' />
  <link rel='prev' title='My Profile' href='http://test.ala.org.au/my-profile/' />
  <link rel='next' title='Search' href='http://test.ala.org.au/tools-services/search-tools/' />
  <meta name="generator" content="WordPress 3.0" />
  <link rel='canonical' href='http://test.ala.org.au/' />

  <link rel="stylesheet" href="${resource(dir:'css',file:'temp-style.css')}"/>
  <link rel="stylesheet" href="${resource(dir:'css',file:'public.css')}"/>
  <g:javascript library="application" />
  <g:javascript library="collectory" />
  <g:javascript src="OpenLayers/OpenLayers.js" />
  <g:layoutHead />
</head>

<!-- WP Menubar 4.7: start CSS -->
<!-- WP Menubar 4.7: end CSS -->
<body class="${pageProperty(name:'body.class')}" id="${pageProperty(name:'body.id')}" onload="${pageProperty(name:'body.onload')}">
  <div id="wrapper">
    <div id="banner">
      <div id="logo">
        <a href="http://test.ala.org.au" title="Atlas of Living Australia home"><img src="http://test.ala.org.au/wp-content/themes/ala/images/ala_logo.png" width="218" height="88" alt="Atlas of Living Ausralia logo" /></a>
      </div><!--close logo-->
      <div id="nav">
        <!-- WP Menubar 4.7: start menu nav-site, template Superfish, CSS  -->
        <ul class="sf"><li class="nav-home"><a  href="http://test.ala.org.au/"><span>Home</span></a></li><li class="nav-explore selected"><a  href="http://test.ala.org.au/explore/"><span>Explore</span></a><ul><li><a  href="http://test.ala.org.au/explore/maps/"><span>Maps</span></a></li><li><a  href="http://test.ala.org.au/explore/themes/"><span>Themes</span></a></li><li><a  href="http://collections.ala.org.au/public/map"><span>Natural History Collections</span></a></li></ul></li><li class="nav-tools"><a  href="http://test.ala.org.au/tools-services/"><span>Tools</span></a><ul><li><a  href="http://test.ala.org.au/tools-services/search-tools/"><span>Mapping Tools</span></a></li><li><a  href="http://test.ala.org.au/tools-services/community-science/"><span>Citizen Science</span></a></li><li><a  href="http://test.ala.org.au/tools-services/identification-tools/"><span>Identification Tools</span></a></li><li><a  href="http://test.ala.org.au/tools-services/for-developers/"><span>For Developers</span></a></li></ul></li><li class="nav-contact"><a  href="http://test.ala.org.au/contact-us/"><span>Contact Us</span></a><ul><li><a  href="http://test.ala.org.au/contact-us/contact-our-team/"><span>Contact Our Team</span></a></li><li><a  href="http://test.ala.org.au/contact-us/contribute/"><span>Contribute</span></a></li></ul></li><li class="nav-support"><a  href="http://test.ala.org.au/support/"><span>Support</span></a><ul><li><a  href="http://test.ala.org.au/support/get-started/"><span>Get Started</span></a></li><li><a  href="http://test.ala.org.au/support/forum/"><span>Forum</span></a></li><li><a  href="http://test.ala.org.au/support/faq/"><span>Frequently Asked Questions</span></a></li><li><a  href="http://test.ala.org.au/support/help/"><span>Help</span></a></li></ul></li><li class="nav-about"><a  href="http://test.ala.org.au/about/"><span>About the Atlas</span></a><ul><li><a  href="http://test.ala.org.au/about/the-project/"><span>The Project</span></a></li><li><a  href="http://test.ala.org.au/about/partnerships/"><span>Partnerships</span></a></li><li><a  href="http://test.ala.org.au/about/communications/"><span>Communications</span></a></li></ul></li><li class="nav-login nav-right"><a  href="/#" title="">Log in</a> 	<ul class="log-in"> 		<li><form method="post" id="log-in" action=""> 			<input id="authenticity_token" name="authenticity_token" type="hidden" value="" /> 			<input id="return_to_ssl" name="return_to_ssl" type="hidden" value="false" /> 			<p><label for="username">Username or e-mail</label><input type="text" class="filled" id="username" name="session[username_or_email]" value="" title="username" tabindex="4"/></p> 			<p><label for="password">Password</label><input type="password" class="filled" id="password" name="session[password]" value="" title="password" tabindex="5"/></p> 			<p><input type="submit" id="login_submit" value="Log in" tabindex="7"/></p> 			<p class="remember-me"><input type="checkbox" id="remember" name="remember_me" value="1" tabindex="6"/><label for="remember">Remember me</label></p> 			<p> 			<a href="" id="forgot_username_link" title="If you remember your password, try logging in with your email">Forgot username?</a><br /> 			<a href="" id="resend_password_link">Forgot password?</a></p> 			</form> 		</li> 	</ul> </li></ul>         <!-- WP Menubar 4.7: end menu nav-site, template Superfish, CSS  -->
      </div><!--close nav-->
      <div id="wrapper_search">
        <form id="search-form" action="http://bie.ala.org.au/search" method="get" name="search-form">
          <label for="search">Search</label>
          <input type="text" class="filled" id="search" name="q" value="Search the Atlas"/>
          <span class="search-button-wrapper"><input type="submit" class="search-button" id="search-button" alt="Search" value="Search"/></span>
        </form>
      </div><!--close wrapper_search-->
    </div><!--close banner-->

    <g:layoutBody/>

    <div id="footer">
      <div id="footer-nav">
        <ul id="menu-footer-site"><li id="menu-item-1046" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/">Home</a></li>
          <li id="menu-item-1049" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/explore/maps/explore-stateterritory/">Explore</a></li>
          <li id="menu-item-1051" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/tools-services/">Tools</a></li>
          <li id="menu-item-1050" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/support/">Support</a></li>
          <li id="menu-item-1048" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/contact-us/">Contact Us</a></li>
          <li id="menu-item-1047" class="menu-item menu-item-type-post_type current-page-ancestor"><a href="http://test.ala.org.au/about/">About the Atlas</a></li>
          <li id="menu-item-1052" class="last menu-item menu-item-type-custom"><a href="http://test.ala.org.au">Log in</a></li>
        </ul>        <ul id="menu-footer-legal"><li id="menu-item-1042" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/home/citing-the-atlas/">Citing the Atlas</a></li>
        <li id="menu-item-1043" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/home/disclaimer/">Disclaimer</a></li>
        <li id="menu-item-1044" class="menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/home/privacy-policy/">Privacy Policy</a></li>
        <li id="menu-item-1045" class="last menu-item menu-item-type-post_type"><a href="http://test.ala.org.au/home/terms-of-use/">Terms of Use</a></li>
      </ul></div>
      <div class="copyright"><p><a href="http://creativecommons.org/licenses/by/2.5/au/" title="External link to Creative Commons" class="left no-pipe"><img src="http://test.ala.org.au/wp-content/themes/ala/images/somerights20.png" width="88" height="31" alt=""/></a>This work is licensed under a <a href="http://creativecommons.org/licenses/by/2.5/au/" title="External link to Creative Commons" class="external external_icon">Creative Commons Attribution 2.5 Australia License</a></p></div>
    </div><!--close footer-->
  </div><!--close wrapper-->
</body>
</html>