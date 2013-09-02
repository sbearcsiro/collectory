/******************************************************************************\
 *  CONFIG MANAGEMENT
\******************************************************************************/
def ENV_NAME = "COLLECTORY_CONFIG"
def default_config = "/data/collectory/config/${appName}-config.properties"
if(!grails.config.locations || !(grails.config.locations instanceof List)) {
    grails.config.locations = []
}
if(System.getenv(ENV_NAME) && new File(System.getenv(ENV_NAME)).exists()) {
    println "[collectory] Including configuration file specified in environment: " + System.getenv(ENV_NAME);
    grails.config.locations = ["file:" + System.getenv(ENV_NAME)]
} else if(System.getProperty(ENV_NAME) && new File(System.getProperty(ENV_NAME)).exists()) {
    println "[collectory] Including configuration file specified on command line: " + System.getProperty(ENV_NAME);
    grails.config.locations = ["file:" + System.getProperty(ENV_NAME)]
} else if(new File(default_config).exists()) {
    println "[collectory] Including default configuration file: " + default_config;
    def loc = ["file:" + default_config]
    println "[collectory]  loc = " + loc
    grails.config.locations = loc
    println "grails.config.locations = " + grails.config.locations
} else {
    println "[collectory] No external configuration file defined."
}
println "[collectory] (*) grails.config.locations = ${grails.config.locations}"

/******************************************************************************\
 *  SKINNING
 \******************************************************************************/
if (!ala.skin) {
    ala.skin = 'ala2';
}
/******************************************************************************\
 *  EXTERNAL SERVERS
\******************************************************************************/
if (!bie.baseURL) {
     bie.baseURL = "http://bie.ala.org.au/"
}
if (!bie.searchPath) {
    bie.searchPath = "/search"
}
if (!biocache.baseURL) {
     biocache.baseURL = "http://biocache.ala.org.au/"
}
if (!spatial.baseURL) {
     spatial.baseURL = "http://spatial.ala.org.au/"
}
if (!ala.baseURL) {
    ala.baseURL = "http://www.ala.org.au"
}
if (!headerAndFooter.baseURL) {
    headerAndFooter.baseURL = "http://www2.ala.org.au/commonui"
}
if(!biocacheServicesUrl){
    biocacheServicesUrl = "http://biocache.ala.org.au/ws"
}

/******************************************************************************\
 *  BIOCACHE URLS
\******************************************************************************/
if (!biocache.occurrences.json) {
    biocache.occurrences.json = "ws/occurrences/{entity}/{uid}.json?pageSize=0"
}
if (!biocache.breakdown.taxa) {
    biocache.breakdown.taxa = "ws/breakdown/{entity}/{uid}"
}

if (!biocache.bounding.box) {
    biocache.bounding.box = "ws/mapping/bounds"
}

/******************************************************************************\
 *  RELOADABLE CONFIG
\******************************************************************************/
//reloadable.cfgPollingFrequency = 1000 * 60 * 60 // 1 hour
//reloadable.cfgPollingRetryAttempts = 5
//reloadable.cfgs = ["file:/data/collectory/config/Collectory-config.properties"]
/******************************************************************************\
 *  SECURITY
\******************************************************************************/
if (!security.cas.uriFilterPattern) {
    security.cas.uriFilterPattern = "/admin.*,/collection.*,/institution.*,/contact.*,/reports.*," +
            "/providerCode.*,/providerMap.*,/dataProvider.*,/dataResource.*,/dataHub.*,/manage/.*"
}
if (!security.cas.loginUrl) {
    security.cas.loginUrl = "https://auth.ala.org.au/cas/login"
}
if (!security.cas.logoutUrl) {
    security.cas.logoutUrl = "https://auth.ala.org.au/cas/logout"
}
if (!security.apikey.serviceUrl) {
    security.apikey.serviceUrl = "http://auth.ala.org.au/apikey/ws/check?apikey="
}
if(!security.cas.appServerName){
    security.cas.appServerName = "http://devt.ala.org.au:8080"
}
if(!security.cas.casServerName){
    security.cas.casServerName = "https://auth.ala.org.au"
}
if(!security.cas.uriExclusionFilterPattern){
    security.cas.uriExclusionFilterPattern = '/images.*,/css.*,/js.*,/less.*'
}
if(!security.cas.authenticateOnlyIfLoggedInPattern){
    security.cas.authenticateOnlyIfLoggedInPattern = "" // pattern for pages that can optionally display info about the logged-in user
}
if(!security.cas.casServerUrlPrefix){
    security.cas.casServerUrlPrefix = 'https://auth.ala.org.au/cas'
}
if(!security.cas.bypass){
    security.cas.bypass = false
}

/******************************************************************************\
 *  TEMPLATES
 \******************************************************************************/
if (!citation.template) {
    citation.template = 'Records provided by @entityName@, accessed through ALA website.'
}
if (!citation.link.template) {
    citation.link.template = 'For more information: @link@'
}
if (!citation.rights.template) {
    citation.rights.template = ''
}
if (!resource.publicArchive.url.template) {
    resource.publicArchive.url.template = "${biocache.baseURL}archives/@UID@/@UID@_ror_dwca.zip"
}

/******* standard grails **********/
grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = true
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text/plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      tsv: 'text/tsv',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]
// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// The default codec used to encode data with ${}
grails.views.default.codec="html" // none, html, base64
grails.views.gsp.encoding="UTF-8"
grails.converters.encoding="UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder=false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// whether to install the java.util.logging bridge for sl4j. Disable fo AppEngine!
grails.logging.jul.usebridge = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// MEW tell the framework which packages to search for @Validateable classes
grails.validateable.packages = ['au.org.ala.collectory']

/******* location of images **********/
// default location for images
repository.location.images = '/data/collectory/data'

/******* log files **********/
def logDirectory = "/data/collectory/logs"

/******************************************************************************\
 *  ENVIRONMENT SPECIFIC
\******************************************************************************/
environments {
    production {
        grails.serverURL = "http://collections.ala.org.au" //"http://www.changeme.com"
        grails.context = ''
        security.cas.serverName = grails.serverURL
        security.cas.contextPath = grails.context
    }
    testserver {
        grails.serverURL = "http://testweb1.ala.org.au:8080/Collectory"
        grails.context = '/Collectory'
        security.cas.serverName = "http://testweb1.ala.org.au:8080"
        security.cas.contextPath = grails.context
    }
    development {
        grails.serverURL = "http://devt.ala.org.au:8080/Collectory"
        grails.context = '/Collectory'
        security.cas.serverName = "http://devt.ala.org.au:8080"
        security.cas.contextPath = grails.context
        security.cas.bypass = false
    }
}

println "[collectory] serverUrl = " + grails.serverURL
println "[collectory] security.cas.serverName = " + security.cas.serverName
println "[collectory] security.cas.context = " + security.cas.contextPath
println "[collectory] security.cas.appServerName = " + security.cas.appServerName
println "[collectory] security.cas.casServerName = " + security.cas.casServerName
println "[collectory] security.cas.uriFilterPattern = " + security.cas.uriFilterPattern

hibernate = "off"

/******************************************************************************\
 *  AUDIT LOGGING
\******************************************************************************/
auditLog {
  actorClosure = { request, session ->
      def cas = session?.getAttribute('_const_cas_assertion_')
      def actor = cas?.getPrincipal()?.getName()
      if (!actor) {
          actor = request.getUserPrincipal()?.attributes?.email
      }
      if (!actor) {
          actor = session.username  // injected by data controller for web services
      }
      return actor ?: "anonymous"
  }
  TRUNCATE_LENGTH = 2048
}
auditLog.verbose = false

/******************************************************************************\
 *  log4j configuration
\******************************************************************************/
log4j = {

    appenders {
        environments {
            development {
                console name: "stdout",
                        layout: pattern(conversionPattern: "%d %-5p [%c{1}]  %m%n")
                rollingFile name: "collectoryLog",
                        maxFileSize: 104857600,
                        file: "/var/log/tomcat6/collectory.log",
                        layout: pattern(conversionPattern: "%d %-5p [%c{1}]  %m%n")
                rollingFile name: "stacktrace",
                        maxFileSize: 104857600,
                        file: "/var/log/tomcat6/collectory-stacktrace.log"
            }
        }
    }

    environments {
        development {
            all additivity: false, stdout: [
                    'grails.app.controllers.au.org.ala.collectory',
                    'grails.app.domain.au.org.ala.collectory',
                    'grails.app.services.au.org.ala.collectory',
                    'grails.app.taglib.au.org.ala.collectory',
                    'grails.app.conf.au.org.ala.collectory',
                    'grails.app.filters.au.org.ala.collectory',
                    'au.org.ala.cas.client'
            ]
            all additivity: false, collectoryLog: [
                    'grails.app.controllers.au.org.ala.collectory',
                    'grails.app.domain.au.org.ala.collectory',
                    'grails.app.services.au.org.ala.collectory',
                    'grails.app.taglib.au.org.ala.collectory',
                    'grails.app.conf.au.org.ala.collectory',
                    'grails.app.filters.au.org.ala.collectory',
                    'au.org.ala.cas.client'
            ]
        }
    }

    root {
        // change the root logger to my log file
        error 'stdout', 'collectoryLog'
        warn 'stdout', 'collectoryLog'
        info 'stdout', 'collectoryLog'
        debug 'stdout', 'collectoryLog'
        additivity = true
    }

    error  'org.codehaus.groovy.grails.web.servlet',  //  controllers
            'org.codehaus.groovy.grails.web.pages', //  GSP
            'org.codehaus.groovy.grails.web.sitemesh', //  layouts
            'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
            'org.codehaus.groovy.grails.web.mapping', // URL mapping
            'org.codehaus.groovy.grails.commons', // core / classloading
            'org.codehaus.groovy.grails.plugins', // plugins
            'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
            'org.springframework',
            'org.hibernate',
            'net.sf.ehcache.hibernate',
            'org.codehaus.groovy.grails.plugins.orm.auditable',
            'org.mortbay.log', 'org.springframework.webflow',
            'grails.app',
            'org.apache',
            'org',
            'com',
            'au',
            'grails.app',
            'net',
            'grails.util.GrailsUtil',
            'grails.app.service.org.grails.plugin.resource',
            'grails.app.service.org.grails.plugin.resource.ResourceTagLib',
            'grails.app',
            'grails.plugin.springcache',
            'au.org.ala.cas.client',
            'grails.spring.BeanBuilder',
            'grails.plugin.webxml',
            'org.codehaus.groovy.grails.plugins.orm.auditable',
            'grails-cache-headers'

    warn   'org.mortbay.log', 'org.springframework.webflow'

    info   'grails.app.controller'

    debug 'grails.app.controllers.au.org.ala'
}


//log4j.logger.org.springframework.security='off,stdout'
// Uncomment and edit the following lines to start using Grails encoding & escaping improvements

/* remove this line 
// GSP settings
grails {
    views {
        gsp {
            encoding = 'UTF-8'
            htmlcodec = 'xml' // use xml escaping instead of HTML4 escaping
            codecs {
                expression = 'html' // escapes values inside null
                scriptlet = 'none' // escapes output from scriptlets in GSPs
                taglib = 'none' // escapes output from taglibs
                staticparts = 'none' // escapes output from static template parts
            }
        }
        // escapes all not-encoded output at final stage of outputting
        filteringCodecForContentType {
            //'text/html' = 'html'
        }
    }
}
remove this line */
