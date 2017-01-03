[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/domoticz
[![](https://images.microbadger.com/badges/version/linuxserver/domoticz.svg)](https://microbadger.com/images/linuxserver/domoticz "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/domoticz.svg)](http://microbadger.com/images/linuxserver/domoticz "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/domoticz.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/domoticz.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-domoticz)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-domoticz/)
[hub]: https://hub.docker.com/r/linuxserver/domoticz/

[Domoticz][domoticzurl] is a Home Automation System that lets you monitor and configure various devices like: Lights, Switches, various sensors/meters like Temperature, Rain, Wind, UV, Electra, Gas, Water and much more. Notifications/Alerts can be sent to any mobile device

[![domoticz](https://github.com/domoticz/domoticz/raw/master/www/images/logo.png)][domoticzurl]
[domoticzurl]: https://www.domoticz.com

## Usage

```
docker create \
  --name=domoticz \
  --net=bridge \
  -v <path to data>:/config \
  -e PGID=<gid> -e PUID=<uid>  \
  -e TZ=<timezone> \
  -p 8080:8080 \
  -p 1443:1443 \
  -p 6144:6144 \
  --device=<path to device> \
  linuxserver/domoticz
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`



* `-p 1234` - the port(s)
* `-v /config` - explain what lives here
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it domoticz /bin/bash`.

### Passing Through USB Devices

To get full use of Domoticz, you probably have a USB device you want to pass through. To figure out which device to pass through, you have to connect the device and look in dmesg for the device node created. Issue the command 'dmesg | tail' after you connected your device and you should see something like below.

```
usb 1-1.2: new full-speed USB device number 7 using ehci-pci
ftdi_sio 1-1.2:1.0: FTDI USB Serial Device converter detected
usb 1-1.2: Detected FT232RL
usb 1-1.2: FTDI USB Serial Device converter now attached to ttyUSB0
```

As you can see above, the device node created is ttyUSB0. It does not say where, but it's almost always in /dev/. The correct tag for passing through this USB device is '--device=/dev/ttyUSB0'

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

To configure Domoticz, go to the IP of your docker host on the port you configured (default 8080), and add your hardware in Setup > Hardware.
The user manual is available at [www.domoticz.com][domoticzurl]

## Info

* Shell access whilst the container is running: `docker exec -it domoticz /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f domoticz`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' domoticz`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/domoticz`

## Versions

+ **03.01.17:** Initial Release.
