
set PATH=C:\Applications\grails-2.2.3\bin

set GRAILS_HOME=C:\Applications\grails-2.2.3

set JAVA_HOME=C:\Program Files\Java\jdk1.6.0_25

set JAVA_OPTS=-client -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m -javaagent:C:\Applications\grails-2.2.3\lib\org.springsource.springloaded\springloaded-core\jars\springloaded-core-1.1.3.jar -noverify -Dspringloaded=profile=grails

grails -Dserver.port=2008  -Dgrails.env=demo -reloading -Dgrails.gsp.enable.reload=true run-app  --stacktrace