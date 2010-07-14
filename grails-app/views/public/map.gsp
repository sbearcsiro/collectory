<%@ page import="au.org.ala.collectory.CollectionLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <!--meta name="viewport" content="initial-scale=1.0, user-scalable=no" /-->
        <title>Natural history collections</title>
        <script type="text/javascript">
          $(document).ready(function() {
            initialize();
          });
        </script>
    </head>
    <body>
    <div id="content">
      <div id="header">
        <!--div>Breadcrumbs here...</div-->
        <div class="section full-width no-margin-top">
          <h1>Australia's natural history collections</h1>
          <p style="margin-left:15px;">Explore the natural history collections of Australia. Learn about the institution, the collections they hold
          and view records of specimens that have been digitised.</p>
          <g:if test="${flash.message}">
          <div class="message">${flash.message}</div>
          </g:if>
        </div>
      </div><!--close header-->

      <div id="nav-tabs">
          <ul class="ui-tabs-nav">
              <li class="ui-tabs-selected"><a href="#map">Map</a></li>
              <li class=""><a href="#list">List</a></li>
          </ul>
      </div>

      <div id="map" class="ui-tabs-panel">
        <div id="column-two">
          <div class="section">
            <div style="border:1px solid gray;">
              <ul style="list-style: none;padding-top:20px;">
                <li><input id="all" style="margin-right:8px;" name="all" type="checkbox" value="all" checked="checked" onchange="setAll()"/>Select all</li>
                <ul style="list-style: none;padding-top:20px;">
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="museums"/>Museums</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="gardens"/>Botanic gardens</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="herbarium"/>Herbaria</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="aquarium"/>Aquariums</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="zoo"/>Zoos</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="insects"/>Insects</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="microbial"/>Microbes</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="birds"/>Birds</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="mammal"/>Mammals</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="fungi"/>Fungi</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="fish"/>Fishes</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="reptiles"/>Reptiles</li>
                  <li><input style="margin-right:8px;" onchange="filterChange()" name="filter" type="checkbox" checked="checked" value="amphibians"/>Amphibians</li>
                </ul>
              </ul>
            </div>
            <p>Showing <span id='numFeatures'></span> collections.</p>
          </div>
        </div>
        <div id="column-one">
          <div class="section no-margin-top">
            <div id="map_canvas" style="width:580px; height:470px"></div>
          </div><!--close section-->
        </div><!--close column-one-->
      </div>
      
      <div id="list" class="ui-tabs-panel ui-tabs-hide">
        <div class="section no-margin-top">
          <div class="nameList" id="names">
            <div style="padding: 0 20px 0 20px;">
              <p>This list may include collections that do not appear on the collections map (due to lack of location information).
              Currently only the collections of ALA partners are shown.
              Over time this list will expand to include all natural history collections in Australia.
              The collections are listed alphabetically. Click on a collection name to see more details including the
              digitised specimen records for the collection.</p>
            </div>
            <table class='shy'>
              <!-- some shenanigans to order alphabetically in columns -->
              <g:set var="half" value="${Math.ceil(collections.size()/2)}"/>
              <g:each var="unused" in="${collections}" status="i">
                <g:set var="c" value="${(i%2 == 0) ? collections[(int)i/2] : collections[(int)(half + (i-1)/2)]}"/>
                <g:if test="${i%2 == 0}">
                  <tr>
                </g:if>
                <td><g:link controller="public" action="show" id="${c.id}">${fieldValue(bean: c, field: "name")}</g:link></td>
                <g:if test="${i%2 != 0}">
                  </tr>
                </g:if>
              </g:each>
            </table>
            <p></p>
          </div>
        </div>
      </div>

    </div>

    <script type="text/javascript">

      /* Filter checkboxes */
      function setAll() {
        var boxes = document.getElementsByName('filter');
        for (i=0;i<boxes.length;i++) {
          boxes[i].checked = document.getElementById('all').checked;
        }
        filterChange();
      }

      function getAll() {
        if (document.getElementById('all').checked) {
          return "all";
        }
        var boxes = document.getElementsByName('filter');
        var checked = "";
        for (i=0;i<boxes.length;i++) {
          if (boxes[i].checked) {
            checked += boxes[i].value + ",";
          }
        }
        return checked;
      }

      function filterChange() {
        // set state of 'select all' box
        var all = true;
        var boxes = document.getElementsByName('filter');
        for (i=0;i<boxes.length;i++) {
          if (!boxes[i].checked) {
            all = false;
          }
        }
        if (document.getElementById('all').checked && !all) {
          document.getElementById('all').checked = false;
        } else if (!document.getElementById('all').checked && all) {
          document.getElementById('all').checked = true;
        }
        reloadData();
      }
      /* END filter checkboxes */

      /* Plot collection locations */
      // the map
      var map;

      // the spherical mercator projection
      var proj = new OpenLayers.Projection("EPSG:4326");

      // projection options for interpreting GeoJSON data
      var proj_options;

      // the data layer
      var vectors;

      function initialize() {
        /* general stuff */
        $('#nav-tabs > ul').tabs();

        // create the map
        map = new OpenLayers.Map('map_canvas',{maxResolution: 2468,controls: []});

        // restrict mouse wheel chaos
        map.addControl(new OpenLayers.Control.Navigation({zoomWheelEnabled:false}));
        map.addControl(new OpenLayers.Control.ZoomPanel());
        map.addControl(new OpenLayers.Control.PanPanel());

        // create Google Mercator layers
        var gmap = new OpenLayers.Layer.Google(
            "Google Streets",
            {'sphericalMercator': true,
             maxExtent: new OpenLayers.Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34)}
        );
        map.addLayer(gmap);
        var gsat = new OpenLayers.Layer.Google(
            "Google Satellite",
            {type: G_SATELLITE_MAP, 'sphericalMercator': true, numZoomLevels: 22}
        );
        map.addLayer(gsat);
        var ghyb = new OpenLayers.Layer.Google(
            "Google Hybrid",
            {type: G_HYBRID_MAP, 'sphericalMercator': true}
        );
        map.addLayer(ghyb);

        // zoom map
        map.zoomToMaxExtent();

        // add layer switcher for now
        map.addControl(new OpenLayers.Control.LayerSwitcher());

        // centre the map on Australia
        var point = new OpenLayers.LonLat(133, -28.2);
        map.setCenter(point.transform(proj, map.getProjectionObject()), 4);

        // set projection options
        proj_options = {
          'internalProjection': map.baseLayer.projection,
          'externalProjection': proj
        };

        // create a layer for markers and set style
        vectors = new OpenLayers.Layer.Vector("Collections");
        vectors.style = {externalGraphic: "${resource(dir:'images/map/',file:'orange-dot.png')}", graphicHeight: 25, graphicWidth: 25};
        vectors.events.register("featureselected", vectors, selected);
        map.addLayer(vectors)

        // control for selecting features
        var control = new OpenLayers.Control.SelectFeature(vectors);
        map.addControl(control);
        control.activate();

        // initial data load
        reloadData();
      }

      /* data loader */
      function reloadData() {
        OpenLayers.Request.GET({
          url: "${createLink(action: 'mapFeatures')}",
          params: {filters: getAll()},
          callback: dataRequestHandler
        });
        /*$.get("${createLink(action: 'mapFeatures')}", function(data) {
          var features = new OpenLayers.Format.GeoJSON(proj_options).read(data);
          vectors.addFeatures(features);
        });*/
      }

      // handler
      function dataRequestHandler(request) {
        vectors.destroyFeatures();
        var features = new OpenLayers.Format.GeoJSON(proj_options).read(request.responseText);
        var numFeatures = features.length;
        document.getElementById('numFeatures').innerHTML = numFeatures;
        vectors.addFeatures(features);
      }
      /* END plot collection locations */

      /* Feature popups */
      function selected (evt) {
        //alert(evt.feature.id + " selected on " + this.name);
        feature = evt.feature;
        var popup = new OpenLayers.Popup.FramedCloud("featurePopup",
                                 feature.geometry.getBounds().getCenterLonLat(),
                                 new OpenLayers.Size(100,100),
                                 "<a href='" + feature.attributes.url + "'>"+feature.attributes.name + "</a>",
                                 null, true, onPopupClose);
        //popup.closeOnMove = true;
        feature.popup = popup;
        popup.feature = feature;
        map.addPopup(popup);
      }

      function onPopupClose(evt) {
        map.removePopup(this);
      }
      /* END feature popups */

      /* geocode */
      function codeAddress(address) {
        if (geocoder) {
          geocoder.geocode( { 'address': address}, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
              var marker = new google.maps.Marker({
                  map: map,
                  position: results[0].geometry.location,
                  title: "Mark's house"
              });
              var infoWindow = new google.maps.InfoWindow({
                content: "Mark lives here"
              });

              google.maps.event.addListener(marker, 'click', function() {
                infoWindow.open(map, marker);
              });
            } else {
              alert("Geocode was not successful for the following reason: " + status);
            }
          });
        }
      }

    </script>
  </body>
</html>
