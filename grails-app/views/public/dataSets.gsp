<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ala"/>
    <title>Atlas Datasets | Atlas of Living Australia</title>
    <link rel="stylesheet" type="text/css" media="screen" href="http://biocache-test.ala.org.au/static/css/search.css"/>
    <g:javascript library="datasets"/>
    <g:javascript library="jquery.json-2.2.min"/>
    <g:javascript library="jquery.ba-bbq.min"/>
    <g:javascript library="debug"/>
    <script type="text/javascript">
      var altMap = true;
      $(document).ready(function() {
        $('#nav-tabs > ul').tabs();
        greyInitialValues();
        loadResources("${ConfigurationHolder.config.grails.serverURL}");
        $('select#per-page').change(onPageSizeChange);
        $('select#sort').change(onSortChange);
        $('select#dir').change(onDirChange);
      });
    </script>
  </head>

  <body id="page-datasets">
    <div id="content">
      <div id="header">
        <!--Breadcrumbs-->
        <div id="breadcrumb"><a href="${ConfigurationHolder.config.ala.baseURL}">Home</a> <a href="${ConfigurationHolder.config.ala.baseURL}/explore/">Explore</a><span class="current">Data sets</span></div>
        <div class="full-width">
          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>
          <div style="padding:0 15px 15px 15px;">
            <h1>Atlas data sets</h1>
            <p>The Atlas draws much of its content from data sets. Data sets are the sources of information as diverse as occurrence records,
                environmental data, images and the conservation status of species.
            Data sets are represented by data resources in the Atlas. These are listed below. Use the filters on the left to refine the list.
            Click an item in the list to expand it.</p>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->

      <noscript>
          <div class="noscriptmsg">
            You don't have javascript enabled. This page will not work without javascript.
          </div>
      </noscript>

      <div class="collectory-content">
      <div id="SidebarBox" class="facets" style="float:left;width:250px;padding-left: 10px;padding-top:10px;">
        <div class="sidebar-header">
          <h3>Refine Results</h3>
        </div>

        <div id="currentFilterHolder">
        </div>

        <div id="facets">
        </div>
      </div>

      <div id="data-set-list" style="float:left;width:720px;margin-right:10px;">
        <div id="resultsReturned">Showing <strong></strong>&nbsp;data sets. <a href="javascript:reset()">Reset list</a></div>

        <div id="searchControls">
          <div id="downloads">
            <a href="#" id="downloadLink"
               title="Download metadata for datasets as a CSV file">Download</a>
          </div>

          <div id="sortWidgets">
              <label for="per-page">Results per page</label>
              <g:select id="per-page" name="per-page" from="${[10,20,50,100]}" value="${pageSize ?: 20}"/>

              Sort by
              <g:select id="sort" name="sort" from="${['name','type','license']}"/>
              Sort order
              <g:select id="dir" name="dir" from="${['asc','desc']}"/>
          </div>
        </div><!--drop downs-->

        <div id="results">
        </div>

        <div id="searchNavBar">
          <div id="navLinks"></div>
        </div>
      </div>

    </div><!-- close collectory-content-->

    </div><!--close content-->

    <script type="text/javascript">
    </script>
  </body>
</html>