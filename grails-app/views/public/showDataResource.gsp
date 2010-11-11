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
              <g:set var="dp" value="${instance.dataProvider}"/>
              <g:if test="${dp}">
                <h2><g:link action="show" id="${dp.uid}">${dp.name}</g:link></h2>
              </g:if>
              <g:if test="${instance.institution}">
                <h2><g:link action="show" id="${instance.institution.uid}">${instance.institution.name}</g:link></h2>
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

            <h2>Citation</h2>
            <g:if test="${instance.citation || instance.citableAgent}">
              <cl:formattedText>${fieldValue(bean: instance, field: "citation")}</cl:formattedText>
              <cl:formattedText>${fieldValue(bean: instance, field: "citableAgent")}</cl:formattedText>
            </g:if>
            <g:else>
              <p>No citation information available.</p>
            </g:else>

            <g:if test="${instance.rights}">
              <h2>Rights</h2>
              <cl:formattedText>${fieldValue(bean: instance, field: "rights")}</cl:formattedText>
            </g:if>
            
            <h2>Digitised records</h2>
            <div>
              <p><span id="numBiocacheRecords">Looking up... the number of records that</span> can be accessed through the Atlas of Living Australia.</p>
              <cl:recordsLink collection="${instance}">Click to view records for the ${instance.name} resource.</cl:recordsLink>
            </div>
          </div>
          <div class="section vertical-charts">
            <h3>Map of records</h3>
            <cl:recordsMap type="dataResource" uid="${instance.uid}"/>
            <div id="taxonChart">
              <img style="margin-left:230px;margin-top:140px;margin-bottom:308px" alt="loading..." src="${resource(dir:'images/ala',file:'ajax-loader.gif')}"/>
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
          </div>
          <cl:lastUpdated date="${instance.lastUpdated}"/>
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
                  <a class='external_icon' target="_blank" href="${instance.websiteUrl}">Visit the data resource's website</a>
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
                    <li><a href="${a.url}" class="external" target="_blank">${a.name}</a></li>
                  </g:each>
                </ul>
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

        $('img#mapLegend').each(function(i, n) {
          // if legend doesn't load, then it must be a point map
          $(this).error(function() {
            $(this).attr('src',"http://nemo-be.nexus.csiro.au:8080/Collectory/images/map/single-occurrences.png");
          });
          // IE hack as IE doesn't trigger the error handler
          if ($.browser.msie && !n.complete) {
            $(this).attr('src',"${resource(dir:'images/map',file:'single-occurrences.png')}");
          }
        });
        /************************************************************\
        *
        \************************************************************/
        function onLoadCallback() {
          // summary biocache data
          var biocacheRecordsUrl = "${ConfigurationHolder.config.grails.context}/public/biocacheRecords.json?uid=${instance.uid}";
          $.get(biocacheRecordsUrl, {}, biocacheRecordsHandler);

          // taxon chart
          taxonUrl = "${ConfigurationHolder.config.grails.context}/public/taxonBreakdown/${instance.uid}?threshold=25";
          $.get(taxonUrl, {}, taxonBreakdownRequestHandler);

          // records map
          //var mapServiceUrl = "${ConfigurationHolder.config.spatial.baseURL}/alaspatial/ws/density/map?collectionUid=${instance.uid}";
          var mapServiceUrl = "${ConfigurationHolder.config.grails.context}/public/recordsMapService?uid=${instance.uid}";
          $.get(mapServiceUrl, {}, mapRequestHandler);
        }
        /************************************************************\
        *
        \************************************************************/
        function biocacheRecordsHandler(response) {
          if (response.error == undefined) {
            setNumbers(response.totalRecords);
            drawDecadeChart(response.decades);
          } else {
            setNumbers(0);
            $('div#decadeChart').css("display","none");
          }
        }
        /************************************************************\
        *
        \************************************************************/
        function setNumbers(totalBiocacheRecords) {
          var recordsClause = "";
          switch (totalBiocacheRecords) {
            case 0: recordsClause = "No records"; break;
            case 1: recordsClause = "1 record"; break;
            default: recordsClause = addCommas(totalBiocacheRecords) + " records";
          }
          $('#numBiocacheRecords').html(recordsClause);
        }
        /************************************************************\
        *
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
        *
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
          if (response.error == undefined) {
            var data = new google.visualization.DataTable(response);
            if (data.getNumberOfRows() > 0) {
              drawTaxonChart(data);
            } else {
                // no data
                $('div#taxonChart').css("display","none");
            }
          } else {
            // an error occurred
            $('div#taxonChart').css("display","none");
          }
        }
        /************************************************************\
        * for testing
        \************************************************************/
        function simpleChart(decadeData) {
          var json = '{"cols":[{"id":"","label":"","pattern":"","type":"string"},{"id":"","label":"","pattern":"","type":"number"}],"rows":[{"c":[{"v":"earlier","f":null},{"v":5,"f":null}]},{"c":[{"v":"1850s","f":null},{"v":13,"f":null}]},{"c":[{"v":"1860s","f":null},{"v":82,"f":null}]},{"c":[{"v":"1870s","f":null},{"v":306,"f":null}]},{"c":[{"v":"1880s","f":null},{"v":470,"f":null}]},{"c":[{"v":"1890s","f":null},{"v":2219,"f":null}]},{"c":[{"v":"1900s","f":null},{"v":5418,"f":null}]},{"c":[{"v":"1910s","f":null},{"v":10117,"f":null}]},{"c":[{"v":"1920s","f":null},{"v":5035,"f":null}]},{"c":[{"v":"1930s","f":null},{"v":3349,"f":null}]},{"c":[{"v":"1940s","f":null},{"v":4978,"f":null}]},{"c":[{"v":"1950s","f":null},{"v":15525,"f":null}]},{"c":[{"v":"1960s","f":null},{"v":44101,"f":null}]},{"c":[{"v":"1970s","f":null},{"v":58549,"f":null}]},{"c":[{"v":"1980s","f":null},{"v":59178,"f":null}]},{"c":[{"v":"1990s","f":null},{"v":47891,"f":null}]},{"c":[{"v":"2000s","f":null},{"v":8490,"f":null}]},{"c":[{"v":"2010s","f":null},{"v":1,"f":null}]}],"p":null}';
          var dataTable = new google.visualization.DataTable(json);
          var data = new google.visualization.DataTable();
          data.addColumn('string', 'Year');
          data.addColumn('number', 'Sales');
          data.addColumn('number', 'Expenses');
          data.addRows(4);
          data.setValue(0, 0, '2004');
          data.setValue(0, 1, 1000);
          data.setValue(0, 2, 400);
          data.setValue(1, 0, '2005');
          data.setValue(1, 1, 1170);
          data.setValue(1, 2, 460);
          data.setValue(2, 0, '2006');
          data.setValue(2, 1, 660);
          data.setValue(2, 2, 1120);
          data.setValue(3, 0, '2007');
          data.setValue(3, 1, 1030);
          data.setValue(3, 2, 540);
          var chart = new google.visualization.ColumnChart(document.getElementById('decadeChart'));
          chart.draw(dataTable, {width: 400, height: 240, title: 'Company Performance',
                            hAxis: {title: 'Year', titleTextStyle: {color: 'red'}}
                           });

        }
        /************************************************************\
        *
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
                document.location.href = "${ConfigurationHolder.config.biocache.baseURL}occurrences/searchForUID?q=${instance.uid}&fq=" + dateRange;
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
        *
        \************************************************************/
        function drawTaxonChart(dataTable) {
          var chart = new google.visualization.PieChart(document.getElementById('taxonChart'));
          var options = {};

          options.width = 600;
          options.height = 500;
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
            var rank = dataTable.getTableProperty('rank')
            var name = dataTable.getValue(chart.getSelection()[0].row,0);
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
                $('div#taxonChart').html('<img style="margin-left:230px;margin-top:140px;margin-bottom:308px;" alt="loading..." src="${resource(dir:'images/ala',file:'ajax-loader.gif')}"/>');
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
          $('span.taxonChartCaption').css('visibility', 'visible');
        }
        /************************************************************\
        *
        \************************************************************/
        function resetTaxonChart() {
          taxonUrl = "${ConfigurationHolder.config.grails.context}/public/taxonBreakdown/${instance.uid}?threshold=55";
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

        google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(onLoadCallback);

      </script>
    </body>
</html>
