<%@ page import="au.org.ala.collectory.ProviderGroup; org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.Collection" %>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="layout" content="main"/>
  <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}"/>
  <title><g:message code="default.show.label" args="[entityName]"/></title>
  <script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.3&sensor=false"></script>
</head>
<body onload="initializeLocationMap('${instance.canBeMapped()}',${instance.latitude},${instance.longitude});">
<style>
#mapCanvas {
  width: 200px;
  height: 170px;
  float: right;
}
</style>
<div class="nav">
  <g:form url="mailto:${instance.getPrimaryContact()?.contact?.email}?subject=Request to review web pages presenting information about the ${instance.name}.&body=${contactEmailBody}">
  <span class="menuButton"><cl:homeLink/></span>
  <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]"/></g:link></span>
  <span class="menuButton"><g:link class="list" action="myList"><g:message code="default.myList.label" args="[entityName]"/></g:link></span>
  <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]"/></g:link></span>
  <!--span class="buttons"><input type="submit" class="special" value="Contact the curator"/></span-->
  <span class="entityType" style="float:right;">Collection</span>
  </g:form>
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
      <h2 style="display:inline"><g:link controller="institution" action="show" id="${instance.institution?.uid}">${instance.institution?.name}</g:link></h2>
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

      <cl:editButton uid="${instance.uid}" page="/shared/base"/>
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

      <cl:editButton uid="${instance.uid}" page="description"/>
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

      <!-- estimate of records -->
      <h2 style="padding-top:10px;">Number of specimens in the collection</h2>
      <g:if test="${fieldValue(bean: instance, field: 'numRecords') != '-1'}">
        <p>The estimated number of specimens within <cl:collectionName prefix="the " name="${instance.name}"/> is ${fieldValue(bean: instance, field: "numRecords")}.</p>
      </g:if>
      <g:if test="${fieldValue(bean: instance, field: 'numRecordsDigitised') != '-1'}">
        <p>Of these ${fieldValue(bean: instance, field: "numRecordsDigitised")} are digitised.
        This represents <cl:percentIfKnown dividend='${instance.numRecordsDigitised}' divisor='${instance.numRecords}' /> of the collection.</p>
      </g:if>

      <!-- actual biocache records -->
      <p><span id="numBiocacheRecords">Looking up... the number of records that</span> can be accessed through the Atlas of Living Australia.
      <cl:recordsLink collection="${instance}">Click to view these records.</cl:recordsLink>
      </p>

      <div id="speedo">
        <div id="progress">
          <img id="progressBar" src="${resource(dir:'images', file:'percentImage.png')}" alt="0%"
                  class="no-radius percentImage1" style='background-position: -120px 0;margin-left:35px;'/>
          <!--cl:progressBar percent="0.0"/-->
        </div>
        <p class="caption"><span id="speedoCaption">No records are available for viewing in the Atlas.</span></p>
      </div>

      <p style="margin-top:20px;">The mapping of records to this collection is based on the provider codes shown in the next section.</p>
      <cl:warnIfInexactMapping collection="${instance}"/>

      <cl:editButton uid="${instance.uid}" page="range"/>
    </div>

    <!-- Contacts -->
    <g:render template="/shared/contacts" model="[contacts: contacts, instance: instance]"/>

    <!-- Provider codes -->
    <div class="show-section">
      <h2>Provider codes</h2>
      <p>These codes control the mapping of online records to this collection.</p>
      <p>Institution codes: ${instance.getListOfInstitutionCodesForLookup().join(", ")}</p>
      <p>Collection codes: ${instance.getListOfCollectionCodesForLookup().join(", ")}</p>
      <g:if test="${instance.providerMap}">
        <g:if test="${instance.providerMap?.matchAnyCollectionCode || !instance.providerMap?.exact}">
          <p>
            <cl:valueOrOtherwise value="${instance.providerMap?.matchAnyCollectionCode}">Will match any collection code. </cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${!instance.providerMap?.exact}">Codes do not map exactly to this collection. </cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${instance.providerMap?.warning}">Warning is: ${instance.providerMap?.warning}</cl:valueOrOtherwise>
          </p>
        </g:if>
        <cl:editButton uid="${instance.uid}" id="${instance.providerMap?.id}" controller="providerMap" action="show" returnTo="${instance.uid}"/>
      </g:if>
      <g:else>
        <cl:editButton controller="providerMap" action="create" returnTo="${instance.uid}" createFor="${instance.uid}"/>
      </g:else>
    </div>

    <!-- Record providers and resources -->
    <g:render template="/shared/providers" model="[instance: instance]"/>

    <!-- Attributions -->
    <g:render template="/shared/attributions" model="[instance: instance]"/>

    <!-- taxonomy hints -->
    <g:render template="/shared/taxonomyHints" model="[instance: instance]"/>

    <!-- change history -->
    <g:render template="/shared/changes" model="[changes: changes, instance: instance]"/>

  </div>
  <div class="buttons">
    <g:form>
      <g:hiddenField name="id" value="${instance?.id}"/>
      <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
        <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
      </cl:ifGranted>
      <span class="button"><cl:viewPublicLink uid="${instance?.uid}"/></span>
      <span class="button"><cl:jsonSummaryLink uid="${instance.uid}"/></span>
      <span class="button"><cl:jsonDataLink uid="${instance.uid}"/></span>
    </g:form>
  </div>
</div>
<script type="text/javascript">
  var initial = -120;
  var imageWidth=240;
  var eachPercent = (imageWidth/2)/100;
  
/************************************************************\
*
\************************************************************/
function onLoadCallback() {
  // summary biocache data
  var biocacheRecordsUrl = "${ConfigurationHolder.config.grails.context}/public/biocacheRecords.json?uid=${instance.uid}";
  $.get(biocacheRecordsUrl, {}, biocacheRecordsHandler);
}
/************************************************************\
*
\************************************************************/
function biocacheRecordsHandler(response) {
  setNumbers(response.totalRecords, ${instance.numRecords});
}
/************************************************************\
*
\************************************************************/
function setNumbers(totalBiocacheRecords, totalRecords) {
  var recordsClause = "";
  switch (totalBiocacheRecords) {
    case 0: recordsClause = "No records"; break;
    case 1: recordsClause = "1 record"; break;
    default: recordsClause = addCommas(totalBiocacheRecords) + " records";
  }
  $('#numBiocacheRecords').html(recordsClause);

  if (totalRecords > 0) {
    var percent = totalBiocacheRecords/totalRecords * 100;
    setProgress(percent);
  } else {
    // to update the speedo caption
    setProgress(0);
  }
}
/************************************************************\
*
\************************************************************/
function setProgress(percentage)
{
  var captionText = "";
  if (${instance.numRecords < 1}) {
    captionText = "There is no estimate of the total number<br/>of specimens in this collection.";
  } else if (percentage == 0) {
    captionText = "No records are available for viewing in the Atlas.";
  } else {
    var displayPercent = percentage.toFixed(1);
    if (percentage < 0.1) {displayPercent = percentage.toFixed(2)}
    if (percentage > 20) {displayPercent = percentage.toFixed(0)}
    if (percentage > 100) {displayPercent = "over 100"}
    captionText = "Records for " + displayPercent + "% of specimens are<br/>available for viewing in the Atlas.";
  }
  $('#speedoCaption').html(captionText);

  if (percentage > 100) {
    $('#progressBar').removeClass('percentImage1');
    $('#progressBar').addClass('percentImage4');
    percentage = 101;
  }
  var percentageWidth = eachPercent * percentage;
  var newProgress = eval(initial)+eval(percentageWidth)+'px';
  $('#progressBar').css('backgroundPosition',newProgress+' 0');
}
/************************************************************\
*
\************************************************************/
function addCommas(nStr)
{
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}
/************************************************************\
*
\************************************************************/

google.setOnLoadCallback(onLoadCallback);

/************************************************************\
*
\************************************************************/
  function contactCurator(email, firstName, uid, instUid) {
      var subject = "Request to review web pages presenting information about your natural history collection.";
      var content = "Dear " + firstName + ",\n\n";
      content = content + "The Atlas of Living Australia aims to amalgamate biodiversity information, data and images on all the living plants, animals and microbes found within Australia.  In addition to this, the Atlas has created a tool to promote knowledge of Natural History Collections throughout Australia and to highlight the importance of our partners (Council Heads of Museums and Herbaria).\n\n";
      content = content + "This database of Natural History Collections was created based on the Biodiversity Collections Index (http://www.biodiversitycollectionsindex.org/static/index.html) and the information we could find for your collection at this resource.  However, as some of this information is out-of-date, we would like you to take a sneak peak at the web site we are creating and provide feedback and edits to the information displayed.  In the future, and in consultation with the Australian Biological Resources Study (ABRS), we intend to build an on-line data collection and editing tool that will allow curators to maintain metadata on their collections and allow key elements of the ABRS \"taxonomic workforce and Institutional Surveys\" to be completed on-line.\n\n";
      content = content + "The web address for the Atlas of Living Australia is: http://www.ala.org.au.\n\n";
      content = content + "However, you can find:\n\n";
      content = content + "Your Collection page at: http://collections.ala.org.au/public/show/" + uid + ".\n\n";
      content = content + "Your Institution page at: http://collections.ala.org.au/public/showInstitution/" + instUid + ".\n\n";
      content = content + "Or explore your collections community at: http://collections.ala.org.au/public/map.\n\n";
      content = content + "After consulting the website, please respond to this email with any feedback and edits that you would like made to your Collections and Institution pages before Monday the 25th of October 2010.\n\n";
      content = content + "Regards,\n";
      content = content + "\tThe Atlas of Living Australia\n\n";
      content = content + "Dr. Peter Neville\n";
      content = content + "Research Projects Officer | Atlas of Living Australia\n";
      content = content + "CSIRO\n";

      $post({
          url: 'mailto:' + email + '?subject=' + subject,
          data: 'body=' + encodeURI(content),
          success: function() {alert('here')}
      });

      if (event) {
          event.cancelBubble = true;
      }
      return false;
  }
</script>
</body>
</html>
