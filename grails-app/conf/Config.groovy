import org.apache.log4j.PatternLayout
import grails.plugins.springsecurity.SecurityConfigType

// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

grails.config.locations = [
//        "classpath:${appName}-config.properties",
//        "classpath:${appName}-config.groovy",
//        "file:${userHome}/${appName}.properties"
//        "file:${userHome}/.pomegranate.properties"
]

def configFilePath = System.getenv('pkm.config') ?: "file:${userHome}/.pkm.properties"
grails.config.locations = [configFilePath]
// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }


grails.project.groupId = pkm // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [html: ['text/html', 'application/xhtml+xml'],
        xml: ['text/xml', 'application/xml'],
        text: 'text/plain',
        js: 'text/javascript',
        rss: 'application/rss+xml',
        atom: 'application/atom+xml',
        css: 'text/css',
        csv: 'text/csv',
        all: '*/*',
        json: ['application/json', 'text/json'],
        form: 'application/x-www-form-urlencoded',
        multipartForm: 'multipart/form-data'
]

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

grails.gsp.reload.enable = false

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart = false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// enable query caching by default
grails.hibernate.cache.queries = true

// set per-environment serverURL stem for creating absolute links
environments {
    production {
        grails.logging.jul.usebridge = false
//        grails.serverURL = "http://localhost/${appName}"
    }
    development {
        grails.logging.jul.usebridge = true
        grails.serverURL = "https://localhost:2015/${appName}"
    }
    test {
//        grails.serverURL = "http://localhost:2008/${appName}"
    }

}

// log4j configuration
/* MINE pre 6.5.1
log4j = {
    def logLayoutPattern = new PatternLayout("%d [%t] %-5p %c %x - %m%n")
    appenders {
        rollingFile(name: "file", file: "/log/mcs_" + new Date().format('dd.MM.yyyy') + '.log',
                datePattern: "'.'yyyy-MM-dd",
                layout: logLayoutPattern)

        rollingFile name: "stacktrace", maxFileSize: 1024, file: "/log/mcs-stackstrace_" + new Date().format('dd.MM.yyyy') + ".log"
        console name: 'stdout', layout: pattern(conversionPattern: '%c{2} %m%n')
    }

    

    root {
        warn 'file', 'stdout'
        info 'file', 'stdout'
        error 'file', 'stdout'
        additivity = true
    }

    error file: "/errors" + new Date().format('dd.MM.yyyy') + ".log"

    warn 'org.codehaus.groovy.grails.web.servlet',  //  controllers
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
    warn 'org.mortbay.log'
    info 'grails.app'
}

*/

log4j = {
    appenders {
        rollingFile name: 'logfile', maxFileSize: '512KB', maxBackupIndex: 10,
                file: (System.getProperty('catalina.base') ?: 'target') + '/logs/application.log'
        layout: pattern(conversionPattern: '%d{dd MMM yyyy HH:mm:ss} %p [%c] - <%m>%n')
        rollingFile name: 'fileSQL', maxFileSize: '512KB', maxBackupIndex: 10,
                file: (System.getProperty('catalina.base') ?: 'target') + '/logs/sql.log'
        layout: pattern(conversionPattern: '%-27d{dd/MMM/yyyy HH:mm:ss Z} %-10r [%t] - %m%n')
        console name: 'stdout', layout: pattern(conversionPattern: '%c{2} %m%n')

    }
    error 'org.codehaus.groovy.grails',
            'org.springframework',
            'org.hibernate',
            'net.sf.ehcache.hibernate',
            'org.codehaus.groovy.grails.web.servlet',  //  controllers
            'org.codehaus.groovy.grails.web.pages', //  GSP
            'org.codehaus.groovy.grails.web.sitemesh', //  layouts
            'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
            'org.codehaus.groovy.grails.web.mapping', // URL mapping
            'org.codehaus.groovy.grails.commons', // core / classloading
            'org.codehaus.groovy.grails.plugins', // plugins
            'org.codehaus.groovy.grails.orm.hibernate' // hibernate integration
    info 'grails.app'
    //debug additivity: false, fileSQL: 'org.hibernate.SQL'
    //trace additivity: false, fileSQL: 'org.hibernate.type'
    root {
        error 'logfile', 'stdout'
    }
}
//grails.plugins.twitterbootstrap.fixtaglib = true
//grails.plugins.twitterbootstrap.defaultBundle = 'bundle_bootstrap'

grails.gorm.default.constraints = {
    '*'(nullable: true)
}


// Added by the Spring Security Core plugin:
grails.plugins.springsecurity.userLookup.userDomainClassName = 'security.User'
grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'security.UserRole'
grails.plugins.springsecurity.authority.className = 'security.Role'




grails.plugins.springsecurity.useBasicAuth = true
grails.plugins.springsecurity.basic.realmName = "HTTP Basic Auth"

grails.plugin.springsecurity.filterChain.chainMap = [
        '/sync/**': 'JOINED_FILTERS,-exceptionTranslationFilter',
        '/rss/**': 'JOINED_FILTERS,-exceptionTranslationFilter',
        '/book/viewImage/**': 'JOINED_FILTERS,-exceptionTranslationFilter',
        '/': 'JOINED_FILTERS,-basicAuthenticationFilter,-basicExceptionTranslationFilter',
        '/*': 'JOINED_FILTERS,-basicAuthenticationFilter,-basicExceptionTranslationFilter',
        '/**': 'JOINED_FILTERS,-basicAuthenticationFilter,-basicExceptionTranslationFilter'
]
grails.plugins.springsecurity.securityConfigType = SecurityConfigType.InterceptUrlMap
grails.plugins.springsecurity.interceptUrlMap = [
        '/login/**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
        '/logout/**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
//        '/rss/feeds**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
        '/book/viewImage**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
     '/book/viewImage/**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
//     '/sync/**': ['IS_AUTHENTICATED_ANONYMOUSLY'],
     '/register/index/*': ['IS_AUTHENTICATED_ANONYMOUSLY'],
     '/register/forgotPassword': ['IS_AUTHENTICATED_ANONYMOUSLY'],
        '/': ['IS_AUTHENTICATED_FULLY'],
        '/*': ['IS_AUTHENTICATED_FULLY'],
        '/**': ['IS_AUTHENTICATED_FULLY']
]
grails.plugin.springsecurity.secureChannel.definition = [
        '/login/**':         'REQUIRES_SECURE_CHANNEL',
        '/maps/**':          'REQUIRES_INSECURE_CHANNEL',
        '/images/login/**':  'REQUIRES_SECURE_CHANNEL',
        '/images/**':        'ANY_CHANNEL',
        '/sync/**':        'ANY_CHANNEL',
        '/rss/**':        'ANY_CHANNEL',
        '/book/viewImage/**':        'ANY_CHANNEL',
        '/**':        'REQUIRES_SECURE_CHANNEL'
]

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
grails.dbconsole.enabled=true
grails.dbconsole.urlRoot='/admin/dbconsole'


jasypt {
    algorithm = " PBEWithMD5AndDES"
    providerName = "BC"
    password = "<your very secret passphrase>"
    keyObtentionIterations = 1000
}