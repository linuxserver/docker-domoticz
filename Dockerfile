FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DOMOTICZ_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"


RUN \
 echo "**** install runtime packages ****" && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
	curl \
	cron \
	libc6 \
	libcap2-bin \
	libcurl3-gnutls \
	libcurl4 \
	libpython3.8 \
	libudev-dev \
	libusb-0.1-4 \
	mosquitto-clients \
	python3-pip \
	python3-requests \
	unzip \
	wget \
	zlib1g && \
 echo "**** link to python lib so domoticz finds it ****" && \
 ln -s /usr/lib/x86_64-linux-gnu/libpython3.8.so.1.0 /usr/lib/x86_64-linux-gnu/libpython3.8.so && \
 echo "**** install domoticz ****" && \
 if [ -z ${DOMOTICZ_RELEASE+x} ]; then \
	DOMOTICZ_RELEASE=$(curl -sX GET "https://api.github.com/repos/domoticz/domoticz/releases/latest" \
        | awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p \
	/defaults \
	/tmp/domoticz \
	/usr/share/domoticz && \
 curl -o /tmp/domoticz.tgz -L \
		https://releases.domoticz.com/releases/release/domoticz_linux_x86_64.tgz && \
 tar xf /tmp/domoticz.tgz -C \
	/tmp/domoticz/ && \
 mv /tmp/domoticz/domoticz /usr/bin/ && \
 mv /tmp/domoticz/www /usr/share/domoticz/ && \
 mv /tmp/domoticz/Config /usr/share/domoticz/ && \
 mv /tmp/domoticz/scripts /defaults/ && \
 mv /tmp/domoticz/dzVents /usr/share/domoticz/ && \
 rm -rf /usr/share/domoticz/scripts/update_domoticz && \
 rm -rf /usr/share/domoticz/scripts/restart_domoticz && \
 rm -rf /usr/share/domoticz/scripts/download_update.sh && \
 echo "**** add abc to dialout group ****" && \
 usermod -a -G dialout abc && \
 echo " **** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files
COPY root/ /

# expose ports
EXPOSE 1443 6144 8080
