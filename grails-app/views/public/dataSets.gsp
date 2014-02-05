<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${grailsApplication.config.ala.skin}"/>
    <title>Datasets | ${grailsApplication.config.projectName} </title>
    <r:require modules="datasets, jquery_json, bbq, rotate, jquery_tools"/>
    <script type="text/javascript">
      var altMap = true;
      $(document).ready(function() {
        $('#nav-tabs > ul').tabs();
        loadResources("${grailsApplication.config.grails.serverURL}","${grailsApplication.config.biocache.baseURL}");
        $('select#per-page').change(onPageSizeChange);
        $('select#sort').change(onSortChange);
        $('select#dir').change(onDirChange);
      });
    </script>
  </head>

  <body id="page-datasets" class="nav-datasets">
    <div id="content">
        <div id="header">
        <!--Breadcrumbs-->
        <div id="breadcrumb">
            <ol class="breadcrumb">
                <li><cl:breadcrumbTrail home="dataSets" atBase="true"/></li>
            </ol>
        </div>
        <div class="full-width">
          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>
          <div>
            <h1>${grailsApplication.config.projectName}  data sets</h1>
            <p style="padding-bottom:6px !important;">Much of the content in the ${grailsApplication.config.projectName} , such as
            occurrence records, environmental data, images and the conservation status of species, comes from data sets provided by
            collecting institutions, individual collectors and community groups. These data sets are listed on this page.</p>
            <p>Refine the list of data sets by clicking on a filter in the left hand list.
            Click the <img style="vertical-align:middle;" src="${resource(dir:'/images/skin',file:'ExpandArrow.png')}"/>toggle to see a description of the data set.
            To find out more, go to the data set's full metadata page by clicking on its name.</p>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->

      <noscript>
          <div class="noscriptmsg">
            You don't have javascript enabled. This page will not work without javascript.
          </div>
      </noscript>

      <div class="collectory-content row-fluid">
          <div id="sidebarBoxXXX" class="span3 facets well well-small">
            <div class="sidebar-header">
              <h3>Refine Results</h3>
            </div>

            <div id="currentFilterHolder">
            </div>

            <div id="dsFacets">
            </div>
          </div>

          <div id="data-set-list" class="span9">
            <div class="well">
                <div class="row-fluid">
                      <div class="pull-left">
                          <span id="resultsReturned">Showing <strong></strong>&nbsp;data sets.</span>
                          <div class="input-append">
                              <input type="text" name="dr-search" id="dr-search"/>
                              <a href="javascript:void(0);" title="Only show data sets which contain the search term" id="dr-search-link" class="btn">Search</a>
                              <a href="javascript:void(0);" id="reset"><a href="javascript:reset()" title="Remove all filters and sorting options" class="btn">Reset list</a></a>
                          </div>
                     </div>
                    <div class="pull-right">
                      <a href="#" id="downloadLink" class="btn"
                           title="Download metadata for datasets as a CSV file">
                            <i class="icon-download"></i>
                            Download</a>
                    </div>
                </div>
                <hr/>
                <div id="searchControls">
                  <div id="sortWidgets" class="row-fluid">
                      <div class="span4">
                          <label for="per-page">Results per page</label>
                          <g:select id="per-page" name="per-page" from="${[10,20,50,100,500]}" value="${pageSize ?: 20}"/>
                      </div>
                      <div class="span4">
                          <label for="sort">Sort by</label>
                          <g:select id="sort" name="sort" from="${['name','type','license']}"/>
                      </div>
                      <div class="span4">
                          <label for="dir">Sort order</label>
                          <g:select id="dir" name="dir" from="${['ascending','descending']}"/>
                      </div>
                  </div>
                </div><!--drop downs-->
            </div>

            <div id="results">
              <div id="loading">Loading ..</div>
            </div>

            <div id="searchNavBar" class="clearfix">
              <div id="navLinks"></div>
            </div>
          </div>

    </div><!-- close collectory-content-->

    </div><!--close content-->

  </body>
</html>