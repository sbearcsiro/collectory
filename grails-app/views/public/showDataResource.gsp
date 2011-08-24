<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; java.text.DecimalFormat; java.text.SimpleDateFormat" %>
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
          <div id="breadcrumb"><cl:breadcrumbTrail home="dataSets"/>
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
            <g:if test="${instance.pubDescription || instance.techDescription || instance.focus}">
                <h2>Description</h2>
            </g:if>
            <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>
            <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>
            <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>
            <cl:dataResourceContribution resourceType="${instance.resourceType}" status="${instance.status}" tag="p"/>

            <g:if test="${instance.contentTypes}">
              <h2>Type of content</h2>
              <cl:contentTypes types="${instance.contentTypes}"/>
            </g:if>
            <h2>Citation</h2>
            <g:if test="${instance.citation}">
              <cl:formattedText>${fieldValue(bean: instance, field: "citation")}</cl:formattedText>
            </g:if>
            <g:else>
              <p>No citation information available.</p>
            </g:else>

            <g:if test="${instance.rights}">
              <h2>Rights</h2>
              <g:if test="${instance.creativeCommons}">
                <p>${fieldValue(bean: instance, field: "rights")}<cl:displayLicenseType type="${instance.licenseType}" version="${instance.licenseVersion}" imageOnly="true"/></p>
              </g:if>
              <g:else>
                <cl:formattedText>${fieldValue(bean: instance, field: "rights")}</cl:formattedText>
              </g:else>
            </g:if>
            
            <g:if test="${instance.dataGeneralizations}">
              <h2>Data generalisations</h2>
              <cl:formattedText>${fieldValue(bean: instance, field: "dataGeneralizations")}</cl:formattedText>
            </g:if>

            <g:if test="${instance.informationWithheld}">
              <h2>Information withheld</h2>
              <cl:formattedText>${fieldValue(bean: instance, field: "informationWithheld")}</cl:formattedText>
            </g:if>

            <g:if test="${instance.downloadLimit}">
              <h2>Limited downloads</h2>
              <p>Downloads from this data resource are limited to ${fieldValue(bean: instance, field: "downloadLimit")} records.</p>
            </g:if>

            <g:if test="${instance.resourceType == 'website' && (instance.lastChecked || instance.dataCurrency)}">
              <h2>Data currency</h2>
                <p><cl:lastChecked date="${instance.lastChecked}"/>
                <cl:dataCurrency date="${instance.dataCurrency}"/></p>
            </g:if>

            <g:if test="${instance.resourceType == 'website' || instance.resourceType == 'records' }">
              <div id='usage-stats'>
                  <h2>Usage statistics</h2>
                  <div id='usage'>
                    <p>Loading...</p>
                  </div>
              </div>
            </g:if>

            <g:if test="${instance.resourceType == 'website'}">
                <div id="usage-visualization" style="width: 600px; height: 200px;"></div>
            </g:if>

            <g:if test="${instance.resourceType == 'records'}">
                <h2>Digitised records</h2>
                <div>
                  <p><span id="numBiocacheRecords">Looking up... the number of records that</span> can be accessed through the Atlas of Living Australia.
                  <cl:lastChecked date="${instance.lastChecked}"/>
                  <cl:dataCurrency date="${instance.dataCurrency}"/>
                  </p>
                  <cl:recordsLink collection="${instance}">Click to view records for the ${instance.name} resource.</cl:recordsLink>
                </div>
            </g:if>
          </div>
          <g:if test="${instance.resourceType == 'records'}">
              <div class="section vertical-charts">
                <h3>Map of records</h3>
                <cl:recordsMap/>
                <h3>Records by taxonomic group</h3>
                <cl:taxonChart uid="${instance.uid}"/>
                <h3>Records by collection date</h3>
                <cl:decadeChart/>
              </div>
          </g:if>
          <cl:lastUpdated date="${instance.lastUpdated}"/>
        </div><!--close column-one-->

        <div id="column-two">
          <div class="section sidebar">
            <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
              <div class="section">
                <img alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                        src="${resource(absolute:"true", dir:"data/dataResource/", file:instance.imageRef.file)}" />
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

            <!-- contacts -->
            <g:set var="contacts" value="${instance.getPublicContactsPrimaryFirst()}"/>
            <g:if test="${!contacts}">
              <g:set var="contacts" value="${instance.dataProvider?.getContactsPrimaryFirst()}"/>
            </g:if>
            <g:render template="contacts" bean="${contacts}"/>

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
        *
        \************************************************************/
        function onLoadCallback() {
          // stats
          if (${instance.resourceType == 'website'}) {
              loadDownloadStats("${instance.uid}","${instance.name}", "2000");
          } else if (${instance.resourceType == 'records'}) {
              loadDownloadStats("${instance.uid}","${instance.name}", "1002");
          }

          // records
          if (${instance.resourceType == 'records'}) {
              // summary biocache data
              var biocacheRecordsUrl = "${ConfigurationHolder.config.grails.context}/public/biocacheRecords.json?uid=${instance.uid}";
              $.get(biocacheRecordsUrl, {}, biocacheRecordsHandler);

              // taxon chart
              loadTaxonChart("${ConfigurationHolder.config.grails.context}", "${instance.uid}", 25);

              // records map
              var mapServiceUrl = "${ConfigurationHolder.config.grails.context}/public/recordsMapService?uid=${instance.uid}";
              $.get(mapServiceUrl, {}, mapRequestHandler);
          }
       }
        /************************************************************\
        *
        \************************************************************/
        function biocacheRecordsHandler(response) {
          if (response.error == undefined) {
            setNumbers(response.totalRecords);
            drawDecadeChart(response.decades, "${instance.uid}");
          } else {
            setNumbers(0);
            $('div#decadeChart').css("display","none");
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

        // define biocache server
        biocacheUrl = "${ConfigurationHolder.config.biocache.baseURL}";
        biocacheRecordsUrl = "${ConfigurationHolder.config.biocache.records.url}";
        useNewBiocache = ${ConfigurationHolder.config.useNewBiocache == 'true'};

        google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(onLoadCallback);

      </script>
    </body>
</html>
