<%@ page import="grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="${grailsApplication.config.ala.skin}" />

    <title>Upload GBIF Archive</title>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.3&sensor=false"></script>
    <r:require modules="fileupload"/>
</head>
<body>
<h1>Automatically create a data resource from a GBIF download
</h1>

<g:uploadForm action="uploadGBIFFile" controller="dataResource">
    <label for="fileToUpload">GBIF Darwin core archive file:</label>
    <div class="fileupload fileupload-new" data-provides="fileupload">

        <div class="well pull-right span5">
            <p>
                Use this tool to upload an archive you have downloaded from
                the <a href="http://www.gbif.org/">GBIF portal</a>.
                <br/>
                This will create a data resource for this archive.
                To load the data, use the biocache commandline tools.
            </p>
            <p>
                <b>Note</b>: This is a simple method of bootstrapping an installation with
            data provided by GBIF web services.<br/>
                This is not intended for long-term production use.
            </p>
        </div>

        <div class="input-append">
            <div class="uneditable-input span3">
                <i class="icon-file fileupload-exists"></i>
                <span class="fileupload-preview"></span>
            </div>
            <span class="btn btn-file">
                <span class="fileupload-new">Select file</span>
                <span class="fileupload-exists">Change</span>
                <input type="file" name="myFile" />
            </span>
            <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
        </div>
        <div style="clear:both">
            <input type="submit" id="fileToUpload" class="btn fileupload-exists btn-primary" value="Upload"/>
            <span class="btn cancel">Cancel</span>
        </div>

    </div>
</g:uploadForm>



</body>
</html>