SHELL := /bin/bash

gtk_version := $(shell pkg-config --modversion gtk+-3.0 | cut -d'.' -f1,2)

EXEC=compile

all: $(EXEC)

preprocess:
	mkdir -p build/source && build/pre-process.py src build/source $(gtk_version)

compile:
	$(MAKE) preprocess
	glib-compile-resources gresource.xml --target=resources.c --generate-source
	valac -g --save-temps \
        -X -lm \
        --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg gio-2.0 \
        --pkg gio-unix-2.0 --pkg gee-0.8 --pkg json-glib-1.0 \
        build/source/*.vala resources.c --gresources gresource.xml \
        -o dockery

install:
	cp -f gdocker /usr/bin/dockery
	$(MAKE) clean
	$(MAKE) install-desktop-entry

install-desktop-entry:
	rm -rf /usr/local/share/applications/dockery.desktop
	cp -f desktop/docker-manager.desktop /usr/local/share/applications/dockery.desktop
	chmod 0777 /usr/local/share/applications/dockery.desktop
	cp desktop/icons/dockery.svg /usr/share/icons/hicolor/scalable/apps/dockery.png
	cp desktop/icons/dockeryx256.png /usr/share/icons/hicolor/256x256/apps/dockery.png
	cp desktop/icons/dockeryx48.png /usr/share/icons/hicolor/48x48/apps/dockery.png
	gtk-update-icon-cache /usr/share/icons/hicolor

clean:
	find . -type f -name '*.c' -delete && rm dockery
	rm -rf build/source

