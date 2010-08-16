/*
 * Mapping - plot collection locations
 */

/* some globals */
// the map
var map;

// the spherical mercator projection
var proj = new OpenLayers.Projection("EPSG:4326");

// projection options for interpreting GeoJSON data
var proj_options;

// the data layer
var vectors;

// the server base url
var baseUrl;

// the ajax url for getting filtered features
var featuresUrl;

/* initialise the map */
/* note this must be called from body.onload() not jQuery document.ready() as the latter is too early */
function initMap(serverUrl) {

    // serverUrl is the base url for the site eg http://collections.ala.org.au in production
    // cannot use relative url as the context path varies with environment
    baseUrl = serverUrl;
    var featureGraphicUrl = baseUrl + "/images/map/orange-dot.png";
    var clusterGraphicUrl = baseUrl + "/images/map/orange-dot-multiple.png";
    featuresUrl = baseUrl + "/public/mapFeatures";

    // create the map
    map = new OpenLayers.Map('map_canvas', {
        maxResolution: 2468,
        /*maxExtent: new OpenLayers.Bounds(-10037508.34, -10037508.34, 10037508.34, 10037508.34),*/
        controls: []
    });

    // restrict mouse wheel chaos
    map.addControl(new OpenLayers.Control.Navigation({zoomWheelEnabled:false}));
    map.addControl(new OpenLayers.Control.ZoomPanel());
    map.addControl(new OpenLayers.Control.PanPanel());

    // create Google base layers
    var extent = new OpenLayers.Bounds(-20037508.34, -20037508.34, 20037508.34, 20037508.34);
    var gmap = new OpenLayers.Layer.Google(
            "Google Streets",
            {'sphericalMercator': true,
              numZoomLevels: 24,
              maxExtent: extent
            });
    map.addLayer(gmap);
    var gsat = new OpenLayers.Layer.Google(
            "Google Satellite",
            {type: G_SATELLITE_MAP,
            'sphericalMercator': true,
             numZoomLevels: 24,
             maxExtent: extent
            });
    map.addLayer(gsat);
    var ghyb = new OpenLayers.Layer.Google(
            "Google Hybrid",
            {type: G_HYBRID_MAP,
            'sphericalMercator': true,
             numZoomLevels: 24,
             maxExtent: extent
            });
    map.addLayer(ghyb);

    // zoom map
    map.zoomToMaxExtent();

    // add layer switcher for now - review later
    map.addControl(new OpenLayers.Control.LayerSwitcher());

    // centre the map on Australia
    var point = new OpenLayers.LonLat(133, -28.2);
    map.setCenter(point.transform(proj, map.getProjectionObject()), 4);

    // set projection options
    proj_options = {
        'internalProjection': map.baseLayer.projection,
        'externalProjection': proj
    };

    // create a style that handles clusters
    var style = new OpenLayers.Style({
        externalGraphic: "${pin}",
        graphicHeight: "${size}",
        graphicWidth: "${size}"
    }, {
        context: {
            pin: function(feature) {
                return (feature.cluster) ? clusterGraphicUrl : featureGraphicUrl;
            },
            size: function(feature) {
                return (feature.cluster) ? 25 : 23;
            }
        }
    });

    // create a layer for markers and set style
    var clusterStrategy = new OpenLayers.Strategy.Cluster({distance: 10, threshold: 2});
    vectors = new OpenLayers.Layer.Vector("Collections", {
        strategies: [clusterStrategy],
        styleMap: new OpenLayers.StyleMap({"default": style})});

    // listen for feature selection
    vectors.events.register("featureselected", vectors, selected);
    map.addLayer(vectors);

    // listen for changes to visible region
    map.events.register("moveend", map, moved);
    
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
    //map.addControl(hoverControl);
    //hoverControl.activate();

    // control for selecting features (on click)
    var control = new OpenLayers.Control.SelectFeature(vectors, {
        clickout: true
    });
    map.addControl(control);
    control.activate();

    // create custom button to zoom extents to Australia
    var button = new OpenLayers.Control.Button({
        displayClass: "resetZoom",
        title: "Zoom to Australia",
        trigger: resetZoom
    });
    var panel = new OpenLayers.Control.Panel({defaultControl: button});
    panel.addControls([button]);
    map.addControl(panel);

    // initial data load
    reloadData();
}

/* load features via ajax call */
function reloadData() {
  $.get(featuresUrl, {filters: getAll()}, dataRequestHandler);
}

/* handler for loading features */
function dataRequestHandler(data) {
    // clear existing
    vectors.destroyFeatures();

    // parse returned json
    var features = new OpenLayers.Format.GeoJSON(proj_options).read(data);

    // update list
    updateList(features);

    // add features to map
    vectors.addFeatures(features);

    // remove non-mappable collections
    var unMappable = new Array();
    for (var i = 0; i < features.length; i++) {
        if (!features[i].attributes.isMappable) {
            unMappable.push(features[i]);
        }
    }
    vectors.destroyFeatures(unMappable);

    // update number of unmappable collections
    var unMappedText = "";
    switch (unMappable.length) {
        case 0: unMappedText = ""; break;
        case 1: unMappedText = "1 collection cannot be mapped."; break;
        default: unMappedText = unMappable.length + " collections cannot be mapped."; break;
    }
    $('span#numUnMappable').html(unMappedText);

    // update display of number of features
    var innerFeatures = "";
    switch (features.length) {
        case 0: innerFeatures = "No collections are selected."; break;
        case 1: innerFeatures = features.length + " collection is selected."; break;
        default: innerFeatures = features.length + " collections are selected."; break;
    }
    $('span#numFeatures').html(innerFeatures);

    // fire moved to initialise number visible
    moved(null);
}

function updateList(features) {
    // update display of number of features
    var innerFeatures = "";
    switch (features.length) {
        case 0: innerFeatures = "No collections are selected"; break;
        case 1: innerFeatures = features.length + " collection is listed"; break;
        default: innerFeatures = features.length + " collections are listed alphabetically"; break;
    }
    $('span#numFilteredCollections').html(innerFeatures);

    var innerHtml = "";
    for (var i = 0; i < features.length; i++) {
        innerHtml = innerHtml + "<li>";
        innerHtml = innerHtml + "<a href=" + baseUrl + "/public/show/" + features[i].attributes.id + ">" + features[i].attributes.name + "</a>";
        if (!features[i].attributes.isMappable) {
          innerHtml = innerHtml + "<img style='vertical-align:middle' src='" + baseUrl + "/images/nomap.gif'/>";
        }
        innerHtml = innerHtml + "</li>";
    }
    $('ul#filtered-list').html(innerHtml);
}

/* hover handlers */
function hoverOff(evt) {
    feature = evt.feature;
    if (feature != null && feature.popup != null) {
        map.removePopup(feature.popup);
        feature.destroyPopup(feature.popup);
    }
}

function hoverOn(evt) {
  feature = evt.feature;
    var content = "";
    if (feature.cluster) {
        content = "<ul class='hoverPop'>";
        for(var c = 0; c < feature.cluster.length; c++) {
            content += "<li>"
                    + feature.cluster[c].attributes.name
                    + "</li>";
        }
        content += "</ul>";
    } else {
        content = feature.attributes.name;
    }
    var popup = new OpenLayers.Popup.FramedCloud(feature.attributes.id,
                        feature.geometry.getBounds().getCenterLonLat(),
                        new OpenLayers.Size(10, 10),
                        content,
                        null,
                        false);
    // attach to feature
    feature.popup = popup;
    // add to map
    map.addPopup(popup);
    // fit to content
    popup.updateSize();
}

/* move (zoom pan) handler */
function moved(evt) {
    // determine how many individual features are visible
    var visibleCount = 0;
    for (var c = 0; c < vectors.features.length; c++) {
        var f = vectors.features[c];
        if (f.onScreen(true)) {
            if (f.cluster) {
                // for clusters count each feature
                visibleCount += f.cluster.length;
            } else {
                // single feature
                visibleCount++;
            }
        }
    }
    // update display of number of features visible
    var innerFeatures = "";
    switch (visibleCount) {
        case 0: innerFeatures = "No collections are currently visible on the map."; break;
        case 1: innerFeatures = visibleCount + " collection is currently visible on the map."; break;
        default: innerFeatures = visibleCount + " collections are currently visible on the map."; break;
    }
    $('span#numVisible').html(innerFeatures);
}

/* click (select) handlers */
function selected(evt) {
    feature = evt.feature;

    // get rid of any dags - hopefully
    clearPopups();

    // double check that none are hanging around
    if (feature.popup != null) {
        map.removePopup(feature.popup);
    }

    // build content
    var content = "";
    if (feature.cluster) {
        content = "Multiple collections at this location:<ul>";
        for(var c = 0; c < feature.cluster.length; c++) {
            content += "<li>"
                    + "<a href='" + feature.cluster[c].attributes.url + "'>"
                    + feature.cluster[c].attributes.name + "</a>"
                    + "</li>";
        }
        content += "</ul>";
    } else {
        var address = "";
        if (feature.attributes.address != null && feature.attributes.address != "") {
            address = "<br/>" + feature.attributes.address;
        }
        var desc = feature.attributes.desc;
        if (desc != null && desc != "") {
            desc = "<br/>" + desc;
        } else {
            desc = "";
        }
        content = "<a href='" + feature.attributes.url + "'>"
                    + feature.attributes.name + "</a>"
                    + "<span class='abstract'>" + "<em>" + address + "</em>"
                    + desc + "</span>"
    }
    
    // create popoup
    var popup = new OpenLayers.Popup.FramedCloud("featurePopup",
            feature.geometry.getBounds().getCenterLonLat(),
            new OpenLayers.Size(50, 100),
            content,
            null, true, onPopupClose);

    // control shape
    if (!feature.cluster) {
        popup.maxSize = new OpenLayers.Size(300, 500);
    }
    //popup.maxSize = feature.cluster ? new OpenLayers.Size(300, 500) : new OpenLayers.Size(300, 500);
    //popup.closeOnMove = true;
    feature.popup = popup;
    popup.feature = feature;

    // add to map
    map.addPopup(popup);
}

function onPopupClose(evt) {
    //evt.feature.removePopup(this);
    map.removePopup(this);
}

function clearPopups() {
    for (pop in map.popups) {
        map.removePopup(pop)
    }
    // maybe iterate features and clear popups?
}

function resetZoom() {
    // centre the map on Australia
    var point = new OpenLayers.LonLat(133, -28.2);
    map.setCenter(point.transform(proj, map.getProjectionObject()), 4);
}
/* END plot collection locations */

/*
 * Helpers for managing Filter checkboxes
 */

// set all boxes checked and trigger change handler
function setAll() {
    $('input[name=filter]').attr('checked', $('input#all').is(':checked'));
    filterChange();
}

// build comma-separated string representing all selected boxes
function getAll() {
    if ($('input#all').is(':checked')) {
        return "all";
    }
    var checked = "";
    $('input[name=filter]').each(function(index, element){
        if (element.checked) {
            checked += element.value + ",";
        }
    });

    return checked;
}

// handler for selection change
function filterChange() {
    // set state of 'select all' box
    var all = true;
    $('input[name=filter]').each(function(index, element){
        if (!element.checked) {
            all = false;
        }
    });
    if ($('input#all').is(':checked') && !all) {
        $('input#all').attr('checked', false);
    } else if (!$('input#all').is(':checked') && all) {
        $('input#all').attr('checked', true);
    }

    // reload features based on new filter selections
    reloadData();
}
/* END filter checkboxes */

