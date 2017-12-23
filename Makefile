SHELL := /bin/bash

gtk_version := $(shell pkg-config --modversion gtk+-3.0 | cut -d'.' -f1,2)

ifdef ($(TRAVIS))
	libvte_version=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-([0-9].[0-9][0-9])-dev.*/$1/g')
else
    libvte_version=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-\([0-9].[0-9][0-9]\)-dev.*$$/\1/g')
endif

EXEC=compile

.PHONY: all preprocess compile compile-resources install install-desktop-entry debug

all: $(EXEC)

preprocess:
	mkdir -p build/source && build/pre-process.py src build/source $(gtk_version) $(libvte_version)

compile: preprocess compile-resources
	dpkg-query -l|grep 'json-glib'
	valac -g --save-temps --thread \
        -X -w -X -lm -v \
        --target-glib 2.32 \
        --pkg gtk+-3.0 --pkg gio-2.0 --pkg libsoup-2.4 \
        --pkg gio-unix-2.0 --pkg gee-0.8 --pkg json-glib-1.0 --pkg vte-$(libvte_version) \
        build/source/*.vala resources.c --gresources gresource.xml \
        -o dockery

compile-resources:
	glib-compile-resources gresource.xml --target=resources.c --generate-source

install: clean install-desktop-entry
	cp -f dockery /usr/bin/dockery

install-desktop-entry:
	rm -rf /usr/local/share/applications/dockery.desktop
	cp -f desktop/dockery.desktop /usr/local/share/applications/dockery.desktop
	chmod 0644 /usr/local/share/applications/dockery.desktop
	cp desktop/icons/dockery.svg /usr/share/icons/hicolor/scalable/apps/dockery.png
	cp desktop/icons/dockeryx256.png /usr/share/icons/hicolor/256x256/apps/dockery.png
	cp desktop/icons/dockeryx48.png /usr/share/icons/hicolor/48x48/apps/dockery.png
	gtk-update-icon-cache /usr/share/icons/hicolor

clean:
	rm -f dockery
	rm -rf build/source
	find . -type f -name '*.c' -delete

debug: clean compile

