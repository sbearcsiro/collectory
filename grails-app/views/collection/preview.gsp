<%@ page import="au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.InfoSource" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title>Preview ${fieldValue(bean: collectionInstance, field: "name")}</title>
    </head>
    <body>
        <!--div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="list" action="myList"><g:message code="default.myList.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div-->
        <div class="body" style="background: white;">
          <div class="previewHeader">
            <!-- institution -->
            <g:set var="institution" value="${collectionInstance.findPrimaryInstitution()}"/>
            <g:if test="${institution}">
              <g:if test="${fieldValue(bean: institution, field: 'logoRef') && fieldValue(bean: institution, field: 'logoRef.file')}">
                <img src='${resource(dir:"images/institution/",file:fieldValue(bean: institution, field: 'logoRef.file'))}' />
                <!--div style="clear: both;"></div-->
              </g:if>
              <span><g:link controller="institution" action="show" id="${institution.id}">${fieldValue(bean: institution, field: "name")}</g:link></span>
            </g:if>
            <!-- collection name -->
            <h1>${fieldValue(bean: collectionInstance, field: "name")}</h1>
            <!-- guid -->
            <cl:guid target="_blank" guid='${fieldValue(bean: collectionInstance, field: "guid")}'/>
          </div>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
          <div class="dialog preview">
            <table><colgroup><col width="70%"><col width = "30%"></colgroup>
              <tr><td class="leftColumn">
                <h2>Description</h2>
                <p><cl:formattedText>${fieldValue(bean: collectionInstance, field: "pubDescription")}</cl:formattedText></p>
                <p><cl:formattedText>${fieldValue(bean: collectionInstance, field: "techDescription")}</cl:formattedText></p>
                <cl:temporalSpan start='${fieldValue(bean: collectionInstance, field: "scope.startDate")}' end='${fieldValue(bean: collectionInstance, field: "scope.endDate")}'/>

                <h2>Taxonomic range</h2>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'focus')}">
                  <p><cl:formattedText>${fieldValue(bean: collectionInstance, field: "focus")}</cl:formattedText></p>
                </g:if>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.kingdomCoverage')}">
                  <p>Kingdoms covered include: ${fieldValue(bean: collectionInstance, field: "scope.kingdomCoverage")}</p>
                </g:if>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.scientificNames')}">
                  <p>Specimens in the ${collectionInstance.name} include members from the following taxa:<br/>
                  <cl:JSONListAsList json='${fieldValue(bean: collectionInstance, field: "scope.scientificNames")}'/></p>
                </g:if>

                <h2>Geographic range</h2>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.geographicDescription')}">
                  <p>${fieldValue(bean: collectionInstance, field: "scope.geographicDescription")}</p>
                </g:if>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.states')}">
                  <p><cl:stateCoverage states='${fieldValue(bean: collectionInstance, field: "scope.states")}'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.westCoordinate != -1}">
                  <p>${fieldValue(bean: collectionInstance, field: 'scope.westCoordinate')}</p>
                  <p>The western most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.westCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.eastCoordinate != -1}">
                  <p>The eastern most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.eastCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.northCoordinate != -1}">
                  <p>The northtern most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.northCoordinate}' degree='true'/></p>
                </g:if>
                <g:if test="${collectionInstance.scope.southCoordinate != -1}">
                  <p>The southern most extent of the collection is: <cl:showDecimal value='${collectionInstance.scope?.southCoordinate}' degree='true'/></p>
                </g:if>

                <!--h2>Geological age</h2-->

                <h2>Number of specimens in the collection</h2>
                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.numRecords') != '-1'}">
                  <p>The estimated number of specimens within the ${collectionInstance.name}: ${fieldValue(bean: collectionInstance, field: "scope.numRecords")}.</p>
                </g:if>

                <g:if test="${fieldValue(bean: collectionInstance, field: 'scope.numRecordsDigitised') != '-1'}">
                  <h2>Number of digitised specimens</h2>
                  <p>Of these ${fieldValue(bean: collectionInstance, field: "scope.numRecordsDigitised")} are digitised.
                  This represents <cl:percentIfKnown dividend='${collectionInstance.scope?.numRecordsDigitised}' divisor='${collectionInstance.scope?.numRecords}' /> of the collection.</p>
                </g:if>

                <g:if test="${collectionInstance.scope.listSubCollections()?.size() > 0}">
                  <h2>Sub-collections</h2>
                  <p>The <cl:collectionName name="${collectionInstance.name}"/> contains these significant collections:</p>
                  <g:each var="sub" in="${collectionInstance.scope.listSubCollections()}" >
                    <p class="sub"><cl:subCollectionDisplay sub="${sub}"/></p>
                  </g:each>
                </g:if>
              </td>
              <td class="rightColumn">
                <div>
                  <g:if test="${fieldValue(bean: collectionInstance, field: 'imageRef') && fieldValue(bean: collectionInstance, field: 'imageRef.file')}">
                    <img alt="${fieldValue(bean: collectionInstance, field: "imageRef.file")}"
                            src="${resource(dir:'images/collection', file:collectionInstance.imageRef.file)}" />
                    <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.caption")}</p>
                    <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.attribution")}</p>
                    <p class="caption">${fieldValue(bean: collectionInstance, field: "imageRef.copyright")}</p>
                  </g:if>
                </div>

                <h4>Location</h4>
                  <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "address.street")}'/>
                  <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "address.postBox")}'/>
                  <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "address.city")+ " " +fieldValue(bean: collectionInstance, field: "address.state")+ " " +fieldValue(bean: collectionInstance, field: "address.postcode")}'/>
                  <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "address.country")}'/>

                  <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "email")}'/>
                  <cl:ifNotBlank value='${fieldValue(bean: collectionInstance, field: "phone")}'/>

                <g:if test="${contact}">
                  <h4>Contact</h4>
                    <p class="contactName">${contact?.contact?.buildName()}</p>
                    <p>${contact?.role}</p>
                    <cl:ifNotBlank prefix="phone: " value='${fieldValue(bean: contact, field: "contact.phone")}'/>
                    <cl:ifNotBlank prefix="fax: " value='${fieldValue(bean: contact, field: "contact.fax")}'/>
                    <p>email: <cl:emailLink>${contact?.contact?.email}</cl:emailLink></p>
                </g:if>                  

                <!-- web site -->
                <g:if test="${collectionInstance.websiteUrl}">
                  <h4>Web site</h4>
                  <div class="webSite">
                    <a target="_blank" href="${collectionInstance.websiteUrl}">${collectionInstance.websiteUrl}</a>
                  </div>
                </g:if>

                <!-- network membership -->
                <g:if test="${collectionInstance.networkMembership}">
                  <h4>Membership</h4>
                  <g:if test="${collectionInstance.isMemberOf('CHAEC')}">
                    <p>Member of Council of Heads of Australian Entomological Collections (CHAEC)</p>
                    <img src="${resource(dir:"images/network/",file:"butflyyl.gif")}"/>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('CHAH')}">
                    <p>Member of Council of Heads of Australasian Herbaria (CHAH)</p>
                    <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(dir:"images/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('CHAFC')}">
                    <p>Member of Council of Heads of Australian Faunal Collections (CHAFC)</p>
                  </g:if>
                  <g:if test="${collectionInstance.isMemberOf('AMRRN')}">
                    <p>Member of Australian Microbial Resources Reseach Network (AMRRN)</p>
                    <img src="${resource(dir:"images/network/",file:"amrrnlogo.png")}"/>
                  </g:if>
                </g:if>

              </td></tr>
            </table>

            </div>
            <div class="buttons">
              <g:form>
                <g:hiddenField name="id" value="${collectionInstance?.id}" />
                <span class="button"><g:actionSubmit class="return" action='show' value="${message(code: 'default.button.return.label', default: 'Return')}" /></span>
              </g:form>
            </div>
        </div>
    </body>
</html>
