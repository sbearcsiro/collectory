// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

/******************************************************************************\
 *  CONFIG MANAGEMENT
\******************************************************************************/
def ENV_NAME = "COLLECTORY_CONFIG"
def default_config = "/data/collectory/config/${appName}-config.properties"
if(!grails.config.locations || !(grails.config.locations instanceof List)) {
    grails.config.locations = []
}
if(System.getenv(ENV_NAME) && new File(System.getenv(ENV_NAME)).exists()) {
    println "Including configuration file specified in environment: " + System.getenv(ENV_NAME);
    grails.config.locations = ["file:" + System.getenv(ENV_NAME)]
} else if(System.getProperty(ENV_NAME) && new File(System.getProperty(ENV_NAME)).exists()) {
    println "Including configuration file specified on command line: " + System.getProperty(ENV_NAME);
    grails.config.locations = ["file:" + System.getProperty(ENV_NAME)]
} else if(new File(default_config).exists()) {
    println "Including default configuration file: " + default_config;
    def loc = ["file:" + default_config]
    println ">> loc = " + loc
    grails.config.locations = loc
    println "grails.config.locations = " + grails.config.locations
} else {
    println "No external configuration file defined."
}
println "(*) grails.config.locations = ${grails.config.locations}"

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
/******************************************************************************\
 *  BIOCACHE URLS
\******************************************************************************/
if (!biocache.occurrences.json) {
    biocache.occurrences.json = "ws/occurrences/{entity}/{uid}.json?pageSize=0"
}
if (!biocache.breakdown.taxa) {
    biocache.breakdown.taxa = "ws/breakdown/{entity}/{uid}"
}
/******************************************************************************\
 *  RELOADABLE CONFIG
\******************************************************************************/
reloadable.cfgPollingFrequency = 1000 * 60 * 60 // 1 hour
reloadable.cfgPollingRetryAttempts = 5
reloadable.cfgs = ["file:/data/collectory/config/Collectory-config.properties"]
/******************************************************************************\
 *  SECURITY
\******************************************************************************/
if (!security.cas.urlPattern) {
    security.cas.urlPattern = "/admin.*,/collection.*,/institution.*,/contact.*,/reports.*," +
            "/providerCode.*,/providerMap.*,/dataProvider.*,/dataResource.*,/dataHub.*,/manage/.*"
}
if (!security.cas.authenticateOnlyIfLoggedInPattern) {
    security.cas.authenticateOnlyIfLoggedInPattern = "/"
}
if (!security.cas.casServerName) {
    security.cas.casServerName = "https://auth.ala.org.au"
}
if (!security.cas.loginUrl) {
    security.cas.loginUrl = "${security.cas.casServerName}/cas/login"
}
if (!security.cas.logoutUrl) {
    security.cas.logoutUrl = "${security.cas.casServerName}/cas/logout"
}
if (!citation.template) {
    citation.template = 'Records provided by @entityName@, accessed through ALA website.'
}
if (!citation.link.template) {
    citation.link.template = 'For more information: @link@'
}
if (!citation.rights.template) {
    citation.rights.template = ''
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
        security.cas.appServerName = grails.serverURL
        security.cas.contextPath = grails.context
    }
    testserver {
        grails.serverURL = "http://testweb1.ala.org.au:8080/Collectory"
        grails.context = '/Collectory'
        security.cas.appServerName = "http://testweb1.ala.org.au:8080"
        security.cas.contextPath = grails.context
    }
    development {
        security.cas.appServerName = "http://flemmo.ala.org.au:8080"
        grails.context = '/Collectory'
        grails.serverURL = security.cas.appServerName + grails.context
        security.cas.contextPath = grails.context
        security.cas.bypass = false
    }
    test {
        grails.serverURL = "http://localhost:8080/${appName}"
        grails.context = ''
        security.cas.appServerName = ''
        security.cas.contextPath = grails.context
        security.cas.bypass = true
    }

}

println "serverUrl = " + grails.serverURL
println "security.cas.casServerName = " + security.cas.casServerName
println "security.cas.context = " + security.cas.contextPath

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

/*
    appenders {
        file name:'appLog', file: "${logDirectory}/collectory.log".toString()

        // set up a log file for the stacktrace log; be sure to use .toString() with ${}
        rollingFile name:'tomcatLog', file:"${logDirectory}/stacktrace.log".toString(), maxFileSize:'100KB'
        'null' name:'stacktrace'
    }
*/
    production {
        appenders {
            rollingFile name: "stacktrace", maxFileSize: 1024, file: "/var/log/tomcat55/collectory-stacktrace.log"
        }
    }

    root {
        // change the root logger to my tomcatLog file
        error 'stdout', 'tomcatLog', 'appLog'
        warn 'stdout', 'tomcatLog', 'appLog'
        info 'stdout','appLog'
        //debug 'stdout','appLog'
        additivity = true
    }

    // example for sending stacktraces to my tomcatLog file
    //error tomcatLog:'StackTrace'

/* normal logging */
    /*debug  'au.org.ala.collectory',
            'org.jasic.cas',
            'org.jasic.cas.client',
            'org.ala.cas.client'*/

//          'org.mortbay.log'

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
           'org.codehaus.groovy.grails.plugins.orm.auditable'

    warn   'org.mortbay.log', 'org.springframework.webflow'

    info   'grails.app.controller'

    debug

/* debug logging
    debug  'org.springframework.webflow',
           'org.springframework',
           'au.org.ala.collectory',
           'grails.app.controller',
           'org.codehaus.groovy.grails.commons', // core / classloading
           'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
           'org.mortbay.log',
           'net.sf.ehcache.hibernate'

    error  'org.codehaus.groovy.grails.web.servlet',  //  controllers
	       'org.codehaus.groovy.grails.web.pages', //  GSP
	       'org.codehaus.groovy.grails.web.sitemesh', //  layouts
	       'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
	       'org.codehaus.groovy.grails.web.mapping', // URL mapping
	       'org.codehaus.groovy.grails.plugins', // plugins
           'org.springframework',
           'org.hibernate'
 */
    
}


     

//log4j.logger.org.springframework.security='off,stdout'