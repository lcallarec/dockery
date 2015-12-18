# gnome-docker-manager

(very early stage of development)

## Compile instructions

Be sure these librairies are installed :

* valac (`apt-get install valac`, `apt-get install libgtk-3-dev`)
* libsoup-2.4
* gio-2.0
* gio-unix-2.0
* gee-0.8 (`apt-get install libgee-0.8`)
* json-glib-1.0 (`apt-get install libjson-glib-1.0.0 libjson-glib-dev`)

Just run :

```bash
valac -g --save-temps \
         --pkg gtk+-3.0 \
         --pkg libsoup-2.4 \
         --pkg gio-2.0 \
         --pkg gio-unix-2.0 \
         --pkg gee-0.8 \
         --pkg json-glib-1.0 \
         main.vala docker/*.vala view/*.vala \
         -o gdocker
```
