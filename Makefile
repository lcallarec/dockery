SHELL := /bin/bash

gtk_version := $(shell pkg-config --modversion gtk+-3.0 | cut -d'.' -f1,2)

ifdef ($(TRAVIS))
	libvte_version=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-([0-9].[0-9][0-9])-dev.*/$1/g')
    json_glib_version=$(shell dpkg-query -l| grep 'libjson-glib-1.0-common' | awk '{print $3}' | sed 's/^\([0-9]\.[0-9]\).*/$1/g')
else
    libvte_version=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-\([0-9].[0-9][0-9]\)-dev.*$$/\1/g')
    json_glib_version=$(shell dpkg-query -l| grep 'libjson-glib-1.0-common' | awk '{print $$3}' | sed 's/^\([0-9]\.[0-9]\).*$$/\1/g')
endif

DESKTOP_DIR_PATH := $(shell if [ -d "/usr/local/share/applications" ]; then echo "/usr/local/share/applications"; else echo "/usr/share/applications"; fi)
DESKTOP_PATH :=$(DESKTOP_DIR_PATH)/dockery.desktop
ICONS_DIR_PATH := $(shell if [ -d "/usr/local/share/icons" ]; then echo "/usr/local/share/icons"; else echo "/usr/share/icons"; fi)

EXEC=compile

.PHONY: all preprocess compile compile-resources install install-desktop-entry debug

all: $(EXEC)

preprocess:
	mkdir -p build/source && build/pre-process.py src build/source $(gtk_version) $(libvte_version) $(json_glib_version)

compile: preprocess compile-resources
	valac -g --save-temps --thread \
        -X -w -X -lm -v \
        --target-glib 2.32 \
        --pkg gtk+-3.0 --pkg gio-2.0 --pkg libsoup-2.4 \
        --pkg gio-unix-2.0 --pkg gee-0.8 --pkg json-glib-1.0 --pkg vte-$(libvte_version) \
        build/source/*.vala resources.c --gresources gresource.xml \
        -o dockery

compile-resources:
	glib-compile-resources gresource.xml --target=resources.c --generate-source

install: install-desktop-entry
	cp -f dockery /usr/bin/dockery

install-desktop-entry:
	rm -rf $(DESKTOP_PATH)
	cp -f desktop/dockery.desktop $(DESKTOP_PATH)
	chmod 0644 $(DESKTOP_PATH)
	cp desktop/icons/dockeryx256.png $(ICONS_DIR_PATH)/hicolor/256x256/apps/dockery.png
	cp desktop/icons/dockery.svg $(ICONS_DIR_PATH)/hicolor/scalable/apps/dockery.png
	cp desktop/icons/dockeryx48.png $(ICONS_DIR_PATH)/hicolor/48x48/apps/dockery.png
	gtk-update-icon-cache $(ICONS_DIR_PATH)/hicolor

clean:
	rm -f dockery
	rm -rf build/source
	find . -type f -name '*.c' -delete

debug: clean compile

