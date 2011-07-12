<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Registry database reports</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><cl:homeLink/></span>
            <span class="menuButton"><g:link class="list" action="list">Reports</g:link></span>
        </div>
        <div class="body">
            <h1>Data mobilisation settings</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
              <p>This list shows the metadata that controls data mobilisation.</p>
              <p id="switch"></p>
              <table>
                <colgroup><col width="100px"/><col width="10%"/><col width="10%"/><col width="15%"/><col width="150px"/></colgroup>
                <tr class="reportHeaderRow"><td>Resource</td><td>Status</td><td>Freq</td><td>Last</td><td>Connection</td></tr>
                <g:each var='r' in="${resources}">
                  <g:if test="${r.connectionParameters}">
                      <g:set var="pList" value="${JSON.parse(r.connectionParameters)}"/>
                  </g:if>
                  <g:else>
                      <g:set var="pList" value="${['none':'']}"/>
                  </g:else>
                  <g:if test="${r.harvestFrequency || r.lastChecked || r.connectionParameters}">
                      <g:set var="hide" value=""/>
                  </g:if>
                  <g:else>
                      <g:set var="hide" value="class='noValues'"/>
                  </g:else>

                  <g:each in="${pList}" var="p" status="i">
                      <tr ${hide}>
                        <td>
                            <g:if test="${i == 0}">
                                <g:link controller="dataResource" action="show" id="${r.uid}">
                                    ${r.acronym ?: r.name}
                                </g:link>
                            </g:if>
                        </td>
                        <td>
                            <g:if test="${i == 0}">
                                ${r.status}
                            </g:if>
                        </td>
                        <td>
                            <g:if test="${i == 0}">
                                ${r.harvestFrequency}
                            </g:if>
                        </td>
                        <td>
                            <g:if test="${i == 0}">
                                ${r.lastChecked}
                            </g:if>
                        </td>
                        <td><g:if test="${p.key != 'none'}">${p.key} =</g:if>
                            <g:if test="${p.key == 'keywords'}">
                                ${p.value.tokenize(',').join(', ')}
                            </g:if>
                            <g:elseif test="${p.key == 'termsForUniqueKey'}">
                                <g:each in="${p.value}" var="pi">
                                    ${pi},
                                </g:each>
                            </g:elseif>
                            <g:elseif test="${p.key == 'protocol'}">
                                <b>${p.value}</b>
                            </g:elseif>
                            <g:else>
                                ${p.value}
                            </g:else>
                        </td>
                      </tr>
                  </g:each>
                </g:each>
              </table>
            </div>
        </div>
        <script type="text/javascript">
            function hideEmpty() {
                $('tr.noValues').css('display', 'none');
                $('p#switch').html("<a href='javascript:showEmpty();'>Show resources with no mobilisation values.</a>");
            }
            function showEmpty() {
                $('tr.noValues').removeAttr('style');
                $('p#switch').html("<a href='javascript:hideEmpty();'>Hide resources with no mobilisation values.</a>");
            }
            hideEmpty();
        </script>
    </body>
</html>
