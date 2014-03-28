
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
        mavenRepo "http://repository.codehaus.org/"
        mavenRepo "https://repository.jboss.org/nexus/content/repositories/thirdparty-releases"
        mavenRepo "https://oss.sonatype.org/content/repositories/releases/org/asciidoctor/asciidoctor-maven-plugin/0.1.4"
        mavenRepo "https://wordpress-java.googlecode.com/svn/repo"
        mavenRepo "http://repo.jenkins-ci.org/releases/org/eclipse/mylyn/wikitext/wikitext.core/1.7.4.v20130429"
        mavenRepo "http://repo1.maven.org/maven2/net/sourceforge/jexcelapi/jxl/2.6.12"
        mavenRepo "http://repo1.maven.org/maven2/org/jbibtex/jbibtex/1.0.11"
        mavenRepo "https://oss.sonatype.org/content/repositories/releases/de/undercouch/citeproc-java/0.6/"
        mavenRepo "https://oss.sonatype.org/content/repositories/releases/com/itextpdf/itextpdf/5.5.0/"
        mavenRepo "http://mirrors.ibiblio.org/maven2/org/ocpsoft/prettytime/prettytime/3.2.4.Final/"
        mavenRepo "http://repo1.maven.org/maven2/de/l3s/boilerpipe/boilerpipe/1.1.0/"
        mavenRepo "http://repo.jenkins-ci.org/releases/org/eclipse/mylyn/wikitext/wikitext/1.7.4.v20130429-0100/"
//        mavenRepo "http://repo.springsource.org/libs-milestone"
//        mavenRepo "http://snapshots.repository.codehaus.org"
        // mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
//        mavenRepo "https://repository.jboss.org/nexus/content/repositories/thirdparty-releases"
//        mavenRepo "https://repository.jboss.org/nexus/content/repositories/scala-tools-releases"
    }
    dependencies {
        // specify dependencies here under either 'runtime', 'compile', 'runtime', 'test' or 'provided' scopes eg.

        compile "mysql:mysql-connector-java:5.1.29"
		compile "com.gravity:goose:2.1.23"
        compile "wordpress-java:jwordpress:0.5.1"
//        compile 'jpwgen:jpwgen:1.2.0'
        //        compile 'org.eclipse.mylyn.wikitext:wikitext:1.7.4.v20130429-0100'
        compile 'de.l3s.boilerpipe:boilerpipe:1.1.0'
        compile 'com.itextpdf:itextpdf:5.5.0'
        compile 'org.ocpsoft.prettytime:prettytime:3.2.4.Final'
        compile 'net.sourceforge.jexcelapi:jxl:2.6.12'
        compile 'de.undercouch:citeproc-java:0.6'
        compile 'org.jbibtex:jbibtex:1.0.11'
        compile 'net.java.dev.rome:rome:1.0.0'
        //        compile 'org.eclipse.mylyn.wikitext:wikitext.core:1.7.4.v20130429'
        compile 'org.asciidoctor:asciidoctor-maven-plugin:0.1.4'
        //compile  "org.codehaus.groovy.modules.http-builder:http-builder:0.7"
    }
    plugins {

        compile ":oauth:2.1.0"
        // Uncomment these (or add new ones) to enable additional resources capabilities
        //runtime ":zipped-resources:1.0"
        //runtime ":cached-resources:1.0"

        runtime ":hibernate:$grailsVersion"
        build ":tomcat:$grailsVersion"

        compile ':cache:1.1.1'
        compile ":famfamfam:1.0.1"
        compile ":mail:1.0.4"
        compile ":spring-security-ui:0.2"
        compile ":spring-security-core:1.2.7.3"
        //        compile ":spring-security-ui:1.0-RC1"
        //        compile ":spring-security-core:2.0-RC2"
        //runtime 'antlr:antlr:2.7.6' // post about it
        compile ":jquery:1.8.0"
        compile ":jquery-ui:1.8.15"
        compile ":resources:1.2.1"
        compile ":console:1.3"
        compile ":feeds:1.5"
        compile ":ic-alendar:0.3.8"
        compile ":pretty-size:0.2"
        compile ":pretty-time:2.1.3.Final-1.0.1"
        compile ":ajax-uploader:1.1"
        compile ":quartz2:2.1.6.2"
        compile ":remote-pagination:0.4.6"
        compile ":browser-detection:0.4.3"
        compile ":searchable:0.6.4"
        compile ":audit-logging:0.5.5.3"
        compile ":rest-client-builder:2.0.1"
        compile ":jasypt-encryption:1.1.0"
    }
}
