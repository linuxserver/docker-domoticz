[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# PSA: Changes are happening

From August 2018 onwards, Linuxserver are in the midst of switching to a new CI platform which will enable us to build and release multiple architectures under a single repo. To this end, existing images for `arm64` and `armhf` builds are being deprecated. They are replaced by a manifest file in each container which automatically pulls the correct image for your architecture. You'll also be able to pull based on a specific architecture tag.

TLDR: Multi-arch support is changing from multiple repos to one repo per container image.

# [linuxserver/domoticz](https://github.com/linuxserver/docker-domoticz)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/domoticz.svg)](https://microbadger.com/images/linuxserver/domoticz "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/domoticz.svg)](https://microbadger.com/images/linuxserver/domoticz "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/domoticz.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/domoticz.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-domoticz/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-domoticz/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/domoticz/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/domoticz/latest/index.html)

[Domoticz](https://www.domoticz.com) is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.

[![domoticz](https://github.com/domoticz/domoticz/raw/master/www/images/logo.png)](https://www.domoticz.com)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list). 

Simply pulling `linuxserver/domoticz` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |

## Version Tags

This image provides various versions that are available via tags. `latest` tag usually provides the latest stable version. Others are considered under development and caution must be exercised when using them.

| Tag | Description |
| :----: | --- |
| latest | Current latest head from master at https://github.com/domoticz/domoticz. |
| stable | Latest stable version. |
| stable-4.9700 | Old stable version. Will not be updated anymore! |
| stable-3.815 | Old stable version. Will not be updated anymore! |
| stable-3.5877 | Old stable version. Will not be updated anymore! |

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=domoticz \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Europe/London \
  -p 8080:8080 \
  -p 6144:6144 \
  -p 1443:1443 \
  -v <path to data>:/config \
  --device <path to device>:<path to device> \
  --restart unless-stopped \
  linuxserver/domoticz
```

### Passing Through USB Devices

To get full use of Domoticz, you probably have a USB device you want to pass through. To figure out which device to pass through, you have to connect the device and look in dmesg for the device node created. Issue the command 'dmesg | tail' after you connected your device and you should see something like below.

```
usb 1-1.2: new full-speed USB device number 7 using ehci-pci
ftdi_sio 1-1.2:1.0: FTDI USB Serial Device converter detected
usb 1-1.2: Detected FT232RL
usb 1-1.2: FTDI USB Serial Device converter now attached to ttyUSB0
```
As you can see above, the device node created is ttyUSB0. It does not say where, but it's almost always in /dev/. The correct tag for passing through this USB device is '--device /dev/ttyUSB0:/dev/ttyUSB0'


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  domoticz:
    image: linuxserver/domoticz
    container_name: domoticz
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/London
    volumes:
      - <path to data>:/config
    ports:
      - 8080:8080
      - 6144:6144
      - 1443:1443
    devices:
      - <path to device>:<path to device>
    mem_limit: 4096m
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8080` | WebUI |
| `-p 6144` | Domoticz communication port. |
| `-p 1443` | Domoticz communication port. |
| `-e PUID=1001` | for UserID - see below for explanation |
| `-e PGID=1001` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /config` | Where Domoticz stores config files and data. |
| `--device <path to device>` | For passing through USB devices. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```


&nbsp;
## Application Setup

To configure Domoticz, go to the IP of your docker host on the port you configured (default 8080), and add your hardware in Setup > Hardware.
The user manual is available at [www.domoticz.com](https://www.domoticz.com)



## Support Info

* Shell access whilst the container is running: `docker exec -it domoticz /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f domoticz`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' domoticz`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/domoticz`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/domoticz`
* Stop the running container: `docker stop domoticz`
* Delete the container: `docker rm domoticz`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start domoticz`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update the image: `docker-compose pull linuxserver/domoticz`
* Let compose update containers as necessary: `docker-compose up -d`
* You can also remove the old dangling images: `docker image prune`

## Versions

* **19.02.19:** - Fix branch for version logic.
* **11.02.19:** - Add pipeline logic and multi arch.
* **02.07.18:** - Add openssh package.
* **01.07.18:** - Fix backup/restore in webgui.
* **03.04.18:** - Add dependencies for BroadlinkRM2 plugin.
* **20.01.18:** - Move telldus core to repo to prevent build fail when source site goes down.
* **18.01.18:** - Remove logging to syslog in the run command to prevent double logging.
* **04.01.18:** - Deprecate cpu_core routine lack of scaling.
* **08.12.17:** - Rebase to alpine 3.7.
* **26.11.17:** - Use cpu core counting routine to speed up build time.
* **28.05.17:** - Rebase to alpine 3.6.
* **26.02.17:** - Add curl and replace openssl with libressl.
* **11.02.17:** - Update README.
* **03.01.17:** - Initial Release.
