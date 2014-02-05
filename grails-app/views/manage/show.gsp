<%@ page import="au.org.ala.collectory.ContactFor; grails.converters.deep.JSON; org.codehaus.groovy.grails.commons.ConfigurationHolder; java.text.DecimalFormat; au.org.ala.collectory.Collection; au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.ala.skin}" />
        <title><cl:pageTitle>${fieldValue(bean: instance, field: "name")}</cl:pageTitle></title>
        <link rel="stylesheet" type="text/css" href="${resource(dir:'js/jquery.fancybox/fancybox',file:'jquery.fancybox-1.3.1.css')}" media="screen" />
        <link rel="stylesheet" href="${resource(dir:'css/smoothness',file:'jquery-ui-1.8.16.custom.css')}" type="text/css" media="screen"/>
        <r:require modules="fancybox, jquery_ui_custom, rotate, change, json2"/>
        <script type="text/javascript" src="${resource(dir:'js/tinymce/jscripts/tiny_mce', file:'jquery.tinymce.js')}" ></script >
        <script type="text/javascript" >
          $(document).ready(function() {
            greyInitialValues();
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
        <script type="text/javascript" language="javascript" src="http://www.google.com/jsapi"></script>
    </head>
    <body class="two-column-right">
      <div id="content">
        <div id="header" class="collectory">
          <!--Breadcrumbs-->
          <div id="breadcrumb"><cl:breadcrumbTrail/>
            <span class="icon icon-arrow-right"></span>
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

                <h2>Description<cl:change id="descriptionLink"/></h2>
                <div id="description">
                  <cl:formattedText body="${instance.pubDescription}"/>
                  <cl:formattedText body="${instance.techDescription}"/>
                </div>
                <p><span id="temporalSpan"><cl:temporalSpanText start="${instance.startDate}" end="${instance.endDate}" change="true"/></span>
                  <cl:change id="temporalSpanLink"/></p>

                <h2>Taxonomic range<cl:change id="taxonomicRangeLink"/></h2>
                <p class="${instance.focus ? '' : 'empty'}" id="focus">${fieldValue(bean: instance, field: "focus")}</p>
                <p class="${instance.kingdomCoverage ? '' : 'empty'}" id="kingdomCoverage">Kingdoms covered include: <cl:concatenateStrings values='${fieldValue(bean: instance, field: "kingdomCoverage")}'/>.</p>
                <p class="${instance.scientificNames ? '' : 'empty'}" id="sciNames"><cl:collectionName name="${instance.name}" prefix="The "/> includes members from the following taxa:<br/>
                <span id="scientificNames"><cl:JSONListAsStrings json='${fieldValue(bean: instance, field: "scientificNames")}'/></span>.</p>

                <h2>Geographic range<cl:change id="geographicRangeLink"/></h2>
                <p class="${instance.geographicDescription ? '' : 'empty'}" id="geographicDescription">${fieldValue(bean: instance, field: "geographicDescription")}</p>
                <p class="${instance.states ? '' : 'empty'}" id="states"><cl:stateCoverage states='${fieldValue(bean: instance, field: "states")}'/></p>

                <g:set var="nouns" value="${cl.nounForTypes(types:instance.listCollectionTypes())}"/>
                <h2>Number of <cl:nounForTypes types="${instance.listCollectionTypes()}"/> in the collection<cl:change id="records"/></h2>
                <g:if test="${fieldValue(bean: instance, field: 'numRecords') != '-1'}">
                <p>The estimated number of ${nouns} in <cl:collectionName prefix="the " name="${instance.name}"/> is ${fieldValue(bean: instance, field: "numRecords")}.</p>
                </g:if>
                <g:if test="${fieldValue(bean: instance, field: 'numRecordsDigitised') != '-1'}">
                <p>Of these ${fieldValue(bean: instance, field: "numRecordsDigitised")} are databased.
                This represents <cl:percentIfKnown dividend='${instance.numRecordsDigitised}' divisor='${instance.numRecords}' /> of the collection.</p>
                </g:if>
                <p>Click the Records & Statistics tab to access those database records that are available through the atlas.</p>

                <h2>Sub-collections<cl:change id="subCollections"/></h2>
                <p><cl:collectionName prefix="The " name="${instance.name}"/> contains these significant collections:</p>
                <cl:subCollectionList list="${instance.subCollections}"/>

                <cl:lastUpdated date="${instance.lastUpdated}"/>
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
              <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
                <div class="section">
                  <img style="max-width:100%;max-height:350px;" alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                          src="${resource(absolute:"true", dir:"data/collection/", file:instance.imageRef.file)}" />
                  <cl:formattedText pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
                  <cl:valueOrOtherwise value="${instance.imageRef?.attribution}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
                  <cl:valueOrOtherwise value="${instance.imageRef?.copyright}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
                  <cl:change id="imageRef"/>
                </div>
              </g:if>

              <div class="section">
                <h3>Location<cl:change id="location"/></h3>
                <!-- use parent location if the collection is blank -->
                <g:set var="address" value="${instance.address}"/>
                <g:if test="${address == null || address.isEmpty()}">
                  <g:if test="${instance.getInstitution()}">
                    <g:set var="address" value="${instance.getInstitution().address}"/>
                  </g:if>
                </g:if>

                <g:if test="${!address?.isEmpty()}">
                  <p>
                    <cl:valueOrOtherwise value="${address?.street}">${address?.street}<br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.city}">${address?.city}<br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.state}">${address?.state}</cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.postcode}">${address?.postcode}<br/></cl:valueOrOtherwise>
                    <cl:valueOrOtherwise value="${address?.country}">${address?.country}<br/></cl:valueOrOtherwise>
                  </p>
                </g:if>

                <g:if test="${instance.email}"><cl:emailLink>${fieldValue(bean: instance, field: "email")}</cl:emailLink><br/></g:if>
                <cl:ifNotBlank value='${fieldValue(bean: instance, field: "phone")}'/>
              </div>

              <!-- contacts -->
              <g:render template="/public/contacts" bean="${instance.getPublicContactsPrimaryFirst()}"/>

              <!-- web site -->
              <g:if test="${instance.websiteUrl || instance.institution?.websiteUrl}">
                <div class="section">
                  <h3>Web site<cl:change id="websiteUrl"/></h3>
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
                  <h3>Membership<cl:change id="networkMembership"/></h3>
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
                  <h4>Contributors to this page<cl:change id="attributions"/></h4>
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
            <p class="dialog-hints">This description is the main block of text that appears at the top of the page.</p>
            <p class="validateTips"> </p>
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

        <script type="text/javascript">
            originalValues.name = "${instance.name}";
            originalValues.acronym = "${instance.acronym}";
            originalValues.pubDescription = "";
            var baseUrl = "${ConfigurationHolder.config.grails.serverURL}",
                uid = "${instance.uid}",
                username = "<cl:loggedInUsername/>",
                currentValue = {
                    name: "${instance.name}",
                    acronym: "${instance.acronym}",
                    guid: "${instance.guid}",
                    pubDescription: "",   // not initialised as the initial text is
                    techDescription: "",  // taken from the formatted page elements
                    startDate: "${instance.startDate}",
                    endDate: "${instance.endDate}",
                    focus: "${instance.focus}",
                    kingdomCoverage: "${instance.kingdomCoverage}",
                    scientificNames: <cl:raw value="${instance.scientificNames}" default="[]"/>,
                    geographicDescription: "${instance.geographicDescription}",
                    states: "${instance.states}"
                };
        </script>
    </body>
</html>
