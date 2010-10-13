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
	<link rel="stylesheet" type="text/css" media="screen" href="http://test.ala.org.au/wp-content/themes/ala/css/highlights.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="http://test.ala.org.au/wp-content/themes/ala/css/jquery.autocomplete.css" />
    <script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/iframe.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/form.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/jquery-1.4.2.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/ui.core.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/ui.tabs.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/hoverintent-min.js"></script>
	<script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/superfish/superfish.js"></script>
    <script language="JavaScript" type="text/javascript" src="http://test.ala.org.au/wp-content/themes/ala/scripts/jquery.autocomplete.js"></script>
	<script type="text/javascript">

		// initialise plugins
		jQuery(function(){
          jQuery('ul.sf').superfish( {
              delay:500,
              autoArrows:false,
              dropShadows:false
          });

          jQuery("form#search-form input#search").autocomplete('http://bie.ala.org.au/search/auto.jsonp', {
              extraParams: {limit: 100},
              dataType: 'jsonp',
              parse: function(data) {
                  var rows = new Array();
                  data = data.autoCompleteList;
                  for(var i=0; i<data.length; i++){
                      rows[i] = {
                          data:data[i],
                          value: data[i].matchedNames[0],
                          result: data[i].matchedNames[0]
                      };
                  }
                  return rows;
              },
              matchSubset: true,
              formatItem: function(row, i, n) {
                  return row.matchedNames[0];
              },
              cacheLength: 10,
              minChars: 3,
              scroll: false,
              max: 10,
              selectFirst: false
          });

		});

	</script>
  <meta name='robots' content='noindex,nofollow' />
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

<body class="${pageProperty(name:'body.class')}" id="${pageProperty(name:'body.id')}" onload="${pageProperty(name:'body.onload')}">
  <div id="wrapper">
    <div id="banner">
      <div id="logo">
        <a href="http://test.ala.org.au" title="Atlas of Living Australia home"><img src="http://test.ala.org.au/wp-content/themes/ala/images/ala_logo.png" width="216" height="88" alt="Atlas of Living Ausralia logo" /></a>
      </div><!--close logo-->
      <div id="nav">
        <!-- WP Menubar 4.7: start menu nav-site, template Superfish, CSS  -->
        <ul class='sf'><li class='nav-home'><a href='http://test.ala.org.au/'><span>Home</span></a></li><li class='nav-explore'><a href='http://test.ala.org.au/explore/'><span>Explore</span></a><ul><li><a href='http://biocache.ala.org.au/explore/your-area'><span>Your Area</span></a></li><li><a href='http://bie.ala.org.au/regions/'><span>States &amp; Territories</span></a></li><li><a href='http://test.ala.org.au/explore/species-maps/'><span>Species Maps</span></a></li><li><a href='http://collections.ala.org.au/public/map'><span>Natural History Collections</span></a></li><li><a href='http://test.ala.org.au/explore/themes/'><span>Themes &amp; Highlights </span></a></li></ul></li><li class='nav-tools'><a href='http://test.ala.org.au/tools-services/'><span>Tools</span></a><ul><li><a href='http://test.ala.org.au/tools-services/creative-commons-licensing/'><span>Creative Commons licensing</span></a></li><li><a href='http://test.ala.org.au/tools-services/community-science/'><span>Citizen Science</span></a></li><li><a href='http://test.ala.org.au/tools-services/identification-tools/'><span>Identification Tools</span></a></li><li><a href='http://test.ala.org.au/tools-services/for-developers/'><span>For Developers</span></a></li><li><a href='http://test.ala.org.au/tools-services/sharing-data-through-the-atlas/'><span>Sharing data through the Atlas</span></a></li><li><a href='http://test.ala.org.au/tools-services/taxonomic-databases-working-group/'><span>TDWG</span></a></li></ul></li><li class='nav-contribute'><a href='http://test.ala.org.au/contribute/' title='Contribute - links, images, images, literature, your time'><span>Contribute</span></a><ul><li><a href='http://test.ala.org.au/contribute/general-contribute/'><span>General Comments</span></a></li><li><a href='http://test.ala.org.au/contribute/sighting/'><span>Record Sightings</span></a></li><li><a href='http://test.ala.org.au/contribute/share-links/'><span>share links, ideas, information</span></a></li><li><a href='http://test.ala.org.au/contribute/share-images/'><span>Share Photos</span></a></li><li><a href='http://test.ala.org.au/contribute/share-data/'><span>Upload Data Sets</span></a></li><li><a href='http://test.ala.org.au/contribute/share-analogue-data/'><span>Non-digital Information</span></a></li></ul></li><li class='nav-support'><a href='http://test.ala.org.au/support/'><span>Support</span></a><ul><li><a href='http://test.ala.org.au/support/get-started/'><span>Get Started</span></a></li><li><a href='http://test.ala.org.au/support/forum/'><span>Forum</span></a></li><li><a href='http://test.ala.org.au/support/faq/'><span>Frequently Asked Questions</span></a></li><li><a href='http://test.ala.org.au/support/how-to/'><span>How To</span></a></li></ul></li><li class='nav-contact'><a href='http://test.ala.org.au/contact-us/'><span>Contact Us</span></a></li><li class='nav-about'><a href='http://test.ala.org.au/about/'><span>About the Atlas</span></a><ul><li><a href='http://test.ala.org.au/about/people/'><span>Working Together</span></a></li><li><a href='http://test.ala.org.au/about/portfolio-of-projects/'><span>Projects</span></a></li><li><a href='http://test.ala.org.au/about/project-time-line/'><span>Project Time Line</span></a></li><li><a href='http://test.ala.org.au/about/governance/'><span>Governance</span></a></li><li><a href='http://test.ala.org.au/about/media-centre/'><span>Media Centre</span></a></li><li><a href='http://test.ala.org.au/about/newsevents/'><span>News &amp; Events</span></a></li><li><a href='http://test.ala.org.au/about/resources/'><span>Resources</span></a></li></ul></li><li class='nav-login nav-right'><a href='https://auth.ala.org.au/cas/login?service=http://bie.ala.org.au/species/urn:lsid:biodiversity.org.au:afd.taxon:5b72fb29-0318-43f8-bc0a-58b879b17601'>Log in</a></li></ul>
        <!-- WP Menubar 4.7: end menu nav-site, template Superfish, CSS  -->
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
      <div id='footer-nav'><ul id='menu-footer-site'><li id='menu-item-1046' class='menu-item menu-item-type-post_type current-menu-item page_item page-item-97 current_page_item menu-item-1046'><a href='http://test.ala.org.au/'>Home</a></li><li id='menu-item-1051' class='menu-item menu-item-type-post_type menu-item-1051'><a href='http://test.ala.org.au/tools-services/'>Tools</a></li><li id='menu-item-1050' class='menu-item menu-item-type-post_type menu-item-1050'><a href='http://test.ala.org.au/support/'>Support</a></li><li id='menu-item-1048' class='menu-item menu-item-type-post_type menu-item-1048'><a href='http://test.ala.org.au/contact-us/'>Contact Us</a></li><li id='menu-item-1047' class='menu-item menu-item-type-post_type menu-item-1047'><a href='http://test.ala.org.au/about/'>About the Atlas</a></li><li id='menu-item-1052' class='last menu-item menu-item-type-custom menu-item-1052'><a href='https://auth.ala.org.au/cas/login?service=http://bie.ala.org.au/species/urn:lsid:biodiversity.org.au:afd.taxon:5b72fb29-0318-43f8-bc0a-58b879b17601'>Log in</a></li></ul><ul id='menu-footer-legal'><li id='menu-item-3090' class='menu-item menu-item-type-post_type menu-item-3090'><a href='http://test.ala.org.au/site-map/'>Site Map</a></li><li id='menu-item-1042' class='menu-item menu-item-type-post_type menu-item-1042'><a href='http://test.ala.org.au/about/media-centre/terms-of-use/citing-the-atlas/'>Citing the Atlas</a></li><li id='menu-item-1043' class='menu-item menu-item-type-post_type menu-item-1043'><a href='http://test.ala.org.au/about/media-centre/terms-of-use/disclaimer/'>Disclaimer</a></li><li id='menu-item-1045' class='last menu-item menu-item-type-post_type menu-item-1045'><a href='http://test.ala.org.au/about/media-centre/terms-of-use/'>Terms of Use</a></li></ul></div><div class='copyright'><p><a href='http://creativecommons.org/licenses/by/2.5/au/' title='External link to Creative Commons' class='left no-pipe'><img src='http://test.ala.org.au/wp-content/themes/ala/images/somerights20.png' width='88' height='31' alt=''/></a>This work is licensed under a <a href='http://creativecommons.org/licenses/by/2.5/au/' title='External link to Creative Commons'>Creative Commons Attribution 2.5 Australia License</a></p></div>
      <script type='text/javascript'> var gaJsHost = (('https:' == document.location.protocol) ? 'https://ssl.' : 'http://www.');document.write(unescape('%3Cscript src="' + gaJsHost + 'google-analytics.com/ga.js" type="text/javascript"%3E%3C/script%3E'));</script> <script type='text/javascript'> var pageTracker = _gat._getTracker('UA-4355440-1');pageTracker._initData();pageTracker._trackPageview();</script>
    </div><!--close footer-->
  </div><!--close wrapper-->
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