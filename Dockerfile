FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DOMOTICZ_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

# environment settings
ENV HOME="/config"

# copy prebuilds
COPY patches/ /

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	binutils \
	cmake \
	confuse-dev \
	doxygen \
	eudev-dev \
	g++ \
	gcc \
	git \
	gzip \
	libftdi1-dev \
	libressl-dev \
	make \
	musl-dev \
	pkgconf \
	tar && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	domoticz \
	eudev-libs \
	iputils \
	mosquitto-clients \
	openssh \
	openssl \
	openzwave \
	python3 \
	python3-dev && \
 echo "**** link libftdi libs ****" && \
 ln -s /usr/lib/libftdi1.so /usr/lib/libftdi.so && \
 ln -s /usr/lib/libftdi1.a /usr/lib/libftdi.a && \
 ln -s /usr/include/libftdi1/ftdi.h /usr/include/ftdi.h && \
 echo "**** build telldus-core ****" && \
 mkdir -p \
	/tmp/telldus-core && \
 tar xf /tmp/patches/telldus-core-2.1.2.tar.gz -C \
	/tmp/telldus-core --strip-components=1 && \
 curl -o /tmp/telldus-core/Doxyfile.in -L \
	https://raw.githubusercontent.com/telldus/telldus/master/telldus-core/Doxyfile.in && \
 cp /tmp/patches/Socket_unix.cpp /tmp/telldus-core/common/Socket_unix.cpp && \
 cp /tmp/patches/ConnectionListener_unix.cpp /tmp/telldus-core/service/ConnectionListener_unix.cpp && \
 cp /tmp/patches/CMakeLists.txt /tmp/telldus-core/CMakeLists.txt && \
 cd /tmp/telldus-core && \
 cmake -DBUILD_TDADMIN=false -DCMAKE_INSTALL_PREFIX=/tmp/telldus-core . && \
 make && \
 echo "**** configure telldus core ****" && \
 mv /tmp/telldus-core/client/libtelldus-core.so.2.1.2 /usr/lib/libtelldus-core.so.2.1.2 && \
 mv /tmp/telldus-core/client/telldus-core.h /usr/include/telldus-core.h && \
 ln -s /usr/lib/libtelldus-core.so.2.1.2 /usr/lib/libtelldus-core.so.2 && \
 ln -s /usr/lib/libtelldus-core.so.2 /usr/lib/libtelldus-core.so && \
 echo "**** install BroadlinkRM2 plugin dependencies ****" && \
 git clone https://github.com/mjg59/python-broadlink.git /tmp/python-broadlink && \
 cd /tmp/python-broadlink && \
 git checkout 8bc67af6 && \
 pip3 install . && \
 pip3 install pyaes && \
 apk add --no-cache \
	$RUNTIME_PACKAGES && \
 echo "**** add abc to dialout and cron group ****" && \
 usermod -a -G 16,20 abc && \
 echo " **** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/* \
	/usr/lib/libftdi* \
	/usr/include/ftdi.h

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8080 6144 1443
VOLUME /config
