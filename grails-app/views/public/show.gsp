<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; java.text.DecimalFormat; au.org.ala.collectory.Collection; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <title><cl:pageTitle>${fieldValue(bean: instance, field: "name")}</cl:pageTitle></title>
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
            <cl:pageOptionsLink>${fieldValue(bean:instance,field:'name')}</cl:pageOptionsLink>
          </div>
          <cl:pageOptionsPopup instance="${instance}"/>
          <div class="section full-width">
            <div class="hrgroup col-8">
              <cl:h1 value="${instance.name}"/>
              <g:set var="inst" value="${instance.getInstitution()}"/>
              <g:if test="${inst}">
                <h2><g:link action="show" id="${inst.uid}">${inst.name}</g:link></h2>
              </g:if>
              <cl:valueOrOtherwise value="${instance.acronym}"><span class="acronym">Acronym: ${fieldValue(bean: instance, field: "acronym")}</span></cl:valueOrOtherwise>
              <span class="lsid"><a href="#lsidText" id="lsid" class="local" title="Life Science Identifier (pop-up)">LSID</a></span>
              <div style="display:none; text-align: left;">
                  <div id="lsidText" style="text-align: left;">
                      <b><a class="external_icon" href="http://lsids.sourceforge.net/" target="_blank">Life Science Identifier (LSID):</a></b>
                      <p style="margin: 10px 0;"><cl:guid target="_blank" guid='${fieldValue(bean: instance, field: "guid")}'/></p>
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
              <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>
              <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>
              <cl:temporalSpan start='${fieldValue(bean: instance, field: "startDate")}' end='${fieldValue(bean: instance, field: "endDate")}'/>

              <h2>Taxonomic range</h2>
              <g:if test="${fieldValue(bean: instance, field: 'focus')}">
                <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>
              </g:if>
              <g:if test="${fieldValue(bean: instance, field: 'kingdomCoverage')}">
                <p>Kingdoms covered include: <cl:concatenateStrings values='${fieldValue(bean: instance, field: "kingdomCoverage")}'/>.</p>
              </g:if>
              <g:if test="${fieldValue(bean: instance, field: 'scientificNames')}">
                <p><cl:collectionName name="${instance.name}" prefix="The "/> includes members from the following taxa:<br/>
                <cl:JSONListAsStrings json='${fieldValue(bean: instance, field: "scientificNames")}'/>.</p>
              </g:if>

              <g:if test="${instance?.geographicDescription || instance.states}">
                <h2>Geographic range</h2>
                <g:if test="${fieldValue(bean: instance, field: 'geographicDescription')}">
                  <p>${fieldValue(bean: instance, field: "geographicDescription")}</p>
                </g:if>
                <g:if test="${fieldValue(bean: instance, field: 'states')}">
                  <p><cl:stateCoverage states='${fieldValue(bean: instance, field: "states")}'/></p>
                </g:if>
                <g:if test="${instance.westCoordinate != -1}">
                  <p>The western most extent of the collection is: <cl:showDecimal value='${instance.westCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${instance.eastCoordinate != -1}">
                  <p>The eastern most extent of the collection is: <cl:showDecimal value='${instance.eastCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${instance.northCoordinate != -1}">
                  <p>The northtern most extent of the collection is: <cl:showDecimal value='${instance.northCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${instance.southCoordinate != -1}">
                  <p>The southern most extent of the collection is: <cl:showDecimal value='${instance.southCoordinate}' degree='true'/></p>
                </g:if>
              </g:if>

              <g:set var="nouns" value="${cl.nounForTypes(types:instance.listCollectionTypes())}"/>
              <h2>Number of <cl:nounForTypes types="${instance.listCollectionTypes()}"/> in the collection</h2>
              <g:if test="${fieldValue(bean: instance, field: 'numRecords') != '-1'}">
                <p>The estimated number of ${nouns} in <cl:collectionName prefix="the " name="${instance.name}"/> is ${fieldValue(bean: instance, field: "numRecords")}.</p>
              </g:if>
              <g:if test="${fieldValue(bean: instance, field: 'numRecordsDigitised') != '-1'}">
                <p>Of these ${fieldValue(bean: instance, field: "numRecordsDigitised")} are databased.
                This represents <cl:percentIfKnown dividend='${instance.numRecordsDigitised}' divisor='${instance.numRecords}' /> of the collection.</p>
              </g:if>
              <p>Click the Records & Statistics tab to access those database records that are available through the atlas.</p>

              <g:if test="${instance.listSubCollections()?.size() > 0}">
                <h2>Sub-collections</h2>
                <p><cl:collectionName prefix="The " name="${instance.name}"/> contains these significant collections:</p>
                <cl:subCollectionList list="${instance.subCollections}"/>
              </g:if>

              <cl:lastUpdated date="${instance.lastUpdated}"/>
            </div><!--close section-->
          </div><!--close column-one-->

          <div id="column-two">
            <div class="section sidebar">
              <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
                <div class="section">
                  <img style="max-width:100%;max-height:350px;" alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                          src="${resource(absolute:"true", dir:"data/collection/", file:instance.imageRef.file)}" />
                  <cl:formattedText pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
                  <cl:valueOrOtherwise value="${instance.imageRef?.attribution}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
                  <cl:valueOrOtherwise value="${instance.imageRef?.copyright}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
                </div>
              </g:if>

              <div class="section">
                <h3>Location</h3>
                <!-- use parent location if the collection is blank -->
                <g:set var="address" value="${instance.address}"/>
                <g:if test="${address == null || address.isEmpty()}">
                  <g:if test="${instance.getInstitution()}">
                    <g:set var="address" value="${instance.getInstitution().address}"/>
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

                <g:if test="${instance.email}"><cl:emailLink>${fieldValue(bean: instance, field: "email")}</cl:emailLink><br/></g:if>
                <cl:ifNotBlank value='${fieldValue(bean: instance, field: "phone")}'/>
              </div>

              <!-- contacts -->
              <g:render template="contacts" bean="${instance.getContactsPrimaryFirst()}"/>

              <!-- web site -->
              <g:if test="${instance.websiteUrl || instance.institution?.websiteUrl}">
                <div class="section">
                  <h3>Web site</h3>
                  <g:if test="${instance.websiteUrl}">
                    <div class="webSite">
                      <a class='external' rel='nofollow' target="_blank" href="${instance.websiteUrl}">Visit the collection's website</a>
                    </div>
                  </g:if>
                  <g:if test="${instance.institution?.websiteUrl}">
                    <div class="webSite">
                      <a class='external' rel='nofollow' target="_blank" href="${instance.institution?.websiteUrl}">
                        Visit the <cl:institutionType inst="${instance.institution}"/>'s website</a>
                    </div>
                  </g:if>
                </div>
              </g:if>

              <!-- network membership -->
              <g:if test="${instance.networkMembership}">
                <div class="section">
                  <h3>Membership</h3>
                  <g:if test="${instance.isMemberOf('CHAEC')}">
                    <p>Council of Heads of Australian Entomological Collections</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chaec-logo.png")}"/>
                  </g:if>
                  <g:if test="${instance.isMemberOf('CHAH')}">
                    <p>Council of Heads of Australasian Herbaria</p>
                    <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
                  </g:if>
                  <g:if test="${instance.isMemberOf('CHAFC')}">
                    <p>Council of Heads of Australian Faunal Collections</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chafc.png")}"/>
                  </g:if>
                  <g:if test="${instance.isMemberOf('CHACM')}">
                    <p>Council of Heads of Australian Collections of Microorganisms</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chacm.png")}"/>
                  </g:if>
                </div>
              </g:if>

              <!-- attribution -->
              <g:set var='attribs' value='${instance.getAttributionList()}'/>
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
                <g:if test="${instance.numRecords != -1}">
                  <p><cl:collectionName prefix="The " name="${instance.name}"/> has an estimated ${fieldValue(bean: instance, field: "numRecords")} ${nouns}.
                    <g:if test="${instance.numRecordsDigitised != -1}">
                      <br/>The collection has databased <cl:percentIfKnown dividend='${instance.numRecordsDigitised}' divisor='${instance.numRecords}'/> of these (${fieldValue(bean: instance, field: "numRecordsDigitised")} records).
                    </g:if>
                  </p>
                </g:if>
                <g:if test="${biocacheRecordsAvailable}">
                  <p><span id="numBiocacheRecords">Looking up... the number of records that</span> can be accessed through the Atlas of Living Australia.</p>
                  <cl:warnIfInexactMapping collection="${instance}"/>
                  <cl:recordsLink collection="${instance}">
                    Click to view all records for the <cl:collectionName name="${instance.name}"/></cl:recordsLink>
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
                <table class="charts">
                  <colgroup><col width="530"><col width="400"></colgroup>
                  <tr>
                    <td>
                      <h3>Map of occurrence records</h3>
                      <cl:recordsMap/>
                    </td>
                    <td rowspan="2">
                      <h3>Records by taxonomic group</h3>
                      <cl:taxonChart uid="${instance.uid}"/>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding-top:35px;">
                      <h3>Records by collection date</h3>
                      <cl:decadeChart/>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <div id='usage-stats'>
                        <h2>Download statistics</h2>
                        <div id='usage'>
                          <p>Loading...</p>
                        </div>
                      </div>
                    </td>
                  </tr>
                </table>
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
  // stats
  loadDownloadStats("${instance.uid}","${instance.name}", "1002");

  // summary biocache data
  var biocacheRecordsUrl = "${ConfigurationHolder.config.grails.context}/public/biocacheRecords.json?uid=${instance.uid}";
  $.get(biocacheRecordsUrl, {}, biocacheRecordsHandler);

  // taxon breakdown
  loadTaxonChart("${ConfigurationHolder.config.grails.context}", "${instance.uid}", 55, {
    width: 400,
    height: 400//,
    //chartArea: {left:10, top:40, width:"90%", height: "75%"}
  });

  // records map
  //var mapServiceUrl = "${ConfigurationHolder.config.spatial.baseURL}/alaspatial/ws/density/map?collectionUid=${instance.uid}";
  var mapServiceUrl = "${ConfigurationHolder.config.grails.context}/public/recordsMapService?uid=${instance.uid}";
  $.get(mapServiceUrl, {}, mapRequestHandler);
}
/************************************************************\
* Handle biocache records response
\************************************************************/
function biocacheRecordsHandler(response) {
  if (response.error == undefined) {
    setNumbers(response.totalRecords, ${instance.numRecords});
    if (response.totalRecords < 1) {
      noBiocacheData();
    }
    drawDecadeChart(response.decades, "${instance.uid}", {
      width: 470,
      chartArea:  {left: 50, width:"88%", height: "75%"}
    });
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
    if (percent > 100 && ${instance.isInexactlyMapped()}) {
      // don't show greater than 100 if the mapping is not exact as the estimated num records may be correct
      percent = 100;
    }
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
  } else {
    // set map url
    $('#recordsMap').attr("src",response.mapUrl);
    // set legend url
    $('#mapLegend').attr("src",response.legendUrl);
  }
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
* Taxonomic breakdown chart
\************************************************************/
function drawTaxonChart2(dataTable) {
  var chart = new google.visualization.PieChart(document.getElementById('taxonChart'));
  var options = {};

  options.width = 400;
  options.height = 400;
  options.is3D = false;
  if (dataTable.getTableProperty('scope') == "all") {
    options.title = "Number of records by " + dataTable.getTableProperty('rank');
  } else {
    options.title = dataTable.getTableProperty('name') + " records by " + dataTable.getTableProperty('rank')
  }
  options.titleTextStyle = {color: "#555", fontName: 'Arial', fontSize: 15};
  options.sliceVisibilityThreshold = 0;
  options.legend = "left";
  options.chartArea = {left:10, top:40, width:"90%"};
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
      var linkUrl = "${ConfigurationHolder.config.biocache.baseURL}occurrences/searchForUID?q=${instance.uid}&fq=" +
        rank + ":" + name;
      document.location.href = linkUrl;
    } else {
      // clicked slice - drill down unless already at species
      if (rank != "species") {
        // NOTE *** margin-bottom value must match the value in the source html
        $('div#taxonChart').html('<img style="margin-left:230px;margin-top:150px;margin-bottom:218px;" alt="loading..." src="${resource(dir:'images/ala',file:'ajax-loader.gif')}"/>');
        var drillUrl = "${ConfigurationHolder.config.grails.context}/public/rankBreakdown/${instance.uid}?name=" +
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
  $('div#taxonChartCaption').css('visibility', 'visible');
}
/************************************************************\
* Draw % digitised bar (progress bar)
\************************************************************/
function setProgress(percentage)
{
  var captionText = "";
  if (${instance.numRecords < 1}) {
    captionText = "There is no estimate of the total number<br/>of ${nouns} in this collection.";
  } else if (percentage == 0) {
    captionText = "No records are available for viewing in the Atlas.";
  } else {
    var displayPercent = percentage.toFixed(1);
    if (percentage < 0.1) {displayPercent = percentage.toFixed(2)}
    if (percentage > 20) {displayPercent = percentage.toFixed(0)}
    if (percentage > 100) {displayPercent = "over 100"}
    captionText = "Records for " + displayPercent + "% of ${nouns} are<br/>available for viewing in the Atlas.";
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
