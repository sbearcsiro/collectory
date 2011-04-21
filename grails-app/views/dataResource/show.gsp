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
    <body onload="initializeLocationMap('${instance.canBeMapped()}',${instance.latitude},${instance.longitude});">
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
                  <p><span class="category">Source of records</span>: <g:link controller="institution" action="show" id="${instance.institution?.uid}">${instance.institution?.name}</g:link></p>
                </g:if>

                <!-- GUID    -->
                <p><span class="category">LSID</span>: <cl:guid target="_blank" guid='${fieldValue(bean: instance, field: "guid")}'/></p>

                <!-- UID    -->
                <p><span class="category">UID</span>: ${fieldValue(bean: instance, field: "uid")}</p>

                <!-- type -->
                <p><span class="category">Resource type</span>: ${fieldValue(bean: instance, field: "resourceType")}</p>

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

                <!-- license -->
                <p><span class="category">License type</span>: <cl:displayLicenseType type="${instance.licenseType}"/></p>

                <!-- license version -->
                <p><span class="category">License version</span>: ${fieldValue(bean: instance, field: "licenseVersion")}</p>

                <!-- generalisations -->
                <p><span class="category">Data generalisations</span>: ${fieldValue(bean: instance, field: "dataGeneralizations")}</p>

                <!-- info withheld -->
                <p><span class="category">Information withheld</span>: ${fieldValue(bean: instance, field: "informationWithheld")}</p>

                <div><span class="buttons"><g:link class="edit" action='edit' params="[page:'rights']" id="${instance.id}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
              </div>

              <!-- images -->
              <g:render template="/shared/images" model="[target: 'logoRef', image: instance.logoRef, title:'Logo', instance: instance]"/>
              <g:render template="/shared/images" model="[target: 'imageRef', image: instance.imageRef, title:'Representative image', instance: instance]"/>

              <!-- location -->
              <g:render template="/shared/location" model="[instance: instance]"/>

              <!-- Record consumers -->
              <g:render template="/shared/consumers" model="[instance: instance]"/>

              <!-- Contacts -->
              <g:render template="/shared/contacts" model="[contacts: contacts, instance: instance]"/>

              <!-- Attributions -->
              <g:render template="/shared/attributions" model="[instance: instance]"/>

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
    </body>
</html>
