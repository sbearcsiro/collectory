grails.servlet.version = "2.5"
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir	= "target/test-reports"
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
        mavenRepo "http://repository.codehaus.org"
        mavenRepo "http://maven.ala.org.au/repository/"
    }
    dependencies {
        runtime 'mysql:mysql-connector-java:5.1.5'
        runtime 'net.sf.opencsv:opencsv:2.3'
	    runtime 'ant:ant:1.6.5'
        runtime 'commons-httpclient:commons-httpclient:3.1'
//        runtime 'org.springframework:spring-context:3.0.2.RELEASE'
////        runtime "net.sf.ehcache:ehcache-core:2.8.1"
//        runtime 'net.sf.ehcache:ehcache:2.8.1'
////        runtime 'net.sf.ehcache:ehcache-core:2.8.1', {
////            excludes 'bsh', 'btm', 'commons-logging', 'derby', 'dom4j', 'hamcrest-core',
////                    'hamcrest-library', 'hibernate', 'hibernate-core', 'hibernate-ehcache',
////                    'javassist', 'jta', 'junit', 'mockito-core', 'servlet-api', 'sizeof-agent',
////                    'slf4j-api', 'slf4j-jdk14', 'xsom'
////        }

        runtime 'org.aspectj:aspectjweaver:1.6.6'
    }

    plugins {
        runtime ":hibernate:3.6.10.11"
        runtime ":jquery:1.7.1"
        runtime ":resources:1.2.7"
        runtime ":release:3.0.1"
        build ":tomcat:7.0.52.1"
        runtime ":audit-logging:0.5.5.3"
        runtime ":cache-headers:1.1.6"
        runtime ":richui:0.8"
        runtime ":tiny-mce:3.4.4"
        runtime ":ala-web-theme:0.2.4"
//        compile ":cache-ehcache:1.0.1"
//        compile ":cache:1.1.1"
    }
}
