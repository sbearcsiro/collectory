<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <title>ALA Metadata Management</title>
	<meta name="layout" content="main" />

    </head>
    
    <body>
      <div class="floating-content manage">
    
        <div style="float:right;">
            <g:link class="mainLink" controller="public" action="map">View public site</g:link>
        </div>
        <h1>ALA Metadata Management</h1>
        <p>Metadata for collections, institutions and datasets can be managed here.</p>

        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>

        <div style="width:400px;">
            <h2 style="margin-top:30px;">Please log in</h2>
            <span id="login-button">
                <a href="http://auth.ala.org.au/cas/login?service=${ConfigurationHolder.config.security.cas.serverName}${request.forwardURI}">&nbsp;Log in&nbsp;</a>
            </span>

            <p>You must log in to manage metadata</p>
        </div>
        <div style="margin-top:25px;">
            <h3>About access accounts</h3>
            <h4>What do I need to edit my metadata?</h4>
            <p>You will need:</p>
            <ol>
                <li>a standard ALA login</li>
                <li>the 'Collections Editor' role</li>
                <li>to be listed as a contact with administrator rights for the collection, institution or dataset you want to edit.</li>
            </ol>
            <h4>I don't have an ALA account!</h4>
            <p>You can register <a href="http://auth.ala.org.au/emmet/selfRegister.html">here</a>.<p>
            <p>If you are already listed as a contact for the entity you want to edit, make sure you use the same email
            address as that contact.</p>
            <h4>How do I get the editor role?</h4>
            <p>Send an email to <span class="link" onclick="return sendEmail('support(SPAM_MAIL@ALA.ORG.AU)ala.org.au')">support</span>
            and request ROLE_COLLECTIONS_EDITOR.</p>
            <h4>What if I am not listed as a contact for the entity I want to edit?</h4>
            <p>You can be added as a contact by another user who has edit rights for the entity. Or you can send an email to
            <span class="link" onclick="return sendEmail('support(SPAM_MAIL@ALA.ORG.AU)ala.org.au')">support</span>
            and ask to be added. You can choose whether your name and contact details should be displayed on the public
            page for the entity.</p>
        </div>

    </body>
</html>