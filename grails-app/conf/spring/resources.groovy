
import grails.util.GrailsUtil
import org.codehaus.groovy.grails.commons.GrailsApplication

beans = {
  customPropertyEditorRegistrar(util.CustomPropertyEditorRegistrar)
  localeResolver(org.springframework.web.servlet.i18n.SessionLocaleResolver)
}

