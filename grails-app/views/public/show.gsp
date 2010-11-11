<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; java.text.DecimalFormat; au.org.ala.collectory.Collection; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <title><cl:pageTitle>${fieldValue(bean: collectionInstance, field: "name")}</cl:pageTitle></title>
        <g:javascript src="jquery.fancybox/fancybox/jquery.fancybox-1.3.1.pack.js" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'js/jquery.fancybox/fancybox',file:'jquery.fancybox-1.3.1.css')}" media="screen" />
        <script type="text/javascript">
          $(document).ready(function() {
            $('#nav-tabs > ul').tabs();
            greyInitialValues();
            $("a#lsid").fancybox({
                    'hideOnContentClick' : false,
                    'titleShow' : false,
                    'autoDimensions' : false,
                    'width' : 600,
                    'height' : 180
            });
            $("a.current").fancybox({
                    'hideOnContentClick' : false,
                    'titleShow' : false,
                        'titlePosition' : 'inside',
                    'autoDimensions' : true,
                    'width' : 300
            });
          });
        </script>
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
    </head>
    <body class="two-column-right">
      <div id="content">
        <div id="header" class="collectory">
          <!--Breadcrumbs-->
          <div id="breadcrumb"><cl:breadcrumbTrail/>
            <cl:pageOptionsLink>${fieldValue(bean:collectionInstance,field:'name')}</cl:pageOptionsLink>
          </div>
          <cl:pageOptionsPopup instance="${collectionInstance}"/>
          <div class="section full-width">
            <div class="hrgroup col-8">
              <cl:h1 value="${collectionInstance.name}"/>
              <g:set var="inst" value="${collectionInstance.getInstitution()}"/>
              <g:if test="${inst}">
                <h2><g:link action="show" id="${inst.uid}">${inst.name}</g:link></h2>
              </g:if>
              <cl:valueOrOtherwise value="${collectionInstance.acronym}"><span class="acronym">Acronym: ${fieldValue(bean: collectionInstance, field: "acronym")}</span></cl:valueOrOtherwise>
              <span class="lsid"><a href="#lsidText" id="lsid" class="local" title="Life Science Identifier (pop-up)">LSID</a></span>
              <div style="display:none; text-align: left;">
                  <div id="lsidText" style="text-align: left;">
                      <b><a class="external_icon" href="http://lsids.sourceforge.net/" target="_blank">Life Science Identifier (LSID):</a></b>
                      <p style="margin: 10px 0;"><cl:guid target="_blank" guid='${fieldValue(bean: collectionInstance, field: "guid")}'/></p>
                      <p style="font-size: 12px;">LSIDs are persistent, location-independent,resource identifiers for uniquely naming biologically
                           significant resources including species names, concepts, occurrences, genes or proteins,
                           or data objects that encode information about them. To put it simply,
                          LSIDs are a way to identify and locate pieces of biological information on the web. </p>
                  </div>
              </div>
            </div>
            <div class="aside col-4 center">
              <!-- institution logo -->
              <g:if test="${inst?.logoRef?.file}">
                <g:link action="showInstitution" id="${inst.id}">
                  <img class="institutionImage" src='${resource(absolute:"true", dir:"data/institution/",file:fieldValue(bean: inst, field: 'logoRef.file'))}' />
                </g:link>
                  <!--div style="clear: both;"></div-->
              </g:if>
            </div>
          </div>
          <div id="nav-tabs">
            <ul class="ui-tabs-nav">
                <li class="ui-tabs-selected"><a href="#overview">Overview</a></li>
                <li><a href="#statistics">Records & Statistics</a></li>
            </ul>
          </div>
        </div><!--close header-->
        <div id="overview" class="ui-tabs-panel">
          <div id="column-one">
            <div class="section">
              <h2>Description</h2>
              <cl:formattedText>${fieldValue(bean: collectionInstance, field: "pubDescription")}</cl:formattedText>
              <cl:formattedText>${fieldValue(bean: collectionInstance, field: "techDescription")}</cl:formattedText>
              <cl:temporalSpan start='${fieldValue(bean: collectionInstance, field: "startDate")}' end='${fieldValue(bean: collectionInstance, field: "endDate")}'/>

              <h2>Taxonomic range</h2>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'focus')}">
                <cl:formattedText>${fieldValue(bean: collectionInstance, field: "focus")}</cl:formattedText>
              </g:if>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'kingdomCoverage')}">
                <p>Kingdoms covered include: <cl:concatenateStrings values='${fieldValue(bean: collectionInstance, field: "kingdomCoverage")}'/>.</p>
              </g:if>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'scientificNames')}">
                <p>Specimens in the ${collectionInstance.name} include members from the following taxa:<br/>
                <cl:JSONListAsStrings json='${fieldValue(bean: collectionInstance, field: "scientificNames")}'/>.</p>
              </g:if>

              <g:if test="${collectionInstance?.geographicDescription || collectionInstance.states}">
                <h2>Geographic range</h2>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'geographicDescription')}">
                  <p>${fieldValue(bean: collectionInstance, field: "geographicDescription")}</p>
                </g:if>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'states')}">
                  <p><cl:stateCoverage states='${fieldValue(bean: collectionInstance, field: "states")}'/></p>
                </g:if>
                <g:if test="${collectionInstance.westCoordinate != -1}">
                  <p>The western most extent of the collection is: <cl:showDecimal value='${collectionInstance.westCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.eastCoordinate != -1}">
                  <p>The eastern most extent of the collection is: <cl:showDecimal value='${collectionInstance.eastCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.northCoordinate != -1}">
                  <p>The northtern most extent of the collection is: <cl:showDecimal value='${collectionInstance.northCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.southCoordinate != -1}">
                  <p>The southern most extent of the collection is: <cl:showDecimal value='${collectionInstance.southCoordinate}' degree='true'/></p>
                </g:if>
              </g:if>

              <h2>Number of specimens in the collection</h2>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'numRecords') != '-1'}">
                <p>The estimated number of specimens within <cl:collectionName prefix="the " name="${collectionInstance.name}"/> is ${fieldValue(bean: collectionInstance, field: "numRecords")}.</p>
              </g:if>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'numRecordsDigitised') != '-1'}">
                <p>Of these ${fieldValue(bean: collectionInstance, field: "numRecordsDigitised")} are databased.
                This represents <cl:percentIfKnown dividend='${collectionInstance.numRecordsDigitised}' divisor='${collectionInstance.numRecords}' /> of the collection.</p>
              </g:if>
              <p>Click the Records & Statistics tab to access those database records that are available through the atlas.</p>

              <g:if test="${collectionInstance.listSubCollections()?.size() > 0}">
                <h2>Sub-collections</h2>
                <p><cl:collectionName prefix="The " name="${collectionInstance.name}"/> contains these significant collections:</p>
                <cl:subCollectionList list="${collectionInstance.subCollections}"/>
              </g:if>

              <cl:lastUpdated date="${collectionInstance.lastUpdated}"/>
            </div><!--close section-->
          </div><!--close column-one-->

          <div id="column-two">
            <div class="section sidebar">
              <g:if test="${fieldValue(bean: collectionInstance, field: 'imageRef') && fieldValue(bean: collectionInstance, field: 'imageRef.file')}">
                <div class="section">
                  <img style="max-width:100%;max-height:350px;" alt="${fieldValue(bean: collectionInstance, field: "imageRef.file")}"
                          src="${resource(absolute:"true", dir:"data/collection/", file:collectionInstance.imageRef.file)}" />
                  <cl:formattedText pClass="caption">${fieldValue(bean: collectionInstance, field: "imageRef.caption")}</cl:formattedText>
                  <cl:valueOrOtherwise value="${collectionInstance.imageRef?.attribution}"><p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
                  <cl:valueOrOtherwise value="${collectionInstance.imageRef?.copyright}"><p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
                </div>
              </g:if>

              <div class="section">
                <h3>Location</h3>
                <!-- use parent location if the collection is blank -->
                <g:set var="address" value="${collectionInstance.address}"/>
                <g:if test="${address == null || address.isEmpty()}">
                  <g:if test="${collectionInstance.getInstitution()}">
                    <g:set var="address" value="${collectionInstance.getInstitution().address}"/>
                  </g:if>
                </g:if>

                <g:if test="${!address?.isEmpty()}">
                  <p>
                    <cl:valueOrOtherwise value="${address?.street}">${address?.street}<br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.city}">${address?.city}<br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.state}">${address?.state}</cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.postcode}">${address?.postcode}<br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.country}">${address?.country}<br/></cl:valueOrOtherwise>
                  </p>
                </g:if>

                <g:if test="${collectionInstance.email}"><cl:emailLink>${fieldValue(bean: collectionInstance, field: "email")}</cl:emailLink><br/></g:if>
                <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "phone")}'/>
              </div>

              <!-- contacts -->
              <g:set var="contacts" value="${collectionInstance.getContactsPrimaryFirst()}"/>
              <g:if test="${contacts.size() > 0}">
                <div class="section">
                  <h3>Contact</h3>
                  <g:each in="${contacts}" var="cf">
                    <div class="contact">
                      <p class="contactName">${cf?.contact?.buildName()}</p>
                      <p>${cf?.role}</p>
                      <cl:ifNotBlank prefix="phone: " value='${fieldValue(bean: cf, field: "contact.phone")}'/>
                      <cl:ifNotBlank prefix="fax: " value='${fieldValue(bean: cf, field: "contact.fax")}'/>
                      <p>email: <cl:emailLink>${cf?.contact?.email}</cl:emailLink></p>
                    </div>
                  </g:each>
                </div>
              </g:if>

              <!-- web site -->
              <g:if test="${collectionInstance.websiteUrl || collectionInstance.institution?.websiteUrl}">
                <div class="section">
                  <h3>Web site</h3>
                  <g:if test="${collectionInstance.websiteUrl}">
                    <div class="webSite">
                      <a class='external' target="_blank" href="${collectionInstance.websiteUrl}">Visit the collection's website</a>
                    </div>
                  </g:if>
                  <g:if test="${collectionInstance.institution?.websiteUrl}">
                    <div class="webSite">
                      <a class='external' target="_blank" href="${collectionInstance.institution?.websiteUrl}">
                        Visit the <cl:institutionType inst="${collectionInstance.institution}"/>'s website</a>
                    </div>
                  </g:if>
                </div>
              </g:if>

              <!-- network membership -->
              <g:if test="${collectionInstance.networkMembership}">
                <div class="section">
                  <h3>Membership</h3>
                  <g:if test="${collectionInstance.isMemberOf('CHAEC')}">
                    <p>Council of Heads of Australian Entomological Collections</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chaec-logo.png")}"/>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('CHAH')}">
                    <p>Council of Heads of Australasian Herbaria</p>
                    <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('CHAFC')}">
                    <p>Council of Heads of Australian Faunal Collections</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"CHAFC_sm.jpg")}"/>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('CHACM')}">
                    <p>Council of Heads of Australian Collections of Microorganisms</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chacm.png")}"/>
                  </g:if>
                </div>
              </g:if>

              <!-- attribution -->
              <g:set var='attribs' value='${collectionInstance.getAttributionList()}'/>
              <g:if test="${attribs.size() > 0}">
                <div class="section" id="infoSourceList">
                  <h4>Contributors to this page</h4>
                  <ul>
                    <g:each var="a" in="${attribs}">
                      <g:if test="${a.url}">
                        <li><cl:wrappedLink href="${a.url}">${a.name}</cl:wrappedLink></li>
                      </g:if>
                      <g:else>
                        <li>${a.name}</li>
                      </g:else>
                    </g:each>
                  </ul>
                </div>
              </g:if>
            </div>
          </div>
          </div><!--overview-->
          <div id="statistics" class="ui-tabs-panel ui-tabs-hide">
            <div class="section">
              <h2>Digitised records available through the Atlas</h2>
              <div style="float:left;">
                <g:if test="${collectionInstance.numRecords != -1}">
                  <p><cl:collectionName prefix="The " name="${collectionInstance.name}"/> has an estimated ${fieldValue(bean: collectionInstance, field: "numRecords")} specimens.
                    <g:if test="${collectionInstance.numRecordsDigitised != -1}">
                      <br/>The collection has databased <cl:percentIfKnown dividend='${collectionInstance.numRecordsDigitised}' divisor='${collectionInstance.numRecords}'/> of these (${fieldValue(bean: collectionInstance, field: "numRecordsDigitised")} records).
                    </g:if>
                  </p>
                </g:if>
                <g:if test="${biocacheRecordsAvailable}">
                  <p><span id="numBiocacheRecords">Looking up... the number of records that</span> can be accessed through the Atlas of Living Australia.</p>
                  <cl:warnIfInexactMapping collection="${collectionInstance}"/>
                  <cl:recordsLink collection="${collectionInstance}">
                    <img src="${resource(dir:"images/ala/",file:"database_go.png")}"/>
                    Click to view all records for the <cl:collectionName name="${collectionInstance.name}"/></cl:recordsLink>
                </g:if>
                <g:else>
                  <p>No database records for this collection can be accessed through the Atlas of Living Australia.</p>
                </g:else>
              </div>
              <div id="speedo">
                <div id="progress">
                  <img id="progressBar" src="${resource(dir:'images', file:'percentImage.png')}" alt="0%"
                          class="no-radius percentImage1" style='background-position: -120px 0;'/>
                  <!--cl:progressBar percent="0.0"/-->
                </div>
                <p class="caption"><span id="speedoCaption">No records are available for viewing in the Atlas.</span></p>
              </div>
            </div>
            <div class="section">
              <g:if test="${biocacheRecordsAvailable}">
                <div style="clear:both;"></div>
                <div class="inline">
                  <h3>Map of occurrence records</h3>
                  <cl:recordsMap type="collection" uid="${collectionInstance.uid}"/>
                </div>
                <div id="taxonChart" style="display: inline; width: 500px;">
                  <!-- NOTE *** margin-bottom value must match the value in the javascript (drawTaxonChart - dril down handler) -->
                  <img style="margin-left:230px;margin-top:150px;margin-bottom:218px" alt="loading..." src="${resource(dir:'images/ala',file:'ajax-loader.gif')}"/>
                </div>
                <div id="taxonChartCaption">
                  <span style="visibility:hidden;" class="taxonChartCaption">Click a slice to drill into a group.<br/>Click a legend colour patch<br/>to view records for a group.</span><br/>
                  <span id="resetTaxonChart" onclick="resetTaxonChart()"></span>&nbsp;
                </div>
                <div id="decadeChart">
                  <img style="margin-left:130px;margin-top:-20px;margin-bottom:108px" alt="loading..." src="${resource(dir:'images/ala',file:'decade-loader.gif')}"/>
                </div>
                <div id="decadeChartCaption">
                  <span style="visibility:hidden;" class="decadeChartCaption">Click a column to view records for that decade.</span>
                </div>
              </g:if>
            </div>
          </div>
        </div>
      <script type="text/javascript">
/************************************************************\
*
\************************************************************/
var queryString = '';
var decadeUrl = '';
var initial = -120;
var imageWidth=240;
var eachPercent = (imageWidth/2)/100;

$('img#mapLegend').each(function(i, n) {
  // if legend doesn't load, then it must be a point map
  $(this).error(function() {
    $(this).attr('src',"${resource(dir:'images/map',file:'single-occurrences.png')}");
  });
  // IE hack as IE doesn't trigger the error handler
  if ($.browser.msie && !n.complete) {
    $(this).attr('src',"${resource(dir:'images/map',file:'single-occurrences.png')}");
  }
});
/************************************************************\
* initiate ajax calls
\************************************************************/
function onLoadCallback() {
  // summary biocache data
  var biocacheRecordsUrl = "${ConfigurationHolder.config.grails.context}/public/biocacheRecords.json?uid=${collectionInstance.uid}";
  $.get(biocacheRecordsUrl, {}, biocacheRecordsHandler);

  // taxon breakdown
  var taxonUrl = "${ConfigurationHolder.config.grails.context}/public/taxonBreakdown/${collectionInstance.uid}?threshold=55";
  $.get(taxonUrl, {}, taxonBreakdownRequestHandler);

  // records map
  //var mapServiceUrl = "${ConfigurationHolder.config.spatial.baseURL}/alaspatial/ws/density/map?collectionUid=${collectionInstance.uid}";
  var mapServiceUrl = "${ConfigurationHolder.config.grails.context}/public/recordsMapService?uid=${collectionInstance.uid}";
  $.get(mapServiceUrl, {}, mapRequestHandler);
}
/************************************************************\
* Handle biocache records response
\************************************************************/
function biocacheRecordsHandler(response) {
  if (response.error == undefined) {
    setNumbers(response.totalRecords, ${collectionInstance.numRecords});
    if (response.totalRecords < 1) {
      noBiocacheData();
    }
    drawDecadeChart(response.decades);
  } else {
    noBiocacheData();
  }
}
/************************************************************\
* Set biocache record numbers to none and hide link and chart
\************************************************************/
function noBiocacheData() {
  setNumbers(0);
  $('a.recordsLink').css('visibility','hidden');
  $('div#decadeChart').css("display","none");
}
/************************************************************\
* Set total and percent biocache record numbers
\************************************************************/
function setNumbers(totalBiocacheRecords, totalRecords) {
  var recordsClause = "";
  switch (totalBiocacheRecords) {
    case 0: recordsClause = "No records"; break;
    case 1: recordsClause = "1 record"; break;
    default: recordsClause = addCommas(totalBiocacheRecords) + " records";
  }
  $('#numBiocacheRecords').html(recordsClause);

  if (totalRecords > 0) {
    var percent = totalBiocacheRecords/totalRecords * 100;
    setProgress(percent);
  } else {
    // to update the speedo caption
    setProgress(0);
  }
}
/************************************************************\
* Add commas to number display
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
/************************************************************\
* Handle map response
\************************************************************/
function mapRequestHandler(response) {
  if (response.error != undefined) {
    // set map url
    $('#recordsMap').attr("src","${resource(dir:'images/map',file:'mapaus1_white-340.png')}");
    // set legend url
    $('#mapLegend').attr("src","${resource(dir:'images/map',file:'mapping-data-not-available.png')}");
  }
  // set map url
  $('#recordsMap').attr("src",response.mapUrl);
  // set legend url
  $('#mapLegend').attr("src",response.legendUrl);
}
/************************************************************\
* DEPRECATED
\************************************************************/
function decadeBreakdownRequestHandler(response) {
  var data = new google.visualization.DataTable(response);
  if (data.getNumberOfRows() > 0) {
    draw(data);
  }
}
/************************************************************\
* Handle taxon breakdown response
\************************************************************/
function taxonBreakdownRequestHandler(response) {
  if (response.error == undefined) {
    var data = new google.visualization.DataTable(response);
    if (data.getNumberOfRows() > 0) {
      drawTaxonChart(data);
    } else {
      clearTaxonChart();
    }
  } else {
    clearTaxonChart(response.error);
  }
}
/************************************************************\
* No chart available
\************************************************************/
function clearTaxonChart(error) {
  $('div#taxonChart img').attr('src',"${resource(dir:'images/ala',file:'missing.png')}");
}
/************************************************************\
* Decade breakdown chart
\************************************************************/
function drawDecadeChart(decadeData) {
  var dataTable = new google.visualization.DataTable(decadeData,0.6);
  if (dataTable.getNumberOfRows() > 0) {
    var vis = new google.visualization.ColumnChart(document.getElementById('decadeChart'));
    google.visualization.events.addListener(vis, 'select', function() {
      var decade = dataTable.getValue(vis.getSelection()[0].row,0);
      // TODO: handle 'earlier' label
      if (decade != 'earlier' && decade.length > 3) {
        decade = decade.substr(0,4);
        var dateTo = addDecade(decade);
        var dateRange = "occurrence_date:[" + decade + "-01-01T12:00:00Z%20TO%20" + dateTo + "-01-01T12:00:00Z]";
        // eg. occurrence_date:[1990-01-01T12:00:00Z%20TO%202000-01-01T12:00:00Z]
        document.location.href = "${ConfigurationHolder.config.biocache.baseURL}occurrences/searchForUID?q=${collectionInstance.uid}&fq=" + dateRange;
      }
    });
    vis.draw(dataTable, {
      width: 600,
      height: 300,
      chartArea:  {left: 50},
      title: "Additions by decade",
      titleTextStyle: {color: "#555", fontName: 'Arial', fontSize: 15},
      legend: 'none'
    });
    // show caption
    $('span.decadeChartCaption').css('visibility', 'visible');
  } else {
    // no data
    $('div#decadeChart').css("display","none");
  }
}
/************************************************************\
* increment year by a decade, eg 1990 -> 2000
\************************************************************/
function addDecade(from) {
  var num = parseInt(from);
  return num + 10;
}
/************************************************************\
* Taxonomic breakdown chart
\************************************************************/
function drawTaxonChart(dataTable) {
  var chart = new google.visualization.PieChart(document.getElementById('taxonChart'));
  var options = {};

  options.width = 510;
  options.height = 460;
  options.is3D = false;
  if (dataTable.getTableProperty('scope') == "all") {
    options.title = "Number of records by " + dataTable.getTableProperty('rank');
  } else {
    options.title = dataTable.getTableProperty('name') + " records by " + dataTable.getTableProperty('rank')
  }
  options.titleTextStyle = {color: "#555", fontName: 'Arial', fontSize: 15};
  options.sliceVisibilityThreshold = 0;
  //options.pieSliceText = "label";
  options.legend = "left";
  google.visualization.events.addListener(chart, 'select', function() {
    var name = dataTable.getValue(chart.getSelection()[0].row,0);
    var rank = dataTable.getTableProperty('rank')
    // differentiate between clicks on legend versus slices
    if (chart.getSelection()[0].column == undefined) {
      // clicked legend - show records
      var scope = dataTable.getTableProperty('scope');
      if (scope == "genus" && rank == "species") {
        name = dataTable.getTableProperty('name') + " " + name;
      }
      var linkUrl = "${ConfigurationHolder.config.biocache.baseURL}occurrences/searchForUID?q=${collectionInstance.uid}&fq=" +
        rank + ":" + name;
      document.location.href = linkUrl;
    } else {
      // clicked slice - drill down unless already at species
      if (rank != "species") {
        // NOTE *** margin-bottom value must match the value in the source html
        $('div#taxonChart').html('<img style="margin-left:230px;margin-top:150px;margin-bottom:218px;" alt="loading..." src="${resource(dir:'images/ala',file:'ajax-loader.gif')}"/>');
        var drillUrl = "${ConfigurationHolder.config.grails.context}/public/rankBreakdown/${collectionInstance.uid}?name=" +
                dataTable.getValue(chart.getSelection()[0].row,0) +
               "&rank=" + dataTable.getTableProperty('rank')
        $.get(drillUrl, {}, taxonBreakdownRequestHandler);
      }
      if ($('span#resetTaxonChart').html() == "") {
        $('span#resetTaxonChart').html("reset to " + dataTable.getTableProperty('rank'));
      }
    }
  });

  chart.draw(dataTable, options);

  // show taxon caption
  $('span.taxonChartCaption').css('visibility', 'visible');
}
/************************************************************\
* Put back in orginal state
\************************************************************/
function resetTaxonChart() {
  taxonUrl = "${ConfigurationHolder.config.grails.context}/public/taxonBreakdown/${collectionInstance.uid}?threshold=55";
  $.get(taxonUrl, {}, taxonBreakdownRequestHandler);
  $('span#resetTaxonChart').html("");
}
/************************************************************\
* Draw % digitised bar (progress bar)
\************************************************************/
function setProgress(percentage)
{
  var captionText = "";
  if (${collectionInstance.numRecords < 1}) {
    captionText = "There is no estimate of the total number<br/>of specimens in this collection.";
  } else if (percentage == 0) {
    captionText = "No records are available for viewing in the Atlas.";
  } else {
    var displayPercent = percentage.toFixed(1);
    if (percentage < 0.1) {displayPercent = percentage.toFixed(2)}
    if (percentage > 20) {displayPercent = percentage.toFixed(0)}
    if (percentage > 100) {displayPercent = "over 100"}
    captionText = "Records for " + displayPercent + "% of specimens are<br/>available for viewing in the Atlas.";
  }
  $('#speedoCaption').html(captionText);

  if (percentage > 100) {
    $('#progressBar').removeClass('percentImage1');
    $('#progressBar').addClass('percentImage4');
    percentage = 101;
  }
  var percentageWidth = eachPercent * percentage;
  var newProgress = eval(initial)+eval(percentageWidth)+'px';
  $('#progressBar').css('backgroundPosition',newProgress+' 0');
}
/************************************************************\
* Load charts
\************************************************************/

        google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(onLoadCallback);

      </script>
    </body>
</html>
