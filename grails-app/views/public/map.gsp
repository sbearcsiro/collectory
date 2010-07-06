<%@ page import="au.org.ala.collectory.CollectionLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <!--meta name="viewport" content="initial-scale=1.0, user-scalable=no" /-->
        <title>Natural history collections</title>
        <!--script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script-->
    </head>
    <body onload="initialize()">
    <div id="content">
      <div id="header">
        <h1>Australian natural history collections</h1>
      </div><!--close header-->
      <div class="section no-margin-top">
        <p>Explore the natural history collections of Australia. Learn about the institution, the collections they hold
        and view records of specimens that have been digitised.</p>
        <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
        </g:if>
      </div>

      <div id="column-two">
        <div class="section">
          <div style="border:1px solid gray;">
            <ul style="list-style: none;padding-top:20px;">
              <li><input id="all" style="margin-right:8px;" name="all" type="checkbox" value="all" checked="checked" onclick="setAll()"/>All colections</li>
              <ul style="list-style: none;padding-top:20px;">
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Museums</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Botanic gardens</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Herbaria</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Aquariums</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Zoos</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Insects</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Microbes</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Birds</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Mammals</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Fungi</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Fishes</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Reptiles</li>
                <li><input style="margin-right:8px;" name="museums" type="checkbox" checked="checked" value="museums"/>Amphibians</li>
              </ul>
            </ul>
          </div>
        </div>
      </div>

      <div id="column-one">
        <div class="section no-margin-top">
          <div id="map_canvas" style="width:600px; height:500px"></div>
        </div><!--close section-->
      </div><!--close column-one-->

      <div class="section no-margin-top">
        <a href="" onclick="toggleLayer('names');return false;">List collections by name</a>
        <div id="names" style="display:none;">
          <table class='shy'>
            <g:each var="c" in="${collections}" status="i">
              <g:if test="${i%2 == 0}">
                <tr>
              </g:if>
              <td><g:link controller="public" action="show" id="${c.id}">${fieldValue(bean: c, field: "name")}</g:link></td>
              <g:if test="${i%2 != 0}">
                </tr>
              </g:if>
            </g:each>
          </table>
        </div>
      </div>

    </div>

    <script type="text/javascript">
      function setAll() {
        var boxes = document.getElementsByName('museums');
        for (i=0;i<boxes.length;i++) {
          boxes[i].checked = document.getElementById('all').checked;
        }
      }

      var geocoder;
      var map;
      function initialize() {
        /*var mapOptions = "{maxResolution: 2468}";
        var options2 = {
            projection: new OpenLayers.Projection("EPSG:900913"),
            units: "m",
            maxResolution: 156543.0339,
            maxExtent: new OpenLayers.Bounds(-20037508.34, -20037508.34,
                                             20037508.34, 20037508.34)
        };*/
        var map = new OpenLayers.Map('map_canvas');
        /*var layer = new OpenLayers.Layer.WMS(
            "Global Imagery",
            "http://maps.opengeo.org/geowebcache/service/wms",
            {layers: "bluemarble"},
            {wrapDateLine: true}
        );

        var statesLayer = new OpenLayers.Layer.WMS("Political States",
            "http://maps.ala.org.au/wms",
            {layers: "ala:as",
            srs: 'EPSG:4326',
            version: "1.0.0",
            transparent: "true",
            format: "image/png",
            maxExtent: new OpenLayers.Bounds(112.91,-54.76,159.11,-10.06)},
            {alpha: true}
        );

        map.addLayer(layer);
        map.addLayer(statesLayer);*/

        // create Google Mercator layers
        var gmap = new OpenLayers.Layer.Google(
            "Google Streets",
            {'sphericalMercator': true,
             maxExtent: new OpenLayers.Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34)}
        );
        map.addLayer(gmap);
        map.zoomToMaxExtent();
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

        map.addControl(new OpenLayers.Control.LayerSwitcher());

        var proj = new OpenLayers.Projection("EPSG:4326");
        var point = new OpenLayers.LonLat(133, -27);

        map.setCenter(point.transform(proj, map.getProjectionObject()), 4);

        var vectors = new OpenLayers.Layer.Vector("Collections");
        vectors.style = {externalGraphic: "${resource(dir:'images/map/',file:'orange-dot.png')}", graphicHeight: 25, graphicWidth: 25};
        map.addLayer(vectors)

        var in_options = {
            'internalProjection': map.baseLayer.projection,
            'externalProjection': proj
        };

        $.get("${createLink(action: 'mapFeatures')}", function(data) {
          var features = new OpenLayers.Format.GeoJSON(in_options).read(data);
          var bounds
          for(var i=0; i<features.length; ++i) {
              if (!bounds) {
                  bounds = features[i].geometry.getBounds();
              } else {
                  bounds.extend(features[i].geometry.getBounds());
              }
          }
          vectors.addFeatures(features);
          //map.zoomToExtent(bounds);
        });

        /*var geojson = new OpenLayers.Layer.GML("GeoJSON", ${locations}, {
          projection: new OpenLayers.Projection("EPSG:4326"),
          format: OpenLayers.Format.GeoJSON
        });
        map.addLayer(geojson);*/
        
        // reload vector layer on zoom event
        //map.events.register('zoomend', map, function (e) {
        //    loadVectorLayer();
        //});

        /*var vectorLayer = new OpenLayers.Layer.Vector("Overlay");
        var marker = new OpenLayers.Geometry.Point(149.114293, -35.274218);
        marker.transform(proj, map.getProjectionObject());
        var feature = new OpenLayers.Feature.Vector(
          marker,
          {some:'data'},
          {externalGraphic: "${resource(dir:'images/map/',file:'red-dot.png')}", graphicHeight: 25, graphicWidth: 21});
        vectorLayer.addFeatures(feature);
        map.addLayer(vectorLayer);*/
        //map.zoomToMaxExtent();


      }

      function onPopupClose(evt) {
          // 'this' is the popup.
          selectControl.unselect(this.feature);
      }
      function onFeatureSelect(evt) {
          feature = evt.feature;
          popup = new OpenLayers.Popup.FramedCloud("featurePopup",
                                   feature.geometry.getBounds().getCenterLonLat(),
                                   new OpenLayers.Size(100,100),
                                   "<h2>"+feature.attributes.title + "</h2>" +
                                   feature.attributes.description,
                                   null, true, onPopupClose);
          feature.popup = popup;
          popup.feature = feature;
          map.addPopup(popup);
      }
      function onFeatureUnselect(evt) {
          feature = evt.feature;
          if (feature.popup) {
              popup.feature = null;
              map.removePopup(feature.popup);
              feature.popup.destroy();
              feature.popup = null;
          }
      }

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
