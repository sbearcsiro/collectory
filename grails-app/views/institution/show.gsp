
<%@ page import="au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'institution.label', default: 'Institution')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        <script type="text/javascript" src="http://www.google.com/jsapi?key=${grailsApplication.config.google.maps.v2.key}"></script>
    </head>
    <body onload="load();">
    <style>
    #mapCanvas {
      width: 200px;
      height: 170px;
      float: right;
    }
    </style>
        <div class="nav">
            <span class="menuButton"><cl:homeLink/></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            <span class="entityType" style="float:right;">Institution</span>
        </div>
        <div class="body">
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog emulate-public">
              <!-- base attributes -->
              <div class="show-section titleBlock">
                <!-- Name --><!-- Acronym -->
                <g:if test="${institutionInstance.name.size() > 50}">
                  <h1 style="display:inline;font-size:1.7em;">${fieldValue(bean: institutionInstance, field: "name")}<cl:valueOrOtherwise value="${institutionInstance.acronym}"> (${fieldValue(bean: institutionInstance, field: "acronym")})</cl:valueOrOtherwise></h1>
                  <cl:partner test="${institutionInstance.isALAPartner}"/><br/>
                </g:if>
                <g:else>
                  <h1 style="display:inline">${fieldValue(bean: institutionInstance, field: "name")}<cl:valueOrOtherwise value="${institutionInstance.acronym}"> (${fieldValue(bean: institutionInstance, field: "acronym")})</cl:valueOrOtherwise></h1>
                  <cl:partner test="${institutionInstance.isALAPartner}"/><br/>
                </g:else>
                <!-- Institutions -->
                <g:set var='parents' value="${institutionInstance.listParents()}"/>
                <g:if test="${parents}">
                  <g:each in="${parents}" var="p">
                    <h2 style="display:inline;font-size:1.2em"><g:link controller="institution" action="show" id="${p.uid}">${p.name}</g:link></h2>
                    <cl:partner test="${p.isALAPartner}"/><br/>
                  </g:each>
                </g:if>
                <!-- GUID    -->
                <p><span class="category">LSID</span>: <cl:guid target="_blank" guid='${fieldValue(bean: institutionInstance, field: "guid")}'/></p>

                <!-- UID    -->
                <p><span class="category">UID</span>: ${fieldValue(bean: institutionInstance, field: "uid")}</p>

                <!-- Web site -->
                <p><span class="category">Collection website</span>: <a target="_blank" href="${fieldValue(bean: institutionInstance, field: 'websiteUrl')}">${fieldValue(bean: institutionInstance, field: "websiteUrl")}</a></p>

                <!-- Networks -->
                <g:if test="${institutionInstance.networkMembership}">
                  <p><cl:membershipWithGraphics coll="${institutionInstance}"/></p>
                </g:if>

                <!-- Notes -->
                <g:if test="${institutionInstance.notes}">
                  <p><cl:formattedText>${fieldValue(bean: institutionInstance, field: "notes")}</cl:formattedText></p>
                </g:if>

                <!-- last edit -->
                <p><span class="category">Last change</span> ${fieldValue(bean: institutionInstance, field: "userLastModified")} on ${fieldValue(bean: institutionInstance, field: "lastUpdated")}</p>

                <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/base']" id="${institutionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- description -->
              <div class="show-section">
                <!-- Pub Desc -->
                <h2>Description</h2>
                <div class="source">[Public description]</div><div style="clear:both;"></div>
                <cl:formattedText>${fieldValue(bean: institutionInstance, field: "pubDescription")}</cl:formattedText>

                <!-- Tech Desc -->
                <div class="source">[Technical description]</div><div style="clear:both;"></div>
                <cl:formattedText>${fieldValue(bean: institutionInstance, field: "techDescription")}</cl:formattedText>

                <!-- Contribution -->
                <div class="source">[Contribution]</div><div style="clear:both;"></div>
                <cl:formattedText>${fieldValue(bean: institutionInstance, field: "focus")}</cl:formattedText>

                <!-- Institution type -->
                <p>Institution type is: ${fieldValue(bean: institutionInstance, field: "institutionType")}</p>

                <!-- Collections -->
                <h2>Collections</h2>
                <ul class='fancy'>
                  <g:each in="${institutionInstance.listCollections().sort{it.name}}" var="c">
                      <li><g:link controller="collection" action="show" id="${c.uid}">${c?.name}</g:link></li>
                  </g:each>
                  <li><g:link controller="collection" action="create" params='[institutionUid: "${institutionInstance.uid}"]'>create a new collection for this institution</g:link></li>
                </ul>

                <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'description']" id="${institutionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- images -->
              <div class="show-section">
                <!-- ImageRef -->
                  <h2>Logo</h2>
                  <g:if test="${fieldValue(bean: institutionInstance, field: 'logoRef.file')}">
                    <img class="showImage" alt="${fieldValue(bean: institutionInstance, field: "logoRef.file")}"
                        src="${resource(absolute: "true", dir: 'data/institution', file: institutionInstance.logoRef.file)}"/>
                    <p class="caption">${fieldValue(bean: institutionInstance, field: "logoRef.file")}</p>
                    <cl:formattedText pClass="caption">${fieldValue(bean: institutionInstance, field: "logoRef.caption")}</cl:formattedText>
                    <p class="caption">${fieldValue(bean: institutionInstance, field: "logoRef.attribution")}</p>
                    <p class="caption">${fieldValue(bean: institutionInstance, field: "logoRef.copyright")}</p>
                  </g:if>

                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/images',target:'logoRef']" id="${institutionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- images -->
              <div class="show-section">
                <!-- ImageRef -->
                  <h2>Representative Image</h2>
                  <g:if test="${fieldValue(bean: institutionInstance, field: 'imageRef.file')}">
                    <img class="showImage" alt="${fieldValue(bean: institutionInstance, field: "imageRef.file")}"
                        src="${resource(absolute: "true", dir: 'data/institution', file: institutionInstance.imageRef.file)}"/>
                    <p class="caption">${fieldValue(bean: institutionInstance, field: "imageRef.file")}</p>
                    <cl:formattedText pClass="caption">${fieldValue(bean: institutionInstance, field: "imageRef.caption")}</cl:formattedText>
                    <p class="caption">${fieldValue(bean: institutionInstance, field: "imageRef.attribution")}</p>
                    <p class="caption">${fieldValue(bean: institutionInstance, field: "imageRef.copyright")}</p>
                  </g:if>

                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/images',target:'imageRef']" id="${institutionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- location -->
              <g:render template="/shared/location" model="[instance: institutionInstance]"/>

              <!-- Contacts -->
              <div class="show-section">
                <h2>Contacts</h2>
                <ul class="fancy">
                  <g:each in="${contacts}" var="c">
                    <li><g:link controller="contact" action="show" id="${c?.contact?.id}">
                      ${c?.contact?.buildName()}
                      <cl:roleIfPresent role='${c?.role}'/>
                      <cl:adminIfPresent admin='${c?.administrator}'/>
                      ${c?.contact?.phone}
                      <cl:valueOrOtherwise value ="${c?.primaryContact}"> (Primary contact)</cl:valueOrOtherwise>
                    </g:link>
                    </li>
                  </g:each>
                </ul>
                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/showContacts']" id="${institutionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- Attributions -->
              <div class="show-section">
                <h2>Attributions</h2>
                <ul class="fancy">
                  <g:each in="${institutionInstance.getAttributionList()}" var="att">
                    <li>${att.name}</li>
                  </g:each>
                </ul>
                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/editAttributions']" id="${institutionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- change history -->
              <g:render template="/shared/changes" model="[changes: changes, instance: institutionInstance]"/>

            </div>
            <div class="buttons">
              <g:form>
                <g:hiddenField name="id" value="${institutionInstance?.id}"/>
                <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
                  <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
                </cl:ifGranted>
                <span class="button"><g:link class="preview" controller="public" action='show' id="${institutionInstance?.uid}">${message(code: 'default.button.preview.label', default: 'Preview')}</g:link></span>
              </g:form>
            </div>
        </div>
    <script type="text/javascript">

    var map;
    var marker;

    function load() {
        initialize();
    }

    function initialize() {
      if (${institutionInstance.canBeMapped()}) {
        var lat = ${institutionInstance.latitude};
        if (lat == undefined || lat == 0 || lat == -1 ) {lat = -35.294325779329654}
        var lng = ${institutionInstance.longitude};
        if (lng == undefined || lng == 0 || lng == -1 ) {lng = 149.10602960586547}
        var latLng = new google.maps.LatLng(lat, lng);
        map = new google.maps.Map(document.getElementById('mapCanvas'), {
          zoom: 14,
          center: latLng,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          scrollwheel: false
        });
        marker = new google.maps.Marker({
          position: latLng,
          title: 'Edit section to change pin location',
          map: map
        });
      } else {
        var middleOfAus = new google.maps.LatLng(-28.2,133);
        map = new google.maps.Map(document.getElementById('mapCanvas'), {
          zoom: 2,
          center: middleOfAus,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          draggable: false,
          disableDoubleClickZoom: true,
          scrollwheel: false
        });
      }
    }
    </script>
    </body>
</html>
