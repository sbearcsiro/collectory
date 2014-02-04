<%@ page import="au.org.ala.collectory.ProviderGroup" %>
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
            <h1>Data relationships</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <p>This list shows which data resources/providers provide data record for which collections/institutions.</p>
              <p>(P) = data provider, (R) = data resource, (I) = institution, (C) = collection.</p>
              <table class="table table-striped table-bordered">
                <colgroup><col width="45%"/><col width="10%"/><col width="45%"/></colgroup>
                <tr class="reportHeaderRow"><td>Provider</td><td></td><td>Consumer</td></tr>
                <g:each var='link' in="${links}">
                  <g:set var="provider" value="${ProviderGroup._get(link.provider)}"/>
                  <g:set var="consumer" value="${ProviderGroup._get(link.consumer)}"/>
                  <tr>
                    <td><g:link controller="${cl.controllerFromUid(uid: link.provider)}" action="show" id="${link.provider}">
                      ${provider.name} <cl:entityIndicator entity="${provider}"/>
                    </g:link></td>
                    <td> &lt;=&gt; </td>
                    <td><g:link controller="${cl.controllerFromUid(uid: link.consumer)}" action="show" id="${link.consumer}">
                      ${consumer.name} <cl:entityIndicator entity="${consumer}"/>
                    </g:link></td>
                  </tr>
                </g:each>
              </table>
            </div>
        </div>
    </body>
</html>
