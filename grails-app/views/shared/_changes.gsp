<g:if test="${changes}">
  <div class="show-section">
    <h2>Change history</h2>
    <p>Click an item to view full change details.</p>
    <ul class=simple>
      <g:each in="${changes}" var="ch">
        <li><g:link controller='auditLogEvent' action='show' id='${ch.id}'>${ch.lastUpdated}: ${ch.actor}
          <cl:changeEventName event="${ch.eventName}" highlightInsertDelete="true"/> <strong>${ch.propertyName}</strong>
          <g:if test="${ch.className.endsWith('ContactFor')}">
            <g:if test="${ch.eventName == 'UPDATE'}">in Contact</g:if>
            <g:elseif test="${ch.eventName == 'INSERT'}">new Contact</g:elseif>
            <g:else>Contact</g:else>
          </g:if>
        </g:link></li>
      </g:each>
    </ul>
    <div style="clear:both;"><span class="buttons"><g:link class="edit" action="showChanges" id="${instance?.id}">${message(code: 'default.button.showAll.label', default: 'Show all')}</g:link></span></div>
  </div>
</g:if>
