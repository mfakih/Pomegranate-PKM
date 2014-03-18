
grails.servlet.version = "2.5" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.7
grails.project.source.level = 1.7
grails.project.war.file = "target/pkm.war"
grails.project.plugins.dir='plugins'
//grails.project.dependency.resolver = "maven"

grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // uncomment to disable ehcache
        excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    repositories {

        grailsPlugins()
        grailsHome()
        grailsCentral()
        mavenLocal()
        mavenCentral()
        // uncomment the below to enable remote dependency resolution
        // from public Maven repositories
        mavenLocal()
        mavenCentral()
//        mavenRepo "http://snapshots.repository.codehaus.org"
        // mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
    }
    dependencies {
        // specify dependencies here under either 'runtime', 'compile', 'runtime', 'test' or 'provided' scopes eg.
        runtime "mysql:mysql-connector-java:5.1.27"

    }
    plugins {

        // Uncomment these (or add new ones) to enable additional resources capabilities
        //runtime ":zipped-resources:1.0"
        //runtime ":cached-resources:1.0"

        runtime ":hibernate:$grailsVersion"
        build ":tomcat:$grailsVersion"

        compile ':cache:1.1.1'

        compile ":famfamfam:1.0.1"
        compile ":mail:1.0.1"

        compile ":spring-security-ui:0.2"
        compile ":spring-security-core:1.2.7.3"

//        compile ":spring-security-ui:1.0-RC1"
//        compile ":spring-security-core:2.0-RC2"


        //runtime 'antlr:antlr:2.7.6' // post about it
        compile ":jquery:1.8.0"
        compile ":jquery-ui:1.8.15"

        compile ":resources:1.2.1"

        compile ":console:1.3"

        compile ":feeds:1.6"
        compile ":ic-alendar:0.3.8"

        compile ":pretty-size:0.2"
        compile ":pretty-time:2.1.3.Final-1.0.1"
        compile ":ajax-uploader:1.1"
        compile ":quartz2:2.1.6.2"
        compile ":remote-pagination:0.4.6"

        compile ":browser-detection:0.4.3"

        compile ":searchable:0.6.4"
        compile ":audit-logging:0.5.5.3"

    }
}
