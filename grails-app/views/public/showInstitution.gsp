<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.DataResource; org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.Institution"%>
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
            <g:set var="parents" value="${instance.listParents()}"/>
            <g:each var="p" in="${parents}">
              <h2 style="font-size:1.5em;"><g:link action="show" id="${p.uid}">${p.name}</g:link></h2>
            </g:each>
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
              <img class="institutionImage" src='${resource(absolute:"true", dir:"data/institution/",file:fieldValue(bean: instance, field: 'logoRef.file'))}' />
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
        <h2>Collections</h2>
        <ol>
          <g:each var="c" in="${instance.listCollections().sort{it.name}}">
            <li><g:link controller="public" action="show" id="${c.uid}">${c?.name}</g:link> ${c?.makeAbstract(400)}</li>
          </g:each>
        </ol>

        <g:if test="${false}">
          <div id='usage-stats'>
            <h2>Usage statistics</h2>
            <div id='usage'>
              <p>Loading...</p>
            </div>
          </div>
        </g:if>

        <g:if test="${ConfigurationHolder.config.ui.showChartsForInstitutions != 'false'}">
          <h2>Digitised records</h2>
          <div>
            <p style="padding-bottom:8px;"><span id="numBiocacheRecords">Looking up... the number of records that</span> can be accessed through the Atlas of Living Australia.</p>
            <cl:recordsLink entity="${instance}">Click to view records for the ${instance.name}.</cl:recordsLink>
          </div>
          <div class="section vertical-charts">
            <h3>Records by taxonomic group</h3>
            <cl:taxonChart uid="${instance.descendantUids().join(',')}"/>
            <h3>Records by collection date</h3>
            <cl:decadeChart/>
          </div>
        </g:if>

        <cl:lastUpdated date="${instance.lastUpdated}"/>

      </div><!--close section-->
    </div><!--close column-one-->

    <div id="column-two">
      <div class="section sidebar">
        <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
          <div class="section">
            <img alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                    src="${resource(absolute:"true", dir:"data/institution/", file:instance.imageRef.file)}" />
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
      <g:render template="contacts" bean="${instance.getPublicContactsPrimaryFirst()}"/>

        <!-- web site -->
        <g:if test="${instance.websiteUrl}">
          <div class="section">
            <h3>Web site</h3>
            <div class="webSite">
              <a class='external' target="_blank" href="${instance.websiteUrl}">Visit the <cl:institutionType inst="${instance}"/>'s website</a>
            </div>
          </div>
        </g:if>

        <!-- network membership -->
        <g:if test="${instance.networkMembership}">
          <div class="section">
            <h3>Membership</h3>
            <g:if test="${instance.isMemberOf('CHAEC')}">
              <p>Council of Heads of Australian Entomological Collections (CHAEC)</p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"chaec-logo.png")}"/>
            </g:if>
            <g:if test="${instance.isMemberOf('CHAH')}">
              <p>Council of Heads of Australasian Herbaria (CHAH)</p>
              <a target="_blank" href="http://www.chah.gov.au"><img style="padding-left:25px;" src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
            </g:if>
            <g:if test="${instance.isMemberOf('CHAFC')}">
              <p>Council of Heads of Australian Faunal Collections (CHAFC)</p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"CHAFC_sm.jpg")}"/>
            </g:if>
            <g:if test="${instance.isMemberOf('CHACM')}">
              <p>Council of Heads of Australian Collections of Microorganisms (CHACM)</p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"chacm.png")}"/>
            </g:if>
          </div>
        </g:if>
      </div>


    </div><!--close column-two-->

  </div><!--close content-->
<script type="text/javascript">

/************************************************************\
* Actions when page is loaded
\************************************************************/
function onLoadCallback() {

  // stats
  //loadDownloadStats("${instance.uid}","${instance.name}", "1002");

  var showStats = true;
  if ("${ConfigurationHolder.config.ui.showChartsForInstitutions}" == "false") {
    showStats = false;
  }

  if (showStats) {
    // summary biocache data
    var biocacheRecordsUrl = "${ConfigurationHolder.config.grails.context}/public/biocacheRecords.json?uid=${instance.descendantUids().join(',')}";
    $.get(biocacheRecordsUrl, {}, biocacheRecordsHandler);

    // taxon chart
    loadTaxonChart("${ConfigurationHolder.config.grails.context}", "${instance.descendantUids().join(',')}", 55);

  }
}
/************************************************************\
*
\************************************************************/
function biocacheRecordsHandler(response) {
  if (response.error == undefined && response.totalRecords > 0) {
    setNumbers(response.totalRecords);
    drawDecadeChart(response.decades, "${instance.descendantUids().join(',')}");
  } else {
    setNumbers(0);
    $('a.recordsLink').css("display","none");
    $('div#decadeChart').css("display","none");
    $('div.vertical-charts').css("display","none");
  }
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