<%@ page import="au.org.ala.collectory.Classification; au.org.ala.collectory.Collection" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.ala.skin}" />
        <title>Registry database reports - duplicate contacts</title>
    </head>
    <body>
        <div class="nav">
            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list">Reports</g:link></span></li>
            </ul>
        </div>
        <div class="body reports">
            <h1>Duplicate contacts</h1>
            <p>This report shows contacts that are suspected of being duplicates. Multiple contacts with the same email
            will disrupt the contact's ability to edit their own pages.</p>
            <h2>Duplicate email addresses</h2>
            <p>These contacts have the same email address:</p>
            <table class="separate-rows">
                <col width="35%"><col width="65%">
                <g:each in="${dupEmails}" var="de">
                    <tr>
                        <td>${de.email}</td>
                        <td>
                            <g:each in="${de.contacts}" var="c">
                                ${c.firstName} ${c.lastName} - (id=${c.id})
                                    <g:link controller="contact" action="show" id="${c.id}">View</g:link>
                                <br/>
                            </g:each>
                        </td>
                    </tr>
                </g:each>
            </table>
            <h2>Duplicate names</h2>
            <p>These contacts have the same first and last name:</p>
            <table class="separate-rows">
                <col width="35%"><col width="65%">
                <g:each in="${dupNames}" var="dn">
                    <tr>
                        <td>${dn.firstName} ${dn.lastName}</td>
                        <td>
                            <g:each in="${dn.contacts}" var="c">
                                ${c.email} - (id=${c.id})
                                    <g:link controller="contact" action="show" id="${c.id}">View</g:link>
                                <br/>
                            </g:each>
                        </td>
                    </tr>
                </g:each>
            </table>
        </div>
    </body>
</html>