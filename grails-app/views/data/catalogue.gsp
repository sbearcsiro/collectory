<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.CollectionLocation" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="ala" />
        <!--meta name="viewport" content="initial-scale=1.0, user-scalable=no" /-->
        <title>Web Services | Natural History Collections | Atlas of Living Australia</title>

        <script type="text/javascript">
          var altMap = true;
          $(document).ready(function() {
            $('#nav-tabs > ul').tabs();
            greyInitialValues();
            <!-- calling initMap() here rather than in onload() causes instability -->
          });
        </script>
    </head>
    <body class="two-column-right" onload="">
    <div id="content">
      <div id="header">
        <!--Breadcrumbs-->
        <div id="breadcrumb"><a href="${ConfigurationHolder.config.ala.baseURL}">Home</a> <a href="${ConfigurationHolder.config.ala.baseURL}/explore/">Explore</a> <a href="/">Natural History Collections</a> <span class="current">Web services</span></div>
        <div class="section full-width">
          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>
          <div class="hrgroup">
            <img src="${resource(dir:"images/ala",file:"webservices.png")}" style="float: right;padding-right:50px;"/>
            <h1>Web services for the Atlas Registry</h1>
            <p>More information can be found at the project's <a href="http://code.google.com/p/ala-collectory/w/list">wiki</a>,
            and in particular in the documentation of <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices">Collectory services</a>.</p>
          </div><!--close hrgroup-->
        </div><!--close section-->
      </div><!--close header-->
      <div id="column-one">
        <div class="section infoPage">
          <div id='warnings'>
            <h2>Disclaimer</h2>
            <p>Please be aware that these services are still being refined. The specifications should be treated as experimental.
            They may change.</p>
          </div>
          
          <h2>Data services</h2>
          <p>The registry of the Atlas of Living Australia maintains metadata that describe:</p>
          <ul>
            <li><span class='entity'>collections</span> - natural history collections;</li>
            <li><span class='entity'>institutions</span> - institutions and organisations that manage collections;</li>
            <li><span class='entity'>dataProviders</span> - providers of biodiversity information in electronic form, eg occurrence records, websites;</li>
            <li><span class='entity'>dataResources</span> - specific resources made available by data providers; and</li>
            <li><span class='entity'>dataHubs</span> - aggregators of biodiversity data.</li>
            <li><span class='entity'>contacts</span> - for any of the above resources.</li>
          </ul>
          <p>Access to this metadata is provided by <em>resource-oriented web services</em> that adhere to <a href="http://en.wikipedia.org/wiki/Representational_State_Transfer">RESTful</a> principles.
          Response payloads are generally formatted as <a href="http://en.wikipedia.org/wiki/JSON">JSON</a> although some services offer other formats through content negotiation.</p>
          <p>Details of how these services can be used are provided at the project's <a href="http://code.google.com/p/ala-collectory/w/list">wiki</a>, and in particular <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices">here</a>.</p>
          <h3>Form of URIs</h3>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td>All service URIs are based on the URI of this page:</td>
              <td><a href="http://collections.ala.org.au/ws">http://collections.ala.org.au/ws</a></td>
            </tr>
            <tr>
              <td>URI's for the resources listed above are this root plus the name of the type of resource, eg:</td>
              <td><a href="http://collections.ala.org.au/ws/institution.json">http://collections.ala.org.au/ws/institution</a></td>
            </tr>
            <tr>
              <td>The URI for a specific instance of a resource is the same followed by the UID of the instance. For example, the resource representing the Aust. Wine Research Institute (UID=in72) is:</td>
              <td><a href="http://collections.ala.org.au/ws/institution/in72.json">http://collections.ala.org.au/ws/institution/in72</a></td>
            </tr>
            <tr>
              <td>Resources that are attributes of a resource, such as the list of contacts for a collection, are addressed by appending the resource type to the uri that represents the main resource, eg:</td>
              <td><a href="http://collections.ala.org.au/ws/institution/in72/contacts.json">http://collections.ala.org.au/ws/institution/in72/contacts</a></td>
            </tr>
          </table>
          <h3>Methods</h3>
          <p>Data services support the GET, HEAD, POST, PUT, OPTIONS and DELETE methods.</p>
          <p><span class='entity'>GET</span> will return the json representation of the specified resource or the list of all resources of the specified resource type.</p>
          <p><span class='entity'>HEAD</span> will return no content but will confirm the existence of the specified resource.</p>
          <p><span class='entity'>POST</span> will update the specified resource based on the information in the body of the request.
          If no resource is specified, the information in the body will be used to create a new resource.
          The body must be valid json and you must specify at least these properties:</p>
          <ul>
            <li>user - the name of the application that is requesting the update; and</li>
            <li>api_key - a valid key to verify that you are authorised to modify the resource.</li>
          </ul>
          <p>If a new resource is being created you must also specify at least:</p>
          <ul>
            <li>name - the name of the resource</li>
          </ul>
          <p>Other properties are treated as the properties to be updated. Property names are the same as those used in the GET representation.</p>
          <p><span class='entity'>PUT</span> behaves the same as POST.</p>
          <p><span class='entity'>OPTIONS</span> returns a list of the allowed methods.</p>
          <p><span class='entity'>DELETE</span> will remove the specified resource. This is currently disallowed.</p>
          <h3>Contacts</h3>
          <p>Contacts exist as resources in their own right. They can be addressed in the standard form.</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td>List all contacts:</td>
              <td><a href="http://collections.ala.org.au/ws/contacts.json">http://collections.ala.org.au/ws/contacts</a></td>
            </tr>
            <tr>
              <td>Get details for a specific contact</td>
              <td><a href="http://collections.ala.org.au/ws/contacts/31.json">http://collections.ala.org.au/ws/contacts/31</a></td>
            </tr>
          </table>
          <p>A contact may be associated with any number of resources. A resource may have any number of contacts.
          The relationship between a contact and a resource has its own metadata such as the role that the contact has in relation to the resource,
          the contact's editing rights, etc.</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2">This metadata is accessed by appending <span class="code">contacts</span> to the uri of a resource using the form:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/ws/{resource type}/{resource uid}/contacts</span></td>
            </tr>
            <tr>
              <td>For example:</td>
              <td><a href="http://collections.ala.org.au/ws/collection/co13/contacts.json">http://collections.ala.org.au/ws/collection/co13/contacts</a></td>
            </tr>
            <tr>
              <td colspan="2">The metadata for a specific contact relationship has the form:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/ws/{resource type}/{resource uid}/contacts/{id}</span></td>
            </tr>
            <tr>
              <td>For example:</td>
              <td><a href="http://collections.ala.org.au/ws/collection/co13/contacts/20.json">http://collections.ala.org.au/ws/collection/co13/contacts/20</a></td>
            </tr>
            <tr>
              <td colspan="2">The primary contacts for all instances of a type of resource can be accessed using the form:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/ws/{resource type}/contacts</span></td>
            </tr>
            <tr>
              <td>For example:</td>
              <td><a href="http://collections.ala.org.au/ws/collection/contacts.json">http://collections.ala.org.au/ws/collection/contacts</a></td>
            </tr>
            <tr>
              <td colspan="2">Contacts may elect to be notified when significant events occur to a resource.
              The list of contacts to be notified for a specific resource can be retrieved from a uri of the form:</td>
            </tr>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/ws/{resource type}/{resource uid}/contacts/notifiable</span></td>
            </tr>
            <tr>
              <td>For example:</td>
              <td><a href="http://collections.ala.org.au/ws/collection/co13/contacts/notifiable.json">http://collections.ala.org.au/ws/collection/co13/contacts/notifiable</a></td>
            </tr>
          </table>
          <p>All contact services can return payload as CSV, XML or JSON via content negotiation.<br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Data_services">More information.</a></p>

          <h3>EML metadata interchange</h3>
          <p>The registry provides a service to extract resource metadata in EML format. The response complies with <a href="http://community.gbif.org/pg/pages/view/10913/the-gbif-eml-metadata-profile">GBIF's EML schema</a>.
          This document is suitable for inclusion in a Darwin Core Archive as the metadata description of the contained records.
          The form is:</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/ws/eml/<strong>{uid}</strong></span></td>
            </tr>
            <tr>
              <td>This example uri returns an XML document describing the set of occurrence records for the DECCW Atlas of NSW Wildlife:</td>
              <td><a href="http://collections.ala.org.au/ws/eml/dr368">http://collections.ala.org.au/ws/eml/dr368</a></td>
            </tr>
          </table>

          <h2>Citation services</h2>
          <p>Citation services return attribution and licence information for digitised records that can be accessed through the Atlas.</p>

          <h3>Citations for a list of data providers</h3>
          <p>This service accepts a list of entity UIDs and returns citation information for each entity.
          Any entity types can be specified but only data resources have meaningful citation information.
          For each entity, the service returns the name of the entity, its citation text, its rights text and a 'more information' string containing a link to the collectory page for the entity.
          The form is:</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/ws/citations/<strong>{listOfUIDs}</strong></span></td>
            </tr>
            <tr>
              <td colspan="2">where <span class="code">listOfUIDs</span> is a comma-separated list of UID.</td>
            </tr>
            <tr>
              <td>This example uri returns a list of citations for the three specified data resources:</td>
              <td><a href="http://collections.ala.org.au/ws/citations/dr368,dr105,dr357">http://collections.ala.org.au/ws/citations/dr368,dr105,dr357</a></td>
            </tr>
          </table>

          <p>The service can return the information as a JSON list or a CSV or TSV file with appropriate headers. The format is specified by http content-negotiation.
          <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_citation_text_for_a_list_of_UIDs">More information.</a></p>

          <h2>Lookup services</h2>
          <p>These services explicitly support inter-operation with other components of the Atlas such as the bio-cache and the BIE. They do not all comply with RESTful principles but are being progressively refactored to do so.</p>
          <h3>Map a bio-cache record to a collection</h3>
          <p>This service takes a collection code and an institution code from a raw specimen record and maps the combination to a single collection.
          The form is:</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/lookup/inst/<strong>{institution-code}</strong>/coll/<strong>{collection-code}</strong></span></td>
            </tr>
            <tr>
              <td>This example uri returns metadata for the Australian National Insect Collection:</td>
              <td><a href="http://collections.ala.org.au/lookup/inst/ANIC/coll/Insects.json">http://collections.ala.org.au/lookup/inst/ANIC/coll/Insects</a></td>
            </tr>
            <tr>
              <td colspan="2"><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_collection_from_institution_and_collection_codes">More information.</a></td>
            </tr>
          </table>

          <h3>Get a summary for an entity</h3>
          <p>This service just returns a subset of metadata for an entity. The form is:</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/lookup/summary/<strong>{uid}</strong></span></td>
            </tr>
            <tr>
              <td>This example uri returns the short metadata for the Birds Australia data provider:</td>
              <td><a href="http://collections.ala.org.au/lookup/summary/dp28.json">http://collections.ala.org.au/lookup/summary/dp28</a></td>
            </tr>
          </table>
          <p>The summary services are less useful now that we have full RESTful metadata services but are retained for backward compatibility. They also provide a small efficiency
          when the service is called repeatedly such as during indexing operations. <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_summary_from_UID">More information.</a></p>

          <h3>Lookup the name of an entity</h3>
          <p>This service is even more cut down than the summary. It returns only the name of an entity given its UID. The form is: </p>
          <p><span class="code">GET http://collections.ala.org.au/lookup/name/<strong>{uid}</strong></span></p>
          <p><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_name_from_UID">More information.</a></p>

          <h3>Get taxonomic coverage hints for an entity</h3>
          <p>This service plays a roll in taxonomic name matching during the processing of raw bio-cache records. When a record has been mapped to
          a collection, the collection metadata can be used to inform the matching process by adding weight to matches within particular taxonomic groups. The form is:</p>
          <table class="clean no-left-pad">
            <colgroup><col width="55%"><col width="45%"></colgroup>
            <tr>
              <td colspan="2"><span class="code">GET http://collections.ala.org.au/lookup/taxonomicCoverageHints/<strong>{uid}</strong></span></td>
            </tr>
            <tr>
              <td>This example uri returns a list of rank-name pairs that describe a taxonomic range:</td>
              <td><a href="http://collections.ala.org.au/lookup/taxonomyCoverageHints/co12.json">http://collections.ala.org.au/lookup/taxonomyCoverageHints/co12</a></td>
            </tr>
            <tr>
              <td colspan="2"><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_taxonomic_coverage_hints_from_UID">More information.</a></td>
            </tr>
          </table>

          <h3>Generate UID for a new entity</h3>
          <p>This is a temporary service used when new data resources are discovered during the harvesting of records. This service will disappear when the
          harvesting process is refactored. The standard data services will be used to create the new resource and return the UID assigned by the collectory.
          The form is:</p>
          <p><span class="code">GET http://collections.ala.org.au/lookup/generateDataResourceUid</span></p>
          <p><a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Generate_UID_for_a_new_entity">More information.</a></p>

        </div><!--close section-->
      </div><!--close column-one-->

      <div id="column-two">
        <div class="section infoColumn">
          <h1>Common services</h1>
          <p>
            <a href="http://collections.ala.org.au/ws/collection.json">List all collections</a><br/>
            <a href="http://collections.ala.org.au/ws/institution.json">List all institutions</a><br/>
            <a href="http://collections.ala.org.au/ws/dataProvider.json">List all data providers</a><br/>
            <a href="http://collections.ala.org.au/ws/dataResource.json">List all data resources</a><br/>
            <a href="http://collections.ala.org.au/ws/dataHub.json">List all hubs</a><br/>
          </p>
          <p>
            <a href="http://collections.ala.org.au/ws/collection/contacts.json">List main contact for each collection</a><br/>
          </p>

          <h1>Detailed documentation</h1>
          <p>
            <a href="http://code.google.com/p/ala-collectory/w/list">Project wiki</a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices">Services overview</a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Data_services">Data Services</a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#EML_services">EML service</a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_citation_text_for_a_list_of_UIDs">Citations service</a><br/>
            <a href="http://code.google.com/p/ala-collectory/wiki/CollectoryServices#Lookup_services">Lookup services</a><br/>
          </p>
        </div><!--close section-->
      </div><!--close column-two-->

    </div><!--close content-->
  </body>
</html>