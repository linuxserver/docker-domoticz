FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

# environment settings
ENV HOME="/config"

# copy prebuilds
COPY patches/ /

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	argp-standalone \
	autoconf \
	automake \
	binutils \
	boost-dev \
	cmake \
	confuse-dev \
	curl-dev \
	doxygen \
	eudev-dev \
	g++ \
	gcc \
	git \
	gzip \
	libcurl \
	libftdi1-dev \
	libffi-dev \
	libressl-dev \
	libusb-compat-dev \
	libusb-dev \
	linux-headers \
	lua5.2-dev \
	make \
	mosquitto-dev \
	musl-dev \
	pkgconf \
	sqlite-dev \
	tar \
	zlib-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	eudev-libs \
	libressl \
	python3-dev \
	py3-cffi \
	py3-gevent \
	py3-msgpack	&& \
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
 echo "**** build openzwave ****" && \
 git clone https://github.com/OpenZWave/open-zwave.git /tmp/open-zwave && \
 ln -s /tmp/open-zwave /tmp/open-zwave-read-only && \
 cd /tmp/open-zwave && \
 make && \
 make \
	instlibdir=usr/lib \
	pkgconfigdir="usr/lib/pkgconfig/" \
	PREFIX=/usr \
	sysconfdir=etc/openzwave \
 install && \
 echo "**** build domoticz ****" && \
 git clone https://github.com/domoticz/domoticz.git /tmp/domoticz && \
 cd /tmp/domoticz && \
 cmake \
	-DBUILD_SHARED_LIBS=True \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/var/lib/domoticz \
	-DOpenZWave=/usr/lib/libopenzwave.so \
	-DUSE_BUILTIN_LUA=OFF \
	-DUSE_BUILTIN_MQTT=OFF \
	-DUSE_BUILTIN_SQLITE=OFF \
	-DUSE_STATIC_LIBSTDCXX=OFF \
	-DUSE_STATIC_OPENZWAVE=OFF \
	-Wno-dev && \
 make && \
 make install && \
 echo "**** install python-miio dependencies ****" && \
 pip3 install python-miio && \
 echo "**** install BroadlinkRM2 plugin dependencies ****" && \
 git clone https://github.com/mjg59/python-broadlink.git /tmp/python-broadlink && \
 cd /tmp/python-broadlink && \
 git checkout 8bc67af6 && \
 pip3 install --no-cache-dir . && \
 pip3 install --no-cache-dir pyaes && \
 echo "**** determine runtime packages using scanelf ****" && \
 RUNTIME_PACKAGES="$( \
	scanelf --needed --nobanner /var/lib/domoticz/domoticz \
	| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
	| sort -u \
	| xargs -r apk info --installed \
	| sort -u \
	)" && \
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

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8080 6144 1443
VOLUME /config
