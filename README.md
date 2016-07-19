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

Support GTK+3 from 3.10 (fallbacks) to 3.20(latest).

## Compile and install instructions

Be sure these librairies are installed :

* build-essential (`apt-get install build-essential`)
* Gtk3+ header files (`apt-get install libgtk-3-dev`)
* valac (`apt-get install libvala-0.22-dev valac-0.22 `)
* libsoup-2.4
* gio-2.0
* gio-unix-2.0
* gee-0.8 (`apt-get install libgee-0.8`)
* vte-2.90 (`apt-get install libvte-2.90-dev`)
* json-glib-1.0 (`apt-get install libjson-glib-1.0.0 libjson-glib-dev`)

```
make
sudo make install
```

## Execute
```
dockery
```
