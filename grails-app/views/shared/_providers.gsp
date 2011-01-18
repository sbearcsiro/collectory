<%@ page import="au.org.ala.collectory.ProviderGroup" %>
<div class="show-section">
  <h2>Record providers and resources</h2>
  <p>These data providers and data resources contribute digitised records for specimens in this ${ProviderGroup.textFormOfEntityType(instance.uid)}.</p>
  <ul class="fancy">
    <g:each in="${instance.listProviders()}" var="prov">
      <g:set var="pg" value="${ProviderGroup._get(prov)}"/>
      <g:if test="${pg}">
        <g:set var="isProvider" value="${prov[0..1] == 'dp'}"/>
        <li><g:link controller="${cl.controllerFromUid(uid:prov)}" action="show" id="${prov}">${pg.name}</g:link> (${isProvider ? 'provider' : 'resource'})</li>
        <g:if test="${isProvider}">
          <!-- list resources -->
          <ul class='resources'>
            <g:each in="${pg.resources}" var="res">
              <li>${res.name} (resource)</li>
            </g:each>
          </ul>
        </g:if>
      </g:if>
      <g:else><li>The specified provider does not exist!</li></g:else>
    </g:each>
  </ul>
  <div style="clear:both;"></div>
  <cl:editButton uid="${instance.uid}" controller="dataLink" action="list" consumer="${instance.uid}"/>
</div>
