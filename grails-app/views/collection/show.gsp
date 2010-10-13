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
      <h1>${fieldValue(bean: instance, field: "name")}<cl:valueOrOtherwise value="${instance.acronym}"> (${fieldValue(bean: instance, field: "acronym")})</cl:valueOrOtherwise></h1>

      <!-- Institution --><!-- ALA Partner -->
      <h2 style="display:inline"><g:link controller="institution" action="show" id="${instance.institution?.id}">${instance.institution?.name}</g:link></h2>
      <cl:partner test="${instance.institution?.isALAPartner}"/><br/>

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

    <!-- collection description -->
    <div class="show-section">
      <!-- Pub Desc -->
      <h2>Description</h2>
      <div class="source">[Public description]</div><div style="clear:both;"></div>
      <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>

      <!-- Tech Desc -->
      <div class="source">[Technical description]</div><div style="clear:both;"></div>
      <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>
      <div class="source">[Start/End dates]</div><div style="clear:both;"></div>
      <cl:temporalSpan start='${fieldValue(bean: instance, field: "startDate")}' end='${fieldValue(bean: instance, field: "endDate")}'/>

      <!-- Collection types -->
      <p><span class="category">Collection types</span> include:
      <cl:JSONListAsStrings json='${instance.collectionType}'/>.</p>

      <!-- Active -->
      <p><span class="category">Activity status</span> is <cl:valueOrOtherwise value="${instance.active}" otherwise="unknown"/>.</p>

      <!-- Keywords -->
      <p><span class="category">Keywords</span> are not directly displayed but are used for searching and filtering.
        These keywords have been added for this collection: <cl:valueOrOtherwise value="${instance.listKeywords().join(', ')}" otherwise="none"/>.
        <g:if test="${!instance.listKeywords().contains('fauna')}">
          (<g:link action="addKeyword" id="${instance.id}" params="[keyword:'fauna']">Add fauna</g:link>)
        </g:if>
        <g:if test="${!instance.listKeywords().contains('plants')}">
          (<g:link action="addKeyword" id="${instance.id}" params="[keyword:'plants']">Add plants</g:link>)
        </g:if>
        <g:if test="${!instance.listKeywords().contains('entomology')}">
          (<g:link action="addKeyword" id="${instance.id}" params="[keyword:'entomology']">Add entomology</g:link>)
        </g:if>
        <g:if test="${!instance.listKeywords().contains('microbes')}">
          (<g:link action="addKeyword" id="${instance.id}" params="[keyword:'microbes']">Add microbes</g:link>)
        </g:if>
      </p>

      <!-- sub collections -->
      <h2>Sub-collections</h2>
      <cl:subCollectionList list="${instance.subCollections}"/>

      <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'description']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
  </div>

    <!-- images -->
    <g:render template="/shared/images" model="[target: 'imageRef', image: instance.imageRef, title:'Representative image', instance: instance]"/>

    <!-- location -->
    <g:render template="/shared/location" model="[instance: instance]"/>

    <!-- collection scope -->
    <div class="show-section">
      <h2>Geographic range</h2>
      <table>
        <colgroup><col width="25%"/><col width="75%"/></colgroup>
        <!-- Geo descrip -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="geographicDescription.label" default="Geographic Description"/></td>
          <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: instance, field: "geographicDescription")}</cl:formattedText></td>
        </tr>

        <!-- States -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="states.label" default="States covered"/></td>
          <td valign="top" class="value">${fieldValue(bean: instance, field: "states")}</td>
        </tr>

        <!-- Extent -->
        <tr class="prop">
          <td valign="top" class="name">Specimens were collected<br/> within these bounds</td>
          <td valign="top" class="value">
            <table class="shy">
              <colgroup><col width="30%"/><col width="40%"/><col width="30%"/></colgroup>
              <tr><td></td><td>North: <cl:showDecimal value='${instance.northCoordinate}' degree='true'/></td><td></td></tr>
              <tr><td>West: <cl:showDecimal value='${instance.westCoordinate}' degree='true'/></td>
              <td></td>
              <td>East: <cl:showDecimal value='${instance.eastCoordinate}' degree='true'/></td></tr>
              <tr><td></td><td>South: <cl:showDecimal value='${instance.southCoordinate}' degree='true'/></td><td></td></tr>
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
          <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText></td>
        </tr>

        <!-- Kingdom cover-->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="kingdomCoverage.label" default="Kingdom Coverage"/></td>
          <td valign="top" class="checkbox"><cl:checkBoxList readonly="true" name="kingdomCoverage" from="${Collection.kingdoms}" value="${instance?.kingdomCoverage}" /></td>
        </tr>

        <!-- sci names -->
        <tr class="prop">
          <td valign="top" class="name"><g:message code="scientificNames.label" default="Scientific Names"/></td>
          <td valign="top" class="value"><cl:JSONListAsStrings json='${fieldValue(bean: instance, field: "scientificNames")}'/></td>
        </tr>
      </table>

      <h2 style="padding-top:10px;">Number of specimens in the collection</h2>
      <g:if test="${fieldValue(bean: instance, field: 'numRecords') != '-1'}">
        <p>The estimated number of specimens within <cl:collectionName prefix="the " name="${instance.name}"/> is ${fieldValue(bean: instance, field: "numRecords")}.</p>
      </g:if>
      <g:if test="${fieldValue(bean: instance, field: 'numRecordsDigitised') != '-1'}">
        <p>Of these ${fieldValue(bean: instance, field: "numRecordsDigitised")} are digitised.
        This represents <cl:percentIfKnown dividend='${instance.numRecordsDigitised}' divisor='${instance.numRecords}' /> of the collection.</p>
      </g:if>

      <!-- biocache records -->
      <g:if test="${numBiocacheRecords}">
        <p><cl:numberOf number="${numBiocacheRecords}" noun="specimen record"/> can be accessed through the Atlas of Living Australia.
        <g:if test="${percentBiocacheRecords}">
          (${cl.formatPercent(percent: percentBiocacheRecords)}% of all specimens in the collection.)
          <cl:recordsLink collection="${instance}">Click to view records these records.</cl:recordsLink>
        </g:if></p>
        <p>The mapping of these records to this collection is based on <cl:institutionCodes collection="${instance}"/> and <cl:collectionCodes collection="${instance}"/>.</p>
        <cl:warnIfInexactMapping collection="${instance}"/>
      </g:if>
      <g:else>
        <p>No digitised records for this collection can be accessed through the Atlas of Living Australia.</p>
      </g:else>

      <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'range']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
    </div>

    <!-- Contacts -->
    <g:render template="/shared/contacts" model="[contacts: contacts, instance: instance]"/>

    <!-- Attributions -->
    <g:render template="/shared/attributions" model="[instance: instance]"/>

    <!-- Provider codes -->
    <g:if test="${instance.providerMap}">
      <div class="show-section">
        <h2>Provider codes</h2>
        <p>Institution codes: ${instance.getListOfInstitutionCodesForLookup().join(" ")}</p>
        <p>Collection codes: ${instance.getListOfCollectionCodesForLookup().join(" ")}</p>
        <g:if test="${instance.providerMap.matchAnyCollectionCode || !instance.providerMap.exact}">
          <p>
            <cl:valueOrOtherwise value="${instance.providerMap.matchAnyCollectionCode}">Will match any collection code. </cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${!instance.providerMap.exact}">Codes do not map exactly to this collection. </cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${instance.providerMap.warning}">Warning is: ${instance.providerMap.warning}</cl:valueOrOtherwise>
          </p>
        </g:if>
        <div style="clear:both;"><span class="buttons"><g:link class="edit" controller="providerMap" action='show' id="${instance.providerMap.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
      </div>
    </g:if>

    <!-- change history -->
    <g:render template="/shared/changes" model="[changes: changes, instance: instance]"/>

  </div>
  <div class="buttons">
    <g:form>
      <g:hiddenField name="id" value="${instance?.id}"/>
      <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
      <span class="button"><g:link class="preview" controller="public" action='show' id="${instance?.id}">${message(code: 'default.button.preview.label', default: 'Preview')}</g:link></span>
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
