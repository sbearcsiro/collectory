<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.CollectionLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <!--meta name="viewport" content="initial-scale=1.0, user-scalable=no" /-->
        <title>Natural History Collections | Atlas of Living Australia</title>
        <script type="text/javascript" src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=${grailsApplication.config.google.maps.v2.key}"></script>
        <!--ABQIAAAAJdniJYdyzT6MyTJB-El-5RQumuBjAh1ZwCPSMCeiY49-PS8MIhSVhrLc20UWCGPHYqmLuvaS_b_FaQ-->
        <script type="text/javascript" src="${resource(dir:'js', file:'map.js')}"></script>

        <script type="text/javascript">
          var altMap = true;
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
            <p>Learn about the institution, the collections they hold and view records of specimens that have been databased. Currently only the collections of ALA partners are shown.
              Over time this list will expand to include all natural history collections in Australia.</p>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->

      <div id="nav-tabs">
          <ul class="ui-tabs-nav narrow">
              <li><a href="#map">Map</a></li>
              <li><a href="#list">List</a></li>
          </ul>
      </div>
      <div style="clear:both;"></div>

      <div class="map-alt"><!-- wrap map and list-->

        <div id="column-one" class="fudge">
          <div class="section" style="padding-bottom:0;">
            <p style="padding-bottom:0;padding-left:10px;padding-top:10px;">Click a button to only show those organisms.</p>
          </div>
          <div class="section filter-buttons">
            <div class="all selected" id="all" onclick="toggleButton(this);return false;">
              <h2><a href="">All collections<span id="allButtonTotal">Show all collections.</span></a></h2>
            </div>
            <div class="fauna" id="fauna" onclick="toggleButton(this);return false;">
              <h2><a href="">Fauna<span>Mammals, birds, reptiles, fish, amphibians and invertebrates.</span></a></h2>
            </div>
            <div class="insects" id="entomology" onclick="toggleButton(this);return false;">
              <h2><a href="">Insects<span>Insects, spiders, mites and some other arthropods.</span></a></h2>
            </div>
            <div class="microbes" id="microbes" onclick="toggleButton(this);return false;">
              <h2><a href="">Microorganisms<span>Protists, bacteria, viruses, microfungi and microalgae.</span></a></h2>
            </div>
            <div class="plants" id="plants" onclick="toggleButton(this);return false;">
              <h2><a href="">Plants<span>Vascular plants, algae, fungi, lichens and bryophytes.</span></a></h2>
            </div>
          </div><!--close section-->
          <!--div class="section" style="margin-top:5px;margin-bottom:5px;"><p style="margin-left:8px;padding-bottom:0;color:#666">Note that fauna includes insects.</p></div-->
          <div style="width:265px;margin-left:40px;">
            <p class="collectionsCount"><span id='numFeatures'></span></p>
            <p class="collectionsCount"><span id='numVisible'></span> <span id="numUnMappable"></span></p>
          </div>
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
              <p><span id="numFilteredCollections">No collections are selected</span>. Click on a collection name to see more details including the digitised specimen records for the collection.
              Collections not shown on the map (due to lack of location information) are marked <img style="vertical-align:middle" src="${resource(dir:'images/map', file:'nomap.gif')}"/>.</p>
              <ul id="filtered-list" style="padding-left:15px;">
                <g:each var="c" in="${collections}" status="i">
                  <li>
                    <g:link controller="public" action="show" id="${c.uid}">${fieldValue(bean: c, field: "name")}</g:link>
                    <g:if test="${!c.canBeMapped()}">
                      <img style="vertical-align:middle" src="${resource(dir:'images/map', file:'nomap.gif')}"/>
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