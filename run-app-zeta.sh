
cd /mhi/mdd/Pomegranate-PKM/

export PATH=$PATH:/mhi/mdd/app/jdk1.7.0_25/jre/bin/:/mhi/mdd/app/grails-2.2.3/bin/
export GRAILS_HOME=/mhi/mdd/app/grails-2.2.3
export JAVA_HOME=/mhi/mdd/app/jdk1.7.0_25
export JAVA_OPTS="-client -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m"


grails  -Ddisable.auto.recompile=true -Drecompile.frequency=20 -Dserver.port=2014 --stacktrace run-app
#-Dgrails.env=development
