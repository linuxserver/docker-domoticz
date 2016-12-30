FROM lsiobase/alpine
MAINTAINER saarg

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# Environment settings
ENV HOME="/config"

# copy prebuilds
COPY patches/ /

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	boost-dev \
	cmake \
	curl-dev \
	eudev-dev \
	g++ \
	gcc \
	git \
	libcurl \
	libusb-compat-dev \
	libusb-dev \
	linux-headers \
	lua5.2-dev \
	make \
	mosquitto-dev \
	openssl-dev \
	pkgconf \
	sqlite-dev \
	tar \
	zlib-dev && \

# install telldus-core build-dependencies
 apk add --no-cache --virtual=telldus-build-dependencies \
	argp-standalone \
	binutils \
	confuse-dev \
	curl \
	gzip && \

# install telldus-core build-dependencies from edge
 apk add --no-cache --virtual=telldus-build-dependencies-edge \
		--repository http://nl.alpinelinux.org/alpine/edge/community \
	doxygen \
	libftdi1-dev && \


# add runtime packages required in build stage
 apk add --no-cache \
	python3-dev && \

# link libftdi as the alpine guys named the libs wrong
 ln -s /usr/lib/libftdi1.so /usr/lib/libftdi.so && \
 ln -s /usr/lib/libftdi1.a /usr/lib/libftdi.a && \
 ln -s /usr/include/libftdi1/ftdi.h /usr/include/ftdi.h && \

# build telldus-core
 mkdir -p \
	/tmp/telldus-core && \
 curl -o /tmp/telldus-core.tar.gz -L \
		http://download.telldus.se/TellStick/Software/telldus-core/telldus-core-2.1.2.tar.gz && \
 tar xf /tmp/telldus-core.tar.gz -C \
	/tmp/telldus-core --strip-components=1 && \
 curl -o /tmp/telldus-core/Doxyfile.in -L \
		https://raw.githubusercontent.com/telldus/telldus/master/telldus-core/Doxyfile.in && \
 cp /tmp/patches/Socket_unix.cpp /tmp/telldus-core/common/Socket_unix.cpp && \
 cp /tmp/patches/ConnectionListener_unix.cpp /tmp/telldus-core/service/ConnectionListener_unix.cpp && \
 cd /tmp/telldus-core && \
 cmake -DBUILD_TDADMIN=false -DCMAKE_INSTALL_PREFIX=/tmp/telldus-core . && \
 make && \

# move needed telldus core files and link them
 mv /tmp/telldus-core/client/libtelldus-core.so.2.1.2 /usr/lib/libtelldus-core.so.2.1.2 && \
 mv /tmp/telldus-core/client/telldus-core.h /usr/include/telldus-core.h && \
 ln -s /usr/lib/libtelldus-core.so.2.1.2 /usr/lib/libtelldus-core.so.2 && \
 ln -s /usr/lib/libtelldus-core.so.2 /usr/lib/libtelldus-core.so && \

# build OpenZWave
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

# build domoticz
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
	-DUSE_STATIC_OPENZWAVE=OFF && \
 make && \
 make install && \

# determine runtime packages
 RUNTIME_PACKAGES="$( \
	scanelf --needed --nobanner /var/lib/domoticz/domoticz \
	| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
	| sort -u \
	| xargs -r apk info --installed \
	| sort -u \
	)" && \

# install runtime dependencies
 apk add --no-cache \
	eudev-libs \
	openssl \
	$RUNTIME_PACKAGES && \

# cleanup build dependencies
 apk del --purge \
	build-dependencies \
	telldus-build-dependencies \
	telldus-build-dependencies-edge && \


# add abc to dialout and cron group trying to fix different GID for dialout group
 usermod -a -G 16,20 abc && \

# cleanup /tmp
 rm -rf \
	/tmp/* \
	/usr/lib/libftdi* \
	/usr/include/ftdi.h

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8080 6144 1443
VOLUME /config
