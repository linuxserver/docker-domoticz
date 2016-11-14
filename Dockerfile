FROM lsiobase/alpine
MAINTAINER saarg

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# Environment settings
ENV HOME="/config"

# copy local files
COPY root/ /

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	boost-dev \
	cmake \
	coreutils \
	curl-dev \
	eudev-dev \
	g++ \
	gcc \
	git \
	libcurl \
	libusb-compat-dev \
	libusb-dev \
	make \
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

# build domoticz
 git clone https://github.com/domoticz/domoticz.git /tmp/domoticz && \
 cd /tmp/domoticz && \
 cmake -USE_STATIC_OPENZWAVE -DCMAKE_BUILD_TYPE=Release . && \
 make && \
 make install && \

# cleanup build dependencies
 apk del --purge \
	build-dependencies && \

# install runtime dependencies
 apk add --no-cache \
	libcrypto1.0 \
	libcurl \
	libssl1.0 \
	libstdc++ \
	libusb \
	libusb-compat \
	zlib && \

# add abc to dialout and cron group trying to fix different GID for dialout group
 usermod -a -G 16 abc && \
 usermod -a -G 20 abc && \

# cleanup /tmp
 rm -rf \
	/tmp/*

# ports and volumes
EXPOSE 8080 6144 1443

VOLUME /config 