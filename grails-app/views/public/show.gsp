<%@ page import="java.text.DecimalFormat; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.InfoSource" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <title>${fieldValue(bean: collectionInstance, field: "name")}</title>
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
    </head>
    <body class="two-column-right">
      <div id="content">
        <div id="header" class="taxon" style="margin-bottom:15px;">
          <!--Breadcrumbs-->
          <div id="breadcrumb"><a  href="http://test.ala.org.au">Home</a> <a  href="http://test.ala.org.au/explore/">Explore</a> <g:link controller="public" action="map">Natural History Collections</g:link> <span class="current">${collectionInstance.name}</span></div>
          <div class="section full-width">
            <div class="hrgroup col-9">
              <h1 class="family"><i>${fieldValue(bean:collectionInstance,field:'name')}</i></h1>
              <g:set var="inst" value="${collectionInstance.findPrimaryInstitution()}"/>
              <g:if test="${inst}">
                <h2><g:link action="showInstitution" id="${inst.id}">${inst.name}</g:link></h2>
              </g:if>
              <cite><a href="#lsidText" id="lsid" class="local" title="Life Science Identifier (pop-up)">LSID</a></cite>
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
            <div class="aside col-2">
              <!-- institution -->
              <g:if test="${inst?.logoRef?.file}">
                <g:link action="showInstitution" id="${inst.id}">
                  <img style="padding-top: 10px; margin-right:0; float:right;" src='${resource(absolute:"true", dir:"data/institution/",file:fieldValue(bean: inst, field: 'logoRef.file'))}' />
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
            <div class="section no-margin-top">
              <h2>Description</h2>
              <cl:formattedText>${fieldValue(bean: collectionInstance, field: "pubDescription")}</cl:formattedText>
              <cl:formattedText>${fieldValue(bean: collectionInstance, field: "techDescription")}</cl:formattedText>
              <cl:temporalSpan start='${fieldValue(bean: collectionInstance, field: "scope.startDate")}' end='${fieldValue(bean: collectionInstance, field: "scope.endDate")}'/>

              <h2>Taxonomic range</h2>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'focus')}">
                <cl:formattedText>${fieldValue(bean: collectionInstance, field: "focus")}</cl:formattedText>
              </g:if>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.kingdomCoverage')}">
                <p>Kingdoms covered include: ${fieldValue(bean: collectionInstance, field: "scope.kingdomCoverage")}</p>
              </g:if>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.scientificNames')}">
                <p>Specimens in the ${collectionInstance.name} include members from the following taxa:<br/>
                <cl:JSONListAsList json='${fieldValue(bean: collectionInstance, field: "scope.scientificNames")}'/></p>
              </g:if>

              <g:if test="${collectionInstance.scope?.geographicDescription || collectionInstance.scope?.states}">
                <h2>Geographic range</h2>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.geographicDescription')}">
                  <p>${fieldValue(bean: collectionInstance, field: "scope.geographicDescription")}</p>
                </g:if>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.states')}">
                  <p><cl:stateCoverage states='${fieldValue(bean: collectionInstance, field: "scope.states")}'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.westCoordinate != -1}">
                  <p>The western most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.westCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.eastCoordinate != -1}">
                  <p>The eastern most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.eastCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.northCoordinate != -1}">
                  <p>The northtern most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.northCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.southCoordinate != -1}">
                  <p>The southern most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.southCoordinate}' degree='true'/></p>
                </g:if>
              </g:if>

              <h2>Number of specimens in the collection</h2>
              <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.numRecords') != '-1'}">
                <p>The estimated number of specimens within the ${collectionInstance.name}: ${fieldValue(bean: collectionInstance, field: "scope.numRecords")}.</p>
              </g:if>

              <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.numRecordsDigitised') != '-1'}">
                <h2>Number of digitised specimens</h2>
                <p>Of these ${fieldValue(bean: collectionInstance, field: "scope.numRecordsDigitised")} are digitised.
                This represents <cl:percentIfKnown dividend='${collectionInstance.scope?.numRecordsDigitised}' divisor='${collectionInstance.scope?.numRecords}' /> of the collection.</p>
              </g:if>

              <g:if test="${collectionInstance.scope.listSubCollections()?.size() > 0}">
                <h2>Sub-collections</h2>
                <p>The <cl:collectionName name="${collectionInstance.name}"/> contains these significant collections:</p>
                <g:each var="sub" in="${collectionInstance.scope.listSubCollections()}" >
                  <p class="sub"><cl:subCollectionDisplay sub="${sub}"/></p>
                </g:each>
              </g:if>
            </div><!--close section-->
          </div><!--close column-one-->

          <div id="column-two">
            <div class="section sidebar">
              <g:if test="${fieldValue(bean: collectionInstance, field: 'imageRef') && fieldValue(bean: collectionInstance, field: 'imageRef.file')}">
                <div class="section">
                  <img alt="${fieldValue(bean: collectionInstance, field: "imageRef.file")}"
                          src="${resource(absolute:"true", dir:"data/collection/", file:collectionInstance.imageRef.file)}" />
                  <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.caption")}</p>
                  <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.attribution")}</p>
                  <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.copyright")}</p>
                </div>
              </g:if>

              <div class="section">
                <h4>Location</h4>
                <!-- use parent location if the collection is blank -->
                <g:set var="address" value="${collectionInstance.address}"/>
                <g:if test="${address == null || address.isEmpty()}">
                  <g:if test="${collectionInstance.findPrimaryInstitution()}">
                    <g:set var="address" value="${collectionInstance.findPrimaryInstitution().address}"/>
                  </g:if>
                </g:if>

                <cl:ifNotBlank value='${address?.street}'/>
                <cl:ifNotBlank value='${address?.postBox}'/>
                <cl:ifNotBlank value="${address?.city}" value2="${address?.state}" value3="${address?.postcode}" join=" "/>
                <cl:ifNotBlank value='${address?.country}'/>

                <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "email")}'/>
                <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "phone")}'/>
              </div>

              <g:set var="contact" value="${collectionInstance.getPrimaryContact()}"/>
              <g:if test="${contact}">
                <div class="section">
                  <h4>Contact</h4>
                  <p class="contactName">${contact?.contact?.buildName()}</p>
                  <p>${contact?.role}</p>
                  <cl:ifNotBlank prefix="phone: " value='${fieldValue(bean: contact, field: "contact.phone")}'/>
                  <cl:ifNotBlank prefix="fax: " value='${fieldValue(bean: contact, field: "contact.fax")}'/>
                  <p>email: <cl:emailLink>${contact?.contact?.email}</cl:emailLink></p>
                </div>
              </g:if>

              <!-- web site -->
              <g:if test="${collectionInstance.websiteUrl}">
                <div class="section">
                  <h4>Web site</h4>
                  <div class="webSite">
                    <a class='external_icon' target="_blank" href="${collectionInstance.websiteUrl}">Visit the collection's website</a>
                  </div>
                </div>
              </g:if>

              <!-- network membership -->
              <g:if test="${collectionInstance.networkMembership}">
                <div class="section">
                  <h4>Membership</h4>
                  <g:if test="${collectionInstance.isMemberOf('CHAEC')}">
                    <p>Member of Council of Heads of Australian Entomological Collections (CHAEC)</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"butflyyl.gif")}"/>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('CHAH')}">
                    <p>Member of Council of Heads of Australasian Herbaria (CHAH)</p>
                    <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('CHAFC')}">
                    <p>Member of Council of Heads of Australian Faunal Collections (CHAFC)</p>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('AMRRN')}">
                    <p>Member of Australian Microbial Resources Reseach Network (AMRRN)</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"amrrnlogo.png")}"/>
                  </g:if>
                </div>
              </g:if>
            </div>
          </div>
          </div><!--overview-->
          <div id="statistics" class="ui-tabs-panel ui-tabs-hide">
            <div class="section">
              <h2>Digitised specimen records</h2>
              <div style="float:left;">
                <g:if test="${numBiocacheRecords != -1}">
                  <p>The ALA holds <cl:numberOf number="${numBiocacheRecords}" noun="specimen record"/> for the ${cl.collectionName(name: collectionInstance.name)}.</p>
                  <g:if test="${percentBiocacheRecords != -1}">
                    <p>This represents ${cl.formatPercent(percent: percentBiocacheRecords)}% of all specimens in the collection.</p>
                  </g:if>
                </g:if>
                <cl:recordsLink collection="${collectionInstance}">Click to view records for the ${cl.collectionName(name: collectionInstance.name)}.
                </cl:recordsLink>
              </div>
              <div style="float:right;text-align:center;padding-right:60px;margin-top:-20px;">
                <g:if test="${percentBiocacheRecords != -1}">
                  <img src="http://chart.apis.google.com/chart?chs=200x90&cht=gm&chd=t:${percentBiocacheRecords}" width="200" height="90" alt="% of specimens available as digitised records" />
                  <p class="caption"><cl:formatPercent percent="${percentBiocacheRecords}"/>% of records<br/>available for viewing.</p>
                </g:if>
              </div>
            </div>
            <div class="section">
              <h3>Statistics of digitised specimens in this collection.</h3>
              <div><p>Static example charts - not actual data!</p>
                <img src="http://chart.apis.google.com/chart?chxl=1:|1950|1960|1970|1980|1990|2000|2010&chxr=0,0,4000&chxt=y,x&chbh=a,4,35&chs=300x225&cht=bvs&chco=A2C180&chd=s:uZOQLVS&chdlp=l&chtt=Specimens+added+per+decade" width="300" height="225" alt="Specimens added per decade" />
                <img src="http://chart.apis.google.com/chart?chs=400x225&cht=p3&chco=7777CC|76A4FB|3399CC|3366CC&chd=s:QEHCVfe&chdl=Angiosperms|Dicots|Monocots|Gymnosperms|Pteridophytes|Mosses|Algae&chdlp=t&chp=12.7&chl=Angiosperms|Dicots|Monocots|Gymnosperms|Pteridophytes|Mosses|Algae&chma=0,0,30,10" width="400" height="225" alt="" />
              </div>
            </div>
          </div>
        </div>
    </body>
</html>
