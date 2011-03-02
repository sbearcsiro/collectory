<%@ page contentType="text/html;charset=UTF-8" import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.DataHub"%>
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
            <cl:valueOrOtherwise value="${instance.acronym}"><span class="acronym">Acronym: ${fieldValue(bean: instance, field: "acronym")}</span></cl:valueOrOtherwise>
            <g:if test="${instance.guid?.startsWith('urn:lsid:')}">
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
            </g:if>
          </div>
          <div class="aside col-4 center">
            <!-- logo -->
            <g:if test="${fieldValue(bean: instance, field: 'logoRef') && fieldValue(bean: instance, field: 'logoRef.file')}">
              <img class="institutionImage" src='${resource(absolute:"true", dir:"data/"+instance.urlForm()+"/",file:fieldValue(bean: instance, field: 'logoRef.file'))}' />
            </g:if>
          </div>
        </div>
      </div><!--close header-->
      <div id="column-one">
      <div class="section">
        <g:if test="${instance.pubDescription}">
          <h2>Description</h2>
          <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>
          <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>
        </g:if>
        <g:if test="${instance.focus}">
          <h2>Contribution to the Atlas</h2>
          <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>
        </g:if>

        <div class="section vertical-charts">
          <!-- would normally use the following tag here - but it is directly coded as an example of a chart in a standalone app-->
          <!--cl:taxonChart uid="${instance.uid}"/-->

          <!-- STANDALONE TAXON BREAKDOWN CHART -->
          <div id='taxonChart'>
            <img class='taxon-loading' alt='loading...' src='http://collections.ala.org.au/images/ala/ajax-loader.gif'/>
          </div>
          <div id='taxonChartCaption' style='visibility:hidden;'>
            <span class='taxonChartCaption'>Click a slice or legend to drill into a group.</span><br/>
            <span id='resetTaxonChart' class="resetChart" onclick='resetTaxonChart()'></span>
          </div>
          <script type="text/javascript">
            //var taxaBreakdownUrl = "http://ala-bie1.vm.csiro.au:8080/biocache-service/breakdown/uid/namerank/";
            //var taxaBreakdownUrl = "http://biocache.ala.org.au/breakdown/uid/namerank/";
            var taxaBreakdownUrl = "${ConfigurationHolder.config.grails.serverURL}/public/serviceRedirect";
            var summaryUrl = "http://biocache.ala.org.au/occurrences/searchForUID.json?pageSize=0&q=";
            /************************************************************\
            *
            \************************************************************/
            function loadTaxonChart(uid, name, rank) {
              var url = taxaBreakdownUrl /*+ uid*/ + ".json?rank=" + rank;
              if (name != undefined) {
                url = url + "&name=" + name;
              }
              $.ajax({
                url: url,
                dataType: 'json',
                error: function(jqXHR, textStatus, errorThrown) {
                  alert(textStatus + ": " + errorThrown);
                },
                success: function(data) {
//                  alert(data);
                  var dataTable = buildDataTable(data, name, rank);
                  drawTaxonChart(dataTable)
                }
              });
            }
            /************************************************************\
            * Converts biocache json to Google VIS DataTable
            \************************************************************/
            function buildDataTable(data, name, rank) {
              var table = new google.visualization.DataTable();
              table.addColumn('string', data.rank);
              table.addColumn('number', 'count');

              if (data.taxa == undefined) {
                alert("no data");
              }
              for (var i = 0; i < data.taxa.length; i++) {
                table.addRow([data.taxa[i].label,data.taxa[i].count]);
              }
              table.setTableProperty('rank', data.rank);
              if (name == undefined) {
                table.setTableProperty('scope', 'all');
              } else {
                table.setTableProperty('name', name);
              }
              return table
            }
            /************************************************************\
            * Draw the chart
            \************************************************************/
            function drawTaxonChart(dataTable) {
              var chart = new google.visualization.PieChart(document.getElementById('taxonChart'));
              var options = {
                  width: 400,
                  height: 400,
                  chartArea: {left:0, top:30, width:"90%", height: "75%"},
                  is3D: false,
                  titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
                  sliceVisibilityThreshold: 0,
                  legend: "left"
              };
              if (dataTable.getTableProperty('scope') == "all") {
                options.title = "Records by " + dataTable.getTableProperty('rank');
              } else {
                options.title = dataTable.getTableProperty('name') + " records by " + dataTable.getTableProperty('rank');
              }
              google.visualization.events.addListener(chart, 'select', function() {
                var rank = dataTable.getTableProperty('rank');
                var name = dataTable.getValue(chart.getSelection()[0].row,0);
                // add genus to name if we are at species level
                var scope = dataTable.getTableProperty('scope');
                if (scope == "genus" && rank == "species") {
                  name = dataTable.getTableProperty('name') + " " + name;
                }
                // drill down unless already at species
                if (rank != "species") {
                  $('div#taxonChart').html('<img class="taxon-loading" alt="loading..." src="http://collections.ala.org.au/images/ala/ajax-loader.gif"/>');
                  loadTaxonChart(instanceUid, dataTable.getValue(chart.getSelection()[0].row,0), dataTable.getTableProperty('rank'));
                }
                // show reset link if we were at top level
                if ($('span#resetTaxonChart').html() == "") {
                  $('span#resetTaxonChart').html("Reset to " + dataTable.getTableProperty('rank'));
                }
              });

              chart.draw(dataTable, options);

              // show taxon caption
              $('div#taxonChartCaption').css('visibility', 'visible');
            }
            /************************************************************\
            *
            \************************************************************/
            function resetTaxonChart() {
              $('div#taxonChart').html('<img class="taxon-loading" alt="loading..." src="http://collections.ala.org.au/images/ala/ajax-loader.gif"/>');
              loadTaxonChart(instanceUid, null, 'phylum');
              $('span#resetTaxonChart').html("");
            }
          </script>

          <!--
          *******                                        *****
          ******* STANDALONE INSTITUTION BREAKDOWN CHART *****
          *******                                        *****
          -->
          <div id='instChart'>
            <img style="margin-left: 230px;margin-top: 100px;margin-bottom: 118px;" alt='loading...' src='http://collections.ala.org.au/images/ala/ajax-loader.gif'/>
          </div>
          <div id='instChartCaptionBlock' style='visibility:hidden;'>
            <span id="instChartCaption" class='taxonChartCaption'>Click a slice or legend to show the institution's collections.</span><br/>
            <span id='resetInstChart' style="margin-left:90px;" class="resetChart" onclick='resetInstChart()'></span>
          </div>
          <script type="text/javascript">
            var chart;
            var instBreakdownJson = {empty: true};
            var topLevel = true;
            function loadInstChart() {
              //var url = biocacheServicesUrl + "occurrences/data-provider/" + instanceUid + ".json?pageSize=0";
              //var oldUrl = biocacheUrl + "occurrences/searchForUID.json?pageSize=0&q=" + instanceUid;
              if (instBreakdownJson.empty) {
                // load json one time only
                var url = "${ConfigurationHolder.config.grails.serverURL}/public/recordsByCollectionByInstitution.json";
                $.ajax({
                    url: url,
                    dataType: 'json',
                    success: function(data) {
                      instBreakdownJson = data.breakdown;
                      drawInstitutionBreakdown();
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                      alert(textStatus);//$('div#instChart').html(textStatus);
                    }
                });
              } else {
                // json already loaded
                drawInstitutionBreakdown();
              }
            }
            function drawInstitutionBreakdown(data) {
              topLevel = true;
              var data = instBreakdownJson;
              // build data table
              var table = new google.visualization.DataTable();
              table.addColumn('string', 'Institution');
              table.addColumn('number', 'Number of records');
              for (var i = 0; i < data.length; i++) {
                table.addRow([data[i].label,data[i].total]);
              }

              // chart options
              var options = {
                  width: 510,
                  height: 280,
                  chartArea: {left:0, top:60, width:"100%", height: "90%"},
                  title: 'Records by source institution',
                  titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
                  sliceVisibilityThreshold: 0,
                  legend: "right"
              };

              // create chart
              chart = new google.visualization.PieChart(document.getElementById('instChart'));

              // selection actions
              google.visualization.events.addListener(chart, 'select', function() {
                // only take an action if we are at the institution level
                var label = table.getValue(chart.getSelection()[0].row,0);
                if (topLevel) {
                  drawCollectionBreakdownChart(label);
                  topLevel = false;
                  // show reset link
                  $('span#resetInstChart').html("Return to institution view");
                  $('span#instChartCaption').html("Click a slice or legend to show records for the collection.");
                }
              });

              // draw
              chart.draw(table, options);

              // show caption
              $('div#instChartCaptionBlock').css('visibility', 'visible');

            }

            function drawCollectionBreakdownChart(label) {
              // extract data section for name
              var collData;
              var name;
              for (var i = 0; i < instBreakdownJson.length; i++) {
                if(instBreakdownJson[i].label == label) {
                  collData = instBreakdownJson[i].collections;
                  name = instBreakdownJson[i].name;
                }
              }
              var nameLabel;
              if (name == "Museum Victoria") {
                nameLabel = name;
              } else {
                nameLabel = 'the ' + name;
              }
              // build data table
              var table = new google.visualization.DataTable();
              table.addColumn('string', 'Collection');
              table.addColumn('number', 'Number of records');
              for (var i = 0; i < collData.length; i++) {
                table.addRow([collData[i].name,collData[i].count]);
              }
              // chart options
              var options = {
                  width: 510,
                  height: 280,
                  chartArea: {left:0, top:60, width:"100%", height: "90%"},
                  title: 'Records by collections for ' + nameLabel,
                  titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
                  sliceVisibilityThreshold: 0,
                  legend: "right"
              };

              // draw chart
              chart.draw(table, options);

              // set caption
              $('div#instChartCaption').html("");

            }

            function resetInstChart() {
              $('div#instChart').html('<img style="margin-left: 230px;margin-top: 140px;margin-bottom: 110px;" alt="loading..." src="http://collections.ala.org.au/images/ala/ajax-loader.gif"/>');
              topLevel = true;
              loadInstChart();
              $('span#instChartCaption').html("Click a slice or legend to show the institution's collections.");
              $('span#resetInstChart').html("");
            }
          </script>

          <!-- STANDALONE TYPES BREAKDOWN CHART -->
          <div id='typesChart'>
            <img class='taxon-loading' alt='loading...' src='http://collections.ala.org.au/images/ala/ajax-loader.gif'/>
          </div>
          <div id='typesChartCaption'>
            <span class='taxonChartCaption'>Click a slice or legend to show records of that type.</span><br/>
          </div>
          <script type="text/javascript">
            var priorityOfTypes = ['holotype','lectotype','neotype','syntype','paratype','allotype','topotype','paralectotype','cotype','hapantotype','allolectotype','paraneotype'];
            function drawTypesBreakdown(data) {
              var types = data.fieldResult;
              types.sort(typeSorter);
              // build data table
              var table = new google.visualization.DataTable();
              table.addColumn('string', 'Type');
              table.addColumn('number', 'Number of records');
              for (var i = 0; i < types.length; i++) {
                var label = types[i].label;
                if (label == 'type') {label = 'unknown type';}
                if (label != 'notatype') {
                  table.addRow([label,types[i].count]);
                }
              }

              // chart options
              var options = {
                  width: 510,
                  height: 280,
                  chartArea: {left:0, top:60, width:"100%", height: "90%"},
                  title: 'Records by type status',
                  titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
                  sliceVisibilityThreshold: 0,
                  legend: "right"
              };

              // create chart
              var chart = new google.visualization.PieChart(document.getElementById('typesChart'));

              // selection actions
              google.visualization.events.addListener(chart, 'select', function() {
                var name = table.getValue(chart.getSelection()[0].row,0);
                // reverse any presentation transforms
                if (name == 'unknown type') {name = 'type';}
                window.location.href = "http://ala-bie1.vm.csiro.au:8080/hubs-webapp/occurrences/search?q=*:*&fq=type_status:" + name;
              });

              // draw
              chart.draw(table, options);
            }

            function typeSorter(a,b) {
              // assign a rank to each
              var aRank = 100;
              var bRank = 100;
              for (var i = 0; i < priorityOfTypes.length; i++) {
                if (priorityOfTypes[i] == a.label) { aRank = i;}
                if (priorityOfTypes[i] == b.label) { bRank = i;}
              }
              return aRank - bRank;
            }
          </script>

          <!-- STANDALONE STATE BREAKDOWN CHART -->
          <div id='statesChart'>
            <img class='taxon-loading' alt='loading...' src='http://collections.ala.org.au/images/ala/ajax-loader.gif'/>
          </div>
          <div id='statesChartCaption' style='visibility:hidden;'>
            <span class='taxonChartCaption'>Click a slice or legend to learn more about the institution.</span><br/>
          </div>
          <script type="text/javascript">
            function drawStatesBreakdown(data) {
              var drs = data.fieldResult;
              // build data table
              var table = new google.visualization.DataTable();
              table.addColumn('string', 'Type');
              table.addColumn('number', 'Number of records');
              for (var i = 0; i < drs.length; i++) {
                var label = drs[i].label;
                table.addRow([label,drs[i].count]);
              }

              // chart options
              var options = {
                  width: 510,
                  height: 280,
                  chartArea: {left:0, top:60, width:"100%", height: "90%"},
                  title: 'Records by state',
                  titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
                  sliceVisibilityThreshold: 0,
                  legend: "right"
              };

              // create chart
              var chart = new google.visualization.PieChart(document.getElementById('statesChart'));

              // selection actions
              google.visualization.events.addListener(chart, 'select', function() {
                var name = table.getValue(chart.getSelection()[0].row,0);
                // reverse any presentation transforms
                if (name == 'unknown type') {name = 'type';}
                window.location.href = "http://ala-bie1.vm.csiro.au:8080/hubs-webapp/occurrences/search?q=*:*&fq=type_status:" + name;
              });

              // draw
              chart.draw(table, options);
            }
          </script>

          <!-- STANDALONE SPECIMEN ACCUMULATION CHART -->
          <div id='recordsAccumChart'>
            <img class='taxon-loading' alt='loading...' src='http://collections.ala.org.au/images/ala/ajax-loader.gif'/>
          </div>
          <div id='recordsAccumChartCaption'>
            <span id='toggleAccumChart' class="resetChart" style="margin-left:200px;" onclick='toggleLogScale()'>Use linear scale</span>
          </div>
          <div id="raJson"></div>
          <script type="text/javascript">
            var useStaticData = false;
            var accumChart;
            var accumTable;
            var accumOptions;
            var rawData;
            function loadRecordsAccumulation() {
              var url = "http://woodfired.ala.org.au:8080/Collectory/public/recordsByDecadeByInstitution.json";  //!!!!!!!
              if (useStaticData) { url = url + "?static=true";}
              $.get(url, {}, drawRecordsAccumulation);
            }
            function drawRecordsAccumulation(data) {
              rawData = data;
              // build data table
              if (useStaticData) {
                accumTable = new google.visualization.DataTable(data);
              } else {
                accumTable = new google.visualization.DataTable();
                accumTable.addRows(17);
                accumTable.addColumn('string', 'Decade');
                for (var i = 0; i < 17; i++) {
                  accumTable.setValue(i, 0, (i * 10 + 1850) + 's');
                }
                for (var i = 0; i < data.length; i++) {
                  accumTable.addColumn('number', data[i].label);
                  loadRecords(data[i], accumTable, i + 1);
                }

                //$('div#raJson').html(table.toJSON());
              }

              // chart options
              accumOptions = {
                  width: 650,
                  height: 340,
                  vAxis: {logScale: true, title: "num records (log scale)", format: "#,###,###"},
                  //vAxis: {logScale: false, title: "number of records", format: "#,###,###"},
                  chartArea: {left: 80, width:"55%"},
                  title: 'Accumulated records by decade',
                  titleTextStyle: {color: "#1775BA", fontName: 'Arial', fontSize: 18},
                  sliceVisibilityThreshold: 0,
                  legend: "right"
              };

              // create chart
              accumChart = new google.visualization.LineChart(document.getElementById('recordsAccumChart'));

              // selection actions
              google.visualization.events.addListener(accumChart, 'select', function() {
                var selection = accumChart.getSelection()[0];
                var instData = rawData[selection.column - 1];
                var name = instData.name;
                var searchUrl = "http://ozcam-demo.ala.org.au:8080/occurrences/search?q=" + name;
                if (selection.row != undefined) {
                  var decadeStart = selection.row * 10 + 1850;
                  var decadeEnd = selection.row * 10 + 1850 + 10;
                  searchUrl = searchUrl + "&fq=occurrence_date:[" + decadeStart + "-01-01T12:00:00Z%20TO%20" + decadeEnd + "-01-01T12:00:00Z]";
                }
                window.location.href = searchUrl;
              });

              // draw
              accumChart.draw(accumTable, accumOptions);
            }

            function loadRecords(inst, table, col) {
              table.setValue(0, col , inst.d1850);
              table.setValue(1, col , inst.d1860);
              table.setValue(2, col , inst.d1870);
              table.setValue(3, col , inst.d1880);
              table.setValue(4, col , inst.d1890);
              table.setValue(5, col , inst.d1900);
              table.setValue(6, col , inst.d1910);
              table.setValue(7, col , inst.d1920);
              table.setValue(8, col , inst.d1930);
              table.setValue(9, col , inst.d1940);
              table.setValue(10, col , inst.d1950);
              table.setValue(11, col , inst.d1960);
              table.setValue(12, col , inst.d1970);
              table.setValue(13, col , inst.d1980);
              table.setValue(14, col , inst.d1990);
              table.setValue(15, col , inst.d2000);
              table.setValue(16, col , inst.d2010);
            }

            function toggleLogScale() {
              if ($('span#toggleAccumChart').html() == "Use log scale") {
                accumOptions.vAxis = {logScale: true, title: "num records (log scale)", format: "#,###,###"}
                accumChart.draw(accumTable, accumOptions);
                $('span#toggleAccumChart').html('Use linear scale');
              } else {
                accumOptions.vAxis = {logScale: false, title: "number of records", format: "#,###,###"}
                accumChart.draw(accumTable, accumOptions);
                $('span#toggleAccumChart').html('Use log scale');
              }
            }
          </script>

        </div>
        
        <cl:lastUpdated date="${instance.lastUpdated}"/>

      </div><!--close section-->
    </div><!--close column-one-->

    <div id="column-two">
      <div class="section sidebar">
        <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
          <div class="section">
            <img alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                    src="${resource(absolute:"true", dir:"data/"+instance.urlForm()+"/", file:instance.imageRef.file)}" />
            <cl:formattedText pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
            <cl:valueOrOtherwise value="${instance.imageRef?.attribution}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${instance.imageRef?.copyright}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
          </div>
        </g:if>

        <div class="section">
          <h3>Location</h3>
          <g:if test="${instance.address != null && !instance.address.isEmpty()}">
            <p>
              <cl:valueOrOtherwise value="${instance.address?.street}">${instance.address?.street}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.city}">${instance.address?.city}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.state}">${instance.address?.state}</cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.postcode}">${instance.address?.postcode}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.country}">${instance.address?.country}<br/></cl:valueOrOtherwise>
            </p>
          </g:if>
          <g:if test="${instance.email}"><cl:emailLink>${fieldValue(bean: instance, field: "email")}</cl:emailLink><br/></g:if>
          <cl:ifNotBlank value='${fieldValue(bean: instance, field: "phone")}'/>
        </div>

        <!-- contacts -->
        <g:render template="contacts" bean="${instance.getContactsPrimaryFirst()}"/>

        <!-- web site -->
        <g:if test="${instance.websiteUrl}">
          <div class="section">
            <h3>Web site</h3>
            <div class="webSite">
              <a class='external_icon' target="_blank" href="${instance.websiteUrl}">Visit the data provider's website</a>
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
            </g:if>
            <g:if test="${instance.isMemberOf('CHACM')}">
              <p>Member of Council of Heads of Australian Collections of Microorganisms (CHACM)</p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"chacm.png")}"/>
            </g:if>
          </div>
        </g:if>
      </div>


    </div><!--close column-two-->

  </div><!--close content-->

<script type="text/javascript">
// inject alternate server here
var biocacheUrl = "http://biocache.ala.org.au/";
var biocacheServicesUrl = "http://ala-bie1.vm.csiro.au:8080/biocache-service/";
// inject UID of hub here
var instanceUid = 'dp20';
// handy table for mapping between resource, institution/collection name and uid
var resourceTable = [
  {drName: 'Australian Museum provider for OZCAM', name:'Australian Museum', uid: 'in4'},
  {drName: 'South Australian Museum Australia provider for OZCAM', name:'South Australian Museum', uid: 'in22'},
  {drName: 'Western Australia Museum provider for OZCAM', name:'Western Australian Museum', uid: 'in34'},
  {drName: 'Museum Victoria provider for OZCAM', name:'Museum Victoria', uid: 'in16'},
  {drName: 'Australian National Wildlife Collection provider for OZCAM', name:'Australian National Wildlife Collection', uid: 'co16'},
  {drName: 'Northern Territory Museum and Art Gallery provider for OZCAM', name:'Northern Territory Museum and Art Gallery', uid: 'in17'},
  {drName: 'Queen Victoria Museum Art Gallery provider for OZCAM', name:'Queen Victoria Museum and Art Gallery', uid: 'in13'},
  {drName: 'Tasmanian Museum and Art Gallery provider for OZCAM', name:'Tasmanian Museum and Art Gallery', uid: 'in25'},
  {drName: 'Queensland Museum provider for OZCAM', name:'Queensland Museum', uid: 'in15'}
];
function getResourceByResourceName(name) {
  for (var i = 0; i < resourceTable.length; i++) {
    if (resourceTable[i].drName == name) {
      return resourceTable[i];
    }
  }
  return {};
}
function getResourceByName(name) {
  for (var i = 0; i < resourceTable.length; i++) {
    if (resourceTable[i].name == name) {
      return resourceTable[i];
    }
  }
  return {};
}
/************************************************************\
* Specify charts to load.
\************************************************************/
function onLoadCallback() {
  loadInstChart();

  // summary biocache data
  var url = biocacheServicesUrl + "occurrences/search.json?q=*:*&pageSize=0";
  $.ajax({
    url: "${ConfigurationHolder.config.grails.serverURL}/public/newBiocacheBreakdown.json",
    dataType: 'json',
    cache: false,
    error: function(jqXHR, textStatus, errorThrown) {
      alert(textStatus);
    },
    success: function(data) {
      //var facets = data.facetResults; // services version
      var facets = data.facetResults;
      var foundTypesData = false;
      var foundStatesData = false;
      for (var i = 0; i < facets.length; i++) {
        if (facets[i].fieldName == 'type_status') {
          drawTypesBreakdown(facets[i]);
          foundTypesData = true;
        }
        if (facets[i].fieldName == 'states') {
          drawStatesBreakdown(facets[i]);
          foundStatesData = true;
        }
      }
      if (!foundTypesData) {
        $('div#typesChart').css('display', 'none');
      }
      if (!foundStatesData) {
        $('div#statesChart').css('display', 'none');
      }
    }
  });

  // taxon chart
  loadTaxonChart("dp20",null,"phylum");  // start with all phyla

  loadRecordsAccumulation();
}
/************************************************************\
* Fire chart loading
\************************************************************/
google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(onLoadCallback);

  </script>

  </body>
</html>