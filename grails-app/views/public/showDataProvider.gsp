<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.DataProvider"%>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="ala" />
    <title>${fieldValue(bean: instance, field: "name")}</title>
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
        <div id="breadcrumb"><a  href="http://test.ala.org.au">Home</a> <a  href="http://test.ala.org.au/explore/">Explore</a> <g:link controller="public" action="map">Natural History Collections</g:link> <span class="current">${fieldValue(bean:instance,field:'name')}</span></div>
        <div class="section full-width">
          <div class="hrgroup col-8">
            <h1>${fieldValue(bean:instance,field:'name')}</h1>
            <g:if test="${instance.guid?.startsWith('urn:lsid:')}">
              <cite><a href="#lsidText" id="lsid" class="local" title="Life Science Identifier (pop-up)">LSID</a></cite>
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
          <div class="aside col-4">
            <!-- logo -->
            <g:if test="${fieldValue(bean: instance, field: 'logoRef') && fieldValue(bean: instance, field: 'logoRef.file')}">
              <img style="padding-bottom:5px; float:right; margin-top:0" src='${resource(absolute:"true", dir:"data/"+instance.urlForm()+"/",file:fieldValue(bean: instance, field: 'logoRef.file'))}' />
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
        <h2>Resources</h2>
        <ol>
          <g:each var="c" in="${instance.getResources()}">
            <li><g:link controller="public" action="show" id="${c.uid}">${c?.name}</g:link> ${c?.makeAbstract(400)}</li>
          </g:each>
        </ol>
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
              <cl:valueOrOtherwise value="${instance.address?.postBox}">${instance.address?.postBox}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.city}">${instance.address?.city}</cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.state}">${instance.address?.state}</cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.postcode}">${instance.address?.postcode}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.country}">${instance.address?.country}<br/></cl:valueOrOtherwise>
            </p>
          </g:if>
          <cl:ifNotBlank value='${fieldValue(bean: instance, field: "email")}'/>
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
              <img src="${resource(absolute:"true", dir:"data/network/",file:"amrrnlogo.png")}"/>
            </g:if>
          </div>
        </g:if>
      </div>


    </div><!--close column-two-->

  </div><!--close content-->
  </body>
</html>