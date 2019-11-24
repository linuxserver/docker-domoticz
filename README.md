[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

[![Blog](https://img.shields.io/static/v1.svg?style=flat-square&color=E68523&label=linuxserver.io&message=Blog)](https://blog.linuxserver.io "all the things you can do with our containers including How-To guides, opinions and much more!")
[![Discord](https://img.shields.io/discord/354974912613449730.svg?style=flat-square&color=E68523&label=Discord&logo=discord&logoColor=FFFFFF)](https://discord.gg/YWrKVTn "realtime support / chat with the community and the team.")
[![Discourse](https://img.shields.io/discourse/https/discourse.linuxserver.io/topics.svg?style=flat-square&color=E68523&logo=discourse&logoColor=FFFFFF)](https://discourse.linuxserver.io "post on our community forum.")
[![Fleet](https://img.shields.io/static/v1.svg?style=flat-square&color=E68523&label=linuxserver.io&message=Fleet)](https://fleet.linuxserver.io "an online web interface which displays all of our maintained images.")
[![Podcast](https://img.shields.io/static/v1.svg?style=flat-square&color=E68523&label=linuxserver.io&message=Podcast)](https://anchor.fm/linuxserverio "on hiatus. Coming back soon (late 2018).")
[![Open Collective](https://img.shields.io/opencollective/all/linuxserver.svg?style=flat-square&color=E68523&label=Open%20Collective%20Supporters)](https://opencollective.com/linuxserver "please consider helping us by either donating or contributing to our budget")

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [Discourse](https://discourse.linuxserver.io) - post on our community forum.
* [Fleet](https://fleet.linuxserver.io) - an online web interface which displays all of our maintained images.
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).
* [Open Collective](https://opencollective.com/linuxserver) - please consider helping us by either donating or contributing to our budget

# [linuxserver/domoticz](https://github.com/linuxserver/docker-domoticz)
[![GitHub Release](https://img.shields.io/github/release/linuxserver/docker-domoticz.svg?style=flat-square&color=E68523)](https://github.com/linuxserver/docker-domoticz/releases)
[![MicroBadger Layers](https://img.shields.io/microbadger/layers/linuxserver/domoticz.svg?style=flat-square&color=E68523)](https://microbadger.com/images/linuxserver/domoticz "Get your own version badge on microbadger.com")
[![MicroBadger Size](https://img.shields.io/microbadger/image-size/linuxserver/domoticz.svg?style=flat-square&color=E68523)](https://microbadger.com/images/linuxserver/domoticz "Get your own version badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/domoticz.svg?style=flat-square&color=E68523)](https://hub.docker.com/r/linuxserver/domoticz)
[![Docker Stars](https://img.shields.io/docker/stars/linuxserver/domoticz.svg?style=flat-square&color=E68523)](https://hub.docker.com/r/linuxserver/domoticz)
[![Build Status](https://ci.linuxserver.io/view/all/job/Docker-Pipeline-Builders/job/docker-domoticz/job/master/badge/icon?style=flat-square)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-domoticz/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/domoticz/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/domoticz/latest/index.html)

[Domoticz](https://www.domoticz.com) is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device.

[![domoticz](https://github.com/domoticz/domoticz/raw/master/www/images/logo.png)](https://www.domoticz.com)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/).

Simply pulling `linuxserver/domoticz` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |

## Version Tags

This image provides various versions that are available via tags. `latest` tag usually provides the latest stable version. Others are considered under development and caution must be exercised when using them.

| Tag | Description |
| :----: | --- |
| latest | Current latest head from development at https://github.com/domoticz/domoticz. |
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
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e WEBROOT=domoticz `#optional` \
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
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - WEBROOT=domoticz #optional
    volumes:
      - <path to data>:/config
    ports:
      - 8080:8080
      - 6144:6144
      - 1443:1443
    devices:
      - <path to device>:<path to device>
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8080` | WebUI |
| `-p 6144` | Domoticz communication port. |
| `-p 1443` | Domoticz communication port. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e WEBROOT=domoticz` | Sets webroot to domoticz for usage with subfolder reverse proxy. Not needed unless reverse proxying. |
| `-v /config` | Where Domoticz stores config files and data. |
| `--device <path to device>` | For passing through USB devices. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
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
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull domoticz`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d domoticz`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once domoticz
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/linuxserver/docker-domoticz.git
cd docker-domoticz
docker build \
  --no-cache \
  --pull \
  -t linuxserver/domoticz:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **24.11.19:** - Change to using domoticz builtin Lua and MQTT.
* **03.11.19:** - 2nd try setting capabilities for Domoticz binary.
* **29.10.19:** - Set capabilities for Domoticz binary so spawned processes can use sockets.
* **28.06.19:** - Rebasing to alpine 3.10. Add iputils for ping. Fix typo in readme. Fix permissions for custom icons.
* **30.03.19:** - Add env variable to set webroot.
* **23.03.19:** - Switching to new Base images, shift to arm32v7 tag.
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
