<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; java.text.DecimalFormat" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <title><cl:pageTitle>${fieldValue(bean: instance, field: "name")}</cl:pageTitle></title>
        <g:javascript src="jquery.fancybox/fancybox/jquery.fancybox-1.3.1.pack.js" />
        <link rel="stylesheet" type="text/css" href="${resource(dir:'js/jquery.fancybox/fancybox',file:'jquery.fancybox-1.3.1.css')}" media="screen" />
        <script type="text/javascript">
          $(document).ready(function() {
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
          <div id="breadcrumb"><a  href="http://test.ala.org.au">Home</a> <a  href="http://test.ala.org.au/explore/">Explore</a> <g:link controller="public" action="map">Natural History Collections</g:link> <span class="current">${instance.name}</span></div>
          <div class="section full-width">
            <div class="hrgroup col-8">
              <cl:h1 value="${instance.name}"/>
              <g:set var="dp" value="${instance.dataProvider}"/>
              <g:if test="${dp}">
                <h2><g:link action="show" id="${dp.uid}">${dp.name}</g:link></h2>
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
              <!-- provider -->
              <g:if test="${dp?.logoRef?.file}">
                <g:link action="show" id="${dp.uid}">
                  <img class="institutionImage" src='${resource(absolute:"true", dir:"data/dataProvider/",file:fieldValue(bean: dp, field: 'logoRef.file'))}' />
                </g:link>
                  <!--div style="clear: both;"></div-->
              </g:if>
            </div>
          </div>
        </div><!--close header-->
        <div id="column-one">
          <div class="section">
            <h2>Description</h2>
            <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>
            <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>
            <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>

            <h2>Digitised records</h2>
            <g:set var="recordsAvailable" value="${numBiocacheRecords != -1 && numBiocacheRecords != 0}"/>
            <div>
              <g:if test="${recordsAvailable}">
                <p><cl:numberOf number="${numBiocacheRecords}" noun="specimen record"/> can be accessed through the Atlas of Living Australia.</p>
                <cl:recordsLink collection="${instance}">Click to view records for the ${instance.name} resource.</cl:recordsLink>
              </g:if>
              <g:else>
                <p>No digitised records for this data resource can be accessed through the Atlas of Living Australia.</p>
              </g:else>
            </div>
          </div>
          <div class="section vertical-charts">
            <h3>Distribution and statistics</h3>
            <cl:distributionImg inst="${['ANIC']}" coll="${['Insects']}"/>
            <div id="taxonChart" style="margin-left:-15px;margin-top:-20px;">
            </div>
            <!--span class="taxonChartCaption">Click a segment to view its records.</span-->
            <div id="decadeChart" style="padding-right: 20px;width:500">
            </div>
          </div>
        </div><!--close column-one-->

        <div id="column-two">
          <div class="section sidebar">
            <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
              <div class="section">
                <img alt="${fieldValue(bean: instance, field: "imageRef.file")}"
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
                <g:if test="${instance.dataProvider}">
                  <g:set var="address" value="${instance.dataProvider?.address}"/>
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

            <g:set var="contact" value="${instance.getPrimaryContact()}"/>
            <g:if test="${contact}">
              <div class="section">
                <h3>Contact</h3>
                <p class="contactName">${contact?.contact?.buildName()}</p>
                <p>${contact?.role}</p>
                <cl:ifNotBlank prefix="phone: " value='${fieldValue(bean: contact, field: "contact.phone")}'/>
                <cl:ifNotBlank prefix="fax: " value='${fieldValue(bean: contact, field: "contact.fax")}'/>
                <p>email: <cl:emailLink>${contact?.contact?.email}</cl:emailLink></p>
              </div>
            </g:if>

            <!-- web site -->
            <g:if test="${instance.websiteUrl}">
              <div class="section">
                <h3>Web site</h3>
                <div class="webSite">
                  <a class='external_icon' target="_blank" href="${instance.websiteUrl}">Visit the collection's website</a>
                </div>
              </div>
            </g:if>

            <!-- network membership -->
            <g:if test="${instance.networkMembership}">
              <div class="section">
                <h3>Membership</h3>
                <g:if test="${instance.isMemberOf('CHAEC')}">
                  <p>Member of Council of Heads of Australian Entomological Collections (CHAEC)</p>
                  <img src="${resource(absolute:"true", dir:"data/network/",file:"butflyyl.gif")}"/>
                </g:if>
                <g:if test="${instance.isMemberOf('CHAH')}">
                  <p>Member of Council of Heads of Australasian Herbaria (CHAH)</p>
                  <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
                </g:if>
                <g:if test="${instance.isMemberOf('CHAFC')}">
                  <p>Member of Council of Heads of Australian Faunal Collections (CHAFC)</p>
                  <img src="${resource(absolute:"true", dir:"data/network/",file:"CHAFC_sm.jpg")}"/>
                </g:if>
                <g:if test="${instance.isMemberOf('CHACM')}">
                  <p>Member of Council of Heads of Australian Collections of Microorganisms (CHACM)</p>
                  <img src="${resource(absolute:"true", dir:"data/network/",file:"amrrnlogo.png")}"/>
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
                    <li><a href="${a.url}" class="external" target="_blank">${a.name}</a></li>
                  </g:each>
                </ul>
              </div>
            </g:if>
          </div>
        </div>
      </div>

      <script type="text/javascript">
        var queryString = '';
        var decadeUrl = '';
        var taxonUrl = '';

        function onLoadCallback() {
          if (${numBiocacheRecords != -1 && numBiocacheRecords != 0}) {
            if (decadeUrl.length > 0) {
              var query = new google.visualization.Query(decadeUrl);
              query.setQuery(queryString);
              query.send(handleQueryResponse);
            } else {
              decadeUrl = "${ConfigurationHolder.config.grails.context}/public/decadeBreakdown/${instance.uid}";
              $.get(decadeUrl, {}, decadeBreakdownRequestHandler);
            }
            if (taxonUrl.length > 0) {
              var taxonQuery = new google.visualization.Query(taxonUrl);
              taxonQuery.setQuery(queryString);
              taxonQuery.send(handleQueryResponse);
            } else {
              taxonUrl = "${ConfigurationHolder.config.grails.context}/public/taxonBreakdown/${instance.uid}?threshold=55";
              $.get(taxonUrl, {}, taxonBreakdownRequestHandler);
            }
          }
        }

        function decadeBreakdownRequestHandler(response) {
          var data = new google.visualization.DataTable(response);
          if (data.getNumberOfRows() > 0) {
            draw(data);
          }
        }

        function taxonBreakdownRequestHandler(response) {
          var data = new google.visualization.DataTable(response);
          if (data.getNumberOfRows() > 0) {
            drawTaxonChart(data);
          }
        }

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

          options.chs = '400x200';

          //options.chxt = 'x,x,y';
          //options.chxl = '2:|Decade';
          //options.chxp = '0,50';

          vis.draw(dataTable, options);
        }

        function drawTaxonChart(dataTable) {
          var chart = new google.visualization.PieChart(document.getElementById('taxonChart'));
          var options = {};

          options.width = 500;
          options.height = 500;
          options.is3D = false;
          options.title = "Record numbers by " + dataTable.getTableProperty('rank');
          options.titleTextStyle = {color: "#7D8804", fontName: 'Arial', fontSize: 15};
          //options.sliceVisibilityThreshold = 1/2000;
          //options.pieSliceText = "label";
          options.legend = "left";
          google.visualization.events.addListener(chart, 'select', function() {
            var linkUrl = "${ConfigurationHolder.config.biocache.baseURL}occurrences/searchForUID?q=${instance.uid}&fq=" +
              dataTable.getTableProperty('rank') + ":" + dataTable.getValue(chart.getSelection()[0].row,0);
            document.location.href = linkUrl;
          });
          //google.visualization.events.addListener(chart, 'onmouseover', function() {
          //  $("div#taxonChart").css("cursor") = "pointer";
          //});

          chart.draw(dataTable, options);
        }

        function handleQueryResponse(response) {
          if (response.isError()) {
            alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
            return;
          }
          draw(response.getDataTable());
        }

        google.load("visualization", "1", {packages:["imagechart","corechart"]});
        google.setOnLoadCallback(onLoadCallback);

      </script>
    </body>
</html>
