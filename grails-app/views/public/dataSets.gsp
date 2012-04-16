<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder" %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${ConfigurationHolder.config.ala.skin}"/>
    <title>Atlas Datasets | Atlas of Living Australia</title>
    <link rel="stylesheet" type="text/css" media="screen" href="http://biocache.ala.org.au/static/css/search.css"/>
    <g:javascript library="datasets"/>
    <g:javascript library="jquery.json-2.2.min"/>
    <g:javascript library="jquery.ba-bbq.min"/>
    <g:javascript library="jQueryRotateCompressed.2.1"/>
    <g:javascript library="debug"/>
    <script type="text/javascript">
      var altMap = true;
      $(document).ready(function() {
        $('#nav-tabs > ul').tabs();
        loadResources("${ConfigurationHolder.config.grails.serverURL}","${ConfigurationHolder.config.biocache.records.url}");
        $('select#per-page').change(onPageSizeChange);
        $('select#sort').change(onSortChange);
        $('select#dir').change(onDirChange);
      });
    </script>
  </head>

  <body id="page-datasets">
    <div id="content">
        %{--<header id="page-header">
            <div class="inner">
                <nav id="breadcrumb"><ol><li><a href="http://www.ala.org.au">Home</a></li> <li><a href='${ConfigurationHolder.config.ala.baseURL}/data-sets/'>Data sets</a></li> <li class="last">List</li></ol></nav>
                <h1>Atlas data sets</h1>
            </div><!--inner-->
        </header>
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>--}%

        <div id="header">
        <!--Breadcrumbs-->
        <div id="breadcrumb"><cl:breadcrumbTrail home="dataSets" atBase="true"/></div>
        <div class="full-width">
          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>
          <div style="padding:0 15px 15px 15px;">
            <h1>Atlas data sets</h1>
            <p style="padding-bottom:6px !important;">Much of the content in the Atlas, such as occurrence records, environmental data, images and the conservation status of species, comes from data sets provided by collecting institutions, individual collectors and community groups. These data sets are listed on this page.</p>
            <p>Refine the list of data sets by clicking on a filter in the left hand list. Click the <img style="vertical-align:middle;" src="${resource(dir:'/images/skin',file:'ExpandArrow.png')}"/>toggle to see a description of the data set. To find out more, go to the data set's full metadata page by clicking on its name.</p>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->

      <noscript>
          <div class="noscriptmsg">
            You don't have javascript enabled. This page will not work without javascript.
          </div>
      </noscript>

      <div class="collectory-content">
      <div id="sidebarBox" class="facets">
        <div class="sidebar-header">
          <h3>Refine Results</h3>
        </div>

        <div id="currentFilterHolder">
        </div>

        <div id="dsFacets">
        </div>
      </div>

      <div id="data-set-list" style="float:left;width:720px;margin-right:10px;">
        <div id="listHeader"><span id="resultsReturned">Showing <strong></strong>&nbsp;data sets.</span>
          <input type="text" name="dr-search" id="dr-search"/> <span title="Only show data sets which contain the search term" id="dr-search-link" class="link">Search</span>
          <span id="reset"><a href="javascript:reset()" title="Remove all filters and sorting options">Reset list</a></span>
        </div>

        <div id="searchControls">
          <div id="downloads">
            <a href="#" id="downloadLink"
               title="Download metadata for datasets as a CSV file">Download</a>
          </div>

          <div id="sortWidgets">
              <label for="per-page">Results per page</label>
              <g:select id="per-page" name="per-page" from="${[10,20,50,100,500]}" value="${pageSize ?: 20}"/>

              Sort by
              <g:select id="sort" name="sort" from="${['name','type','license']}"/>
              Sort order
              <g:select id="dir" name="dir" from="${['ascending','descending']}"/>
          </div>
        </div><!--drop downs-->

        <div id="results">
          <div id="loading">Loading ..</div>
        </div>

        <div id="searchNavBar" class="clearfix">
          <div id="navLinks"></div>
        </div>
      </div>

    </div><!-- close collectory-content-->

    </div><!--close content-->

    <g:javascript library="jquery.tools.min"/>
  </body>
</html>