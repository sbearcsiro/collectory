<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.ProviderGroup"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="ala" />
    <title>${fieldValue(bean: institution, field: "name")}</title>
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
      <div id="header" class="taxon" style="margin-bottom:15px;">
        <!--Breadcrumbs-->
        <div id="breadcrumb"><a  href="http://test.ala.org.au">Home</a> <a  href="http://test.ala.org.au/explore/">Explore</a> <g:link controller="public" action="map">Natural History Collections</g:link> <span class="current">${fieldValue(bean:institution,field:'name')}</span></div>
        <div class="section full-width">
          <div class="hrgroup col-9">
            <h1>${fieldValue(bean:institution,field:'name')}</h1>
            <g:if test="${institution.guid?.startsWith('urn:lsid:')}">
              <cite><a href="#lsidText" id="lsid" class="local" title="Life Science Identifier (pop-up)">LSID</a></cite>
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
          <div class="aside col-3">
            <!-- logo -->
            <g:if test="${fieldValue(bean: institution, field: 'logoRef') && fieldValue(bean: institution, field: 'logoRef.file')}">
              <img style="padding-bottom:5px; margin-right:20px; float:right; margin-top:0" src='${resource(absolute:"true", dir:"data/institution/",file:fieldValue(bean: institution, field: 'logoRef.file'))}' />
            </g:if>
          </div>
        </div>
      </div><!--close header-->
      <div id="column-one">
      <div class="section no-margin-top">
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
          <g:each var="c" in="${institution.getSafeChildren()}">
            <li><g:link controller="public" action="show" id="${c.id}">${c?.name}</g:link> ${c?.makeAbstract(400)}</li>
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
            <p class="caption">${fieldValue(bean: institution, field: "imageRef.caption")}</p>
            <p class="caption">${fieldValue(bean: institution, field: "imageRef.attribution")}</p>
            <p class="caption">${fieldValue(bean: institution, field: "imageRef.copyright")}</p>
          </div>
        </g:if>

        <g:if test="${institution.address != null && !institution.address.isEmpty()}">
          <div class="section">
            <h4>Location</h4>
            <cl:ifNotBlank value='${institution.address?.street}'/>
            <cl:ifNotBlank value='${institution.address?.postBox}'/>
            <cl:ifNotBlank value="${institution.address?.city}" value2="${institution.address?.state}" value3="${institution.address?.postcode}" join=" "/>
            <cl:ifNotBlank value='${institution.address?.country}'/>
            <cl:ifNotBlank value='${fieldValue(bean: institution, field: "email")}'/>
            <cl:ifNotBlank value='${fieldValue(bean: institution, field: "phone")}'/>
          </div>
        </g:if>

        <g:set var="contact" value="${institution.getPrimaryContact()}"/>
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
        <g:if test="${institution.websiteUrl}">
          <div class="section">
            <h4>Web site</h4>
            <div class="webSite">
              <a class='external_icon' target="_blank" href="${institution.websiteUrl}">Visit the institution's website</a>
            </div>
          </div>
        </g:if>

        <!-- network membership -->
        <g:if test="${institution.networkMembership}">
          <div class="section">
            <h4>Membership</h4>
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
            <g:if test="${institution.isMemberOf('AMRRN')}">
              <p>Member of Australian Microbial Resources Reseach Network (AMRRN)</p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"amrrnlogo.png")}"/>
            </g:if>
          </div>
        </g:if>
      </div>


    </div><!--close column-two-->

  </div><!--close content-->
  </body>
</html>