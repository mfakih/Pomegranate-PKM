
cd /mhi/dev/pkm9

export PATH=$PATH:/mhi/app/jdk/bin/:/mhi/app/grails-2.2.3/bin/
export GRAILS_HOME=/mhi/app/grails-2.2.3
export JAVA_HOME=/mhi/app/jdk
export JAVA_OPTS="-client -Xmx600m -XX:PermSize=128m -XX:MaxPermSize=256m"

#grails clean
grails run-app -Dserver.port=2016
#-Dgrails.project.war.file=/var/lib/tomcat7/webapps/pkm.war
#-Dgrails.env=ext war
#--nojars
