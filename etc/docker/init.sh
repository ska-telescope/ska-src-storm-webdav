#!/bin/bash

env

# Start the StoRM service.
/usr/bin/java \
	${STORM_WEBDAV_JVM_OPTS} \
	-Djava.io.tmpdir=/var/lib/storm-webdav/work \
	-Dlogging.config=${STORM_WEBDAV_LOG_CONFIGURATION} \
	-jar ${STORM_WEBDAV_JAR} > >(tee -a ${STORM_WEBDAV_OUT}) 2> >(tee -a ${STORM_WEBDAV_ERR} >&2)

