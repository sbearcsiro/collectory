<%@ page import="au.org.ala.collectory.Collection" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'collection.label', default: 'Collection')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><cl:homeLink/></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="list" action="myList"><g:message code="default.myList.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1>${fieldValue(bean: collectionInstance, field: "name")}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                        <tr colspan="2">
                          <g:if test="${fieldValue(bean: collectionInstance, field: 'logoRef')}">
                            <img src='${resource(absolute: "true", dir:"data/collection/",file:fieldValue(bean: collectionInstance, field: 'logoRef.file'))}' />
                          </g:if>
                        </tr>
                    
<!-- Name -->           <tr class="prop">
                            <td valign="top" class="name" style="width: 300px"><g:message code="collection.name.label" default="Name" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "name")}</td>
                        </tr>

<!-- GUID    -->        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.guid.label" default="Guid" /></td>
                            <td valign="top" class="value"><cl:guid target="_blank" guid='${fieldValue(bean: collectionInstance, field: "guid")}'/></td>
                        </tr>

<!-- UID    -->        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.uid.label" default="Uid" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "uid")}</td>
                        </tr>

<!-- Acronym -->        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.acronym.label" default="Acronym" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "acronym")}</td>
                        </tr>

<!-- Collection type --><tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.collectionType.label" default="Collection type" /></td>
                            <td valign="top" class="value"><cl:JSONListAsStrings json='${collectionInstance.collectionType}'/></td>
                        </tr>

<!-- Active -->         <tr class="prop">
                            <td valign="top" class="name"><g:message code="active.label" default="Active" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "active")}</td>
                        </tr>

<!-- Focus   -->        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.focus.label" default="Focus" /></td>
                            <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: collectionInstance, field: "focus")}</cl:formattedText></td>
                        </tr>
                    
<!-- Institution -->   <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.institutions.label" default="Institutions" /></td>
                            <td valign="top" style="text-align: left;" class="value">
                               <li><g:link controller="institution" action="show" id="${collectionInstance.institution?.id}">${collectionInstance.institution?.name}</g:link></li>
                            </td>
                        </tr>

<!-- ALA Partner -->    <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.isALAPartner.label" default="Institution is an ALA Partner" /></td>
                            <td valign="top" class="value"><g:formatBoolean boolean="${collectionInstance?.isALAPartner}" /></td>
                        </tr>

<!-- Networks -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.networkMembership.label" default="Is a member of" /></td>
                            <td valign="top" class="value">
                              <g:if test="${collectionInstance.networkMembership}">
                                <cl:JSONListAsStrings json='${collectionInstance.networkMembership}'/>
                              </g:if>
                              <g:elseif test="${collectionInstance.findPrimaryInstitution()?.networkMembership}">
                                Institution is member of <cl:JSONListAsStrings json='${collectionInstance.findPrimaryInstitution().networkMembership}'/> but the collection is not.
                              </g:elseif>
                            </td>
                        </tr>

<!-- Pub Desc -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.pubDescription.label" default="Public description" /></td>
                            <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: collectionInstance, field: "pubDescription")}</cl:formattedText></td>
                        </tr>

<!-- Tech Desc -->      <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.techDescription.label" default="Technical Description" /></td>
                            <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: collectionInstance, field: "techDescription")}</cl:formattedText></td>
                        </tr>

<!-- sub collections -->
                        <cl:subCollectionList list="${collectionInstance.subCollections}"/>

<!-- Notes -->          <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.notes.label" default="Notes" /></td>
                            <td valign="top" class="value"><cl:formattedText>${fieldValue(bean: collectionInstance, field: "notes")}</cl:formattedText></td>
                        </tr>

<!-- Keywords -->       <tr class="prop">
                          <td valign="top" class="name"><g:message code="keywords.label" default="Keywords" /></td>
                          <td valign="top" class="value"><cl:JSONListAsStrings json='${collectionInstance.keywords}'/></td>
                        </tr>
                    
<!-- Web site -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.website_url.label" default="Website Url" /></td>
                            <td valign="top" class="value"><a target="_blank" href="${fieldValue(bean: collectionInstance, field: 'websiteUrl')}">${fieldValue(bean: collectionInstance, field: "websiteUrl")}</a></td>
                        </tr>

<!-- ImageRef -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.image_ref.label" default="Representative Image" /></td>
                            <td valign="top">
                              <g:if test="${fieldValue(bean: collectionInstance, field: 'imageRef.file')}">
                                <table class='shy'>
                                  <tr>
                                    <td colspan="2">
                                      <img alt="${fieldValue(bean: collectionInstance, field: "imageRef.file")}"
                                              src="${resource(absolute: "true", dir:'data/collection', file:collectionInstance.imageRef.file)}" />
                                    </td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name" style="width:10%"><g:message code="collection.imageRef.file.label" default="File" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "imageRef.file")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="collection.imageRef.file.label" default="Caption" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "imageRef.caption")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="collection.imageRef.file.label" default="Attribution" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "imageRef.attribution")}</td>
                                  </tr>
                                  <tr class="prop">
                                      <td valign="top" class="name"><g:message code="collection.imageRef.file.label" default="Copyright" /></td>
                                      <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "imageRef.copyright")}</td>
                                  </tr>
                                </table>
                              </g:if>
                            </td>
                        </tr>

<!-- States -->         <tr class="prop">
                            <td valign="top" class="name"><g:message code="states.label" default="States" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "states")}</td>
                        </tr>

<!-- Geo descrip -->    <tr class="prop">
                            <td valign="top" class="name"><g:message code="geographicDescription.label" default="Geographic Description" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "geographicDescription")}</td>
                        </tr>

<!-- East coord -->     <tr class="prop">
                            <td valign="top" class="name"><g:message code="eastCoordinate.label" default="East Coordinate" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.eastCoordinate}' degree='true'/></td>
                        </tr>

<!-- West coord -->     <tr class="prop">
                            <td valign="top" class="name"><g:message code="westCoordinate.label" default="West Coordinate" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.westCoordinate}' degree='true'/></td>
                        </tr>

<!-- North coord -->    <tr class="prop">
                            <td valign="top" class="name"><g:message code="northCoordinate.label" default="North Coordinate" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.northCoordinate}' degree='true'/></td>
                        </tr>

<!-- South coord -->    <tr class="prop">
                            <td valign="top" class="name"><g:message code="southCoordinate.label" default="South Coordinate" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.southCoordinate}' degree='true'/></td>
                        </tr>

<!-- Start date -->     <tr class="prop">
                            <td valign="top" class="name"><g:message code="startDate.label" default="Start Date" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "startDate")}</td>
                        </tr>

<!-- End date -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="endDate.label" default="End Date" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "endDate")}</td>
                        </tr>

<!-- Kingdom cover-->   <tr class="prop">
                          <td valign="top" class="name"><g:message code="kingdomCoverage.label" default="Kingdom Coverage" /></td>
                          <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "kingdomCoverage")}</td>
                        </tr>

<!-- sci names -->      <tr class="prop">
                          <td valign="top" class="name"><g:message code="scientificNames.label" default="Scientific Names" /></td>
                          <td valign="top" class="value"><cl:JSONListAsStrings json='${fieldValue(bean: collectionInstance, field: "scientificNames")}'/></td>
                        </tr>

<!-- Num records -->    <tr class="prop">
                          <td valign="top" class="name"><g:message code="numRecords.label" default="Num Records" /></td>
                          <td valign="top" class="value">
                            <g:if test="${fieldValue(bean: collectionInstance, field: 'numRecords') != '-1'}">${fieldValue(bean: collectionInstance, field: "numRecords")}</g:if>
                          </td>
                        </tr>

<!--Records digitised--><tr class="prop">
                          <td valign="top" class="name"><g:message code="numRecordsDigitised.label" default="Num Records Digitised" /></td>
                          <td valign="top" class="value">
                            <g:if test="${fieldValue(bean: collectionInstance, field: 'numRecordsDigitised') != '-1'}">${fieldValue(bean: collectionInstance, field: "numRecordsDigitised")}</g:if>
                          </td>
                        </tr>

<!--% digitised -->     <tr class="prop">
                          <td valign="top" class="name"><g:message code="percentDigitised.label" default="Percent Digitised" /></td>
                          <td valign="top" class="value">
                            <cl:percentIfKnown dividend='${collectionInstance.numRecordsDigitised}' divisor='${collectionInstance.numRecords}' />
                          </td>
                        </tr>

<!-- Address -->        <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.address.label" default="Address" /></td>
                            
                            <td valign="top" class="value">
                              ${fieldValue(bean: collectionInstance, field: "address.street")}
                              ${fieldValue(bean: collectionInstance, field: "address.postBox")}
                              ${fieldValue(bean: collectionInstance, field: "address.city")}
                              ${fieldValue(bean: collectionInstance, field: "address.state")}
                              ${fieldValue(bean: collectionInstance, field: "address.postcode")}
                              <g:if test="${fieldValue(bean: collectionInstance, field: 'address.country') != 'Australia'}">
                                ${fieldValue(bean: collectionInstance, field: "address.country")}
                              </g:if>
                            </td>
                            
                        </tr>
                    
<!-- Latitude -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.latitude.label" default="Latitude" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.latitude}' degree='true'/></td>
                        </tr>

<!-- Longitude -->      <tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.longitude.label" default="Longitude" /></td>
                            <td valign="top" class="value"><cl:showDecimal value='${collectionInstance.longitude}' degree='true'/></td>
                        </tr>

<!-- State -->          <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.state.label" default="State" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "state")}</td>
                        </tr>
                    
<!-- Email -->          <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.email.label" default="Email" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "email")}</td>
                        </tr>
                    
<!-- Phone -->          <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.phone.label" default="Phone" /></td>
                            <td valign="top" class="value">${fieldValue(bean: collectionInstance, field: "phone")}</td>
                        </tr>
                    
<!-- web service -->    <!--tr class="prop">
                        </tr-->

<!-- protocol -->       <!--tr class="prop">
                        </tr-->

<!-- provider codes --> <!--tr class="prop">
                            <td valign="top" class="name"><g:message code="providerGroup.providerCodes.label" default="Collection codes" /></td>
                        </tr-->

<!-- Contacts -->       <tr class="prop">
                            <td valign="top" class="name"><g:message code="collection.contacts.label" default="Contacts" /></td>
                            
                        <td valign="top" style="text-align: left;" class="value">
                            <ul>
                            <g:each in="${contacts}" var="c">
                                <li><g:link controller="contact" action="show" id="${c?.contact?.id}">
                                    ${c?.contact?.buildName()}
                                    <cl:roleIfPresent role='${c?.role}'/>
                                    <cl:adminIfPresent admin='${c?.administrator}'/><br/>
                                    ${c?.contact?.phone}
                                  </g:link>
                                </li>
                            </g:each>
                            </ul>
                        </td>
                        </tr>
                    
<!-- last edit -->      <tr class="prop">
                            <td valign="top" class="name">Last edited</td>
                            <td valign="top" class="value">by ${fieldValue(bean: collectionInstance, field: "userLastModified")} on ${fieldValue(bean: collectionInstance, field: "lastUpdated")}</td>
                        </tr>

                    </tbody>
                </table>
            </div>
            <div class="buttons">
              <g:form>
                <g:hiddenField name="id" value="${collectionInstance?.id}" />
                  <span class="button"><g:actionSubmit class="edit" action='editCollection' value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                  <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                <span class="button"><g:link class="preview" controller="public" action='show' id="${collectionInstance?.id}">${message(code: 'default.button.preview.label', default: 'Preview')}</g:link></span>
              </g:form>
            </div>
        </div>
    </body>
</html>
