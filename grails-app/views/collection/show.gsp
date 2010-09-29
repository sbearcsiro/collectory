<%@ page import="au.org.ala.collectory.Collection" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
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
  <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]"/></g:link></span>
  <span class="menuButton"><g:link class="list" action="myList"><g:message code="default.myList.label" args="[entityName]"/></g:link></span>
  <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]"/></g:link></span>
  <span class="entityType" style="float:right;">Collection</span>
</div>
<div class="body">
  <g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
  </g:if>
  <div class="dialog emulate-public">
    <!-- base attributes -->
    <div class="show-section titleBlock">
      <!-- Name --><!-- Acronym -->
      <h1>${fieldValue(bean: collectionInstance, field: "name")}<cl:valueOrOtherwise value="${collectionInstance.acronym}"> (${fieldValue(bean: collectionInstance, field: "acronym")})</cl:valueOrOtherwise></h1>

      <!-- Institution --><!-- ALA Partner -->
      <h2 style="display:inline"><g:link controller="institution" action="show" id="${collectionInstance.institution?.id}">${collectionInstance.institution?.name}</g:link></h2>
      <cl:partner test="${collectionInstance.institution?.isALAPartner}"/><br/>

      <!-- GUID    -->
      <p><span class="category">LSID</span>: <cl:guid target="_blank" guid='${fieldValue(bean: collectionInstance, field: "guid")}'/></p>

      <!-- UID    -->
      <p><span class="category">UID</span>: ${fieldValue(bean: collectionInstance, field: "uid")}</p>

      <!-- Web site -->
      <p><span class="category">Collection website</span>: <a target="_blank" href="${fieldValue(bean: collectionInstance, field: 'websiteUrl')}">${fieldValue(bean: collectionInstance, field: "websiteUrl")}</a></p>

      <!-- Networks -->
      <g:if test="${collectionInstance.networkMembership}">
        <p><cl:membershipWithGraphics coll="${collectionInstance}"/></p>
      </g:if>

      <!-- Notes -->
      <g:if test="${collectionInstance.notes}">
        <p><cl:formattedText>${fieldValue(bean: collectionInstance, field: "notes")}</cl:formattedText></p>
      </g:if>

      <!-- last edit -->
      <p><span class="category">Last change</span> ${fieldValue(bean: collectionInstance, field: "userLastModified")} on ${fieldValue(bean: collectionInstance, field: "lastUpdated")}</p>
    
      <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/base']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
    </div>

    <!-- collection description -->
    <div class="show-section">
      <!-- Pub Desc -->
      <h2>Description</h2>
      <div class="source">[Public description]</div><div style="clear:both;"></div>
      <cl:formattedText>${fieldValue(bean: collectionInstance, field: "pubDescription")}</cl:formattedText>

      <!-- Tech Desc -->
      <div class="source">[Technical description]</div><div style="clear:both;"></div>
      <cl:formattedText>${fieldValue(bean: collectionInstance, field: "techDescription")}</cl:formattedText>
      <div class="source">[Start/End dates]</div><div style="clear:both;"></div>
      <cl:temporalSpan start='${fieldValue(bean: collectionInstance, field: "startDate")}' end='${fieldValue(bean: collectionInstance, field: "endDate")}'/>

      <!-- Collection types -->
      <p><span class="category">Collection types</span> include:
      <cl:JSONListAsStrings json='${collectionInstance.collectionType}'/>.</p>

      <!-- Active -->
      <p><span class="category">Activity status</span> is <cl:valueOrOtherwise value="${collectionInstance.active}" otherwise="unknown"/>.</p>

      <!-- Keywords -->
      <p><span class="category">Keywords</span> are not directly displayed but are used for searching and filtering.
        These keywords have been added for this collection: <cl:valueOrOtherwise value="${collectionInstance.listKeywords().join(', ')}" otherwise="none"/>.
        <g:if test="${!collectionInstance.listKeywords().contains('fauna')}">
          (<g:link action="addKeyword" id="${collectionInstance.id}" params="[keyword:'fauna']">Add fauna</g:link>)
        </g:if>
        <g:if test="${!collectionInstance.listKeywords().contains('plants')}">
          (<g:link action="addKeyword" id="${collectionInstance.id}" params="[keyword:'plants']">Add plants</g:link>)
        </g:if>
        <g:if test="${!collectionInstance.listKeywords().contains('entomology')}">
          (<g:link action="addKeyword" id="${collectionInstance.id}" params="[keyword:'entomology']">Add entomology</g:link>)
        </g:if>
        <g:if test="${!collectionInstance.listKeywords().contains('microbes')}">
          (<g:link action="addKeyword" id="${collectionInstance.id}" params="[keyword:'microbes']">Add microbes</g:link>)
        </g:if>
      </p>

      <!-- sub collections -->
      <h2>Sub-collections</h2>
      <cl:subCollectionList list="${collectionInstance.subCollections}"/>

      <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'description']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
  </div>

  <!-- images -->
  <div class="show-section">
    <!-- ImageRef -->
      <h2>Representative Image</h2>
      <g:if test="${fieldValue(bean: collectionInstance, field: 'imageRef.file')}">
        <img class="showImage" alt="${fieldValue(bean: collectionInstance, field: "imageRef.file")}"
            src="${resource(absolute: "true", dir: 'data/collection', file: collectionInstance.imageRef.file)}"/>
        <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.file")}</p>
        <cl:formattedText pClass="caption">${fieldValue(bean: collectionInstance, field: "imageRef.caption")}</cl:formattedText>
        <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.attribution")}</p>
        <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.copyright")}</p>
      </g:if>

    <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/images', target:'imageRef']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
  </div>

    <!-- location -->
    <div class="show-section">
      <h2>Location</h2>
      <table>
        <colgroup><col width="10%"/><col width="45%"/><col width="45%"/></colgroup>
        <!-- Address -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="collection.address.label" default="Address"/></td>

          <td valign="top" class="value">
            ${fieldValue(bean: collectionInstance, field: "address.street")}<br/>
            ${fieldValue(bean: collectionInstance, field: "address.city")}<br/>
            ${fieldValue(bean: collectionInstance, field: "address.state")}
            ${fieldValue(bean: collectionInstance, field: "address.postcode")}
            <g:if test="${fieldValue(bean: collectionInstance, field: 'address.country') != 'Australia'}">
              <br/>${fieldValue(bean: collectionInstance, field: "address.country")}
            </g:if>
          </td>

          <!-- map spans all rows -->
          <td rowspan="6">
            <div id="mapCanvas"></div></td>

        </tr>

        <!-- Postal -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="providerGroup.address.postal.label" default="Postal"/></td>
          <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "address.postBox")}</td>
        </tr>

        <!-- Latitude -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="providerGroup.latitude.label" default="Latitude"/></td>
          <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.latitude}' degree='true'/></td>
        </tr>

        <!-- Longitude -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="providerGroup.longitude.label" default="Longitude"/></td>
          <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.longitude}' degree='true'/></td>
        </tr>

        <!-- State -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="collection.state.label" default="State"/></td>
          <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "state")}</td>
        </tr>

        <!-- Email -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="collection.email.label" default="Email"/></td>
          <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "email")}</td>
        </tr>

        <!-- Phone -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="collection.phone.label" default="Phone"/></td>
          <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "phone")}</td>
        </tr>
      </table>
      <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/location']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
    </div>

    <!-- collection scope -->
    <div class="show-section">
      <h2>Geographic range</h2>
      <table>
        <colgroup><col width="25%"/><col width="75%"/></colgroup>
        <!-- Geo descrip -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="geographicDescription.label" default="Geographic Description"/></td>
          <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: collectionInstance, field: "geographicDescription")}</cl:formattedText></td>
        </tr>

        <!-- States -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="states.label" default="States covered"/></td>
          <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "states")}</td>
        </tr>

        <!-- Extent -->
        <tr class="prop">
          <td valign="top" class="name">Specimens were collected<br/> within these bounds</td>
          <td valign="top" class="value">
            <table class="shy">
              <colgroup><col width="30%"/><col width="40%"/><col width="30%"/></colgroup>
              <tr><td></td><td>North: <cl:showDecimal value='${collectionInstance.northCoordinate}' degree='true'/></td><td></td></tr>
              <tr><td>West: <cl:showDecimal value='${collectionInstance.westCoordinate}' degree='true'/></td>
              <td></td>
              <td>East: <cl:showDecimal value='${collectionInstance.eastCoordinate}' degree='true'/></td></tr>
              <tr><td></td><td>South: <cl:showDecimal value='${collectionInstance.southCoordinate}' degree='true'/></td><td></td></tr>
            </table>
          </td>
        </tr>
      </table>
      <h2>Taxonomic range</h2>
      <table>
        <colgroup><col width="25%"/><col width="75%"/></colgroup>
        <!-- Focus   -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="focus.label" default="Collection focus"/></td>
          <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: collectionInstance, field: "focus")}</cl:formattedText></td>
        </tr>

        <!-- Kingdom cover-->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="kingdomCoverage.label" default="Kingdom Coverage"/></td>
          <td valign="top" class="checkbox"><cl:checkBoxList readonly="true" name="kingdomCoverage" from="${Collection.kingdoms}" value="${collectionInstance?.kingdomCoverage}" /></td>
        </tr>

        <!-- sci names -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="scientificNames.label" default="Scientific Names"/></td>
          <td valign="top" class="value"><cl:JSONListAsStrings json='${fieldValue(bean: collectionInstance, field: "scientificNames")}'/></td>
        </tr>
      </table>

      <h2 style="padding-top:10px;">Number of specimens in the collection</h2>
      <g:if test="${fieldValue(bean: collectionInstance, field: 'numRecords') != '-1'}">
        <p>The estimated number of specimens within the ${collectionInstance.name} is ${fieldValue(bean: collectionInstance, field: "numRecords")}.</p>
      </g:if>
      <g:if test="${fieldValue(bean: collectionInstance, field: 'numRecordsDigitised') != '-1'}">
        <p>Of these ${fieldValue(bean: collectionInstance, field: "numRecordsDigitised")} are digitised.
        This represents <cl:percentIfKnown dividend='${collectionInstance.numRecordsDigitised}' divisor='${collectionInstance.numRecords}' /> of the collection.</p>
      </g:if>

      <!-- biocache records -->
      <g:if test="${numBiocacheRecords}">
        <p><cl:numberOf number="${numBiocacheRecords}" noun="specimen record"/> can be accessed through the Atlas of Living Australia.
        <g:if test="${percentBiocacheRecords}">
          (${cl.formatPercent(percent: percentBiocacheRecords)}% of all specimens in the collection.)
          <cl:recordsLink collection="${collectionInstance}">Click to view records these records.</cl:recordsLink>
        </g:if></p>
        <p>The mapping of these records to this collection is based on <cl:institutionCodes collection="${collectionInstance}"/> and <cl:collectionCodes collection="${collectionInstance}"/>.</p>
        <cl:warnIfInexactMapping collection="${collectionInstance}"/>
      </g:if>
      <g:else>
        <p>No digitised records for this collection can be accessed through the Atlas of Living Australia.</p>
      </g:else>

      <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'range']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
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
      <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/showContacts']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
    </div>

    <!-- Attributions -->
    <div class="show-section">
      <h2>Attributions</h2>
      <ul class="fancy">
        <g:each in="${collectionInstance.getAttributionList()}" var="att">
          <li>${att.name}</li>
        </g:each>
      </ul>
      <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/editAttributions']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
    </div>

    <!-- Provider codes -->
    <g:if test="${collectionInstance.providerMap}">
      <div class="show-section">
        <h2>Provider codes</h2>
        <p>Institution codes: ${collectionInstance.getListOfInstitutionCodesForLookup().join(" ")}</p>
        <p>Collection codes: ${collectionInstance.getListOfCollectionCodesForLookup().join(" ")}</p>
        <g:if test="${collectionInstance.providerMap.matchAnyCollectionCode || !collectionInstance.providerMap.exact}">
          <p>
            <cl:valueOrOtherwise value="${collectionInstance.providerMap.matchAnyCollectionCode}">Will match any collection code. </cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${!collectionInstance.providerMap.exact}">Codes do not map exactly to this collection. </cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${collectionInstance.providerMap.warning}">Warning is: ${collectionInstance.providerMap.warning}</cl:valueOrOtherwise>
          </p>
        </g:if>
        <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/editAttributions']" id="${collectionInstance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
      </div>
    </g:if>

  </div>
  <div class="buttons">
    <g:form>
      <g:hiddenField name="id" value="${collectionInstance?.id}"/>
      <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
      <span class="button"><g:link class="preview" controller="public" action='show' id="${collectionInstance?.id}">${message(code: 'default.button.preview.label', default: 'Preview')}</g:link></span>
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
  if (${collectionInstance.canBeMapped()}) {
    var lat = ${collectionInstance.latitude};
    if (lat == undefined || lat == 0 || lat == -1 ) {lat = -35.294325779329654}
    var lng = ${collectionInstance.longitude};
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
