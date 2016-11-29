FROM lsiobase/alpine
MAINTAINER saarg

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# Environment settings
ENV HOME="/config"

# copy prebuilds
COPY prebuilds/ /usr/

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
	build-dependencies && \


# add abc to dialout and cron group trying to fix different GID for dialout group
 usermod -a -G 16,20 abc && \

# cleanup /tmp
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8080 6144 1443
VOLUME /config
