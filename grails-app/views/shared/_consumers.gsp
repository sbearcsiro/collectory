<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<div class="show-section">
  <h2>Record consumers</h2>
  <p>These institutions and collections hold specimens related to the records sourced from this ${ProviderGroup.textFormOfEntityType(instance.uid)}.</p>
  <ul class="fancy">
    <g:each in="${instance.listConsumers()}" var="con">
      <g:set var="pg" value="${ProviderGroup._get(con)}"/>
      <g:if test="${pg}">
        <li><g:link controller="${cl.controllerFromUid(uid:con)}" action="show" id="${con}">${pg.name}</g:link> (${con[0..1] == 'in' ? 'institution' : 'collection'})</li>
      </g:if>
      <g:else><li>The specified consumer does not exist!</li></g:else>
    </g:each>
  </ul>
  <div style="clear:both;"></div>
  <cl:editButton uid="${instance.uid}" action="editConsumers" target="${target}"/>
</div>
