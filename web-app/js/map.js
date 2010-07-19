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

var externalGraphicUrl;
var featuresUrl;

function initMap(serverUrl) {
  externalGraphicUrl = serverUrl + "/images/map/orange-dot.png";
  featuresUrl = serverUrl + "/public/mapFeatures";
    
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
  vectors.style = {externalGraphic: externalGraphicUrl, graphicHeight: 25, graphicWidth: 25};
  vectors.events.register("featureselected", vectors, selected);
  map.addLayer(vectors)

  // control for hover labels
  var hoverControl = new OpenLayers.Control.SelectFeature(vectors, {
    hover: true,
    highlightOnly: true,
    renderIntent: "default",
    eventListeners: {
      //beforefeaturehighlighted: hoverOn,
      featurehighlighted: hoverOn,
      featureunhighlighted: hoverOff
    }
  });
  map.addControl(hoverControl);
  hoverControl.activate();

  // control for selecting features
  var control = new OpenLayers.Control.SelectFeature(vectors, {
    clickout: true
  });
  map.addControl(control);
  control.activate();

  // initial data load
  reloadData();
}

/* data loader */
function reloadData() {
  $.get(featuresUrl, {filters: getAll()}, dataRequestHandler);
  /*OpenLayers.Request.GET({
    url: featuresUrl,
    params: {filters: getAll()},
    callback: dataRequestHandler
  });*/
  /*$.get("${createLink(action: 'mapFeatures')}", function(data) {
    var features = new OpenLayers.Format.GeoJSON(proj_options).read(data);
    vectors.addFeatures(features);
  });*/
}

// handlers
function dataRequestHandler(data) {
  vectors.destroyFeatures();
  var features = new OpenLayers.Format.GeoJSON(proj_options).read(data);
  var numFeatures = features.length;
  document.getElementById('numFeatures').innerHTML = numFeatures;
  vectors.addFeatures(features);
}
/* END plot collection locations */

function hoverOff(evt) {
    feature = evt.feature;
    if (feature != null && feature.popup != null) {
        map.removePopup(feature.popup);
        feature.destroyPopup(feature.popup);
        //alert("off");
    }
}

function hoverOn(evt) {
  feature = evt.feature;
  //if (feature.popup == null) {
    //clearPopups();
    var popup = new OpenLayers.Popup.FramedCloud(feature.attributes.id,
                        feature.geometry.getBounds().getCenterLonLat(),
                        new OpenLayers.Size(10, 10),
                        feature.attributes.name,
                        null,
                        false);
    //popup.closeOnMove(true);
    feature.popup = popup;
    map.addPopup(popup);
    popup.updateSize();

    feature.popup = popup;
    popup.feature = feature;
    map.addPopup(popup);
    //feature.style.externalGraphic = "${resource(dir:'images/map/',file:'orange-dot.png')}";
  //} else {
    //map.removePopup(feature.popup);
    //feature.destroyPopup(feature.popup);
    //feature.style.externalGraphic = "${resource(dir:'images/map/',file:'red-dot.png')}";
  //}
}

function clearPopups() {
    var pops = map.popups
    for (pop in pops) {
        map.removePopup(pop)
    }
}

/* Feature popups */
function selected (evt) {
  clearPopups();
  feature = evt.feature;
  if (feature.popup != null) {
    map.removePopup(feature.popup);
  };
  var address = "";
  if (feature.attributes.address != null && feature.attributes.address != "") {
      address = "<br/>" + feature.attributes.address;
  };
  var desc = feature.attributes.desc;
  if (desc != null && desc != "") {
      desc = "<br/>" + desc;
  } else {
      desc = "";
  }
  var popup = new OpenLayers.Popup.FramedCloud("featurePopup",
                           feature.geometry.getBounds().getCenterLonLat(),
                           new OpenLayers.Size(50,100),
                           "<a href='" + feature.attributes.url + "'>"
                                   + feature.attributes.name + "</a>"
                                   + "<span class='abstract'>" + "<em>" + address + "</em>"
                                   + desc + "</span>",
                           null, true, onPopupClose);
    popup.maxSize = new OpenLayers.Size(300, 500);
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
