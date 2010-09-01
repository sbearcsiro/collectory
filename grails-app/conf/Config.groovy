// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

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

if (!biocache.baseURL) {
     biocache.baseURL = "http://biocache.ala.org.au/"
}
if (!security.cas.urlPattern) {
    security.cas.urlPattern = '/admin.*,/collection/.*,/institution/.*,/contact/.*,/reports/.*,/providerCode/.*,/providerMap/.*'
}
if (!citation.template) {
    citation.template = 'Accessed through ALA website, @entityName@, for more information: @link@'
}

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text/plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]
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

// default location for images
repository.location.images = '/data/collectory/data'

def logDirectory = "/data/collectory/logs"

// set per-environment serverURL stem for creating absolute links
environments {
    production {
        grails.serverURL = "http://collections.ala.org.au" //"http://www.changeme.com"
        security.cas.serverName = grails.serverURL
        security.cas.contextPath = ''
    }
    testserver {
        grails.serverURL = "http://alatstdb1-cbr.vm.csiro.au/Collectory"
        security.cas.serverName = "http://alatstdb1-cbr.vm.csiro.au"
        security.cas.contextPath = '/Collectory'
    }
    development {
        grails.serverURL = "http://nemo-be.nexus.csiro.au:8080/Collectory"
        security.cas.serverName = "http://nemo-be.nexus.csiro.au:8080"
        security.cas.contextPath = '/Collectory'
        security.cas.bypass = false
    }
    test {
        grails.serverURL = "http://localhost:8080/${appName}"
        security.cas.serverName = ''
        security.cas.contextPath = ''
    }

}

println "serverUrl = " + grails.serverURL
println "cas.serverName = " + security.cas.serverName
println "cas.context = " + security.cas.context

hibernate = "off"

// log4j configuration
log4j = {

    appenders {
        file name:'appLog', file: "${logDirectory}/collectory.log".toString()

        // set up a log file for the stacktrace log; be sure to use .toString() with ${}
        rollingFile name:'tomcatLog', file:"${logDirectory}/stacktrace.log".toString(), maxFileSize:'100KB'
        'null' name:'stacktrace'
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
           'net.sf.ehcache.hibernate'

    warn   'org.mortbay.log', 'org.springframework.webflow'

    info   'grails.app.controller'


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