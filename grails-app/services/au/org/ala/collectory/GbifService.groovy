package au.org.ala.collectory

import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import groovyx.net.http.*
import org.apache.commons.httpclient.HttpClient
import org.apache.commons.httpclient.methods.PostMethod
import org.apache.commons.io.FileUtils
import org.apache.commons.io.IOUtils
import org.apache.http.*
import org.apache.http.HttpRequestInterceptor
import org.apache.http.auth.AuthScope
import org.apache.http.auth.AuthState
import org.apache.http.auth.Credentials
import org.apache.http.auth.UsernamePasswordCredentials
import org.apache.http.client.methods.HttpPost
import org.apache.http.client.protocol.ClientContext
import org.apache.http.entity.StringEntity
import org.apache.http.impl.auth.BasicScheme
import org.apache.http.impl.client.DefaultHttpClient
import org.apache.http.protocol.HTTP
import org.apache.http.protocol.HttpContext
import org.apache.tools.zip.ZipFile
import org.codehaus.groovy.grails.web.json.JSONObject
import org.springframework.web.multipart.MultipartFile

import java.text.MessageFormat
import java.util.concurrent.Callable
import java.util.concurrent.Executors
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream


/**
 * Services required to autoload GBIF data into the collectory.
 *
 * @author Natasha Quimby (natasha.quimby@csiro.au)
 */
class GbifService {

    static final String CITATION_FILE="citations.txt"
    static final String RIGHTS_FILE="rights.txt"
    static final String EML_DIRECTORY="dataset"
    static final String OCCURRENCE_FILE= "occurrence.txt"
    static final String META_FILE = "/data/collectory/bootstrap/meta.xml"
    static final String GBIF_API="http://api.gbif.org/v0.9"
    static final String OCCURRENCE_DOWNLOAD="/occurrence/download/request" //POST request to this to start downalod //GET request to retrieve downlaod
    static final String DOWNLOAD_STATUS="/occurrence/download/" //GET request to this
    static final String DATASET_SEARCH="/dataset/search?publishingCountry={0}&type=OCCURRENCE" //GET request to this
    //The request body
    static final String DOWNLOAD_JSON ="'{'\n" +
            "\"creator\":\"{0}\",\n" +
            "\"notification_address\": [],  \n" +
            "\"predicate\":\n" +
            "  '{'\n" +
            "\"type\":\"equals\",\n" +
            "\"key\": \"DATASET_KEY\",\n" +
            "\"value\": \"{2}\"    \n" +
            "  '}'\n" +
            "'}'"


    def crudService
    def grailsApplication
    def CONCURRENT_LOADS=10
    def pool = Executors.newFixedThreadPool(CONCURRENT_LOADS)
    def loading = false
    def loadMap=[:]
    def stopStatus = ["CANCELLED","FAILED","KILLED", "SUCCEEDED", "UNKNOWN"]

    /**
     * Returns the status informationfor the supplied country
     * @param country
     * @return
     */
    def getStatusInfoFor(String country){
        log.debug(loadMap)
        return loadMap[(country.toUpperCase())]
    }

    /**
     * Loads all or a limited number of datasets for the supplied country
     *
     * @param country A GBIF country
     * @param username A registered GBIF username
     * @param password The password for the registered GBIF user
     * @param limit null when all datasets should be load OR the number of datasets to load
     * @return A GBIFLoadSummary that should be used to display details - which will need to be updated
     */
    def loadResourcesFor(String country, final String username, final String password, Integer limit) {
        country = country.toUpperCase()
        //check to see if a load is already running. We can only have one at a time
        if (!loading){
            loading = true
            //get a list of loads that need to be performed
            List loadList = getListOfGbifResources(country, limit)
            if(loadList){
                final GBIFLoadSummary gls = new GBIFLoadSummary()
                //gls.total = loadList.size()
                gls.startTime = new Date()
                gls.country = country
                gls.loads = loadList
                loadMap[(country)] = gls
                //at this point we need to return to the user and perform remaining tasks asynchronously
                pool.submit(new Runnable(){
                    public void run(){
                        def defer = { c -> pool.submit(c as Callable) }
                        gls.loads.each{l ->
                            defer{
                                log.debug("submitting " + l + " to be processed")
                                //1) Start the download
                                String downloadId = startGBIFDownload(l.gbifResourceUid,username, null, password)
                                l.downloadId = downloadId
                                //2) Monitor the download
                                l.phase = "Generating Download..."
                                String status = ""
                                while(!stopStatus.contains(status)){
                                    //sleep for 30 seconds between checks.
                                    Thread.sleep(30000)
                                    status = getDownloadStatus(l.downloadId)
                                }
                                //3) if the status was "SUCCEEDED" then starts the download
                                if(status == "SUCCEEDED"){
                                    l.phase = "Downloading..."
                                    File localTmpDir = new File(grailsApplication.config.uploadFilePath + File.separator+"tmp" + File.separator + l.downloadId)
                                    FileUtils.forceMkdir(localTmpDir)
                                    String tmpFileName = localTmpDir.getAbsolutePath()+File.separator+ l.downloadId
                                    IOUtils.copy(new URL(GBIF_API+OCCURRENCE_DOWNLOAD+"/"+ l.downloadId+".zip").openStream(), new FileOutputStream(tmpFileName))
                                    //4) Now create the data resource using the file downloaded
                                    l.phase = "Creating GBIF Data resource..."
                                    def dr = createGBIFResource(new File(tmpFileName))
                                    if(dr){
                                        l.dataResourceUid = dr.uid
                                        l.phase = "Data Resource Created"
                                    }
                                } else {
                                    l.phase = "Download Failed: " + status
                                }
                                //Thread.sleep(5000)
                                l.setLoaded()
                                //l.dataResourceUid="dr123"
                                //check to see if all the items have finished loading
                                log.debug("IS LOAD STILL RUNNING: " + gls.isLoadRunning())
                                loading = gls.isLoadRunning()
                                if(!loading){
                                    gls.finishTime = new Date()
                                }
                            }
                        }
                    }
                })
                return gls
            } else {
                loading = false
                return null
            }
        }
    }
    /**
     * Queries the GBIF search API for the list of datasets to load
     * @param country The country for the datasets
     * @param userLimit The user supplied limit on the number of datasets
     * @return
     */
    def getListOfGbifResources(String country, Integer userLimit){
        country = country.toUpperCase()
        //first get a request so we know how many we are dealing with
        log.debug(DATASET_SEARCH + " " +country)
        String url = GBIF_API + MessageFormat.format(DATASET_SEARCH, country)
        JSONObject countJson = getJSONWS(url + "&limit=1")
        log.debug("Search URL: " + url);
        if (countJson){
            def total =countJson.getInt("count")
            def limit = (userLimit == null || userLimit>total) ? total : userLimit
            log.debug("We will create " + limit + " data resources for the supplied country " + country)
            int i=0
            def list = []
            while(i <limit){
                def newLimit = userLimit && userLimit >50 ? userLimit-i:limit
                def locallimit =newLimit<50?newLimit:50
                JSONObject pageObject = getJSONWS(url + "&limit="+locallimit+"&offset="+i)
                log.debug(pageObject.get("results").getClass())
                pageObject.get("results").each {result ->
                    GBIFActiveLoad gal = new GBIFActiveLoad()
                    gal.gbifResourceUid = result.getString("key")
                    gal.name = result.getString("title")
                    list << gal
                    i += 1
                }
            }
            log.debug("Finished collecting list " +list.size)
            return list
        } else{
            loading = false
            return null
        }
    }
    /**
     * performs the steps to create a new GBIF resource from the supplied
     * mulitpart file
     *
     * Supplied here so that a normal post webservice can call it as well as a view backed service.
     *
     * @param uploadedFile
     */
    def createGBIFResourceFromMultipart(MultipartFile uploadedFile){
        //1) Save the file to the correct tmp staging location
        def fileId = System.currentTimeMillis()
        File localFile = new File(grailsApplication.config.uploadFilePath + File.separator+"tmp" + File.separator + fileId)
        uploadedFile.transferTo(localFile)
        //2) create the GBIF resource based on a local file now
        return createGBIFResource(localFile)
    }
    /**
     * Creates a data resource from the supplied file. Includes DWCA creation and preoprety extraction.
     *
     * @param uploadedFile
     * @return
     */
    def createGBIFResource(File uploadedFile){
        //1) Extract the ZIP file
        //2) Extract the JSON for the data resource to create
        def json =extractDataResourceJSON(new ZipFile(uploadedFile),uploadedFile.getParentFile());

        log.debug("The JSON to create the dr : " + json)
        //3) Create the data resource
        def dr = crudService.insertDataResource(json)
        log.debug(dr.uid + "  " +dr.id + " " +dr.name)//.toString() + " " + dr.hasErrors() + " " + dr.getErrors())
        //4) Add the contact details for the data resource
        //TODO we may need to add a separate contact at the  moment we are just adding it to the data resource
        //5) Create the DwCA for the resource using the GBIF default meta.xml and occurrences.txt
        String zipFileName = createDWCA(uploadedFile.getParentFile(), json.get("guid"))
        log.debug("Created the zip file " + zipFileName)
        //6) Upload the DwCA for the resource to the created data resource
        applyDwCA(new File(zipFileName), dr)

        return dr
    }
    /**
     * Adds the DWCA to the data resource for use in loading
     * @param file a constructed archive to apply to the resoruce
     * @param dr  The data resource to apply the supplied archive to
     * @return
     */
    def applyDwCA(File file, DataResource dr){
        try{
            log.debug("Copying DwCA to staging and associated the file to the data resource")
            def fileId = System.currentTimeMillis()
            String targetFileName = grailsApplication.config.uploadFilePath + fileId  + File.separator+file.getName()
            File targetFile = new File(targetFileName)
            FileUtils.forceMkdir(targetFile.getParentFile())
            file.renameTo(targetFile)
            log.debug("Finished moving the file for " + dr.getUid())
            //move the DwCA where it needs to be
            def connParams = (new JsonSlurper()).parseText(dr.connectionParameters?:'{}')
            connParams.url = 'file:///'+targetFileName
            connParams.protocol="DwCA"
            connParams.termsForUniqueKey=["occurrenceID"]
            //NQ we need a transaction so the this can be executed in a multithreaded manner.
            DataResource.withTransaction {
                dr.connectionParameters = (new JsonOutput()).toJson(connParams)
                log.debug("Finished creating the connection params for " + dr.getUid())
                dr.save(flush:true)
                log.debug("Finished saving the connection params for " + dr.getUid())
            }
        } catch(Exception e){
            log.error(e.getClass().toString() + " : " + e.getMessage())
        }
    }

    /**
     * Creates a DWCA based on default meta.xml and the occurrence.txt extracted from the
     * GBIF archive
     * @param directoryForArchive
     * @param guid
     * @return
     */
    def createDWCA(File directoryForArchive, String guid){
        //create a ZIP File with the occurrence.txt and meta.xml
        String zipFileName =directoryForArchive.getAbsolutePath() + File.separator + guid + ".zip"
        ZipOutputStream zop = new ZipOutputStream(new FileOutputStream(zipFileName))
        //add the occurrence.txt file
        zop.putNextEntry(new ZipEntry(OCCURRENCE_FILE))
        IOUtils.copy(new FileInputStream(directoryForArchive.getAbsolutePath() + File.separator + OCCURRENCE_FILE), zop)
        zop.closeEntry()
        //add the meta.xml
        zop.putNextEntry(new ZipEntry("meta.xml"))
        IOUtils.copy(new FileInputStream(META_FILE), zop)
        zop.closeEntry()
        zop.flush()
        zop.close()
        return zipFileName
    }
    /**
     * Extracts all the details from the GBIF download to use for the data resource.
     * @param zipFile
     * @param directoryForArchive
     * @return
     */
    def extractDataResourceJSON(ZipFile zipFile, File directoryForArchive){
        String citation=""
        String rights=""
        Map map=[:]
        zipFile.entries.each{ file ->
            if (file.getName() == CITATION_FILE) {
                map.get("citation",zipFile.getInputStream(file).text.replaceAll("\n", " "))
            } else if (file.getName() == RIGHTS_FILE) {
                map.rights = zipFile.getInputStream(file).text.replaceAll("\n"," ")
            } else if (file.getName().startsWith(EML_DIRECTORY)){

                //open the XML file that contains the EML details for the GBIF resource
                def xml = new XmlSlurper().parseText(zipFile.getInputStream(file).text)
                map.guid = xml.@packageId.toString()
                map.name = xml.dataset.title.toString()
                def contact = xml.dataset.contact
                map.phone = contact.phone.toString()
                map.email = contact.electronicMailAddress.toString()
                map.get("citation",xml.additionalMetadata.metadata.gbif.citation.toString())
                map.get("rights",xml.additionalMetadata.metadata.gbif.rights.toString())

                log.debug(map)

            } else if (file.getName() == OCCURRENCE_FILE){
                //save the record to the "directoryForArchive"
                IOUtils.copy(zipFile.getInputStream(file), new FileOutputStream(new File(directoryForArchive, OCCURRENCE_FILE)));
            }
        }

        JSONObject jo = new JSONObject(map)
        //map.each{k, v -> jo.put(k,v)}
        log.debug("the toString : " + jo.toString())
        return jo
    }
    /**
     * Extracts the data resource information from the EML file in the supplied directory
     * @param directory
     */
    def extractDataResourceJSON(String directory){
        def emlDir = new File(directory + File.separator+EML_DIRECTORY)
        //iterate through all the files in the directory (there should only be one, but we will ensure that we only process one set of data)
        boolean done = false
        emlDir.eachFile(){file ->
            if(!done){
                String uuid = file.getName().replace(".xml","")
                //open the XML file that contains the EML details for the GBIF resource
                def xml = new XmlSlurper().parseText(file.text)
                String title = xml.dataset.title
                def contact = xml.dataset.contact
                String phone = contact.phone
                String email = contact.electronicMailAddress
                String citation = xml.additionalMetadata.metadata.gbif.citation

                log.debug(title + " " + uuid + " " + contact)
                log.debug(phone +" " + email + " " + citation)
            }
        }

    }
    /**
     * Extracts the text to use as the citation
     * @param directory
     * @return
     */
    def extractCitation(String directory){
        extractFileText(directory, CITATION_FILE)
    }
    /**
     * Extracts the text to use as the rights
     * @param directory
     * @return
     */
    def extractRights(String directory){
        extractFileText(directory, RIGHTS_FILE)
    }
    /**
     * Generic method to extract the text from a  file.
     * @param directory
     * @param file
     * @return
     */
    def extractFileText(String directory, String file){
        def fileName = directory + File.separator + file
        //extract value to return
        new File(fileName).text
    }
    /**
     * Retrieves the status of the supplied GBIF download
     *
     *
     * The possible status include:
     CANCELLED
     FAILED
     KILLED
     PREPARING
     RUNNING
     SUCCEEDED
     SUSPENDED
     *
     * return "SUCCEEDED" when finished.
     *
     * @param downloadId
     */
    def getDownloadStatus(String downloadId){
        //http://api.gbif.org/v0.9/occurrence/download/0006020-131106143450413
        def json = getJSONWS(GBIF_API+DOWNLOAD_STATUS + downloadId)
        return json && json?.status ? json.status : "UNKNOWN"
//        def http = new HTTPBuilder(GBIF_API+DOWNLOAD_STATUS + downloadId)
//        http.request(Method.GET, ContentType.JSON){
//            response.success = { resp, json ->
//                log.debug("SUCCESS:: "+resp)
//                log.debug(json)
//                return json.status
//            }
//            response.failure ={ resp ->
//                log.debug("FAILURE:: "+resp)
//                return "UNKNOWN"
//            }
//        }

    }
    /**
     * Uses a HTTP "GET" to return the JSON output of the supplied url
     * @param url
     * @return
     */
    def getJSONWS(String url){
        def http = new HTTPBuilder(url)
        http.request(Method.GET, ContentType.JSON){
            response.success = { resp, json ->
                log.debug("SUCCESS:: "+resp)
                log.debug(json)
                return json
            }
            response.failure ={ resp ->
                log.debug("FAILURE:: "+resp)
                return null
            }
        }
    }
    /**
     * Starts the GBIF download by calling the API/
     *
     * @param resourceId The GBIF identifier for the resource
     * @param username The username of a register GBIF user - a download will only be started when a valid user is supplied
     * @param email NOT USED as the email is automatically associated via the username
     * @param password  The password for the GBIF user.
     * @return The downloadId used to monitor when the download has been completed
     */
    def startGBIFDownload(String resourceId,String username, String email, String password){
        String jsonBody = MessageFormat.format(DOWNLOAD_JSON, username, email, resourceId)
        //String encoding = encodeAsBase64(username+":"+password);
        log.debug("JSON Body: "+ jsonBody)
        //NQ: I can't get the Grail HTTPBuilder to work correctly with different request and response data types
//        String downloadId=null
//        def downloadHttp = new HTTPBuilder(GBIF_API+OCCURRENCE_DOWNLOAD)
//        downloadHttp.auth.basic username, password
//
//        downloadHttp.request(Method.POST, ContentType.TEXT){
//            requestContentType = ContentType.JSON
//            //send ContentType.JSON, jsonBody
//            body = jsonBody
//            response.success = { resp, reader ->
//                log.debug(resp + reader)
//                downloadId=reader.getText()
//            }
//            response.failure = { resp ->
//                println "Request failed with status ${resp.status}"
//                println(resp)
//            }
//        }


        //application/JSON
//        def post = new PostMethod(GBIF_API+OCCURRENCE_DOWNLOAD)
//        def http = new HttpClient()
        //Below is the way we set up Basic Authentication to work
        def http = new DefaultHttpClient()
        http.getCredentialsProvider().setCredentials(AuthScope.ANY,new UsernamePasswordCredentials(username,password))
        http.addRequestInterceptor(new HttpRequestInterceptor() {
            public void process(HttpRequest request, HttpContext context) throws HttpException, IOException {
                AuthState state = (AuthState) context.getAttribute(ClientContext.TARGET_AUTH_STATE);
                if (state.getAuthScheme() == null) {
                    BasicScheme scheme = new BasicScheme();
                    org.apache.http.client.CredentialsProvider credentialsProvider = (org.apache.http.client.CredentialsProvider) context.getAttribute(ClientContext.CREDS_PROVIDER);
                    Credentials credentials = credentialsProvider.getCredentials(AuthScope.ANY);
                    if (credentials == null) {
                        throw new HttpException();
                    }
                    state.setAuthScope(AuthScope.ANY);
                    state.setAuthScheme(scheme);
                    state.setCredentials(credentials);
                }
            }
        }, 0); // 0 = first, and you really want to be first.

        HttpPost post = new HttpPost(GBIF_API + OCCURRENCE_DOWNLOAD)
        def entity = new StringEntity(jsonBody, HTTP.UTF_8)
        post.setEntity(entity)
        post.addHeader("Content-Type", "application/json; charset=UTF-8")

        def response = http.execute(post)
        ByteArrayOutputStream bos = new ByteArrayOutputStream()
        response.getEntity().writeTo(bos)
        String downloadId = bos.toString();
        log.debug("download id: " + downloadId)
        return downloadId
        //post.addRequestHeader("Content-Type", "application/json; charset=UTF-8")
        //post.setRequestBody(jsonBody)
        //http.execute(new HttpHost())
        //log.debug("Return code for POST: " +http.executeMethod(post))
        //log.debug(post.responseBodyAsString)
    }

}
