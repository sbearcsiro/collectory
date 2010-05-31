<table class="shy">
  <g:if test="${fieldValue(bean: command, field: 'imageRef.file')}">
    <tr>
      <td colspan="2">
        <img alt="${fieldValue(bean: command, field: "imageRef.file")}"
                src="${resource(dir:'images/'+directory, file:command.imageRef.file)}" />
      </td>
    </tr>
    <tr>
      <td colspan="2" style="padding-bottom:14px;"><span style="padding-right:75px;">${command.imageRef.file}</span>
        <g:link action="${action}" event="removeImage" >Remove image</g:link>
      </td>
    </tr>
  </g:if>
  <tr class='prop'>
    <td valign="top" class="name">
      <g:if test="${fieldValue(bean: command, field: 'imageRef.file')}">
        Choose a <br/>different image
      </g:if>
      <g:else>
        Choose an <br/>image
      </g:else>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.file', 'errors')}">
      <input type="file" name="imageFile" value="${command?.imageRef?.file}"/>
    </td>
  </tr>
  <tr class='prop'>
    <td valign="top" class="name">
      <label for="imageRef.caption"><g:message code="providerGroup.imageRef.filename.label" default="Caption" /></label>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.caption', 'errors')}">
        <g:textField name="imageRef.caption" maxlength="128" value="${command?.imageRef?.caption}" />
    </td>
  </tr>
  <tr class='prop'>
    <td valign="top" class="name">
      <label for="imageRef.attribution"><g:message code="providerGroup.imageRef.attribution.label" default="Attribution" /></label>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.attribution', 'errors')}">
        <g:textField name="imageRef.attribution" maxlength="128" value="${command?.imageRef?.attribution}" />
    </td>
  </tr>
  <tr class='prop'>
    <td valign="top" class="name">
      <label for="imageRef.copyright"><g:message code="providerGroup.imageRef.copyright.label" default="Copyright" /></label>
    </td>
    <td valign="top" class="value ${hasErrors(bean: command, field: 'imageRef.copyright', 'errors')}">
        <g:textField name="imageRef.copyright" maxlength="128" value="${command?.imageRef?.copyright}" />
    </td>
  </tr>
</table>
