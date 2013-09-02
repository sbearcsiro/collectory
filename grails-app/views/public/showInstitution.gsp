<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.DataResource; au.org.ala.collectory.Institution" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="${grailsApplication.config.ala.skin}"/>
    <title><cl:pageTitle>${fieldValue(bean: instance, field: "name")}</cl:pageTitle></title>
    <script type="text/javascript">
        biocacheServicesUrl = "${grailsApplication.config.biocache.baseURL}ws";
        biocacheWebappUrl = "${grailsApplication.config.biocache.baseURL}";
        $(document).ready(function () {
            $("a#lsid").fancybox({
                'hideOnContentClick': false,
                'titleShow': false,
                'autoDimensions': false,
                'width': 600,
                'height': 180
            });
            $("a.current").fancybox({
                'hideOnContentClick': false,
                'titleShow': false,
                'titlePosition': 'inside',
                'autoDimensions': true,
                'width': 300
            });
        });
    </script>
    <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
    <r:require modules="fancybox, jquery_jsonp, charts"/>
</head>

<body>
<div id="content">
    <div id="header" class="collectory">
        <!--Breadcrumbs-->
        <div id="breadcrumb">
            <ol class="breadcrumb">
                <li><cl:breadcrumbTrail/> <span class=" icon icon-arrow-right"></span></li>
                <li><cl:pageOptionsLink>${fieldValue(bean:instance,field:'name')}</cl:pageOptionsLink></li>
            </ol>
        </div>
        <cl:pageOptionsPopup instance="${instance}"/>
        <div class="row-fluid">
            <div class="span8">
                <cl:h1 value="${instance.name}"/>
                <g:set var="parents" value="${instance.listParents()}"/>
                <g:each var="p" in="${parents}">
                    <h2><g:link action="show" id="${p.uid}">${p.name}</g:link></h2>
                </g:each>
                <cl:valueOrOtherwise value="${instance.acronym}"><span
                        class="acronym">Acronym: ${fieldValue(bean: instance, field: "acronym")}</span></cl:valueOrOtherwise>
                <g:if test="${instance.guid?.startsWith('urn:lsid:')}">
                    <span class="lsid"><a href="#lsidText" id="lsid" class="local"
                                          title="Life Science Identifier (pop-up)">LSID</a></span>

                    <div style="display:none; text-align: left;">
                        <div id="lsidText" style="text-align: left;">
                            <b><a class="external_icon" href="http://lsids.sourceforge.net/"
                                  target="_blank">Life Science Identifier (LSID):</a></b>

                            <p><cl:guid target="_blank"
                                                                guid='${fieldValue(bean: instance, field: "guid")}'/></p>

                            <p>LSIDs are persistent, location-independent,resource identifiers for uniquely naming biologically
                            significant resources including species names, concepts, occurrences, genes or proteins,
                            or data objects that encode information about them. To put it simply,
                            LSIDs are a way to identify and locate pieces of biological information on the web.</p>
                        </div>
                    </div>
                </g:if>
            </div>

            <div class="span4">
                <g:if test="${fieldValue(bean: instance, field: 'logoRef') && fieldValue(bean: instance, field: 'logoRef.file')}">
                    <img class="institutionImage"
                         src='${resource(absolute: "true", dir: "data/institution/", file: fieldValue(bean: instance, field: 'logoRef.file'))}'/>
                </g:if>
            </div>
        </div>
    </div><!--close header-->
    <div class="row-fluid">
            <div class="span8">
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
                    <g:each var="c" in="${instance.listCollections().sort { it.name }}">
                        <li><g:link controller="public" action="show"
                                    id="${c.uid}">${c?.name}</g:link> ${c?.makeAbstract(400)}</li>
                    </g:each>
                </ol>

                <div id='usage-stats'>
                    <h2>Usage statistics</h2>

                    <div id='usage'>
                        <p>Loading...</p>
                    </div>
                </div>

                <h2>Digitised records</h2>

                <div>
                    <p style="padding-bottom:8px;"><span
                            id="numBiocacheRecords">Looking up... the number of records that</span> can be accessed through the Atlas of Living Australia.
                    </p>
                    <cl:recordsLink
                            entity="${instance}">Click to view records for the ${instance.name}.</cl:recordsLink>
                </div>

                <div id="recordsBreakdown" class="section vertical-charts">
                    <div id="charts"></div>
                </div>

                <cl:lastUpdated date="${instance.lastUpdated}"/>

            </div><!--close section-->
            <div class="span4">
                <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
                    <div class="section">
                        <img alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                             src="${resource(absolute: "true", dir: "data/institution/", file: instance.imageRef.file)}"/>
                        <cl:formattedText
                                pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
                        <cl:valueOrOtherwise value="${instance.imageRef?.attribution}"><p
                                class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
                        <cl:valueOrOtherwise value="${instance.imageRef?.copyright}"><p
                                class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
                    </div>
                </g:if>

                <div class="section">
                    <h3>Location</h3>
                    <g:if test="${instance.address != null && !instance.address.isEmpty()}">
                        <p>
                            <cl:valueOrOtherwise
                                    value="${instance.address?.street}">${instance.address?.street}<br/></cl:valueOrOtherwise>
                            <cl:valueOrOtherwise
                                    value="${instance.address?.city}">${instance.address?.city}<br/></cl:valueOrOtherwise>
                            <cl:valueOrOtherwise
                                    value="${instance.address?.state}">${instance.address?.state}</cl:valueOrOtherwise>
                            <cl:valueOrOtherwise
                                    value="${instance.address?.postcode}">${instance.address?.postcode}<br/></cl:valueOrOtherwise>
                            <cl:valueOrOtherwise
                                    value="${instance.address?.country}">${instance.address?.country}<br/></cl:valueOrOtherwise>
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
                            <a class='external' target="_blank"
                               href="${instance.websiteUrl}">Visit the <cl:institutionType
                                    inst="${instance}"/>'s website</a>
                        </div>
                    </div>
                </g:if>

            <!-- network membership -->
                <g:if test="${instance.networkMembership}">
                    <div class="section">
                        <h3>Membership</h3>
                        <g:if test="${instance.isMemberOf('CHAEC')}">
                            <p>Council of Heads of Australian Entomological Collections (CHAEC)</p>
                            <img src="${resource(absolute: "true", dir: "data/network/", file: "chaec-logo.png")}"/>
                        </g:if>
                        <g:if test="${instance.isMemberOf('CHAH')}">
                            <p>Council of Heads of Australasian Herbaria (CHAH)</p>
                            <a target="_blank" href="http://www.chah.gov.au"><img style="padding-left:25px;"
                                                                                  src="${resource(absolute: "true", dir: "data/network/", file: "CHAH_logo_col_70px_white.gif")}"/>
                            </a>
                        </g:if>
                        <g:if test="${instance.isMemberOf('CHAFC')}">
                            <p>Council of Heads of Australian Faunal Collections (CHAFC)</p>
                            <img src="${resource(absolute: "true", dir: "data/network/", file: "CHAFC_sm.jpg")}"/>
                        </g:if>
                        <g:if test="${instance.isMemberOf('CHACM')}">
                            <p>Council of Heads of Australian Collections of Microorganisms (CHACM)</p>
                            <img src="${resource(absolute: "true", dir: "data/network/", file: "chacm.png")}"/>
                        </g:if>
                    </div>
                </g:if>
            </div>
        </div><!--close content-->
</div>
<r:script type="text/javascript">
      // configure the charts
      var facetChartOptions = {
          backgroundColor: "#fffef7",
          /* base url of the collectory */
          collectionsUrl: "${grailsApplication.config.grails.serverURL}",
          /* base url of the biocache ws*/
          biocacheServicesUrl: biocacheServicesUrl,
          /* base url of the biocache webapp*/
          biocacheWebappUrl: biocacheWebappUrl,
          /* a uid or list of uids to chart - either this or query must be present
            (unless the facet data is passed in directly AND clickThru is set to false) */
          instanceUid: "${instance.descendantUids().join(',')}",
          /* the list of charts to be drawn (these are specified in the one call because a single request can get the data for all of them) */
          charts: ['country','state','species_group','assertions','type_status',
              'biogeographic_region','state_conservation','occurrence_year']
      }
      var taxonomyChartOptions = {
          backgroundColor: "#fffef7",
          /* base url of the collectory */
          collectionsUrl: "${grailsApplication.config.grails.serverURL}",
          /* base url of the biocache ws*/
          biocacheServicesUrl: biocacheServicesUrl,
          /* base url of the biocache webapp*/
          biocacheWebappUrl: biocacheWebappUrl,
          /* a uid or list of uids to chart - either this or query must be present */
          instanceUid: "${instance.descendantUids().join(',')}",
          /* threshold value to use for automagic rank selection - defaults to 55 */
          threshold: 55,
          rank: "${instance.startingRankHint()}"
      }

    /************************************************************\
    * Actions when page is loaded
    \************************************************************/
    function onLoadCallback() {

      // stats
      loadDownloadStats("${instance.uid}","${instance.name}", "1002");

      // records
      $.ajax({
        url: urlConcat(biocacheServicesUrl, "/occurrences/search.json?pageSize=0&q=") + buildQueryString("${instance.descendantUids().join(',')}"),
        dataType: 'jsonp',
        timeout: 20000,
        complete: function(jqXHR, textStatus) {
            if (textStatus == 'timeout') {
                noData();
                alert('Sorry - the request was taking too long so it has been cancelled.');
            }
            if (textStatus == 'error') {
                noData();
                alert('Sorry - the records breakdowns are not available due to an error.');
            }
        },
        success: function(data) {
            // check for errors
            if (data.length == 0 || data.totalRecords == undefined || data.totalRecords == 0) {
                noData();
            } else {
                setNumbers(data.totalRecords);
                // draw the charts
                drawFacetCharts(data, facetChartOptions);
            }
        }
      });

      // taxon chart
      loadTaxonomyChart(taxonomyChartOptions);
    }
    /************************************************************\
    *
    \************************************************************/
    // define biocache server
    biocacheServicesUrl = "${grailsApplication.config.biocache.baseURL}ws";
    biocacheWebappUrl = "${grailsApplication.config.biocache.baseURL}";

    google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(onLoadCallback);

</r:script>
</body>
</html>