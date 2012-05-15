<g:if test="${it?.size() > 0}">
  <div class="section">
    <h3>Contact</h3>
    <g:each in="${it}" var="cf">
      <div class="contact">
        <p class="contactName">${cf?.contact?.buildName()}</p>
        <p>${cf?.role}</p>
        <cl:ifNotBlank prefix="phone: " value='${fieldValue(bean: cf, field: "contact.phone")}'/>
        <cl:ifNotBlank prefix="fax: " value='${fieldValue(bean: cf, field: "contact.fax")}'/>
        <p><cl:emailLink email="${cf?.contact?.email}">email this contact</cl:emailLink></p>
      </div>
    </g:each>
  </div>
</g:if>
