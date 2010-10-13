<%@ page import="au.org.ala.collectory.Collection; au.org.ala.collectory.DataHub; au.org.ala.collectory.DataResource; au.org.ala.collectory.DataProvider; au.org.ala.collectory.Institution" %>
<div class="show-section">
  <g:if test="${instance instanceof Collection}">
    <g:set var="dir" value="data/collection"/>
  </g:if>
  <g:elseif test="${instance instanceof Institution}">
    <g:set var="dir" value="data/institution"/>
  </g:elseif>
  <g:elseif test="${instance instanceof DataProvider}">
    <g:set var="dir" value="data/dataProvider"/>
  </g:elseif>
  <g:elseif test="${instance instanceof DataResource}">
    <g:set var="dir" value="data/dataResource"/>
  </g:elseif>
  <g:elseif test="${instance instanceof DataHub}">
    <g:set var="dir" value="data/dataHub"/>
  </g:elseif>
  <h2>${title}</h2>
  <g:if test="${fieldValue(bean: image, field: 'file')}">
    <img class="showImage" alt="${fieldValue(bean: image, field: "file")}"
        src="${resource(absolute: "true", dir: dir, file: image.file)}"/>
    <p class="caption">${fieldValue(bean: image, field: "file")}</p>
    <cl:formattedText pClass="caption">${fieldValue(bean: image, field: "caption")}</cl:formattedText>
    <p class="caption">${fieldValue(bean: image, field: "attribution")}</p>
    <p class="caption">${fieldValue(bean: image, field: "copyright")}</p>
  </g:if>

  <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params='[page:"/shared/images",target:"${target}"]' id="${instance.uid}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
</div>
