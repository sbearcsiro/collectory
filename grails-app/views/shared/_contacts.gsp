<!-- Contacts -->
 <div class="show-section">
 <h2>Contacts</h2>
 <ul class="fancy">
   <g:each in="${contacts}" var="c">
     <li><g:link controller="contact" action="show" id="${c?.contact?.id}">
       ${c?.contact?.buildName()}
       <cl:roleIfPresent role='${c?.role}'/>
       <cl:adminIfPresent admin='${c?.administrator}'/>
       ${c?.contact?.phone}
       <cl:valueOrOtherwise value ="${c?.primaryContact}"> (Primary contact)</cl:valueOrOtherwise>
     </g:link>
     </li>
   </g:each>
 </ul>
 <div style="clear:both;"><span class="buttons"><g:link class="edit" action='edit' params="[page:'/shared/showContacts']" id="${instance.uid}">${message(code: 'default.button.edit.label', default: 'Edit')}</g:link></span></div>
 </div>
