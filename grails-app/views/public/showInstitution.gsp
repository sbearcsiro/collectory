<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.ProviderGroup"%>
<html>
<head>
  <meta name="layout" content="ala" />
</head>
  <body>
  <div id="content">
    <div id="header">
      <h1>${fieldValue(bean:institution,field:'name')}</h1>
    </div><!--close header-->
    <div id="column-one">
    <div class="section no-margin-top">
      <p><a target='_blank' href="${institution.websiteUrl}" class="external external_icon">${institution.websiteUrl}</a></p>
      <p>${institution.guid}</p>
      <p><strong>Description of Institution:</strong></p>
      <p>The sheltered, landscaped grounds of the Royal Tasmanian Botanic Gardens hold historic plant collections and a large number of significant trees, many dating from the nineteenth century.</p>
      <p>It also has an increasing number of important conservation collections of Tasmanian plants and the world’s only Subantarctic Plant House.</p>
      <p><strong>Collections:</strong></p>
      <ol>
        <g:each var="c" in="${institution.getSafeChildren()}">
          <li><g:link controller="collection" action="show" id="${c.id}">${c?.name}</g:link>: ${c?.pubDescription}</li>
        </g:each>
      </ol>
    </div><!--close section-->
  </div><!--close column-one-->
<div id="column-two">

<div class="section">
  <script type="text/javascript">
  // initialise plugins
  jQuery(function(){
      jQuery('ul.sf-menu').superfish( {
      autoArrows:false
      });
  });
  </script>
  <ul class="sf-menu sf-vertical" style="padding-bottom:0;">
                      <li class="page_item page-item-434"><a  href="http://test.ala.org.au/?page_id=434" title="Photo credits">Photo credits</a></li>
<li class="page_item page-item-10"><a  href="http://test.ala.org.au/?page_id=10" title="What is the Atlas?">What is the Atlas?</a></li>
<li class="page_item page-item-12"><a  href="http://test.ala.org.au/?page_id=12" title="Project Time Line">Project Time Line</a></li>
<li class="page_item page-item-14"><a  href="http://test.ala.org.au/?page_id=14" title="Partners">Partners</a></li>
<li class="page_item page-item-16 current_page_ancestor current_page_parent"><a  href="http://test.ala.org.au/?page_id=16" title="Natural History Collections">Natural History Collections</a>
<ul class='children'>
<li class="page_item page-item-371 current_page_item"><a  href="http://test.ala.org.au/?page_id=371" title="Institution Placeholder">Institution Placeholder</a></li>
<li class="page_item page-item-379"><a  href="http://test.ala.org.au/?page_id=379" title="Collection Overview Page">Collection Overview Page</a>
<ul class='children'>
<li class="page_item page-item-450"><a  href="http://test.ala.org.au/?page_id=450" title="Collections Map and Records Tab">Collections Map and Records Tab</a></li>
<li class="page_item page-item-452"><a  href="http://test.ala.org.au/?page_id=452" title="Collections Statistics tab page">Collections Statistics tab page</a></li>
</ul>
</li>
</ul>
</li>
<li class="page_item page-item-18"><a  href="http://test.ala.org.au/?page_id=18" title="Contributors">Contributors</a></li>
<li class="page_item page-item-22"><a  href="http://test.ala.org.au/?page_id=22" title="Atlas Team">Atlas Team</a></li>
<li class="page_item page-item-24"><a  href="http://test.ala.org.au/?page_id=24" title="Media Centre">Media Centre</a>
<ul class='children'>
<li class="page_item page-item-28"><a  href="http://test.ala.org.au/?page_id=28" title="In the Media">In the Media</a></li>
<li class="page_item page-item-30"><a  href="http://test.ala.org.au/?page_id=30" title="Media Liaison">Media Liaison</a></li>
</ul>
</li>
<li class="page_item page-item-26"><a  href="http://test.ala.org.au/?page_id=26" title="Atlas Documents">Atlas Documents</a>
<ul class='children'>
<li class="page_item page-item-32"><a  href="http://test.ala.org.au/?page_id=32" title="Publications">Publications</a></li>
<li class="page_item page-item-34"><a  href="http://test.ala.org.au/?page_id=34" title="Presentations">Presentations</a></li>
</ul>
</li>

  </ul>
</div>

</div><!--close column-two-->

  </div><!--close content-->
  </body>
</html>