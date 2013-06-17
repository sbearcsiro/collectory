<%@ page import="au.org.ala.collectory.Contact; au.org.ala.collectory.ContactFor; grails.converters.deep.JSON; org.codehaus.groovy.grails.commons.ConfigurationHolder; java.text.DecimalFormat; au.org.ala.collectory.Collection; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala2" />
        <title><cl:pageTitle>${fieldValue(bean: instance, field: "name")}</cl:pageTitle></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'js/jquery.fancybox/fancybox',file:'jquery.fancybox-1.3.1.css')}" media="screen" />
        <link rel="stylesheet" href="${resource(dir:'css/smoothness',file:'jquery-ui-1.8.19.custom.css')}" type="text/css" media="screen"/>
        <g:javascript src="jquery.fancybox/fancybox/jquery.fancybox-1.3.1.pack.js" />
        <g:javascript library="jquery-ui-1.8.19.custom.min"/>
        <g:javascript library="jQueryRotateCompressed.2.1"/>
        <g:javascript library="underscore"/>
        <g:javascript library="change"/>
        %{--<g:javascript library="datadumper"/>--}%
        <g:javascript library="json2"/>
        <script type="text/javascript" src="${resource(dir:'js/tiny_mce/', file:'jquery.tinymce.js')}" ></script >
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.3&sensor=false"></script>
    </head>
    <body class="two-column-right">
      <style>
        #mapCanvas {
          width: 200px;
          height: 170px;
          float: left;
        }
      </style>
      <div id="content">
        <div id="header" class="collectory">
          <!--Breadcrumbs-->
          <div id="breadcrumb"><cl:breadcrumbTrail/>
            <cl:pageOptionsLink>${fieldValue(bean:instance,field:'name')}</cl:pageOptionsLink>
          </div>
          <cl:pageOptionsPopup instance="${instance}"/>
          <div class="section full-width">
            <g:if test="${flash.message}"><div class="message">${flash.message}</div></g:if>
            <div class="hrgroup col-8">
              <h1><span id="name">${instance.name}</span><img id="nameLink" class="changeLink" src="${resource(dir:'images/admin',file:'change.png')}"/></h1>
              <g:set var="inst" value="${instance.getInstitution()}"/>
              <g:if test="${inst}">
                <h2 class="pseudoLink">${inst.name}</h2>
              </g:if>
              <span class="acronym">Acronym: <span id="acronym">${fieldValue(bean: instance, field: "acronym")}</span><cl:change id="acronymLink"/></span>
              <span class="lsid"><a href="#lsidText" id="lsidbox" class="local" title="Life Science Identifier (pop-up)">LSID</a></span><cl:change id="lsidLink"/>
              <div style="display:none; text-align: left;">
                  <div id="lsidText" style="text-align: left;">
                      <b><a class="external_icon" href="http://lsids.sourceforge.net/" target="_blank">Life Science Identifier (LSID):</a></b>
                      <p style="margin: 10px 0;" id="lsid"><cl:guid target="_blank" guid='${fieldValue(bean: instance, field: "guid")}'/></p>
                      <p style="font-size: 12px;">LSIDs are persistent, location-independent,resource identifiers for uniquely naming biologically
                           significant resources including species names, concepts, occurrences, genes or proteins,
                           or data objects that encode information about them. To put it simply,
                          LSIDs are a way to identify and locate pieces of biological information on the web. </p>
                  </div>
              </div>
            </div>
            <div class="aside col-4 center">
              <!-- institution logo -->
              <g:if test="${inst?.logoRef?.file}">
                <img class="institutionImage" src='${resource(absolute:"true", dir:"data/institution/",file:fieldValue(bean: inst, field: 'logoRef.file'))}' />
              </g:if>
            </div>
          </div>
        </div><!--close header-->
        <div>
          <div id="column-one">
            <div class="section">
                <!-- description -->
                <h2>Description</h2>
                <div><span id="pubDescription"><cl:formattedText body="${instance.pubDescription}"/></span>
                  <cl:change id="pubDescriptionLink" style="position: relative; top: -25px"/></div>
                <div><span id="techDescription"><cl:formattedText body="${instance.techDescription}"/></span>
                  <cl:change id="techDescriptionLink" style="position: relative; top: -25px"/></div>
                <p><span id="temporalSpan"><cl:temporalSpanText start="${instance.startDate}" end="${instance.endDate}" change="true"/></span>
                  <cl:change id="temporalSpanLink"/></p>

                <!-- taxonomic range -->
                <h2>Taxonomic range<cl:change id="taxonomicRangeLink"/></h2>
                <span class="${instance.focus ? '' : 'empty'}" id="focus"><cl:formattedText body="${instance.focus}"/></span>
                <p class="${instance.kingdomCoverage ? '' : 'empty'}" id="kingdomCoverage">Kingdoms covered include: <cl:concatenateStrings values='${fieldValue(bean: instance, field: "kingdomCoverage")}'/>.</p>
                <p class="${instance.scientificNames ? '' : 'empty'}" id="sciNames"><cl:collectionName name="${instance.name}" prefix="The "/> includes members from the following taxa:<br/>
                <span id="scientificNames"><cl:JSONListAsStrings json='${fieldValue(bean: instance, field: "scientificNames")}'/></span>.</p>

                <!-- geographic range -->
                <h2>Geographic range<cl:change id="geographicRangeLink"/></h2>
                <p class="${instance.geographicDescription ? '' : 'empty'}" id="geographicDescription">${fieldValue(bean: instance, field: "geographicDescription")}</p>
                <p class="${instance.states ? '' : 'empty'}" id="states"><cl:stateCoverage states='${fieldValue(bean: instance, field: "states")}'/></p>

                <!-- records -->
                <g:set var="nouns" value="${cl.nounForTypes(types:instance.listCollectionTypes())}"/>
                <h2>Number of <cl:nounForTypes types="${instance.listCollectionTypes()}"/> in the collection<cl:change id="recordsLink"/></h2>
                <g:if test="${fieldValue(bean: instance, field: 'numRecords') != '-1'}">
                <p>The estimated number of ${nouns} in <cl:collectionName prefix="the " name="${instance.name}"/> is <span id="numRecords">${fieldValue(bean: instance, field: "numRecords")}</span>.</p>
                </g:if>
                <g:if test="${fieldValue(bean: instance, field: 'numRecordsDigitised') != '-1'}">
                <p>Of these <span id="numRecordsDigitised">${fieldValue(bean: instance, field: "numRecordsDigitised")}</span> are databased.
                This represents <cl:percentIfKnown dividend='${instance.numRecordsDigitised}' divisor='${instance.numRecords}' /> of the collection.</p>
                </g:if>
                <p>Click the Records & Statistics tab to access those database records that are available through the atlas.</p>

                <!-- sub-collections -->
                <h2>Sub-collections<cl:change id="subCollectionsLink"/></h2>
                <p><cl:collectionName prefix="The " name="${instance.name}"/> contains these significant collections:</p>
                <cl:subCollectionList list="${instance.subCollections}"/>

                <cl:lastUpdated date="${instance.lastUpdated}"/>
                <!-- recent changes -->
                <div>
                    <p id="showChangesLink" class="link under" style="color:#01716E;margin-left:15px;">Show recent changes</p>
                    <div id="changes" style="display:none;">
                      <g:each in="${changes}" var="ch">
                          <div>
                            <g:if test="${ch.eventName == 'UPDATE'}">
                              <p class="relatedFollows">
                                  <img style="vertical-align: bottom;" title="Click to show more information" src="${resource(dir:'images/skin', file:'ExpandArrow.png')}"/>
                                  At ${ch.lastUpdated} <em>${ch.actor}</em> changed the <strong>${ch.propertyName}</strong> field</p>
                              <table class="textChanges">
                                <tr>
                                  <td>to:</td><td><cl:cleanString class="changeTo" value="${ch.newValue}" field="${ch.propertyName}"/></td>
                                </tr><tr>
                                  <td>from:</td><td><cl:cleanString class="changeFrom" value="${ch.oldValue}" field="${ch.propertyName}"/></td>
                                </tr>
                              </table>
                            </g:if>
                            <g:elseif test="${ch.eventName == 'INSERT' && cl.shortClassName(className:ch.className) == 'ContactFor'}">
                              <g:set var="cf" value="${ContactFor.get(ch.persistedObjectId)}"/>
                              <p class="relatedFollows">
                                  <img style="vertical-align: bottom;" title="Click to show more information" src="${resource(dir:'images/skin', file:'ExpandArrow.png')}"/>
                                  At ${ch.lastUpdated} <em>${ch.actor}</em> added a contact</p>
                              <table class="textChanges">
                                <tr>
                                  <td>id:${ch.persistedObjectId}</td><td>${cf ? cf.contact?.buildName() : 'name missing - may have been deleted'}</td>
                                </tr>
                              </table>
                            </g:elseif>
                            <g:elseif test="${ch.eventName == 'DELETE' && cl.shortClassName(className:ch.className) == 'ContactFor'}">
                              <p class="relatedFollows">
                                  <img style="vertical-align: bottom;" title="Click to show more information" src="${resource(dir:'images/skin', file:'ExpandArrow.png')}"/>
                                  At ${ch.lastUpdated} <em>${ch.actor}</em> removed a contact</p>
                              <table class="textChanges">
                                <tr>
                                  <td>id:${ch.persistedObjectId}</td><td>name not available - has been deleted</td>
                                </tr>
                              </table>
                            </g:elseif>
                            <g:elseif test="${ch.eventName == 'INSERT' && ch.uri == instance.uid}">
                              <p class="relatedFollows">
                                  <img style="vertical-align: bottom;" title="Click to show more information" src="${resource(dir:'images/skin', file:'ExpandArrow.png')}"/>
                                  At ${ch.lastUpdated} <em>${ch.actor}</em> created this ${entityNameLower}.</p>
                              <table class="textChanges">
                                <tr>
                                  <td colspan="2">${instance.name}</td>
                                </tr>
                              </table>
                            </g:elseif>
                          </div>
                      </g:each>
                    </div>
                </div>
            </div><!--close section-->
          </div><!--close column-one-->

          <div id="column-two">
            <div class="section sidebar">
              <!-- representative image -->
              <div class="section" id="representativeImage">
                <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
                  <img style="max-width:100%;max-height:350px;" alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                          src="${resource(absolute:"true", dir:"data/collection/", file:instance.imageRef.file)}" />
                  <cl:formattedText pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
                  <cl:valueOrOtherwise value="${instance.imageRef?.attribution}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
                  <cl:valueOrOtherwise value="${instance.imageRef?.copyright}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
                </g:if>
                <g:else>
                  <p class="caption">No representative image</p>
                </g:else>
              </div>
              <cl:change id="representativeImageLink" style="position: relative; top: -5px; left: 10px"/>

                <!-- location -->
              <div class="section" id="address">
                <h3>Location<cl:change id="locationLink"/></h3>
                <!-- use parent location if the collection is blank -->
                <g:set var="address" value="${instance.address}"/>
                <g:if test="${address == null || address.isEmpty()}">
                  <g:if test="${instance.getInstitution()}">
                    <g:set var="address" value="${instance.getInstitution().address}"/>
                  </g:if>
                </g:if>

                <g:set var="latitude" value="${instance.latitude}"/>
                <g:if test="${latitude == null}">
                  <g:if test="${instance.getInstitution()}">
                    <g:set var="latitude" value="${instance.getInstitution().latitude}"/>
                  </g:if>
                </g:if>

                <g:set var="longitude" value="${instance.longitude}"/>
                <g:if test="${longitude == null}">
                  <g:if test="${instance.getInstitution()}">
                    <g:set var="longitude" value="${instance.getInstitution().longitude}"/>
                  </g:if>
                </g:if>

                <g:if test="${!address?.isEmpty()}">
                  <p id="location">
                    <cl:valueOrOtherwise value="${address?.street}"><span id="street">${address?.street}</span><br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.city}"><span id="city">${address?.city}</span><br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.state}"><span id="state">${address?.state}</span></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.postcode}"><span id="postcode">${address?.postcode}</span><br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.country}"><span id="country">${address?.country}</span><br/></cl:valueOrOtherwise>
                  </p>
                </g:if>

                <div id="mapCanvas"></div>

                <g:if test="${instance.email}"><cl:emailLink>${fieldValue(bean: instance, field: "email")}</cl:emailLink><br/></g:if>
                <cl:valueOrOtherwise value="${instance.phone}"><span id="phone">${instance.phone}</span><br/></cl:valueOrOtherwise>
              </div>

              <!-- contacts -->
              <g:render template="/public/contacts" bean="${instance.getPublicContactsPrimaryFirst()}"/>
              <script type="text/javascript">
                $("h3:contains('Contact')").append("<cl:change id='contactsLink'/>");
              </script>

              <!-- web site -->
              <g:if test="${instance.websiteUrl || instance.institution?.websiteUrl}">
                <div class="section">
                  <h3>Web site<cl:change id="websiteUrlLink"/></h3>
                  <g:if test="${instance.websiteUrl}">
                    <div class="webSite">
                      <a class='external' rel='nofollow' target="_blank" href="${instance.websiteUrl}">Visit the collection's website</a>
                    </div>
                  </g:if>
                  <g:if test="${instance.institution?.websiteUrl}">
                    <div class="webSite">
                      <a class='external' rel='nofollow' target="_blank" href="${instance.institution?.websiteUrl}">
                        Visit the <cl:institutionType inst="${instance.institution}"/>'s website</a>
                    </div>
                  </g:if>
                </div>
              </g:if>

              <!-- network membership -->
              <g:if test="${instance.networkMembership}">
                <div class="section">
                  <h3>Membership<cl:change id="networkMembershipLink"/></h3>
                  <g:if test="${instance.isMemberOf('CHAEC')}">
                    <p>Council of Heads of Australian Entomological Collections</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chaec-logo.png")}"/>
                  </g:if>
                  <g:if test="${instance.isMemberOf('CHAH')}">
                    <p>Council of Heads of Australasian Herbaria</p>
                    <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
                  </g:if>
                  <g:if test="${instance.isMemberOf('CHAFC')}">
                    <p>Council of Heads of Australian Faunal Collections</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chafc.png")}"/>
                  </g:if>
                  <g:if test="${instance.isMemberOf('CHACM')}">
                    <p>Council of Heads of Australian Collections of Microorganisms</p>
                    <img src="${resource(absolute:"true", dir:"data/network/",file:"chacm.png")}"/>
                  </g:if>
                </div>
              </g:if>

              <!-- attribution -->
              <g:set var='attribs' value='${instance.getAttributionList()}'/>
              <g:if test="${attribs.size() > 0}">
                <div class="section" id="infoSourceList">
                  <h4>Contributors to this page<cl:change id="attributionsLink"/></h4>
                  <ul>
                    <g:each var="a" in="${attribs}">
                      <g:if test="${a.url}">
                        <li><cl:wrappedLink href="${a.url}">${a.name}</cl:wrappedLink></li>
                      </g:if>
                      <g:else>
                        <li>${a.name}</li>
                      </g:else>
                    </g:each>
                  </ul>
                </div>
              </g:if>
            </div>
          </div>
          </div><!--overview-->
        </div>

        <!-- dialog elements -->
        <div id="name-dialog">
            <p class="dialog-hints">The collection name should be the official name of the collection in the local
            language. Do not include the acronym or any unnecessary punctutaion.</p>
            <p class="validateTips"> </p>
            <input type="text" style="width:450px;" name="name" id="nameInput" value="${instance.name}" maxlength="100"/>
        </div>
        <div id="acronym-dialog">
            <p class="dialog-hints">Acronym, coden or initialism by which this collection is generally known. Do not include parentheses.</p>
            <p class="validateTips"> </p>
            <input type="text" style="width:350px;" name="acronym" id="acronymInput" value="${instance.acronym}" maxlength="45"/>
        </div>
        <div id="lsid-dialog">
            <p class="dialog-hints">Enter a valid lsid for the collection if one has been assigned.</p>
            <p class="validateTips"> </p>
            <input type="text" style="width:350px;" name="lsid" id="lsidInput" value="${instance.guid}" maxlength="45"/>
        </div>
        <div id="description-dialog">
            <p class="dialog-hints">This description is the block of text that appears at the top of the page.</p>
            <p class="validateTips"> </p>
            <g:hiddenField name="descriptionType" value=""/>
            <textarea name="description" id="descriptionInput" rows="20" cols="90" class="tinymce"> </textarea>
        </div>
        <div id="temporalSpan-dialog">
            <p class="dialog-hints">Start and end dates refer to when the collection was first established and when
            acquisition ceased. Both are optional but if present should be valid
            <a href="http://code.google.com/p/darwincore/wiki/Event" target="_blank" class="external">Darwin Core event dates</a>.</p>
            <p class="validateTips"> </p>
            <label for="startDateInput">Start date:</label>
            <input type="text" style="width:350px;" name="startDate" id="startDateInput" value="${instance.startDate}" maxlength="45"/>
            <label for="endDateInput">End date:</label>
            <input type="text" style="width:350px;" name="endDate" id="endDateInput" value="${instance.endDate}" maxlength="45"/>
        </div>
        <div id="taxonomicRange-dialog">
            <p class="validateTips"> </p>
            <fieldset class="dialog">
                <legend>Focus</legend>
                <p>Describe the intended taxonomic focus of the collection, such as 'Fungi of medical importance'.</p>
                <textarea  name="focus" id="focusInput" rows=5 cols="90" >${instance.focus}</textarea>
            </fieldset>
            <fieldset class="dialog">
                <legend>Kingdom coverage</legend>
                <p>Indicate which biological kingdoms are covered by your collection.</p>
                <cl:checkBoxList name="kingdomCoverage" from="${Collection.kingdoms}" value="${instance?.kingdomCoverage}" />
            </fieldset>
            <fieldset class="dialog">
                <legend>Scientific names</legend>
                <p>Enter any number of taxon names that describe the taxonomic scope of the collection.
                Names of families or higher ranks are suitable. Separate names with a comma, eg Insecta, Arachnida</p>
                <textarea  name="scientificNames" id="scientificNamesInput" rows=5 cols="90" ><cl:JSONListAsStrings pureList='true' json='${fieldValue(bean: instance, field: "scientificNames")}'/></textarea>
            </fieldset>
        </div>
        <div id="geographicRange-dialog">
            <p class="validateTips"> </p>
            <fieldset class="dialog">
                <legend>Geographic description</legend>
                <p>A free text description of the geographical scope of the collection.</p>
                <textarea  name="geographicDescription" id="geographicDescriptionInput" rows=5 cols="90" >${instance.geographicDescription}</textarea>
            </fieldset>
            <fieldset class="dialog">
                <legend>States covered</legend>
                <p>States and territories that are covered by the collection.</p>
                <textarea  name="states" id="statesInput" rows=5 cols="90" >${instance.states}</textarea>
            </fieldset>
        </div>
        <div id="records-dialog">
            <label for="numRecordsInput">Number of specimens:</label>
            <input type="text" style="width:350px;" name="numRecords" id="numRecordsInput" value="${instance.numRecords}" maxlength="45"/>
            <label for="numRecordsDigitisedInput">Number of records digitised:</label>
            <input type="text" style="width:350px;" name="numRecordsDigitised" id="numRecordsDigitisedInput" value="${instance.numRecordsDigitised}" maxlength="45"/>
        </div>
        <div id="subCollections-dialog">
            <g:set var="subCollectionList" value="${JSON.parse(instance.subCollections)}"/>
            <table id="subCollections-table">
                <thead><tr><td>Name</td><td>Description</td></tr></thead><tbody>
                <g:each in="${subCollectionList}" var="sub">
                    <tr>
                        <td><textarea rows="3" cols="25">${sub.name}</textarea></td>
                        <td><textarea rows="5" cols="63">${sub.description}</textarea></td>
                    </tr>
                </g:each>
            </tbody></table>
        </div>
        <div id="representativeImage-dialog">
            <p class="dialog-hints"></p>
            <p class="validateTips"></p>
            <label for="imageFileInput">File</label>
            <input type="text" style="width:350px;" name="file" id="imageFileInput" value="${instance.imageRef?.file}" maxlength="45"/>
            <label for="imageCaptionInput">Caption</label>
            <input type="text" style="width:350px;" name="caption" id="imageCaptionInput" value="${instance.imageRef?.caption}" maxlength="45"/>
            <label for="imageAttributionInput">Attribution</label>
            <input type="text" style="width:350px;" name="attribution" id="imageAttributionInput" value="${instance.imageRef?.attribution}" maxlength="45"/>
            <label for="imageCopyrightInput">Copyright</label>
            <input type="text" style="width:350px;" name="copyright" id="imageCopyrightInput" value="${instance.imageRef?.copyright}" maxlength="45"/>
        </div>
        <div id="location-dialog">
            <style>
                #editMapCanvas {
                    width: 350px;
                    height: 300px;
                    float: none;
                }
            </style>
            <p class="dialog-hints"></p>
            <p class="validateTips"></p>
            <label for="streetInput">Street</label>
            <input type="text" style="width:350px;" name="street" id="streetInput" value="${address?.street}" maxlength="45"/>
            <label for="cityInput">City</label>
            <input type="text" style="width:350px;" name="city" id="cityInput" value="${address?.city}" maxlength="45"/>
            <label for="stateInput">State</label>
            <input type="text" style="width:350px;" name="state" id="stateInput" value="${address?.state}" maxlength="45"/>
            <label for="postcodeInput">Postcode</label>
            <input type="text" style="width:350px;" name="postcode" id="postcodeInput" value="${address?.postcode}" maxlength="45"/>
            <label for="countryInput">Country</label>
            <input type="text" style="width:350px;" name="country" id="countryInput" value="${address?.country}" maxlength="45"/>
            <label for="emailInput">Country</label>
            <input type="text" style="width:350px;" name="country" id="emailInput" value="${instance.email}" maxlength="45"/>
            <label for="phoneInput">Country</label>
            <input type="text" style="width:350px;" name="country" id="phoneInput" value="${instance.phone}" maxlength="45"/>
            <label for="latitudeInput">Latitude</label>
            <input type="text" style="width:350px;" name="latitude" id="latitudeInput" value="${latitude}" maxlength="45"/>
            <label for="longitudeInput">Longitude</label>
            <input type="text" style="width:350px;" name="longitude" id="longitudeInput" value="${longitude}" maxlength="45"/>
            <div id="editMapCanvas"></div>
            <script type="text/javascript">
                var map;
                var marker;

                function updateMarkerPosition(latLng) {
                    $('#latitudeInput').val(latLng.lat());
                    $('#longitudeInput').val(latLng.lng());
                }
            </script>
        </div>
        <div id="contacts-dialog">
            <div id="accordion">
            </div><br/>
            <button class="addExistingContact" onclick="dialogs.contacts.addExisting()">Add existing contact</button>
            <g:select name="addContact" from="${Contact.listOrderByLastName()}" optionKey="id" noSelection="${['null':'Select one to add']}" /><br/><br/>
            <button class="addNewContact" onclick="dialogs.contacts.addNew()">Add new contact</button>
        </div>
        <div id="websiteUrl-dialog">
            <p class="validateTips"> </p>
            <fieldset class="dialog">
                <legend>Collection's website</legend>
                <p>Enter the collection's website URL.</p>
                <textarea name="collectionWebsiteUrl" id="collectionWebsiteUrlInput" rows=1 cols="90" >${instance.websiteUrl}</textarea>
            </fieldset>
            <fieldset class="dialog">
                <legend>Institution's website</legend>
                <p>Enter the institution's website URL.</p>
                <textarea name="institutionWebsiteUrl" id="institutionWebsiteUrlInput" rows=1 cols="90" >${instance.institution?.websiteUrl}</textarea>
            </fieldset>
        </div>
        <div id="networkMembership-dialog">

        </div>

        <script type="text/javascript">
            values.name = new Value("${instance.name}");
            values.acronym = new Value("${instance.acronym}");
            values.lsid = new Value("${instance.guid}");
            values.pubDescription = new Value("<cl:formattedText body='${instance.pubDescription}'/>");
            values.techDescription = new Value("<cl:formattedText body='${instance.techDescription}'/>");
            values.startDate = new Value("${instance.startDate}");
            values.endDate = new Value("${instance.endDate}");
            values.focus = new Value("<cl:formattedText body='${instance.focus}'/>");
            values.kingdomCoverage = new Value("${instance.kingdomCoverage}");
            values.scientificNames = new Value(<cl:raw value="${instance.scientificNames}" default="[]"/>);
            values.geographicDescription = new Value("${instance.geographicDescription}");
            values.states = new Value("${instance.states}");
            values.numRecords = new Value("${instance.numRecords}");
            values.numRecordsDigitised = new Value("${instance.numRecordsDigitised}");
            values.subCollections = new Value("${instance.subCollections}".replace(/&quot;/g, '"'));
            values.imageRef = new Value(<cl:toJson obj="${instance.imageRef}" domainClass="true"/>);
            values.address = new Value(<cl:toJson obj="${address}" domainClass="true"/>);
            values.street = new Value("${address?.street}");
            values.city = new Value("${address?.city}");
            values.state = new Value("${address?.state}");
            values.postcode = new Value("${address?.postcode}");
            values.country = new Value("${address?.country}");
            values.latitude = new Value("${latitude}");
            values.longitude = new Value("${longitude}");
            values.contacts = new Value(<cl:toJson obj="${instance.getContactsPrimaryFirst()}"/>);
            values.collectionWebsiteUrl = new Value("${instance.websiteUrl}");
            values.institutionWebsiteUrl = new Value("${instance.institution?.websiteUrl}");

            var baseUrl = "${ConfigurationHolder.config.grails.serverURL}",
                uid = "${instance.uid}",
                username = "<cl:loggedInUsername/>",
                version = "${instance.version}";
        </script>
        <script type="text/javascript" >
            $(document).ready(function() {
                initializeLocationMap('${instance.canBeMapped()}',${latitude},${longitude});
                //greyInitialValues();
                $("a#lsidbox").fancybox({
                    'hideOnContentClick' : false,
                    'titleShow' : false,
                    'autoDimensions' : false,
                    'width' : 600,
                    'height' : 180
                });
                $("a.current").fancybox({
                    'hideOnContentClick' : false,
                    'titleShow' : false,
                    'titlePosition' : 'inside',
                    'autoDimensions' : true,
                    'width' : 300
                });
            });
        </script>
    </body>
</html>
