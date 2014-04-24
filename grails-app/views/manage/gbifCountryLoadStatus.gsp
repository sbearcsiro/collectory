
<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="${grailsApplication.config.ala.skin}" />
    %{--TODO At the moment this is performing a complete reload every 15 seconds while the load has not finished. Make this AJAXy--}%
    <title>Loading Resources From ${country}</title>

    <g:if test="${gbifSummary}">
    <script type="text/javascript">
        if (!window.console) console = {log: function() {}};
        //setup the page
        $(document).ready(function(){
            window.setTimeout(refresh, 15000)
        });

        function refresh() {
            var isRunning = ${gbifSummary.isLoadRunning()}
            if(isRunning){
                console.log("Refreshing page...")
                window.location.reload(true);
                window.setTimeout(refresh, 15000);
            }
        }
    </script>
    </g:if>
</head>
<body>
<g:if test="${gbifSummary}">
<h1>${gbifSummary.isLoadRunning() ? 'Automatically' : 'Finished'} loading ${gbifSummary.loads.size} resources for ${country}
</h1>
<h3>Completed <g:formatNumber number="${gbifSummary.getPercentageComplete()}" format="#0.00"/> %</h3>
<h4>Started: ${gbifSummary.startTime}
    <g:if test="${gbifSummary.finishTime}">
        <br/>Finished: ${gbifSummary.finishTime}
    </g:if>
</h4>

<table class="table table-bordered table-striped">
    <thead>
        <th>Resource</th>
        <th>Status</th>
        <th>Link (will appear when download complete)</th>
    </thead>
<g:each in="${gbifSummary.loads}" var = "load" >
    <tr class="prop">
        <td class="name span4">${load.name}</td>
        <td class="name span2">${load.phase}</td>
        <td class="name span4"><g:if test="${load.dataResourceUid}"><a href="${createLink(controller:'dataResource',action:'show', id:load.dataResourceUid)}"> View Data Resource Page </a></g:if></td>
    </tr>
</g:each>
</table>
</g:if>
<g:else>
    <h1>No resources available to load for ${country}</h1>
    <p>
        To try again click <g:link controller="manage" action="gbifLoadCountry"> here.</g:link>
    </p>

</g:else>

</body>
</html>