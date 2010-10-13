<!-- Attributions -->
<div class="show-section">
  <h2>Attributions</h2>
  <ul class="fancy">
    <g:each in="${instance.getAttributionList()}" var="att">
      <li>${att.name}</li>
    </g:each>
  </ul>
  <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/editAttributions']" id="${instance.uid}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
</div>
