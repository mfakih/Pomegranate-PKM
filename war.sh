cd /mhi/dev/pkm

export PATH=$PATH:/mhi/app/jre/bin/:/mhi/app/grails-2.2.3/bin/
export GRAILS_HOME=/mhi/app/grails-2.2.3
export JAVA_HOME=/mhi/app/jre
export JAVA_OPTS="-client -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m"

grails war
# --nojars -Dgrails.project.war.file=/var/lib/tomcat7/webapps/pkm.war
#-Dgrails.env=ext war
#--nojars
