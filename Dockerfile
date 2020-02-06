FROM centos
MAINTAINER Rajat Arora

ARG OPENJDK_VERSION=1.8.0
ARG TOMCAT_MAJOR=8
ARG TOMCAT_VERSION=8.5.50

# Ensure root user is used               
USER root 
# Install required libs
#RUN yum update -y
RUN yum install -y sudo

# Install OpenJDK
RUN yum install -y "java-${OPENJDK_VERSION}-openjdk-devel"

ARG TOMCAT_HOME=/usr/local/tomcat

ARG TOMCAT_NAME=apache-tomcat-${TOMCAT_VERSION}
ARG TOMCAT_FILE=${TOMCAT_NAME}.tar.gz


ARG TOMCAT_URL=http://mirror.easyname.ch/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

RUN mkdir -p ${TOMCAT_HOME}
RUN mkdir -p /data/iap/logs/
WORKDIR ${TOMCAT_HOME}

ARG CURL_CMD="curl -k"
RUN ${CURL_CMD} -O ${TOMCAT_URL}

RUN tar -xf ${TOMCAT_FILE} --strip-components 1 --directory ${TOMCAT_HOME}
RUN rm -f ${TOMCAT_FILE}

EXPOSE 8080
EXPOSE 8009

USER tomcat
WORKDIR $TOMCAT_HOME

#Copying War FIle
COPY ecspoc-0.0.1-SNAPSHOT.war ${TOMCAT_HOME}/webapps/

# Launch Tomcat
CMD ["./bin/catalina.sh", "run"]

