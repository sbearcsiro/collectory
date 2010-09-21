<%@ page import="au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${instance.ENTITY_TYPE}" />
        <g:set var="entityNameLower" value="${cl.controller(type: instance.ENTITY_TYPE)}"/>
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
            <span class="entityType" style="float:right;">Data Resource</span>
        </div>
        <div class="body">
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog emulate-public">
              <!-- base attributes -->
              <div class="show-section titleBlock">
                <!-- Name --><!-- Acronym -->
                <h1>${fieldValue(bean: instance, field: "name")}<cl:valueOrOtherwise value="${instance.acronym}"> (${fieldValue(bean: instance, field: "acronym")})</cl:valueOrOtherwise></h1>

                <!-- Data Provider --><!-- ALA Partner -->
                <h2 style="display:inline"><g:link controller="dataProvider" action="show" id="${instance.dataProvider?.id}">${instance.dataProvider?.name}</g:link></h2>
                <cl:partner test="${instance.dataProvider?.isALAPartner}"/><br/>

                <!-- Institution -->
                <g:if test="${instance.institution}">
                  <p><span class="category">Source of records</span>: <g:link controller="institution" action="show" id="${instance.institution?.id}">${instance.institution?.name}</g:link></p>
                </g:if>

                <!-- GUID    -->
                <p><span class="category">LSID</span>: <cl:guid target="_blank" guid='${fieldValue(bean: instance, field: "guid")}'/></p>

                <!-- UID    -->
                <p><span class="category">UID</span>: ${fieldValue(bean: instance, field: "uid")}</p>

                <!-- Web site -->
                <p><span class="category">Collection website</span>: <a target="_blank" href="${fieldValue(bean: instance, field: 'websiteUrl')}">${fieldValue(bean: instance, field: "websiteUrl")}</a></p>

                <!-- Networks -->
                <g:if test="${instance.networkMembership}">
                  <p><cl:membershipWithGraphics coll="${instance}"/></p>
                </g:if>

                <!-- Notes -->
                <g:if test="${instance.notes}">
                  <p><cl:formattedText>${fieldValue(bean: instance, field: "notes")}</cl:formattedText></p>
                </g:if>

                <!-- last edit -->
                <p><span class="category">Last change</span> ${fieldValue(bean: instance, field: "userLastModified")} on ${fieldValue(bean: instance, field: "lastUpdated")}</p>

                <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/base']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- description -->
              <div class="show-section">
                <h2>Description</h2>

                <!-- display name -->
                <p><span class="category">Display name</span>: ${fieldValue(bean: instance, field: "displayName")}</p>

                <!-- Pub Desc -->
                <div class="source">[Public description]</div><div style="clear:both;"></div>
                <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>

                <!-- Tech Desc -->
                <div class="source">[Technical description]</div><div style="clear:both;"></div>
                <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>

                <!-- Contribution -->
                <div class="source">[Contribution]</div><div style="clear:both;"></div>
                <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>

                <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'description']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- rights -->
              <div class="show-section">
                <h2>Citation and rights</h2>

                <!-- citation -->
                <p><span class="category">Citation</span>: ${fieldValue(bean: instance, field: "citation")}</p>

                <!-- citable agent -->
                <p><span class="category">Citable agent</span>: ${fieldValue(bean: instance, field: "citableAgent")}</p>

                <!-- rights -->
                <p><span class="category">Rights</span>: ${fieldValue(bean: instance, field: "rights")}</p>

                <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'rights']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- images -->
              <div class="show-section">
                <!-- LogoRef -->
                  <h2>Logo</h2>
                  <g:if test="${fieldValue(bean: instance, field: 'logoRef.file')}">
                    <img class="showImage" alt="${fieldValue(bean: instance, field: "logoRef.file")}"
                        src="${resource(absolute: "true", dir: 'data/dataProvider', file: instance.logoRef.file)}"/>
                    <p class="caption">${fieldValue(bean: instance, field: "logoRef.file")}</p>
                    <cl:formattedText pClass="caption">${fieldValue(bean: instance, field: "logoRef.caption")}</cl:formattedText>
                    <p class="caption">${fieldValue(bean: instance, field: "logoRef.attribution")}</p>
                    <p class="caption">${fieldValue(bean: instance, field: "logoRef.copyright")}</p>
                  </g:if>

                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/images',target:'logoRef']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- images -->
              <div class="show-section">
                <!-- ImageRef -->
                  <h2>Representative Image</h2>
                  <g:if test="${fieldValue(bean: instance, field: 'imageRef.file')}">
                    <img class="showImage" alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                        src="${resource(absolute: "true", dir: 'data/dataProvider', file: instance.imageRef.file)}"/>
                    <p class="caption">${fieldValue(bean: instance, field: "imageRef.file")}</p>
                    <cl:formattedText pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
                    <p class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p>
                    <p class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p>
                  </g:if>

                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/images',target:'imageRef']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- location -->
              <div class="show-section">
                <h2>Location</h2>
                <table>
                  <colgroup><col width="10%"/><col width="45%"/><col width="45%"/></colgroup>
                  <!-- Address -->
                  <tr class="prop">
                    <td valign="top" class="name"><g:message code="providerGroup.address.label" default="Address"/></td>

                    <td valign="top" class="value">
                      ${fieldValue(bean: instance, field: "address.street")}<br/>
                      ${fieldValue(bean: instance, field: "address.postBox")}<br/>
                      ${fieldValue(bean: instance, field: "address.city")}<br/>
                      ${fieldValue(bean: instance, field: "address.state")}
                      ${fieldValue(bean: instance, field: "address.postcode")}
                      <g:if test="${fieldValue(bean: instance, field: 'address.country') != 'Australia'}">
                        <br/>${fieldValue(bean: instance, field: "address.country")}
                      </g:if>
                    </td>

                    <!-- map spans all rows -->
                    <td rowspan="6">
                      <div id="mapCanvas"></div></td>

                  </tr>

                  <!-- Latitude -->
                  <tr class="prop">
                    <td valign="top" class="name"><g:message code="providerGroup.latitude.label" default="Latitude"/></td>
                    <td valign="top" class="value"><cl:showDecimal value='${instance.latitude}' degree='true'/></td>
                  </tr>

                  <!-- Longitude -->
                  <tr class="prop">
                    <td valign="top" class="name"><g:message code="providerGroup.longitude.label" default="Longitude"/></td>
                    <td valign="top" class="value"><cl:showDecimal value='${instance.longitude}' degree='true'/></td>
                  </tr>

                  <!-- State -->
                  <tr class="prop">
                    <td valign="top" class="name"><g:message code="collection.state.label" default="State"/></td>
                    <td valign="top" class="value">${fieldValue(bean: instance, field: "state")}</td>
                  </tr>

                  <!-- Email -->
                  <tr class="prop">
                    <td valign="top" class="name"><g:message code="collection.email.label" default="Email"/></td>
                    <td valign="top" class="value">${fieldValue(bean: instance, field: "email")}</td>
                  </tr>

                  <!-- Phone -->
                  <tr class="prop">
                    <td valign="top" class="name"><g:message code="collection.phone.label" default="Phone"/></td>
                    <td valign="top" class="value">${fieldValue(bean: instance, field: "phone")}</td>
                  </tr>
                </table>
                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/location']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

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
                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/showContacts']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- Attributions -->
              <div class="show-section">
                <h2>Attributions</h2>
                <ul class="fancy">
                  <g:each in="${instance.getAttributionList()}" var="att">
                    <li>${att.name}</li>
                  </g:each>
                </ul>
                <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/editAttributions']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

            </div>
            <div class="buttons">
              <g:form>
                <g:hiddenField name="id" value="${instance?.id}"/>
                <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
                  <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
                </cl:ifGranted>
                <span class="button"><g:link class="preview" controller="public" action='show' id="${instance?.uid}">${message(code: 'default.button.preview.label', default: 'Preview')}</g:link></span>
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
      if (${instance.canBeMapped()}) {
        var lat = ${instance.latitude};
        if (lat == undefined || lat == 0 || lat == -1 ) {lat = -35.294325779329654}
        var lng = ${instance.longitude};
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
