cd /mhi/mdd/dev/prj/mcs

export PATH=$PATH:/mhi/mdd/app/jdk1.7.0_25/jre/bin/:/mhi/mdd/app/grails-2.2.3/bin/
export GRAILS_HOME=/mhi/mdd/app/grails-2.2.3
export JAVA_HOME=/mhi/mdd/app/jdk1.7.0_25
export JAVA_OPTS="-client -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m"

grails war
#-Dgrails.env=ext war
#--nojars