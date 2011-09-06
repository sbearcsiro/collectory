/*------------------------- RECORD BREAKDOWN CHARTS ------------------------------*/

// the server base url
var baseUrl;
var biocacheUrl = "http://biocache.ala.org.au/";  // should be overridden from config by the calling page

var taxaChartOptions = {
    width: 400,
    height: 400,
    chartArea: {left:0, top:30, width:"90%", height: "75%"},
    is3D: false,
    titleTextStyle: {color: "#555", fontName: 'Arial', fontSize: 15},
    sliceVisibilityThreshold: 0,
    legend: "left"
};

var genericChartOptions = {
    width: 500,
    height: 350,
    chartArea: {left:0, top:30, width:"100%", height: "70%"},
    is3D: true,
    titleTextStyle: {color: "#555", fontName: 'Arial', fontSize: 15},
    sliceVisibilityThreshold: 0,
    legend: "right"
};
/*
*//********************************************************************************\
* Ajax request for charts based on the facets available in the biocache breakdown.
\********************************************************************************//*
function loadFacetCharts(chartOptions) {
    if (chartOptions.serverUrl != undefined) { baseUrl = chartOptions.serverUrl; }
    if (chartOptions.biocacheUrl != undefined) { biocacheUrl = chartOptions.biocacheUrl; }
    var url = baseUrl + "/public/biocacheRecords.json?uid=" + chartOptions.instanceUid;
    $.getJSON(url, function(data) {
        loadGenericFacetsCharts(data, chartOptions);
    });
}
*//*********************************************************************\
* Loads charts based on the facets available in the biocache breakdown.
* - does not require any markup other than div#charts element
\*********************************************************************//*
function loadGenericFacetsCharts(dataTableMap, chartOptions) {
    $.each(chartOptions.charts, function(index, value) {
        if (dataTableMap[value] != undefined) {
            buildGenericFacetChart(value,dataTableMap[value], chartOptions[value]);
        }
    });
}
*//************************************************************\
* Create and show a generic facet chart
\************************************************************//*
function buildGenericFacetChart(name, data, options) {

    // determine chart type
    var chartType = (options && options.chartType) ? options.chartType : 'pie';

    // create the data table
    var dataTable = new google.visualization.DataTable(data,0.6);

    // create the container
    var $container = $("<div id='" + name + "'></div>");
    $('div#charts').append($container);

    // create the chart
    var chart = (chartType == 'column') ?
        new google.visualization.ColumnChart(document.getElementById(name)) :
        new google.visualization.PieChart(document.getElementById(name));

    // resolve the chart options
    var opts = $.extend({}, genericChartOptions);
    opts.title = "By " + dataTable.getColumnLabel(0);
    if (chartType == 'column') {
        opts.chartArea = {left:60, top:30, width:"90%", height: "70%"};
    }
    opts = $.extend(true, opts, options);
    chart.draw(dataTable, opts);

    // setup a click handler
    google.visualization.events.addListener(chart, 'select', function() {
        // find out what they clicked
        var id = dataTable.getValue(chart.getSelection()[0].row,0);

        // get the context uid
        var contextUid = dataTable.getTableProperty('uid');

        document.location = biocacheUrl + "occurrences/search?q=" + buildQueryString(contextUid) +
                "&fq=" + name + ":" + id;
    });
}*/

/*------------------------- DIRECT CALL TO BIOCACHE SERVICES ------------------------------*/
var chartLabels = {
    institution_uid: 'institution',
    assertions: 'data assertion'
}

var labelTransforms = {
    institution_uid: 'lookupInstitutionName'
}

/********************************************************************************\
* Ajax request for charts based on the facets available in the biocache breakdown.
\********************************************************************************/
function loadFacetChartsDirect(chartOptions) {
    if (chartOptions.serverUrl != undefined) { baseUrl = chartOptions.serverUrl; }
    if (chartOptions.biocacheUrl != undefined) { biocacheUrl = chartOptions.biocacheUrl; }
    var chartsDiv = $('div#' + (chartOptions.targetDivId ? chartOptions.targetDivId : 'charts'));
    chartsDiv.append($("<span>Loading charts...</span>"));
    var query = chartOptions.query ? chartOptions.query : buildQueryString(chartOptions.instanceUid);
    $.ajax({
      url: biocacheUrl + "ws/occurrences/search.json?pageSize=0&q=" + query,
      dataType: 'jsonp',
      error: function(jqXHR, textStatus, errorThrown) {
        cleanUp();
      },
      success: function(data) {

          // clear loading message
          chartsDiv.find('span').remove();

          // update total if requested
          if (chartOptions.totalRecordsSelector) {
              $(chartOptions.totalRecordsSelector).html(addCommas(data.totalRecords));
          }

          // transform facet results into map
          var facetMap = {};
          $.each(data.facetResults, function(idx, obj) {
              facetMap[obj.fieldName] = obj.fieldResult;
          });

          // draw the charts
          loadGenericFacetsChartsDirect(query, facetMap, chartOptions, chartsDiv);
      }
    });
}
/*********************************************************************\
* Loads charts based on the facets available in the biocache breakdown.
* - does not require any markup other than div#charts element
\*********************************************************************/
function loadGenericFacetsChartsDirect(query, facetMap, chartOptions, chartsDiv) {
    $.each(chartOptions.charts, function(index, name) {
        if (facetMap[name] != undefined) {
            buildGenericFacetChartDirect(name,facetMap[name], chartOptions[name], query, chartsDiv, chartOptions);
        }
    });
}
/************************************************************\
* Create and show a generic facet chart
\************************************************************/
function buildGenericFacetChartDirect(name, data, options, query, chartsDiv, chartOptions) {

    // determine chart type
    var chartType = (options && options.chartType) ? options.chartType : 'pie';

    // create the data table
    var dataTable = new google.visualization.DataTable();
    dataTable.addColumn('string', chartLabels[name] ? chartLabels[name] : name);
    dataTable.addColumn('number','records');
    $.each(data, function(i,obj) {
        // filter any crap
        if (options == undefined || options.ignore == undefined || $.inArray(obj.label, options.ignore) == -1) {
            dataTable.addRow([obj.label, obj.count]);
        }
    });

    // create the container
    var $container = $("<div id='" + name + "'></div>");
    chartsDiv.append($container);

    // create the chart
    var chart = (chartType == 'column') ?
        new google.visualization.ColumnChart(document.getElementById(name)) :
        new google.visualization.PieChart(document.getElementById(name));

    // resolve the chart options
    var opts = $.extend({}, genericChartOptions);
    opts.title = "By " + dataTable.getColumnLabel(0);
    if (chartType == 'column') {
        opts.chartArea = {left:60, top:30, width:"90%", height: "70%"};
    }
    opts = $.extend(true, opts, options);
    chart.draw(dataTable, opts);

    // kick off post-draw asynch actions
    if (labelTransforms[name]) {
        window[labelTransforms[name]](chart, dataTable, opts);
    }

    // setup a click handler - if requested
    if (chartOptions.clickThru) {
        google.visualization.events.addListener(chart, 'select', function() {
            // find out what they clicked
            var uid = dataTable.getProperty(chart.getSelection()[0].row,0,'uid');
            var id = uid ? uid: dataTable.getValue(chart.getSelection()[0].row,0);

            document.location = biocacheUrl + "occurrences/search?q=" + query +
                    "&fq=" + name + ":" + id;
        });
    }
}

/*--------------------- LABEL TRANSFORMATION METHODS ----------------------*/
var institutionNameCache;
function lookupInstitutionName(chart, table, opts) {
    $.ajax({
      url: baseUrl + "/ws/institution",
      dataType: 'jsonp',
      success: function(data) {
          var map = {};
          $.each(data, function(i, obj) {
              map[obj.uid] = obj.name;
          });
          for (var i = 0; i < table.getNumberOfRows(); i++) {
              var uid = table.getValue(i,0);
              table.setValue(i, 0, map[uid]);
              table.setProperty(i, 0, 'uid', uid);
          }
          chart.draw(table, opts);
      }
    });
}

/*------------------------- UTILITIES ------------------------------*/
function fieldNameForSearch(uid) {
    switch (uid.substr(0,2)) {
        case 'co': return 'collection_uid';
        case 'in': return 'institution_uid';
        case 'dr': return 'data_resource_uid';
        case 'dp': return 'data_provider_uid';
        case 'dh': return 'data_hub_uid';
        default: return ""
    }
}

