<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="${grailsApplication.config.ala.skin}" />
    <title>Load GBIF Resources From Country</title>
</head>
<body>
<h1>Automatically load resources from GBIF based on a supplied country</h1>
<div id="baseForm">
    <g:form action="loadAllGbifForCountry" controller="manage">
            <div class="span6">
                    <table>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="country">Publishing country (e.g. SPAIN):</label></td>
                            <td valign="top" class="value">
                                <g:select name="country" from="${pubMap.entrySet()}" optionKey="key" optionValue="value"/>
                            </td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="gbifUsername">GBIF username:</label></td>
                            <td valign="top" class="value"><g:field type="text" name="gbifUsername" required="true" value="" /></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="gbifPassword">GBIF password:</label> </td>
                            <td valign="top" class="value"><g:field type="password" name="gbifPassword" required="true" value="" /></td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><label for="maxResources">Maximum resources (will default to all):</label></td>
                            <td valign="top" class="value"><g:field type="number" name="maxResources"  value="1"/></td>
                        </tr>
                    </table>

                <span class="button"><input type="submit" name="performGBIFLoad" value="Load" class="save btn"></span>
            </div>

            <div class="well pull-right span5">
                <p>
                    This tool will download archives from GBIF web services,
                    store the archives locally and
                    create an initial metadata record for each resource.<br/>
                    This will not load the data into the occurrence store automatically.
                    <br/>
                    To obtain a username, please register with the GBIF web site
                    <a href="http://www.gbif.org/user/register">here</a>.
                </p>
                <p>
                    <b>Note</b>: This is a simple method of bootstrapping an installation with data
                    provided by GBIF web services.<br/>
                    This is not intended for long-term production use.
                </p>
            </div>
        </div>

    </g:form>
</div>

</body>
</html>