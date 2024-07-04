FROM rockylinux:9.3

# install egi repo (grid trust anchors) and dependencies
RUN curl -Lo /etc/yum.repos.d/EGI-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo
RUN yum update -y && yum install -y vim git maven java-11-openjdk.x86_64 ca-policy-egi-core ca-certificates

# create storm user
RUN useradd -ms /bin/bash storm

# clone and build the storm-webdav jar
RUN git clone --quiet https://github.com/italiangrid/storm-webdav.git /opt/storm-webdav
RUN cd /opt/storm-webdav && mvn -B clean package -s maven/cnaf-mirror-settings.xml

# STorM environment settings
# see https://github.com/italiangrid/storm-webdav/tree/master/etc/systemd/system/storm-webdav.service.d
# must be done after build otherwise tests fail
ENV STORM_WEBDAV_USER=storm
ENV STORM_WEBDAV_JVM_OPTS="-Xms1024m -Xmx1024m -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=1044,suspend=n"
ENV STORM_WEBDAV_SERVER_ADDRESS=0.0.0.0
ENV STORM_WEBDAV_HOSTNAME_0=""
ENV STORM_WEBDAV_HTTPS_PORT=8443
ENV STORM_WEBDAV_HTTP_PORT=8085
ENV STORM_WEBDAV_CERTIFICATE_PATH=/etc/grid-security/storm-webdav/hostcert.pem
ENV STORM_WEBDAV_PRIVATE_KEY_PATH=/etc/grid-security/storm-webdav/hostkey.pem
ENV STORM_WEBDAV_TRUST_ANCHORS_DIR=/etc/grid-security/certificates
ENV STORM_WEBDAV_TRUST_ANCHORS_REFRESH_INTERVAL=86400
ENV STORM_WEBDAV_MAX_CONNECTIONS=300
ENV STORM_WEBDAV_MAX_QUEUE_SIZE=900
ENV STORM_WEBDAV_CONNECTOR_MAX_IDLE_TIME=120000
ENV STORM_WEBDAV_SA_CONFIG_DIR=/etc/storm/webdav/sa.d
ENV STORM_WEBDAV_JAR=/usr/share/java/storm-webdav/storm-webdav-server.jar
ENV STORM_WEBDAV_LOG=/var/log/storm/webdav/storm-webdav-server.log
ENV STORM_WEBDAV_OUT=/var/log/storm/webdav/storm-webdav-server.out
ENV STORM_WEBDAV_ERR=/var/log/storm/webdav/storm-webdav-server.err
ENV STORM_WEBDAV_LOG_CONFIGURATION=/etc/storm/webdav/logback.xml
ENV STORM_WEBDAV_ACCESS_LOG_CONFIGURATION=/etc/storm/webdav/logback-access.xml
ENV STORM_WEBDAV_VO_MAP_FILES_ENABLE=false
ENV STORM_WEBDAV_VO_MAP_FILES_CONFIG_DIR=/etc/storm/webdav/vo-mapfiles.d
ENV STORM_WEBDAV_VO_MAP_FILES_REFRESH_INTERVAL=21600
ENV STORM_WEBDAV_TPC_MAX_CONNECTIONS=50
ENV STORM_WEBDAV_TPC_VERIFY_CHECKSUM=false
ENV STORM_WEBDAV_AUTHZ_SERVER_ENABLE=false
ENV STORM_WEBDAV_REQUIRE_CLIENT_CERT=false

# put built java binary in default location
RUN mkdir -p /usr/share/java/storm-webdav/
RUN mv /opt/storm-webdav/target/storm-webdav-server.jar /usr/share/java/storm-webdav/
RUN chown storm:storm /usr/share/java/storm-webdav/storm-webdav-server.jar

# create directories for application and storage area configuration files
RUN mkdir -p /etc/storm/webdav
COPY --chown=storm:storm etc/storm-webdav/logback* /etc/storm/webdav/

# create directory for host certificate
RUN mkdir -p /etc/grid-security/storm-webdav/

# create logging directories
RUN mkdir -p /var/log/storm/webdav/ && chown -R storm:storm /var/log/storm/

# create workspace directory
RUN mkdir -p /var/lib/storm-webdav/work && chown -R storm:storm /var/lib/storm-webdav/

# change to the default directory (required otherwise it won't find the application.yml!)
WORKDIR /etc/storm/webdav
USER storm

# copy entrypoint and exec
COPY ./etc/docker/init.sh .
ENTRYPOINT ["/bin/bash", "init.sh"]
