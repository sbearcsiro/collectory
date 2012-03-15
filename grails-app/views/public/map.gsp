<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.CollectionLocation" %>
<html>
    <head>
        <!-- this is not the current version - use map3 -->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala2" />
        <!--meta name="viewport" content="initial-scale=1.0, user-scalable=no" /-->
        <title>Natural History Collections | Atlas of Living Australia</title>
        <script type="text/javascript" src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=${grailsApplication.config.google.maps.v2.key}"></script>
        <!--ABQIAAAAJdniJYdyzT6MyTJB-El-5RQumuBjAh1ZwCPSMCeiY49-PS8MIhSVhrLc20UWCGPHYqmLuvaS_b_FaQ-->
        <script type="text/javascript" src="${resource(dir:'js', file:'map.js')}"></script>
        
        <script type="text/javascript">
          $(document).ready(function() {
            $('#nav-tabs > ul').tabs();
            greyInitialValues();
            <!-- calling initMap() here rather than in onload() causes instability -->
          });
        </script>
    </head>
    <body id="page-collections-map" onload="initMap('${ConfigurationHolder.config.grails.serverURL}')">
    <div id="content">
      <div id="header">
        <!--Breadcrumbs-->
        <div id="breadcrumb"><a href="${ConfigurationHolder.config.ala.baseURL}">Home</a> <a href="${ConfigurationHolder.config.ala.baseURL}/explore/">Explore</a><span class="current">Natural History Collections</span></div>
        <div class="section full-width">
          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>
          <div class="hrgroup">
            <h1>Australia's natural history collections</h1>
            <p>Learn about the institution, the collections they hold and view records of specimens that have been digitised. Currently only the collections of ALA partners are shown.
              Over time this list will expand to include all natural history collections in Australia.</p>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->

      <div id="nav-tabs">
          <ul class="ui-tabs-nav">
              <li><a href="#map">Map</a></li>
              <li><a href="#list">List</a></li>
          </ul>
      </div>
      <div style="clear:both;"></div>

      <div><!-- wrap map and list-->
        <div id="column-one" class="fudge">
          <div class="section">
            <p style="padding:15px 10px 0 10px">Show these collections:</p>
            <ul id="map-collections">
              <li><input id="all" name="all" type="checkbox" value="all" checked="checked" onclick="setAll();"/><label for="all">Select all</label>
                <ul class="taxaBreakdown">
                  <li id="herbariaBreakdown"><input style="margin-right:8px;" onclick="filterChange()" name="filter" type="checkbox" checked="checked" value="plants" id="plants"/><label for="plants">Herbaria</label></li>
                  <li id="faunaBreakdown"><input style="margin-right:8px;" onclick="filterChange()" name="filter" type="checkbox" checked="checked" value="fauna" id="fauna"/><label for="fauna">Faunal collections</label>
                    <ul>
                      <li id="entoBreakdown"><input style="margin-right:8px;" onclick="entoChange()" name="filter" type="checkbox" checked="checked" value="entomology" id="ento"/><label for="ento">Entomological collections</label></li>
                    </ul>
                  </li>
                  <li id="microbialBreakdown"><input style="margin-right:8px;" onclick="filterChange()" name="filter" type="checkbox" checked="checked" value="microbes" id="microbes"/><label for="microbes">Microbial collections</label></li>
                </ul>
              </li>
            </ul>
            <div style="width:235px;margin-left:0;">
              <p class="collectionsCount"><span id='numFeatures'></span></p>
              <p class="collectionsCount"><span id='numVisible'></span> <span id="numUnMappable"></span></p>
            </div>
          </div><!--close section-->
        </div><!--close column-one-->
        <div id="map">
          <div id="column-two" class="map-column">
            <div class="section">
              <p style="width:588px;padding-bottom:8px;padding-left:30px;">Click on a map pin to see the collections at that location. Use the map controls to zoom into an area of interest. Or drag your mouse while holding the shift key to zoom to an area.</p>
              <div id="map-container">
                <div id="map_canvas"></div>
              </div>
              <p style="padding-left:150px;"><img style="vertical-align: middle;" src="${resource(dir:'images/map', file:'orange-dot-multiple.png')}" width="20" height="20"/>indicates there are multiple collections at this location.<br/></p>
            </div><!--close section-->
          </div><!--close column-two-->
        </div><!--close map-->

        <div id="list">
          <div id="column-two" class="list-column">
            <div class="nameList section" id="names">
              <p>Collections are shown grouped by their institution. Click on a collection name to see more details including the digitised specimen records for the collection.
                Click on the institution name to learn more about the institution.</p>
              <ul id="filtered-list">
              </ul>
              <p>Collections not shown on the map (due to lack of location information) are marked <img style="vertical-align:middle" src="${resource(dir:'images/map', file:'nomap.gif')}"/>.</p>
            </div><!--close nameList-->
          </div><!--close column-one-->
        </div><!--close list-->

      </div><!--close map/list div-->

    </div><!--close content-->
  </body>
</html>