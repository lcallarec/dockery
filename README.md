# Dockery

[![Build Status](https://travis-ci.org/lcallarec/dockery.svg?branch=master)](https://travis-ci.org/lcallarec/dockery)

**Dockery** is a _Docker_ GUI client written in *Vala*, targeted to be compiled on a GNU/Linux platform.

Until we move the build system from plain _Makefile_ to _autotools_, the basic Makefile target **ubuntu/debian** based distributions.

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
$ sudo apt-get install build-essential libgtk-3-dev valac libgee-0.8-dev libjson-glib-dev libsoup2.4-dev
```

Depending of your system, install libvte version 2.90 or 2.91, **Dockery** can be compiled against both of them :

```bash
$ sudo apt-get install libvte-2.90-dev
$ # OR
$ sudo apt-get install libvte-2.91-dev
$ # (the later, the better)
```

Compile and install :
```bash
$ make
$ sudo make install
```

## Execute

```
dockery
```

# Contribute

Feel free to contribute quicker and better than I can :p Any contributions are welcome, don't be shy !

# More features ?

Yes, likely from me. And what about _from_ **you** ? Feel free to contribute, everyone is welcome !
