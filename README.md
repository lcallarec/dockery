# gnome-docker-manager

[![Build Status](https://travis-ci.org/lcallarec/gnome-docker-manager.svg?branch=master)](https://travis-ci.org/lcallarec/gnome-docker-manager)

(very early stage of development)

## Compile and install instructions

Be sure these librairies are installed :

* valac (`apt-get install valac`, `apt-get install libgtk-3-dev`)
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

