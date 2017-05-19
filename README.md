# Dockery

[![Build Status](https://travis-ci.org/lcallarec/dockery.svg?branch=master)](https://travis-ci.org/lcallarec/dockery)

## Features

![Main SC](docs/resources/screenshots/main.png)

* Connect to a local docker deamon via Unix Socket (http support coming soon)
* Get container list and execute some basic actions
  - update status (KILL, PAUSE, STOP, START, RESTART)
  - rename
  - destroy
* Get image list and basic informations
* Search & download images from Docker Hub
* Connect ("bash-in") to a running container

Support GTK+3 from 3.10 (fallback) to 3.20 (latest version at the time of writing).

## Compile and install instructions

Be sure these dependencies are installed :

```bash
$ sudo apt-get install build-essential libgtk-3-dev valac libgee-0.8-dev libvte-dev libjson-glib-dev

$ make
$ sudo make install
```

## Execute

```
dockery
```
