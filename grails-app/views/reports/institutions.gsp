<%@ page import="au.org.ala.collectory.Institution" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.ala.skin}" />
        <title>Registry database reports</title>
    </head>
    <body>
        <div class="nav">
            <ul>
            <li><span class="menuButton"><cl:homeLink/></span></li>
            <li><span class="menuButton"><g:link class="list" action="list">Reports</g:link></span></li>
            </ul>
        </div>
        <div class="body">
            <h1>Institutions report</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

            <div class="dialog">
                <g:if test="${simple != 'true'}">
                    <p><strong>View</strong> column links to the public page for the collection. You can copy this link to use as the permanent URL to the collection page.</p>
                    <p><strong>Edit</strong> column links to the admin page where this collection's metadata can be edited.</p>
                </g:if>
                <p>Showing ${institutions.size()} institutions.
                <g:if test="${simple == 'true'}">
                    <g:link controller="reports" action="institutions" params="[simple:'false']">Show links.</g:link></p>
                </g:if>
                <g:else>
                    <g:link controller="reports" action="institutions" params="[simple:'true']">Show institution names only.</g:link></p>
                </g:else>

              <table class="table table-striped table-bordered">
                <g:if test="${simple != 'true'}">
                    <colgroup><col width="60%"/><col width="20%"/><col width="10%"/><col width="10%"/></colgroup>
                </g:if>

                <g:each var='c' in="${institutions}" status="i">
                  <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td>${c.name}</td>
                    <g:if test="${simple != 'true'}">
                        <td>${c.acronym}</td>
                        <td><g:link controller="public" action="show" id="${c.uid}">View</g:link></td>
                        <td><g:link controller="institution" action="show" id="${c.uid}">Edit</g:link></td>
                    </g:if>
                  </tr>
                </g:each>

              </table>
            </div>

       </div>
    </body>
</html>
