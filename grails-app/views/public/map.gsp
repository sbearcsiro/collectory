<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.CollectionLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <!--meta name="viewport" content="initial-scale=1.0, user-scalable=no" /-->
        <title>Explore |  Atlas Living Australia NG</title>
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
        <div id="breadcrumb"><a href="http://test.ala.org.au">Home</a> <a href="http://test.ala.org.au/explore/">Explore</a><span class="current">Natural History Collections</span></div>
        <div class="section full-width">
          <div class="hrgroup">
            <h1>Australia's natural history collections</h1>
            <p>Learn about the institution, the collections they hold and view records of specimens that have been digitised. Currently only the collections of ALA partners are shown.
              Over time this list will expand to include all natural history collections in Australia.</p>
            <g:if test="${flash.message}">
              <div class="message">${flash.message}</div>
            </g:if>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->

      <div id="nav-tabs">
          <ul class="ui-tabs-nav">
              <li><a href="#map">Map</a></li>
              <li><a href="#list">List</a></li>
          </ul>
      </div>

      <div><!-- wrap map and list-->
        <div id="column-one" class="fudge">
          <div class="section">
            <p style="padding:5px 10px 0 10px">Show collections for these groups:</p>
            <ul id="map-collections">
              <li><input id="all" name="all" type="checkbox" value="all" checked="checked" onchange="setAll()"/><label for="all">Select all</label>
                <ul class="taxaBreakdown">
                  <li id="birdsBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="birds"/>Birds</li>
                  <li id="mammalsBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="mammals"/>Mammals</li>
                  <li id="fishBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="fish"/>Fish</li>
                  <li id="frogsBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="frogs"/>Frogs</li>
                  <li id="reptilesBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="reptiles"/>Reptiles</li>
                  <li id="invertsBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="invertebrates"/>Invertebrates</li>
                  <li id="plantsBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="plants"/>Flowering plants</li>
                  <li id="fungiBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="fungi"/>Fungi</li>
                  <li id="fernsBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="ferns"/>Ferns</li>
                  <li id="microbesBreakdown"><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="microbes"/>Microbes</li>
                </ul>
              </li>
              <p><span id='numFeatures'></span></p>
            </ul>
            <!--div><textarea class="output" id="output"></textarea></div-->
          </div><!--close section-->
        </div><!--close column-one-->
        <div id="map">
          <div id="column-two" class="map-column">
            <div class="section">
              <span id='numVisible' style="padding-left:10px;"></span> <span id="numUnMappable"></span>
              <div id="map_canvas"></div>
              <p style="padding-left:150px;"><img style="vertical-align: middle;" src="${resource(dir:'images/map', file:'orange-dot-multiple.png')}" width="20" height="20"/>indicates there are multiple collections at this location.<br/></p>
            </div><!--close section-->
          </div><!--close column-two-->
        </div><!--close map-->

        <div id="list">
          <div id="column-two" class="list-column">
            <div class="nameList section" id="names">
              <p><span id="numFilteredCollections">No collections are selected</span>. Click on a collection name to see more details including the digitised specimen records for the collection.
              Collections not shown on the map (due to lack of location information) are marked <img style="vertical-align:middle" src="${resource(dir:'images', file:'nomap.gif')}"/>.</p>
              <ul id="filtered-list" style="padding-left:15px;">
                <g:each var="c" in="${collections}" status="i">
                  <li>
                    <g:link controller="public" action="show" id="${c.id}">${fieldValue(bean: c, field: "name")}</g:link>
                    <g:if test="${!c.isMappable()}">
                      <img style="vertical-align:middle" src="${resource(dir:'images', file:'nomap.gif')}"/>
                    </g:if>
                  </li>
                </g:each>
              </ul>
            </div><!--close nameList-->
          </div><!--close column-one-->
        </div><!--close list-->

      </div><!--close map/list div-->

    </div><!--close content-->
  </body>
</html>