<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${layout ?: 'main'}" />
        <g:set var="entityName" value="${instance.ENTITY_TYPE}" />
        <g:set var="entityNameLower" value="${cl.controller(type: instance.ENTITY_TYPE)}"/>
        <title><g:message code="default.show.label" args="[entityName]" /></title>
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

            <p class="pull-right">
            <span class="button"><cl:viewPublicLink uid="${instance?.uid}"/></span>
            <span class="button"><cl:jsonSummaryLink uid="${instance.uid}"/></span>
            <span class="button"><cl:jsonDataLink uid="${instance.uid}"/></span>
            </p>

            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span></li>
            <li><span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span></li>
            </ul>

        </div>


        <div class="body">
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>



            <div class="dialog emulate-public">
              <!-- base attributes -->
              <div class="show-section well titleBlock">
                <!-- Name --><!-- Acronym -->
                <h1>${fieldValue(bean: instance, field: "name")}<cl:valueOrOtherwise value="${instance.acronym}"> (${fieldValue(bean: instance, field: "acronym")})</cl:valueOrOtherwise></h1>

                <!-- Data Provider --><!-- ALA Partner -->
                <h2 style="display:inline"><g:link controller="dataProvider" action="show" id="${instance.dataProvider?.id}">${instance.dataProvider?.name}</g:link></h2>
                <cl:partner test="${instance.dataProvider?.isALAPartner}"/><br/>

                <!-- Institution -->
                <g:if test="${instance.institution}">
                  <p><span class="label">Source of records:</span> <g:link controller="institution" action="show" id="${instance.institution?.uid}">${instance.institution?.name}</g:link></p>
                </g:if>

                <!-- GUID    -->
                <p><span class="label">LSID:</span> <cl:guid target="_blank" guid='${fieldValue(bean: instance, field: "guid")}'/></p>

                <!-- UID    -->
                <p><span class="label">UID:</span> ${fieldValue(bean: instance, field: "uid")}</p>

                <!-- type -->
                <p><span class="label">Resource type:</span> ${fieldValue(bean: instance, field: "resourceType")}</p>

                <!-- Web site -->
                <p><span class="label">Collection website:</span> <cl:externalLink href="${fieldValue(bean:instance, field:'websiteUrl')}"/></p>

                <!-- Networks -->
                <g:if test="${instance.networkMembership}">
                  <p><cl:membershipWithGraphics coll="${instance}"/></p>
                </g:if>

                <!-- Notes -->
                <g:if test="${instance.notes}">
                  <p><cl:formattedText>${fieldValue(bean: instance, field: "notes")}</cl:formattedText></p>
                </g:if>

                <!-- last edit -->
                <p><span class="label">Last change:</span> ${fieldValue(bean: instance, field: "userLastModified")} on ${fieldValue(bean: instance, field: "lastUpdated")}</p>

                <cl:editButton uid="${instance.uid}" page="/shared/base" notAuthorisedMessage="You are not authorised to edit this resource."/>
              </div>

              <!-- description -->
              <div class="show-section well">
                <h2>Description</h2>

                <!-- Pub Desc -->
                <div class="label">Public description:</div><div style="clear:both;"></div>
                <cl:formattedText body="${instance.pubDescription}"/>

                <!-- Tech Desc -->
                <div class="label">Technical description:</div><div style="clear:both;"></div>
                <cl:formattedText body="${instance.techDescription}"/>

                <!-- Focus -->
                <div class="label">Focus:</div><div style="clear:both;"></div>
                <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>

                <!-- generalisations -->
                <p><span class="label">Data generalisations:</span> ${fieldValue(bean: instance, field: "dataGeneralizations")}</p>

                <!-- info withheld -->
                <p><span class="label">Information withheld:</span> ${fieldValue(bean: instance, field: "informationWithheld")}</p>

                <!-- content types -->
                <p><span class="label">Content types:</span> ${fieldValue(bean: instance, field: "contentTypes")}</p>

                <cl:editButton uid="${instance.uid}" page="description"/>
              </div>

              <!-- taxonomic range -->
              <div class="show-section well">
                <h2>Taxonomic range</h2>

                <!-- range -->
                <cl:taxonomicRangeDescription obj="${instance.taxonomyHints}" key="range"/>

                <cl:editButton uid="${instance.uid}" page="/shared/taxonomicRange"/>
              </div>

              <!-- mobilisation -->
              <div class="show-section well">
                <h2>Data mobilisation</h2>

                <!-- contributor -->
                <p><span class="label">Atlas contributor:</span><cl:tickOrCross test="${instance.status == 'dataAvailable' || instance.status == 'linksAvailable'}">yes|no</cl:tickOrCross></p>

                <!-- status -->
                <p><span class="label">Status:</span> ${fieldValue(bean: instance, field: "status")}</p>

                <!-- provenance -->
                <p><span class="label">Provenance:</span> ${fieldValue(bean: instance, field: "provenance")}</p>

                <!-- last checked -->
                <p><span class="label">Last checked:</span> ${fieldValue(bean: instance, field: "lastChecked")}</p>

                <!-- data currency -->
                <p><span class="label">Data currency:</span> ${fieldValue(bean: instance, field: "dataCurrency")}</p>

                <!-- harvest frequency -->
                <p><span class="label">Harvest frequency:</span>
                    <g:if test="${instance.harvestFrequency}">
                        Every ${instance.harvestFrequency} days.</p>
                    </g:if>
                    <g:else>Manual</g:else>

                <!-- mobilisation notes -->
                <p><span class="label">Mobilisation notes:</span> ${fieldValue(bean: instance, field: "mobilisationNotes")}</p>

                <!-- harvesting notes -->
                <p><span class="label">Harvesting notes:</span> ${fieldValue(bean: instance, field: "harvestingNotes")}</p>

                <!-- public archive available -->
                <p><span class="label">Public archive available:</span><cl:tickOrCross test="${instance.publicArchiveAvailable}">yes|no</cl:tickOrCross></p>

                <!-- connection parameters -->
                <p><span class="label">Connection parameters:</span> <cl:showConnectionParameters connectionParameters="${instance.connectionParameters}"/></p>

                <g:if test="${instance.resourceType == 'records'}">
                    <!-- darwin core defaults -->
                    <g:set var="dwc" value="${instance.defaultDarwinCoreValues ? JSON.parse(instance.defaultDarwinCoreValues) : [:]}"/>
                    <p><span class="label">Default values for DwC fields:</span>
                        <g:if test="${!dwc}">none</g:if></p>
                        <table class="valueTable"><colgroup><col width="30%"><col width="70%"></colgroup><tbody>
                        <g:each in="${dwc.entrySet()}" var="dwct">
                            <tr><td>${dwct.key}:</td><td>${dwct.value}</td></tr>
                        </g:each>
                        </tbody></table>
                </g:if>

                <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
                  <div><span class="buttons"><g:link class="edit btn" action='edit' params="[page:'contribution']" id="${instance.uid}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
                </cl:ifGranted>
              </div>

              <!-- rights -->
              <div class="show-section well">
                <h2>Citation and rights</h2>

                <!-- citation -->
                <p><span class="label">Citation:</span> ${fieldValue(bean: instance, field: "citation")}</p>

                <!-- rights -->
                <p><span class="label">Rights:</span> ${fieldValue(bean: instance, field: "rights")}</p>

                <!-- license -->
                <p><span class="label">License type:</span> <cl:displayLicenseType type="${instance.licenseType}"/></p>

                <!-- license version -->
                <p><span class="label">License version:</span> ${fieldValue(bean: instance, field: "licenseVersion")}</p>

                <!-- permissions document -->
                <p><span class="label">Permissions document:</span>
                    <g:if test="${instance.permissionsDocument?.startsWith('http://') || instance.permissionsDocument?.startsWith('https://')}">
                        <g:link class="external_icon" target="_blank" url="${instance.permissionsDocument}">${fieldValue(bean: instance, field: "permissionsDocument")}</g:link>
                    </g:if>
                    <g:else>
                        ${fieldValue(bean: instance, field: "permissionsDocument")}
                    </g:else>
                </p>

                <!-- permissions document type -->
                <p><span class="label">Permissions document type:</span> ${fieldValue(bean: instance, field: "permissionsDocumentType")}</p>

                <!-- DPA flags -->
                <g:if test="${instance.permissionsDocumentType == 'Data Provider Agreement'}">
                    <p><span class="label">Risk assessment completed:</span><cl:tickOrCross test="${instance.riskAssessment}">yes|no</cl:tickOrCross></p>
                    <p><span class="label">Document filed:</span><cl:tickOrCross test="${instance.filed}">yes|no</cl:tickOrCross></p>
                </g:if>

                <!-- download limit -->
                <p><span class="label">Download limit:</span> ${instance.downloadLimit ? fieldValue(bean:instance,field:'downloadLimit') : 'no limit'}</p>

                <cl:editButton uid="${instance.uid}" page="rights"/>
              </div>

              <!-- images -->
              <g:render template="/shared/images" model="[target: 'logoRef', image: instance.logoRef, title:'Logo', instance: instance]"/>
              <g:render template="/shared/images" model="[target: 'imageRef', image: instance.imageRef, title:'Representative image', instance: instance]"/>

              <!-- location -->
              <g:render template="/shared/location" model="[instance: instance]"/>

              <!-- Record consumers -->
              <g:if test="${instance.resourceType == 'records'}">
                  <g:render template="/shared/consumers" model="[instance: instance]"/>
              </g:if>

              <!-- Contacts -->
              <g:render template="/shared/contacts" model="[contacts: contacts, instance: instance]"/>

              <!-- Attributions -->
              <g:render template="/shared/attributions" model="[instance: instance]"/>

              <!-- taxonomy hints -->
              <g:render template="/shared/taxonomyHints" model="[instance: instance]"/>

              <!-- change history -->
              <g:render template="/shared/changes" model="[changes: changes, instance: instance]"/>

            </div>
            <div class="buttons">

              <div class="pull-right">
                <span class="button"><cl:viewPublicLink uid="${instance?.uid}"/></span>
                <span class="button"><cl:jsonSummaryLink uid="${instance.uid}"/></span>
                <span class="button"><cl:jsonDataLink uid="${instance.uid}"/></span>
              </div>
              <g:form>
                <g:hiddenField name="id" value="${instance?.id}"/>
                <cl:ifGranted role="${ProviderGroup.ROLE_ADMIN}">
                  <span><g:actionSubmit class="delete btn btn-danger" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
                </cl:ifGranted>
              </g:form>
            </div>

        </div>
    </body>
</html>
