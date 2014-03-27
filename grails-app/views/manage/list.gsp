<%@ page import="au.org.ala.collectory.Contact; org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.Collection" %>
<html>
    <head>
        <title>Metadata Management | Collectory</title>
	    <meta name="layout" content="${grailsApplication.config.ala.skin}" />
        <r:require modules="smoothness, collectory, jquery_ui_custom" />
    </head>
    
    <body>
      <div class="content">

        <div class="pull-right">
            <g:link class="mainLink btn" controller="public" action="map">View public site</g:link>
        </div>

        <h1>Metadata management</h1>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div class="row-fluid">
            <div class="span3">
                <ul id="adminNavMenu" class="nav nav-list nav-stacked nav-tabs">
                    <li><a href="javascript:showSection('adminTools');"><i class="icon-chevron-right">&nbsp;</i> Admin tools</a></li>
                    <li><a href="javascript:showSection('yourMetadata');"><i class="icon-chevron-right">&nbsp;</i> Your metadata</a></li>
                    <li><a href="javascript:showSection('addCollection');"><i class="icon-chevron-right">&nbsp;</i> Add a new collection or data resource</a></li>
                </ul>
            </div>

            <div class="span9">

                <div id="yourMetadata" class="infoSection hide">
                    <g:if test="${show == 'user'}">
                        <div>
                            <h2>User details</h2>
                            <p>Security is ${grailsApplication.config.security.cas.bypass ? 'bypassed' : 'active'}.</p>
                            <g:set var="username" value="${request.userPrincipal?.name}"/>
                            <g:if test="${username}">
                                <p>Logged in as ${username}.</p>
                                <p>User ${request.isUserInRole('ROLE_COLLECTION_ADMIN') ? 'has' : 'does not have'} ROLE_COLLECTION_ADMIN.</p>
                                <p>User ${request.isUserInRole('ROLE_COLLECTION_EDITOR') ? 'has' : 'does not have'} ROLE_COLLECTION_EDITOR.</p>
                            </g:if>
                            <g:else><p>Not logged in.</p></g:else>
                            <p>
                                <g:set var="cookiename" value="${cookie(name: 'ALA-Auth')}"/>
                                <g:if test="${cookiename}">Cookie is present. Name is ${cookiename}.</g:if>
                                <g:else>No cookie found.</g:else>
                            </p>
                        </div>
                    </g:if>

                    <h2>Your metadata</h2>
                    <p>The institutions, collections and data resources that you are authorised to access are listed below.
                    Be aware that all changes are immediately reflected in the website and any hubs or other websites
                    that use web services.</p>

                    <g:if test="${entities}">
                        <table class="shy" style="margin-left: 25px;">
                            <thead><tr><td style="text-align: center;width:40px;">View</td><td style="text-align: center;width:40px;">Edit</td><td></td></tr></thead>
                            <g:each in="${entities}" var="ent">
                                <tr>
                                    <td style="text-align: center;"><g:link controller="public" action="show" id="${ent.uid}">
                                        <i class="icon-eye-open"></i></g:link>
                                    </td>
                                    <td style="text-align: center;">
                                        <i class="icon-edit"></i>
                                    </td>
                                    <g:set var="name" value="${ent.uid[0..1] == 'in' ? ent.name + ' (Institution)' : ent.name}"/>
                                    <td style="padding-left: 5px;">${name}</td>
                                </tr>
                            </g:each>
                        </table>
                    </g:if>
                    <g:else>
                        <cl:ifGranted role="ROLE_COLLECTION_ADMIN">
                            <p><strong><em>You are authorised to edit all entities because you are admin.</em></strong></p>
                        </cl:ifGranted>
                        <cl:ifNotGranted role="ROLE_COLLECTION_ADMIN">
                            <p style="font-style: italic;margin: 10px;color: black;">You are not authorised to edit any entities.</p>
                        </cl:ifNotGranted>

                        <cl:ifGranted role="ROLE_COLLECTION_EDITOR">
                            <p>You have the required role but are not listed as a contact with editor rights on any
                            collection, institution or dataset. If you believe you should be, ask someone who is listed to add you
                            as a contact. If you can't do that, click the support link below to send a request to the ALA support team.</p>
                        </cl:ifGranted>
                        <cl:ifNotGranted role="ROLE_COLLECTION_EDITOR">
                            <p>You do not have the role required to edit metadata. You can email
                            <span class="link" onclick="return sendEmail('support(SPAM_MAIL@ALA.ORG.AU)ala.org.au')">support</span>
                            to request this role.</p>
                        </cl:ifNotGranted>
                    </g:else>

                    <p>If you do not see your collection, institution or dataset in the list above, please read
                    <span id="instructions-link" class="link under">requirements for editing metadata</span>.</p>
                    <div id="instructions">
                        <div id="requirementsForEditing">
                            <h3>Requirements for editing metadata</h3>
                            <h4>What do I need to edit my metadata?</h4>
                            <p>You need:</p>
                            <ol>
                                <li>to be logged in using a standard account</li>
                                <li>the 'Collections Editor' role</li>
                                <li>to be listed as a contact with editor rights for the collection, institution or dataset you want to edit.</li>
                            </ol>

                            <h4 class="ok">You have an ALA account</h4>
                            <p>You are logged in as <em><cl:loggedInUsername/></em>.</p>

                            <cl:ifGranted role="ROLE_COLLECTION_EDITOR">
                                <h4 class="ok">You have the 'Collections Editor' role</h4>
                            </cl:ifGranted>
                            <cl:ifNotGranted role="ROLE_COLLECTION_EDITOR">
                                <h4 class="missing">You <strong>do not</strong> have the 'Collections Editor' role!</h4>
                                <p>Send an email to <span class="link" onclick="return sendEmail('support(SPAM_MAIL@ALA.ORG.AU)ala.org.au')">support</span>
                                and request ROLE_COLLECTION_EDITOR.</p>
                            </cl:ifNotGranted>

                            <cl:ifGranted role="ROLE_COLLECTION_EDITOR">
                                <g:if test="${!entities}">
                                    <h4 class="missing">You are not an editor for any collection, institution or dataset!</h4>
                                </g:if>
                                <g:else>
                                    <h4 class="ok">You are editor for the ${entities.size()} entities listed above.</h4>
                                </g:else>
                            </cl:ifGranted>
                            <cl:ifNotGranted role="ROLE_COLLECTION_EDITOR">
                                <h4>You need to be listed as an editor for the entity you want to edit.</h4>
                            </cl:ifNotGranted>
                            <p>You must be a contact for the entity and have the editor attribute set.</p>
                            <p>You can be added as a contact and made an editor by another user who has edit rights for the entity.
                            Or you can send an email to
                            <span class="link" onclick="return sendEmail('support(SPAM_MAIL@ALA.ORG.AU)ala.org.au')">support</span>
                            and ask to be added. You can choose whether your name and contact details should be displayed on the public
                            page for the entity.</p>

                            <h4>I still need help.</h4>
                            <p>Please send us an email at
                            <span class="link" onclick="return sendEmail('support(SPAM_MAIL@ALA.ORG.AU)ala.org.au')">support</span>
                            and explain your issues.</p>
                        </div>
                    </div>
                </div>

                <div id="addCollection" class="hide infoSection">
                    <cl:ifGranted role="ROLE_COLLECTION_EDITOR">

                        <h2>Add a new data resource</h2>
                        <p>As a trusted editor you are authorised to add new data resources. Note:</p>
                        <ul class="list">
                            <li>Please check that the data resource does not already exist.</li>
                            <li>The data resource  will become public as soon as you create it.</li>
                        </ul>

                        <g:link controller="dataResource" action="create" class="btn">Create a new data resource</g:link>

                        <h2>Add a new collection</h2>
                        <p>As a trusted editor you are authorised to add new collections. Note:</p>
                        <ul class="list">
                            <li>Please check that the collection does not already exist.</li>
                            <li>You can only link your collection to an institution if you are an editor for the institution.</li>
                            <li>You will be automatically added as a contact and an editor for the new collection.</li>
                            <li>You will need to supply a name for the new collection. It will then be created and you will be
                            directed to the edit pages for the collection to supply further information.</li>
                            <li>The collection will become public as soon as you create it.</li>
                            <li>Only ALA administrators can delete collections. Please contact the administrators if you believe a collection should be removed.</li>
                        </ul>

                        <g:link controller="collection" action="create" class="btn">Create a new collection</g:link>
                    </cl:ifGranted>
                </div>

                <div id="adminTools" class="infoSection">
                <cl:ifGranted role="ROLE_COLLECTION_ADMIN">
                  <div>
                    <h2>Admin functions</h2>
                    <p>You are an administrator (${ProviderGroup.ROLE_ADMIN}). Please use your superpowers wisely.</p>
                    <div class="homeCell">
                        <g:link class="mainLink" controller="collection" action="list">View all collections</g:link>
                        <p class="mainText">Browse all current collections and update collection descriptions.</p>
                    </div>

                    <div class="homeCell">
                        <span class="mainLink">Search for collections</span>

                        <p class="mainText">Enter a part of the name of a collection or its acronym, eg insects, fungi, ANIC</p>
                        <g:form controller="collection" action="searchList" method="get">
                            <div class="input-append">
                                <g:textField class="mainText" name="term" placeholder="Search for collection"/>
                                <g:submitButton class="btn" name="search" value="Search"/>
                            </div>
                        </g:form>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="collection" action="create">Add a collection</g:link>
                        <p class="mainText">Describe a collection that is not currently listed.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="institution" action="list">View all institutions</g:link>
                        <p class="mainText">Browse the institutions that hold collections.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="dataProvider" action="list">View all data providers</g:link>
                        <p class="mainText">Browse all current data providers.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="dataResource" action="list">View all data resources</g:link>
                        <p class="mainText">Browse all current data resources.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="dataHub" action="list">View all data hubs</g:link>
                        <p class="mainText">Browse all current data hubs.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="reports" action="list">View reports</g:link>
                        <p class="mainText">Browse summaries of Registry contents and usage.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="contact" action="list">Manage contacts</g:link>
                        <p class="mainText">View and edit all known contacts for collections and institutions.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="providerCode" action="list">Manage provider codes</g:link>
                        <p class="mainText">View and edit all known collection and institution codes.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="providerMap" action="list">Manage provider maps</g:link>
                        <p class="mainText">View and edit the allocation of collection and institution codes to collections.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="admin" action="export">Export all data as JSON</g:link>
                        <p class="mainText">All tables exported verbatim as JSON.</p>
                    </div>

                    <div class="homeCell">
                        <g:link class="mainLink" controller="auditLogEvent" action="list" params="[max:1000]">View audit events</g:link>
                        <p class="mainText">All audit events</p>
                    </div>
                    <div class="homeCell">
                        <g:link class="mainLink" controller="manage" action="gbifLoadCountry">Add all GBIF resource for a country</g:link>
                        <p class="mainText"r>All the resources for a specific country are added as data resource in the collectory</p>
                    </div>
                    <div class="homeCell">
                        <g:link class="mainLink" controller="dataResource" action="gbifUpload">Upload GBIF file</g:link>
                        <p class="mainText"r>Uploads a GBIF download as a data resource. (Assumes that a single resource is in the file)</p>
                    </div>
                  </div>
                </cl:ifGranted>
                </div>

            </div>
        </div>

        <script type="text/javascript">

            function showSection(sectionToShow){
                $('.infoSection').hide();
                $('#'+sectionToShow).show();
            }

            function edit(uid) {
                document.location.href = "${ConfigurationHolder.config.grails.serverURL}/manage/show/" + uid;
            }
            $('#instructions-link').click(function() {
                var height = $('#instructions').css('height');
                $('#instructions').animate({height: height == '0px' ? 440 : 0}, 'slow');
                return false;
            });

            var hasContact = ${user != null};

            var $name = $("#name");
            var $acronym = $("#acronym");
            var $role = $("#role");
            var $title = $("#title");
            var $firstName = $("#firstName");
            var $lastName = $("#lastName");
            var $phone = $("#phone");
            var $publish = $("#publish");
            var $contactFields = $role;
            if (!hasContact) {
                $contactFields = $contactFields.add($title).add($firstName).add($lastName).add($phone).add($publish);
            }
            var $allFields = $contactFields.add($name);
            var $tips = $(".validateTips");

            function updateTips( t ) {
                $tips
                    .text( t )
                    .addClass( "ui-state-highlight" );
                setTimeout(function() {
                    $tips.removeClass( "ui-state-highlight", 1500 );
                }, 500 );
            }

            function checkLength( o, n, min, max ) {
                if ( o.val().length > max || o.val().length < min ) {
                    o.addClass( "ui-state-error" );
                    updateTips( "Length of " + n + " must be between " +
                        min + " and " + max + "." );
                    return false;
                } else {
                    return true;
                }
            }

            function checkRegexp( o, regexp, n ) {
                if ( !( regexp.test( o.val() ) ) ) {
                    o.addClass( "ui-state-error" );
                    updateTips( n );
                    return false;
                } else {
                    return true;
                }
            }

            function checkUnique(o) {
                var isUnique = true;
                // make a synchronous call to check existence of the name
                $.ajax({
                    url: "${ConfigurationHolder.config.grails.serverURL}/collection/nameExists?name=" + o.val(),
                    dataType: 'json',
                    async: false,
                    success: function(data) {
                        if (data.found == 'true') {
                            o.addClass( "ui-state-error" );
                            updateTips("A collection with this name already exists (" + data.uid + ")");
                            isUnique = false;
                        }
                    }
                });
                return isUnique;
            }

            %{--$('#dialog-form').dialog({--}%
                %{--autoOpen: false,--}%
                %{--width: 350,--}%
                %{--modal: true,--}%
                %{--buttons: {--}%
                    %{--"Create collection": function() {--}%
                        %{--var bValid = true;--}%
                        %{--$allFields.removeClass( "ui-state-error" );--}%

                        %{--bValid = bValid && checkLength( $name, "name", 3, 1024 );--}%

                        %{--if ($('#addAsContact').is(':checked')) {--}%
                            %{--bValid = bValid && checkLength( $role, "role", 3, 45 );--}%
                        %{--}--}%
                        %{----}%
                        %{--bValid = bValid && checkRegexp( $name, /^[a-z]([0-9a-z_ ])+$/i, "Name may consist of a-z, 0-9, underscores, begin with a letter." );--}%

                        %{--bValid = bValid && checkUnique($name);--}%

                        %{--if ( bValid ) {--}%
                            %{--var fieldValues = "";--}%
                            %{--if ($('#addAsContact').is(':checked')) {--}%
                                %{--fieldValues = "&addUserAsContact=true";--}%
                                %{--fieldValues += "&role=" + ($role.val() ? $role.val() : 'editor');--}%
                                %{--if (!hasContact) {--}%
                                    %{--if ($title.val()) fieldValues += "&title=" + $title.val();--}%
                                    %{--if ($firstName.val()) fieldValues += "&firstName=" + $firstName.val();--}%
                                    %{--if ($lastName.val()) fieldValues += "&lastName=" + $lastName.val();--}%
                                    %{--if ($phone.val()) fieldValues += "&phone=" + $phone.val();--}%
                                    %{--if ($('#publish').is(':checked')) fieldValues += "&publish=true";--}%
                                %{--}--}%
                            %{--}--}%
                            %{--//alert(fieldValues);--}%
                             %{--// redirect to create collection--}%
                            %{--document.location.href =--}%
                               %{--"${ConfigurationHolder.config.grails.serverURL}/collection/create?name=" +--}%
                                       %{--$name.val() + fieldValues;--}%
                        %{--}--}%
                    %{--},--}%
                    %{--Cancel: function() {--}%
                        %{--$( this ).dialog( "close" );--}%
                    %{--}--}%
                %{--},--}%
                %{--close: function() {--}%
                    %{--$allFields.val( "" ).removeClass( "ui-state-error" );--}%
                %{--}--}%
            %{--});--}%
            $('#create').click(function() {
                $( "#dialog-form" ).dialog( "open" );
            });
            $('#addAsContact').change(function() {
                if ($('#addAsContact').is(':checked')) {
                    $contactFields.removeAttr('disabled');
                    $contactFields.css('opacity',1);
                    $contactFields.prev('label').css('opacity',1);
                }
                else {
                    $contactFields.attr('disabled', 'disabled');
                    $contactFields.css('opacity',0.5);
                    $contactFields.prev('label').css('opacity',0.5);
                }
            });
        </script>
    </body>
</html>