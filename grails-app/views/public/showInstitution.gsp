<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.Institution"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="ala" />
    <title><cl:pageTitle>${fieldValue(bean: institution, field: "name")}</cl:pageTitle></title>
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
  </head>
  <body class="two-column-right">
    <div id="content">
      <div id="header" class="collectory">
        <!--Breadcrumbs-->
        <div id="breadcrumb"><a  href="http://test.ala.org.au">Home</a> <a  href="http://test.ala.org.au/explore/">Explore</a> <g:link controller="public" action="map">Natural History Collections</g:link> <span class="current">${fieldValue(bean:institution,field:'name')}</span></div>
        <div class="section full-width">
          <div class="hrgroup col-8">
            <h1>${fieldValue(bean:institution,field:'name')}</h1>
            <g:set var="parents" value="${institution.listParents()}"/>
            <g:each var="p" in="${parents}">
              <h2 style="font-size:1.5em;"><g:link action="show" id="${p.uid}">${p.name}</g:link></h2>
            </g:each>
            <cl:valueOrOtherwise value="${institution.acronym}"><span class="acronym">Acronym: ${fieldValue(bean: institution, field: "acronym")}</span></cl:valueOrOtherwise>
            <g:if test="${institution.guid?.startsWith('urn:lsid:')}">
              <span class="lsid"><a href="#lsidText" id="lsid" class="local" title="Life Science Identifier (pop-up)">LSID</a></span>
              <div style="display:none; text-align: left;">
                  <div id="lsidText" style="text-align: left;">
                      <b><a class="external_icon" href="http://lsids.sourceforge.net/" target="_blank">Life Science Identifier (LSID):</a></b>
                      <p style="margin: 10px 0;"><cl:guid target="_blank" guid='${fieldValue(bean: institution, field: "guid")}'/></p>
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
            <g:if test="${fieldValue(bean: institution, field: 'logoRef') && fieldValue(bean: institution, field: 'logoRef.file')}">
              <img class="institutionImage" src='${resource(absolute:"true", dir:"data/institution/",file:fieldValue(bean: institution, field: 'logoRef.file'))}' />
            </g:if>
          </div>
        </div>
      </div><!--close header-->
      <div id="column-one">
      <div class="section">
        <g:if test="${institution.pubDescription}">
          <h2>Description</h2>
          <cl:formattedText>${fieldValue(bean: institution, field: "pubDescription")}</cl:formattedText>
          <cl:formattedText>${fieldValue(bean: institution, field: "techDescription")}</cl:formattedText>
        </g:if>
        <g:if test="${institution.focus}">
          <h2>Contribution to the Atlas</h2>
          <cl:formattedText>${fieldValue(bean: institution, field: "focus")}</cl:formattedText>
        </g:if>
        <h2>Collections</h2>
        <ol>
          <g:each var="c" in="${institution.listCollections().sort{it.name}}">
            <li><g:link controller="public" action="show" id="${c.uid}">${c?.name}</g:link> ${c?.makeAbstract(400)}</li>
          </g:each>
        </ol>
      </div><!--close section-->
    </div><!--close column-one-->

    <div id="column-two">
      <div class="section sidebar">
        <g:if test="${fieldValue(bean: institution, field: 'imageRef') && fieldValue(bean: institution, field: 'imageRef.file')}">
          <div class="section">
            <img alt="${fieldValue(bean: institution, field: "imageRef.file")}"
                    src="${resource(absolute:"true", dir:"data/institution/", file:institution.imageRef.file)}" />
            <cl:formattedText pClass="caption">${fieldValue(bean: institution, field: "imageRef.caption")}</cl:formattedText>
            <cl:valueOrOtherwise value="${institution.imageRef?.attribution}"><p class="caption">${fieldValue(bean: institution, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${institution.imageRef?.copyright}"><p class="caption">${fieldValue(bean: institution, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
          </div>
        </g:if>

        <div class="section">
          <h3>Location</h3>
          <g:if test="${institution.address != null && !institution.address.isEmpty()}">
            <p>
              <cl:valueOrOtherwise value="${institution.address?.street}">${institution.address?.street}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${institution.address?.city}">${institution.address?.city}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${institution.address?.state}">${institution.address?.state}</cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${institution.address?.postcode}">${institution.address?.postcode}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${institution.address?.country}">${institution.address?.country}<br/></cl:valueOrOtherwise>
            </p>
          </g:if>
          <g:if test="${institution.email}"><cl:emailLink>${fieldValue(bean: institution, field: "email")}</cl:emailLink><br/></g:if>
          <cl:ifNotBlank value='${fieldValue(bean: institution, field: "phone")}'/>
        </div>

      <!-- contacts -->
      <g:set var="contacts" value="${institution.getContactsPrimaryFirst()}"/>
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
        <g:if test="${institution.websiteUrl}">
          <div class="section">
            <h3>Web site</h3>
            <div class="webSite">
              <a class='external_icon' target="_blank" href="${institution.websiteUrl}">Visit the institution's website</a>
            </div>
          </div>
        </g:if>

        <!-- network membership -->
        <g:if test="${institution.networkMembership}">
          <div class="section">
            <h3>Membership</h3>
            <g:if test="${institution.isMemberOf('CHAEC')}">
              <p>Member of Council of Heads of Australian Entomological Collections (CHAEC)</p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"butflyyl.gif")}"/>
            </g:if>
            <g:if test="${institution.isMemberOf('CHAH')}">
              <p>Member of Council of Heads of Australasian Herbaria (CHAH)</p>
              <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
            </g:if>
            <g:if test="${institution.isMemberOf('CHAFC')}">
              <p>Member of Council of Heads of Australian Faunal Collections (CHAFC)</p>
            </g:if>
            <g:if test="${institution.isMemberOf('CHACM')}">
              <p>Member of Council of Heads of Australian Collections of Microorganisms (CHACM)</p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"amrrnlogo.png")}"/>
            </g:if>
          </div>
        </g:if>
      </div>


    </div><!--close column-two-->

  </div><!--close content-->
  </body>
</html>