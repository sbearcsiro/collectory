/*------------------------- RECORD BREAKDOWN CHARTS ------------------------------*/

// the server base url
var collectionsUrl = "http://collections.ala.org.au";  // should be overridden from config by the calling page
var biocacheUrl = "http://biocache.ala.org.au/";  // should be overridden from config by the calling page

// defaults for taxa chart
var taxonomyPieChartOptions = {
    width: 480,
    height: 350,
    chartArea: {left:0, top:30, width:"100%", height: "70%"},
    is3D: true,
    titleTextStyle: {color: "#555", fontName: 'Arial', fontSize: 15},
    sliceVisibilityThreshold: 0,
    legend: "right"
};

// defaults for facet charts
var genericChartOptions = {
    width: 480,
    height: 350,
    chartArea: {left:0, top:30, width:"100%", height: "70%"},
    is3D: true,
    titleTextStyle: {color: "#555", fontName: 'Arial', fontSize: 15},
    sliceVisibilityThreshold: 0,
    legend: "right"
};

/*----------------- FACET-BASED CHARTS USING DIRECT CALLS TO BIO-CACHE SERVICES ---------------------*/
// these override the facet names in chart titles
var chartLabels = {
    institution_uid: 'institution',
    data_resource_uid: 'data set',
    assertions: 'data assertion',
    biogeographic_region: 'biogeographic region',
    occurrence_year: 'decade'
}
// asynchronous transforms are applied after the chart is drawn, ie the chart is drawn with the original values
// then redrawn when the ajax call for transform data returns
var asyncTransforms = {
    institution_uid: {method: 'lookupEntityName', param: 'institution'},
    data_resource_uid: {method: 'lookupEntityName', param: 'dataResource'}
}
// synchronous transforms are applied to the json data before the data table is built
var syncTransforms = {
    occurrence_year: {method: 'transformDecadeData'}
}

/********************************************************************************\
* Ajax request for charts based on the facets available in the biocache breakdown.
\********************************************************************************/
function loadFacetCharts(chartOptions) {
    if (chartOptions.collectionsUrl != undefined) { collectionsUrl = chartOptions.collectionsUrl; }
    if (chartOptions.biocacheUrl != undefined) { biocacheUrl = chartOptions.biocacheUrl; }

    var chartsDiv = $('#' + (chartOptions.targetDivId ? chartOptions.targetDivId : 'charts'));
    chartsDiv.append($("<span>Loading charts...</span>"));
    var query = chartOptions.query ? chartOptions.query : buildQueryString(chartOptions.instanceUid);
    $.ajax({
      url: biocacheUrl + "ws/occurrences/search.json?pageSize=0&q=" + query,
      dataType: 'jsonp',
      error: function() {
        cleanUp();
      },
      success: function(data) {

          // clear loading message
          chartsDiv.find('span').remove();

          // draw all charts
          drawFacetCharts(data, chartOptions);

      }
    });
}
function cleanUp() {
    $('img.loading').remove();
}
/*********************************************************************\
* Loads charts based on the facets declared in the config object.
* - does not require any markup other than div#charts element
\*********************************************************************/
function drawFacetCharts(data, chartOptions) {
    // check that we have results
    if (data.length == 0 || data.totalRecords == undefined || data.totalRecords == 0) {
        return;
    }

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
    var chartsDiv = $('#' + (chartOptions.targetDivId ? chartOptions.targetDivId : 'charts'));
    var query = chartOptions.query ? chartOptions.query : buildQueryString(chartOptions.instanceUid);
    $.each(chartOptions.charts, function(index, name) {
        if (facetMap[name] != undefined) {
            buildGenericFacetChart(name,facetMap[name], chartOptions[name], query, chartsDiv, chartOptions);
        }
    });
}
/************************************************************\
* Create and show a generic facet chart
\************************************************************/
function buildGenericFacetChart(name, data, options, query, chartsDiv, chartOptions) {

    // determine chart type
    var chartType = (options && options.chartType) ? options.chartType : 'pie';

    // optionally transform the data
    var xformedData = data;
    if (syncTransforms[name]) {
        xformedData = window[syncTransforms[name].method](data);
    }

    // create the data table
    var dataTable = new google.visualization.DataTable();
    dataTable.addColumn('string', chartLabels[name] ? chartLabels[name] : name);
    dataTable.addColumn('number','records');
    $.each(xformedData, function(i,obj) {
        // filter any crap
        if (options == undefined || options.ignore == undefined || $.inArray(obj.label, options.ignore) == -1) {
            dataTable.addRow([obj.label, obj.count]);
        }
    });

    // reject the chart if there is only one facet value (after filtering)
    if (dataTable.getNumberOfRows() < 2) {
        return;
    }

    // create the container
    var $container = $('#' + name);
    if ($container.length == 0) {
        $container = $("<div id='" + name + "'></div>");
        chartsDiv.append($container);
    }

    // specify the type (for css tweaking)
    $container.addClass(chartType == 'column' ? 'column' : 'pie');
            
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
    if (asyncTransforms[name]) {
        window[asyncTransforms[name].method](chart, dataTable, opts, asyncTransforms[name].param);
    }

    // setup a click handler - if requested
    if (chartOptions.clickThru != false) {  // defaults to true
        google.visualization.events.addListener(chart, 'select', function() {

            // default facet value is the name selected
            var id = dataTable.getValue(chart.getSelection()[0].row,0);

            // this is overridden if the uid property has been set
            var uid = dataTable.getProperty(chart.getSelection()[0].row,0,'uid');
            if (uid) { id = uid; }

            // build the facet query
            var facetQuery = name + ":" + id;

            // the whole facet query can be overridden for date ranges
            if (name == 'occurrence_year') {
                if (id.startsWith('before')) {
                    facetQuery = "occurrence_year:[*%20TO%20" + "1850" + "-01-01T12:00:00Z]";
                }
                else {
                    var decade = id.substr(0,4);
                    var dateTo = parseInt(decade) + 10;
                    facetQuery = "occurrence_year:[" + decade + "-01-01T12:00:00Z%20TO%20" + dateTo + "-01-01T12:00:00Z]";
                }
            }

            // show the records
            document.location = biocacheUrl + "occurrences/search?q=" + query +
                    "&fq=" + facetQuery;
        });
    }
}

/*---------------------- DATA TRANSFORMATION METHODS ----------------------*/
function transformDecadeData(data) {
    var firstDecade;
    var transformedData = [];
    $.each(data, function(i,obj) {
        if (obj.label == 'before') {
            transformedData.splice(0,0,{label: "before " + firstDecade, count: obj.count});
        }
        else {
            var decade = obj.label.substr(0,4);
            if (i == 0) { firstDecade = decade; }
            transformedData.push({label: decade + "s", count: obj.count});
        }
    });
    return transformedData;
}
/*--------------------- LABEL TRANSFORMATION METHODS ----------------------*/
function lookupEntityName(chart, table, opts, entity) {
    var uidList = [];
    for (var i = 0; j = table.getNumberOfRows(), i < j; i++) {
        uidList.push(table.getValue(i,0));
    }
    $.jsonp({
      url: collectionsUrl + "/ws/resolveNames/" + uidList.join(',') + "?callback=?",
      cache: true,
      success: function(data) {
          for (var i = 0;j + table.getNumberOfRows(), i < j; i++) {
              var uid = table.getValue(i,0);
              table.setValue(i, 0, data[uid]);
              table.setProperty(i, 0, 'uid', uid);
          }
          chart.draw(table, opts);
      },
      error: function(d,msg) {
          alert(msg);
      }
    });
}
/*----------- TAXONOMY BREAKDOWN CHARTS USING DIRECT CALLS TO BIO-CACHE SERVICES ------------*/
// currently only available for uid-based queries

/********************************************************************************\
* Ajax request for initial taxonomic breakdown.
\********************************************************************************/
function loadTaxonomyChart(chartOptions) {
    if (chartOptions.collectionsUrl != undefined) { collectionsUrl = chartOptions.collectionsUrl; }
    if (chartOptions.biocacheUrl != undefined) { biocacheUrl = chartOptions.biocacheUrl; }
    var uid = chartOptions.instanceUid;
    var url = biocacheUrl + "ws/breakdown/" + wsEntityForBreakdown(uid) + "/" + uid + ".json?";

    // add url params to set state
    if (chartOptions.rank) {
        url += "rank=" + chartOptions.rank + (chartOptions.name ? "&name=" + chartOptions.name: "");
    }
    else {
        url += "max=" + (chartOptions.threshold ? chartOptions.threshold : '55');
    }

    $.ajax({
      url: url,
      dataType: 'jsonp',
      timeout: 20000,
      complete: function(jqXHR, textStatus) {
          if (textStatus == 'timeout') {
              alert('Sorry - the request was taking too long so it has been cancelled.');
          }
          if (textStatus == 'error') {
              alert('Sorry - the chart cannot be redrawn due to an error.');
          }
          cleanUp();
      },
      success: function(data) {
          // check for errors
          if (data.length == 0) {
              cleanUp();
          }
          else {
              // draw the chart
              drawTaxonomyChart(data, chartOptions);
          }
      }
    });
}

/************************************************************\
* Create and show the taxonomy chart.
\************************************************************/
function drawTaxonomyChart(data, chartOptions) {

    // create the data table
    var dataTable = new google.visualization.DataTable();
    dataTable.addColumn('string', chartLabels[name] ? chartLabels[name] : name);
    dataTable.addColumn('number','records');
    $.each(data.taxa, function(i,obj) {
        dataTable.addRow([obj.label, obj.count]);
    });

    // resolve the chart options
    var opts = $.extend({}, taxonomyPieChartOptions);
    opts = $.extend(true, opts, chartOptions);
    opts.title = opts.name ? opts.name + " records by " + data.rank : "By " + data.rank;

    // create the outer div that will contain the chart and the additional links
    var $outerContainer = $('#taxa');
    if ($outerContainer.length == 0) {
        $outerContainer = $('<div id="taxa"></div>'); // create it
        $outerContainer.css('margin-bottom','-50px');
        var chartsDiv = $('div#' + (chartOptions.targetDivId ? chartOptions.targetDivId : 'charts'));
        // append it
        chartsDiv.prepend($outerContainer);
    }

    // create the chart container if not already there
    var $container = $('#taxaChart');
    if ($container.length == 0) {
        $container = $("<div id='taxaChart' class='pie'></div>");
        $outerContainer.append($container);
    }

    // create the chart
    var chart = new google.visualization.PieChart(document.getElementById('taxaChart'));

    // draw the chart
    chart.draw(dataTable, opts);

    // draw the back button / instructions
    var $backLink = $('#backLink');
    if ($backLink.length == 0) {
        $backLink = $('<div class="link" id="backLink">&laquo; Previous rank</div>').appendTo($outerContainer);  // create it
        $backLink.css('position','relative').css('top','-75px');
        $backLink.click(function() {
            // only act if link was real
            if (!$backLink.hasClass('link')) return;

            // show spinner while loading
            $container.append($('<img class="loading" style="position:absolute;left:130px;top:220px;z-index:2000" ' +
                    'alt="loading..." src="' + collectionsUrl + '/images/ala/ajax-loader.gif"/>'));

            // get state from history
            var previous = popHistory(chartOptions);

            // set new chart state
            chartOptions.rank = previous.rank;
            chartOptions.name = previous.name;

            // redraw chart
            loadTaxonomyChart(chartOptions);
        });
    }
    if (chartOptions.history) {
        // show the prev link
        $backLink.html("&laquo; Previous rank").addClass('link');
    }
    else {
        // show the instruction
        $backLink.html("Click a slice to drill into the next taxonomic level.").removeClass('link');
    }

    // draw records link
    var $recordsLink = $('#recordsLink');
    if ($recordsLink.length == 0) {
        $recordsLink = $('<div class="link under" id="recordsLink">View records</div>').appendTo($outerContainer);  // create it
        $recordsLink.css('position','relative').css('top','-75px');
        $recordsLink.click(function() {
            // show occurrence records
            var fq = "";
            if (chartOptions.rank != undefined && chartOptions.name != undefined) {
                fq = "&fq=" + chartOptions.rank + ":" + chartOptions.name;
            }
            document.location = biocacheUrl + "occurrences/search?q=" + buildQueryString(chartOptions.instanceUid) + fq;
        });
    }
    // set link text
    if (chartOptions.history) {
        $recordsLink.html('View records for ' + chartOptions.rank + ' ' + chartOptions.name);
    }
    else {
        $recordsLink.html('View all records');
    }

    // setup a click handler - if requested
    var clickThru = chartOptions.clickThru == undefined ? true : chartOptions.clickThru;  // default to true
    var drillDown = chartOptions.drillDown == undefined ? true : chartOptions.drillDown;  // default to true
    if (clickThru || drillDown) {
        google.visualization.events.addListener(chart, 'select', function() {

            // find out what they clicked
            var name = dataTable.getValue(chart.getSelection()[0].row,0);
            /* DRILL DOWN */
            if (drillDown && data.rank != "species") {
                // show spinner while loading
                $container.append($('<img class="loading" style="position:absolute;left:130px;top:220px;z-index:2000" ' +
                        'alt="loading..." src="' + collectionsUrl + '/images/ala/ajax-loader.gif"/>'));

                // save current state as history - for back-tracking
                pushHistory(chartOptions);

                // set new chart state
                chartOptions.rank = data.rank;
                chartOptions.name = name;

                // redraw chart
                loadTaxonomyChart(chartOptions);
            }

            /* SHOW RECORDS */
            else {
                // show occurrence records
                document.location = biocacheUrl + "occurrences/search?q=" + buildQueryString(chartOptions.instanceUid) +
                    "&fq=" + data.rank + ":" + name;
            }
        });
    }
}
/************************************************************\
* Add current chart state to its history.
\************************************************************/
function pushHistory(options) {
    if (options.history == undefined) {
        options.history = [];
    }
    options.history.push({rank:options.rank, name:options.name});
}
/************************************************************\
* Pop the previous current chart state from its history.
\************************************************************/
function popHistory(options) {
    if (options.history == undefined) {
        return {};
    }
    var state = options.history.pop();
    if (options.history.length == 0) {
        options.history = null;
    }
    return state;
}

/*------------------------- UTILITIES ------------------------------*/
/************************************************************\
* build records query handling multiple uids
* uidSet can be a comma-separated string or an array
\************************************************************/
function buildQueryString(uidSet) {
    var uids = (typeof uidSet == "string") ? uidSet.split(',') : uidSet;
    var str = "";
    $.each(uids, function(index, value) {
        str += solrFieldNameForUid(value) + ":" + value + " OR ";
    });
    return str.substring(0, str.length - 4);
}
/************************************************************\
* returns the appropriate facet name for the uid - to build
* biocache occurrence searches
\************************************************************/
function solrFieldNameForUid(uid) {
    switch(uid.substring(0,2)) {
        case 'co': return "collection_uid";
        case 'in': return "institution_uid";
        case 'dp': return "data_provider_uid";
        case 'dr': return "data_resource_uid";
        case 'dh': return "data_hub_uid";
        default: return "";
    }
}
/************************************************************\
* returns the appropriate context for the uid - to build
* biocache webservice urls
\************************************************************/
function wsEntityForBreakdown(uid) {
    switch (uid.substr(0,2)) {
        case 'co': return 'collections';
        case 'in': return 'institutions';
        case 'dr': return 'dataResources';
        case 'dp': return 'dataProviders';
        case 'dh': return 'dataHubs';
        default: return "";
    }
}
/************************************************************\
* Add commas to number strings
\************************************************************/
function addCommas(nStr)
{
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}

