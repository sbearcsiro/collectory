grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir	= "target/test-reports"
//grails.project.war.file = "target/${appName}-${appVersion}.war"
grails.war.destFile = "Collectory.war"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits( "global" ) {
        // uncomment to disable ehcache
        // excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    repositories {        
        grailsPlugins()
        grailsHome()
        grailsCentral()

        // uncomment the below to enable remote dependency resolution
        // from public Maven repositories
        mavenLocal()
        mavenCentral()
        //mavenRepo "http://snapshots.repository.codehaus.org"
        //mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
    }
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.

        // runtime 'mysql:mysql-connector-java:5.1.5'
    }

    plugins {
        runtime ":hibernate:$grailsVersion"
        runtime ":jquery:1.7.1"
        runtime ":resources:1.1.6"
//        #plugins.audit-logging=0.5.4
//        #plugins.cache-headers=1.1.5
//        #plugins.hibernate=2.2.4
//        #plugins.jquery=1.7.1
//        #plugins.reloadable-config=0.1
//        #plugins.richui=0.8
//        #plugins.tiny-mce=3.4.4
//        #plugins.tomcat=2.2.4
        runtime ":audit-logging:0.5.4"
        runtime ":cache-headers:1.1.5"
        //runtime ":reloadable-config:0.1"
        runtime ":richui:0.8"
        runtime ":tiny-mce:3.4.4"

        // Uncomment these (or add new ones) to enable additional resources capabilities
        //runtime ":zipped-resources:1.0"
        //runtime ":cached-resources:1.0"
        //runtime ":yui-minify-resources:0.1.4"

        //build ":tomcat:$grailsVersion"
        build ":jetty:2.0.3"
    }

}
