
cd /app/pkm

export PATH=$PATH:/app/jdk1.7.0_25/jre/bin/:/app/grails-2.2.3/bin/
export GRAILS_HOME=/app/grails-2.2.3
export JAVA_HOME=/app/jdk1.7.0_25
export JAVA_OPTS="-client -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m"


grails  -Ddisable.auto.recompile=true -Drecompile.frequency=20 -Dserver.port=2008  -Dgrails.env=ext -reloading -Dgrails.gsp.enable.reload=true run-app  --stacktrace
#-Dgrails.env=development