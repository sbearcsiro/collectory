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
          });
        </script>
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
    </head>
    <body class="two-column-right">
      <div id="content">
        <div id="header" class="collectory">
          <!--Breadcrumbs-->
          <div id="breadcrumb"><a  href="http://test.ala.org.au">Home</a> <a  href="http://test.ala.org.au/explore/">Explore</a> <g:link controller="public" action="map">Natural History Collections</g:link> <span class="current">${collectionInstance.name}</span></div>
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
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"amrrnlogo.png")}"/>
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
                        <li><a href="${a.url}" class="external" target="_blank">${a.name}</a></li>
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
              <g:set var="recordsAvailable" value="${numBiocacheRecords != -1 && numBiocacheRecords != 0}"/>
              <div style="float:left;">
                <g:if test="${collectionInstance.numRecords != -1}">
                  <p><cl:collectionName prefix="The " name="${collectionInstance.name}"/> has an estimated ${fieldValue(bean: collectionInstance, field: "numRecords")} specimens.
                    <g:if test="${collectionInstance.numRecordsDigitised != -1}">
                      <br/>The collection has databased <cl:percentIfKnown dividend='${collectionInstance.numRecordsDigitised}' divisor='${collectionInstance.numRecords}'/> of these (${fieldValue(bean: collectionInstance, field: "numRecordsDigitised")} records).
                    </g:if>
                  </p>
                </g:if>
                <g:if test="${recordsAvailable}">
                  <p><cl:numberOf number="${numBiocacheRecords}" noun="specimen record" none="No"/> can be accessed through the Atlas of Living Australia.</p>
                  <cl:warnIfInexactMapping collection="${collectionInstance}"/>
                  <cl:recordsLink collection="${collectionInstance}">
                    <img src="${resource(dir:"images/ala/",file:"database_go.png")}"/>
                    Click to view <cl:numberOf number="${numBiocacheRecords}" noun="record" none="No"/> for the <cl:collectionName name="${collectionInstance.name}"/></cl:recordsLink>
                </g:if>
                <g:else>
                  <p>No database records for this collection can be accessed through the Atlas of Living Australia.</p>
                </g:else>
              </div>
              <div id="speedo">
                <g:if test="${percentBiocacheRecords != -1}">
                  <div id="progress">
                    <cl:progressBar percent="${percentBiocacheRecords}"/>
                  </div>
                  <p class="caption">
                  <g:if test="${percentBiocacheRecords}">
                    Records for <cl:formatPercent percent="${percentBiocacheRecords}"/>% of specimens are<br/>available for viewing in the Atlas.
                  </g:if>
                  <g:else>
                    <g:if test="${collectionInstance.numRecords > 0}">
                      No records are available for viewing in the Atlas.
                    </g:if>
                    <g:else>
                      There is no estimate of the total number<br/>of specimens in this collection.
                    </g:else>
                  </g:else>
                  </p>
                </g:if>
              </div>
            </div>
            <div class="section">
              <g:if test="${recordsAvailable}">
                <div style="clear:both;"></div>
                <div class="inline">
                  <h3>Map of occurrence records</h3>
                  <cl:recordsMap type="collection" uid="${collectionInstance.uid}"/>
                </div>
                <div id="taxonChart" style="display: inline; width: 500px;">
                </div>
                <span class="taxonChartCaption">Click a slice to drill into a group.<br/>
                  Click a legend box to view records for a group.</span>
                <span id="resetTaxonChart" onclick="resetTaxonChart()"></span>
                <div style="clear:both;"></div>
                <div id="decadeChart" style="display: inline;padding-right: 20px;">
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
var taxonUrl = '';
/************************************************************\
*
\************************************************************/
function onLoadCallback() {
  if (${numBiocacheRecords != -1 && numBiocacheRecords != 0}) {
    if (decadeUrl.length > 0) {
      var query = new google.visualization.Query(decadeUrl);
      query.setQuery(queryString);
      query.send(handleQueryResponse);
    } else {
      decadeUrl = "${ConfigurationHolder.config.grails.context}/public/decadeBreakdown/${collectionInstance.uid}";
      $.get(decadeUrl, {}, decadeBreakdownRequestHandler);
    }
    if (taxonUrl.length > 0) {
      var taxonQuery = new google.visualization.Query(taxonUrl);
      taxonQuery.setQuery(queryString);
      taxonQuery.send(handleQueryResponse);
    } else {
      taxonUrl = "${ConfigurationHolder.config.grails.context}/public/taxonBreakdown/${collectionInstance.uid}?threshold=55";
      $.get(taxonUrl, {}, taxonBreakdownRequestHandler);
    }
  }
}
/************************************************************\
*
\************************************************************/
function decadeBreakdownRequestHandler(response) {
  var data = new google.visualization.DataTable(response);
  if (data.getNumberOfRows() > 0) {
    draw(data);
  }
}
/************************************************************\
*
\************************************************************/
function taxonBreakdownRequestHandler(response) {
  var data = new google.visualization.DataTable(response);
  if (data.getNumberOfRows() > 0) {
    drawTaxonChart(data);
  }
}
/************************************************************\
*
\************************************************************/
function drawDecadeChart(dataTable) {
  var vis = new google.visualization.ColumnChart(document.getElementById('decadeChart'));

  vis.draw(dataTable, {
    width: 500,
    height: 400,
    title: "Additions by decade",
    titleTextStyle: {color: "#7D8804", fontName: 'Arial', fontSize: 15},
    hAxis: {title:"decades", showTextEvery: 3},
    legend: 'none',
    colors: ['#3398cc']
  });
}
/************************************************************\
*
\************************************************************/
function draw(dataTable) {
  var vis = new google.visualization.ImageChart(document.getElementById('decadeChart'));
  var options = {};

  // 'bhg' is a horizontal grouped bar chart in the Google Chart API.
  // The grouping is irrelevant here since there is only one numeric column.
  options.cht = 'bvg';

  // Add a data range.
  var min = 0;
  var max = dataTable.getTableProperty('max');
  options.chds = min + ',' + max;

  // Chart title and style
  options.chtt = 'Additions by decade';  // chart title
  options.chts = '7D8804,15';

  //options.chxt = 'x,x,y';
  //options.chxl = '2:|Decade';
  //options.chxp = '0,50';

  vis.draw(dataTable, options);
}
/************************************************************\
*
\************************************************************/
function drawTaxonChart(dataTable) {
  var chart = new google.visualization.PieChart(document.getElementById('taxonChart'));
  var options = {};

  options.width = 500;
  options.height = 500;
  options.is3D = false;
  if (dataTable.getTableProperty('scope') == "all") {
    options.title = "Number of records by " + dataTable.getTableProperty('rank');
  } else {
    options.title = dataTable.getTableProperty('name') + " records by " + dataTable.getTableProperty('rank')
  }
  options.titleTextStyle = {color: "#555", fontName: 'Arial', fontSize: 15};
  //options.sliceVisibilityThreshold = 1/2000;
  //options.pieSliceText = "label";
  options.legend = "left";
  google.visualization.events.addListener(chart, 'select', function() {
    // differentiate between clicks on legend versus slices
    if (chart.getSelection()[0].column == undefined) {
      // clicked legend - show records
      var linkUrl = "${ConfigurationHolder.config.biocache.baseURL}occurrences/searchForUID?q=${collectionInstance.uid}&fq=" +
        dataTable.getTableProperty('rank') + ":" + dataTable.getValue(chart.getSelection()[0].row,0);
      document.location.href = linkUrl;
    } else {
      // clicked slice - drill down
      var drillUrl = "${ConfigurationHolder.config.grails.context}/public/rankBreakdown/${collectionInstance.uid}?name=" +
              dataTable.getValue(chart.getSelection()[0].row,0) +
             "&rank=" + dataTable.getTableProperty('rank')
      $.get(drillUrl, {}, taxonBreakdownRequestHandler);
      if ($('span#resetTaxonChart').html() == "") {
        $('span#resetTaxonChart').html("reset to " + dataTable.getTableProperty('rank'));
      }
    }
  });

  chart.draw(dataTable, options);
}
/************************************************************\
*
\************************************************************/
function resetTaxonChart() {
  taxonUrl = "${ConfigurationHolder.config.grails.context}/public/taxonBreakdown/${collectionInstance.uid}?threshold=55";
  $.get(taxonUrl, {}, taxonBreakdownRequestHandler);
  $('span#resetTaxonChart').html("");
}
/************************************************************\
*
\************************************************************/
function handleQueryResponse(response) {
  if (response.isError()) {
    alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
    return;
  }
  draw(response.getDataTable());
}
/************************************************************\
*
\************************************************************/

        google.load("visualization", "1", {packages:["imagechart","corechart"]});
        google.setOnLoadCallback(onLoadCallback);

      </script>
    </body>
</html>
