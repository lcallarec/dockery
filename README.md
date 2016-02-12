# Docker-Manager

[![Build Status](https://travis-ci.org/lcallarec/gnome-docker-manager.svg?branch=master)](https://travis-ci.org/lcallarec/gnome-docker-manager)

## Features

![Main SC](docs/resources/screenshots/main.png)

* Connect to a local docker deamon via socket (http support coming soon)
* Get container list and execute some basic actions
  - update status (KILL, PAUSE, STOP, START)
  - rename
  - destroy
* Get image list and basic informations

Support GTK+3 from 3.10 (fallbacks) to 3.18 (latest).

## Compile and install instructions

Be sure these librairies are installed :

* valac (`apt-get install libvala-0.22-dev valac-0.22 `, `apt-get install libgtk-3-dev`)
* libsoup-2.4
* gio-2.0
* gio-unix-2.0
* gee-0.8 (`apt-get install libgee-0.8`)
* json-glib-1.0 (`apt-get install libjson-glib-1.0.0 libjson-glib-dev`)

```
make
sudo make install
```

## Execute
```
gdocker
```

