<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="${grailsApplication.config.ala.skin}" />

    <title>Load GBIF Resources From Country</title>

</head>
<body>
<h1>Automatically load resources from GBIF based on a supplied country
</h1>
<div id="baseForm" class="body">
    <g:form action="loadAllGbifForCountry" controller="manage">


            <div class="input-append">
                    <table>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="country">Country:</label></td>
                            <td valign="top" class="value"><g:field type="text" name="country" required="true" /></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="gbifUsername">GBIF username:</label></td>
                            <td valign="top" class="value"><g:field type="text" name="gbifUsername" required="true" /></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="gbifPassword">GBIF password:</label> </td>
                            <td valign="top" class="value"><g:field type="password" name="gbifPassword" required="true" /></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="maxResources">Maximum resources (will default to all):</label></td>
                            <td valign="top" class="value"><g:field type="number" name="maxResources" /></td>
                        </tr>
                    </table>

                <span class="button"><input type="submit" name="performGBIFLoad" value="Load" class="save btn"></span>
            </div>



        </div>

    </g:form>
</div>

</body>
</html>