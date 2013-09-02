<g:if test="${it?.size() > 0}">
  <div class="section">
    <h3>Contact</h3>
    <g:each in="${it}" var="cf">
      <div class="contact">
        <p>
            <span class="contactName">${cf?.contact?.buildName()}</span><br/>
            <g:if test="${cf?.role}">${cf?.role}<br/></g:if>
            <cl:ifNotBlank tagName="span" prefix="phone: " value='${fieldValue(bean: cf, field: "contact.phone")}'/><br/>
            <cl:ifNotBlank tagName="span" prefix="fax: " value='${fieldValue(bean: cf, field: "contact.fax")}'/><br/>
            <cl:emailLink email="${cf?.contact?.email}">email this contact</cl:emailLink>
        </p>
      </div>
    </g:each>
  </div>
</g:if>
