<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.CollectionLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.ala.skin}" />
        <!--meta name="viewport" content="initial-scale=1.0, user-scalable=no" /-->
        <title><g:message code="data.catalogue.title" /></title>
        <style type="text/css">
            .entity { font-weight: bold; }
            .code { font-family: 'courier new'}
        </style>
    </head>
    <body class="two-column-right" onload="">
    <div id="content">
      <div id="header">
        <!--Breadcrumbs-->
      <div id="breadcrumb">
        <ol class="breadcrumb">
            <li><a href='http://www.ala.org.au'><g:message code="data.catalogue.li01" /></a> <span class="icon icon-arrow-right"></span></li>
            <li><g:link controller="public"><g:message code="data.catalogue.li02" /></g:link> <span class="icon icon-arrow-right"></span></li>
            <li><g:message code="data.catalogue.li03" /></li>
        </ol>
      </div>
        <div class="section full-width">
          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>
          <div class="hrgroup">
            <img src="${resource(dir:"images/ala",file:"webservices.png")}" style="float: right;padding-right:50px;"/>
            <h1><g:message code="data.catalogue.title01" /></h1>
            <p><g:message code="data.catalogue.des01" /> <a href="http://code.google.com/p/ala-collectory/w/list"><g:message code="data.catalogue.des02" /></a>,
            <g:message code="data.catalogue.des03" /> <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices"><g:message code="data.catalogue.des04" /></a>.</p>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->
      <div id="column-one">
        <div class="section infoPage">
          %{--<div id='warnings'>
            <h2>Disclaimer</h2>
            <p>Please be aware that these services are still being refined. The specifications should be treated as experimental.
            They may change.</p>
          </div>--}%

          <h2 id="WS0024"><g:message code="data.catalogue.title02" /></h2>
          <p><g:message code="data.catalogue.des05" />:</p>
          <ul>
            <li><g:message code="data.catalogue.ws0024.li01" />;</li>
            <li><g:message code="data.catalogue.ws0024.li02" />;</li>
            <li><g:message code="data.catalogue.ws0024.li03" />;</li>
            <li><g:message code="data.catalogue.ws0024.li04" />;</li>
            <li><g:message code="data.catalogue.ws0024.li05" />;</li>
            <li><g:message code="data.catalogue.ws0024.li06" /></li>
            <li><g:message code="data.catalogue.ws0024.li07" />.</li>
          </ul>
          <p><g:message code="data.catalogue.des06" />.</p>
          <p><g:message code="data.catalogue.des007" />.</p>
          <h3><g:message code="data.catalogue.title03" /></h3>
          <table class="table">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td><g:message code="data.catalogue.table01.cell0101" />:</td>
              <td><a href="${ConfigurationHolder.config.grails.serverURL}/ws">http://collections.ala.org.au/ws</a></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.table01.cell0201" />:</td>
              <td><a href="${ConfigurationHolder.config.grails.serverURL}/ws/institution.json">http://collections.ala.org.au/ws/institution</a></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.table01.cell0301" />:</td>
              <td><a href="${ConfigurationHolder.config.grails.serverURL}/ws/institution/in72.json">http://collections.ala.org.au/ws/institution/in72</a></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.table01.cell0401" />:</td>
              <td><a href="${ConfigurationHolder.config.grails.serverURL}/ws/institution/count">http://collections.ala.org.au/ws/institution/count</a></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.table01.cell0501" />:</td>
              <td><a href="${ConfigurationHolder.config.grails.serverURL}/ws/institution/count/state">http://collections.ala.org.au/ws/institution/count/state</a></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.table01.cell0601" />:</td>
              <td><a href="${ConfigurationHolder.config.grails.serverURL}/ws/institution/in72/contacts.json">http://collections.ala.org.au/ws/institution/in72/contacts</a></td>
            </tr>
          </table>
          <h3><g:message code="data.catalogue.title04" /></h3>
          <p><g:message code="data.catalogue.des08" />.</p>
          <p><g:message code="data.catalogue.des09" />.</p>
          <p><g:message code="data.catalogue.des10" />.</p>
          <p><g:message code="data.catalogue.des11" />:</p>
          <ul>
            <li><g:message code="data.catalogue.li04" /></li>
            <li><g:message code="data.catalogue.li05" />.</li>
          </ul>
          <p><g:message code="data.catalogue.des12" />:</p>
          <ul>
            <li><g:message code="data.catalogue.li06" /></li>
          </ul>
          <p><g:message code="data.catalogue.des13" />.</p>
          <p><g:message code="data.catalogue.des14" />.</p>
          <p><g:message code="data.catalogue.des15" />.</p>
          <p><g:message code="data.catalogue.des16" />:</p>
            <ul>
                <li><g:message code="data.catalogue.li07" /></li>
                <li><g:message code="data.catalogue.li08" />.</li>
            </ul>

        <h3 id="WS0025"><g:message code="data.catalogue.ws0025.title" /></h3>
          <p><g:message code="data.catalogue.ws0025.des" />.</p>
          <table class="table">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td><g:message code="data.catalogue.ws0025.cell0101" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/contacts.json">http://collections.ala.org.au/ws/contacts</a></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0025.cell0201" /></td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/contacts/31.json">http://collections.ala.org.au/ws/contacts/31</a></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0025.cell0301" /></td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/contacts/email/dave.martin@csiro.au">http://collections.ala.org.au/ws/contacts/email/dave.martin@csiro.au</a></td>
            </tr>
          </table>
          <p><g:message code="data.catalogue.ws0025.des01" />.</p>
            <p><g:message code="data.catalogue.ws0025.des02" />:</p>
            <ul>
                <li><g:message code="data.catalogue.ws0025.li01" /></li>
                <li><g:message code="data.catalogue.ws0025.li02" />.</li>
            </ul>
            <p><g:message code="data.catalogue.ws0025.des03" /></p>
            <ul>
                <li><g:message code="data.catalogue.ws0025.li03" /></li>
                <li><g:message code="data.catalogue.ws0025.li04" /></li>
                <li><g:message code="data.catalogue.ws0025.li05" /></li>
                <li><g:message code="data.catalogue.ws0025.li06" /></li>
                <li><g:message code="data.catalogue.ws0025.li07" /></li>
                <li><g:message code="data.catalogue.ws0025.li08" /></li>
                <li><g:message code="data.catalogue.ws0025.li09" /></li>
            </ul>

          <p><g:message code="data.catalogue.ws0025.des04" />.</p>
          <p><g:message code="data.catalogue.ws0025.des05" />.</p>
          <h4><g:message code="data.catalogue.ws0025.title01" /></h4>
          <p><g:message code="data.catalogue.ws0025.des06" />.</p>
          <table class="table">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><g:message code="data.catalogue.ws0025.table0101" />:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/ws/{resource type}/{resource uid}/contacts</span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0025.table0201" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/collection/co13/contacts.json">http://collections.ala.org.au/ws/collection/co13/contacts</a></td>
            </tr>
            <tr>
              <td colspan="2"><g:message code="data.catalogue.ws0025.table0301" />:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/ws/{resource type}/{resource uid}/contacts/{id}</span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0025.table0401" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/collection/co13/contacts/20.json">http://collections.ala.org.au/ws/collection/co13/contacts/20</a></td>
            </tr>
            <tr>
              <td colspan="2"><g:message code="data.catalogue.ws0025.table0501" />:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/ws/{resource type}/contacts</span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0025.table0601" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/collection/contacts.json">http://collections.ala.org.au/ws/collection/contacts</a></td>
            </tr>
            <tr>
              <td colspan="2"><g:message code="data.catalogue.ws0025.table0701" />:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/ws/{resource type}/{resource uid}/contacts/notifiable</span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0025.table0801" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/collection/co13/contacts/notifiable.json">http://collections.ala.org.au/ws/collection/co13/contacts/notifiable</a></td>
            </tr>
            <tr>
              <td colspan="2"><g:message code="data.catalogue.ws0025.table0901" />:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/ws/contacts/{contact id}/authorised</span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0025.table1001" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/contacts/132/authorised.json">http://collections.ala.org.au/ws/contacts/132/authorised</a></td>
            </tr>
          </table>
          <p><g:message code="data.catalogue.ws0025.des07" />.<br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Data_services"><g:message code="data.catalogue.ws0025.link01" />.</a></p>

          <p><g:message code="data.catalogue.ws0025.des08" />.</p>
            <p><g:message code="data.catalogue.ws0025.des09" />.</p>
            <p><g:message code="data.catalogue.ws0025.des10" />:</p>
            <ul>
                <li><g:message code="data.catalogue.ws0025.li10" /></li>
                <li><g:message code="data.catalogue.ws0025.li11" />.</li>
            </ul>
            <p><g:message code="data.catalogue.ws0025.des11" /></p>
            <ul>
                <li><g:message code="data.catalogue.ws0025.li12" /></li>
                <li><g:message code="data.catalogue.ws0025.li13" /></li>
                <li><g:message code="data.catalogue.ws0025.li14" /></li>
                <li><g:message code="data.catalogue.ws0025.li15" /></li>
            </ul>
            <p><g:message code="data.catalogue.ws0025.des12" /> http://collections.ala.org.au/ws/{resource type}/{resource uid}/contacts/{contact id}</p>
            <p><span class='entity'>PUT</span> <g:message code="data.catalogue.ws0025.des13" />.</p>
            <p><span class='entity'>DELETE</span> <g:message code="data.catalogue.ws0025.des14" />.</p>
            <p><g:message code="data.catalogue.ws0025.des15" />:</p>
            <ul>
                <li><g:message code="data.catalogue.ws0025.li16" /></li>
                <li><g:message code="data.catalogue.ws0025.li17" />.</li>
            </ul>
          <p><g:message code="data.catalogue.ws0025.des16" />.</p>


          <h3 id="WS0026"><g:message code="data.catalogue.ws0026.title" /></h3>
          <p><g:message code="data.catalogue.ws0026.des01" /> <a href="http://community.gbif.org/pg/pages/view/10913/the-gbif-eml-metadata-profile"><g:message code="data.catalogue.ws0026.link01" /></a>.
          <g:message code="data.catalogue.ws0026.des02" />:</p>
          <table class="table">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/ws/eml/<strong>{uid}</strong></span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0026.table0101" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/eml/dr368">http://collections.ala.org.au/ws/eml/dr368</a></td>
            </tr>
          </table>

          <h2 id="WS0032"><g:message code="data.catalogue.ws0032.title" /></h2>
          <p><g:message code="data.catalogue.ws0032.des01" />.</p>

          <h3><g:message code="data.catalogue.ws0032.title01" /></h3>
          <p><g:message code="data.catalogue.ws0032.des02" />:</p>
          <table class="table">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/ws/citations/<strong>{listOfUIDs}</strong></span></td>
            </tr>
            <tr>
              <td colspan="2"><g:message code="data.catalogue.ws0032.td0101" />.</td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0032.td0201" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/ws/citations/dr368,dr105,dr357">http://collections.ala.org.au/ws/citations/dr368,dr105,dr357</a></td>
            </tr>
          </table>

          <p><g:message code="data.catalogue.ws0032.des03" />.
          <br/>
          <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_citation_text_for_a_list_of_UIDs" class="btn"><g:message code="data.catalogue.ws0032.link02" />.</a></p>

          <h2><g:message code="data.catalogue.ws0032.title02" /></h2>
          <p><g:message code="data.catalogue.ws0032.des04" />.</p>
          <h3 id="WS0027"><g:message code="data.catalogue.ws0027.title" /></h3>
          <p><g:message code="data.catalogue.ws0027.des01" />:</p>
          <table class="table">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/lookup/inst/<strong>{institution-code}</strong>/coll/<strong>{collection-code}</strong></span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0027.table0101" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/lookup/inst/ANIC/coll/Insects.json">http://collections.ala.org.au/lookup/inst/ANIC/coll/Insects</a></td>
            </tr>
            <tr>
              <td colspan="2"><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_collection_from_institution_and_collection_codes" class="btn">More information.</a></td>
            </tr>
          </table>

          <h3 id="WS0028"><g:message code="data.catalogue.ws0028.title" /></h3>
          <p><g:message code="data.catalogue.ws0028.des01" />:</p>
          <table class="table">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/lookup/summary/<strong>{uid}</strong></span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0028.table0101" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/lookup/summary/dp28.json">http://collections.ala.org.au/lookup/summary/dp28</a></td>
            </tr>
          </table>
          <p><g:message code="data.catalogue.ws0028.des02" />. <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_summary_from_UID"><g:message code="data.catalogue.ws0028.link01" />.</a></p>

          <h3 id="WS0029"><g:message code="data.catalogue.ws0029.title" /></h3>
          <p><g:message code="data.catalogue.ws0029.des01" />: </p>
          <p><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/lookup/name/<strong>{uid}</strong></span></p>
          <p><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_name_from_UID" class="btn"><g:message code="data.catalogue.ws0029.link01" />.</a></p>

          <h3 id="WS0030"><g:message code="data.catalogue.ws0030.title" /></h3>
          <p><g:message code="data.catalogue.ws0030.des01" />:</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code"><span class='entity'>GET</span> http://collections.ala.org.au/lookup/taxonomicCoverageHints/<strong>{uid}</strong></span></td>
            </tr>
            <tr>
              <td><g:message code="data.catalogue.ws0030.table0101" />:</td>
              <td><a href="${grailsApplication.config.grails.serverURL}/lookup/taxonomyCoverageHints/co12.json">http://collections.ala.org.au/lookup/taxonomyCoverageHints/co12</a></td>
            </tr>
            <tr>
              <td colspan="2"><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_taxonomic_coverage_hints_from_UID" class="btn">More information.</a></td>
            </tr>
          </table>

          <h3><g:message code="data.catalogue.ws0030.title01" /></h3>
          <p><g:message code="data.catalogue.ws0030.des02" />.
          If <span class="code">[ ]</span> <g:message code="data.catalogue.ws0030.des03" />:</p>
          <p><span class="code"><span class='entity'>GET</span> <a href="http://collections.ala.org.au/lookup/downloadLimits">http://collections.ala.org.au/lookup/downloadLimits</a></span></p>

          <h3><g:message code="data.catalogue.ws0030.title02" /></h3>
          <p><g:message code="data.catalogue.ws0030.des04" />:</p>
          <p><span class="code">GET http://collections.ala.org.au/lookup/generateDataResourceUid</span></p>
          <p><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Generate_UID_for_a_new_entity" class="btn"><g:message code="data.catalogue.ws0030.link01" />.</a></p>

        </div><!--close section-->
      </div><!--close column-one-->

      <div id="column-two">
        <div class="section infoColumn">
          <h1><g:message code="data.catalogue.ct.title01" /></h1>
          <p>
            <a href="http://collections.ala.org.au/ws/collection.json"><g:message code="data.catalogue.ct.link01" /></a><br/>
            <a href="http://collections.ala.org.au/ws/institution.json"><g:message code="data.catalogue.ct.lik02" /></a><br/>
            <a href="http://collections.ala.org.au/ws/dataProvider.json"><g:message code="data.catalogue.ct.link03" /></a><br/>
            <a href="http://collections.ala.org.au/ws/dataResource.json"><g:message code="data.catalogue.ct.link04" /></a><br/>
            <a href="http://collections.ala.org.au/ws/dataHub.json"><g:message code="data.catalogue.ct.link05" /></a><br/>
          </p>
          <p>
            <a href="http://collections.ala.org.au/ws/collection/contacts.json"><g:message code="data.catalogue.ct.link06" /></a><br/>
          </p>

          <h1><g:message code="data.catalogue.ct.title02" /></h1>
          <p>
            <a href="http://code.google.com/p/ala-collectory/w/list"><g:message code="data.catalogue.ct.link07" /></a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices"><g:message code="data.catalogue.ct.link08" /></a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Data_services"><g:message code="data.catalogue.ct.link09" /></a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#EML_services"><g:message code="data.catalogue.ct.link10" /></a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_citation_text_for_a_list_of_UIDs"><g:message code="data.catalogue.ct.link11" /></a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_services"><g:message code="data.catalogue.ct.link12" /></a><br/>
          </p>
        </div><!--close section-->
      </div><!--close column-two-->

    </div><!--close content-->
  </body>
</html>