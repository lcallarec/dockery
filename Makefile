SHELL=/bin/bash

gtk_version=$(shell pkg-config --modversion gtk+-3.0 | cut -d'.' -f1,2)

ifdef ($(TRAVIS))
	libvte_version=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-([0-9].[0-9][0-9])-dev.*/$1/g')
	json_glib_version=$(shell dpkg-query -l| grep 'libjson-glib-1.0-common' | awk '{print $3}' | sed 's/^\([0-9]\.[0-9]\).*/$1/g')
else
    	libvte_version=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-\([0-9].[0-9][0-9]\)-dev.*$$/\1/g')
    	json_glib_version=$(shell dpkg-query -l| grep 'libjson-glib-1.0-common' | awk '{print $$3}' | sed 's/^\([0-9]\.[0-9]\).*$$/\1/g')
endif

ifdef DEBUG
	DEBUG= -g
endif


PPSYMBOLS=

ifeq ($(libvte_version),2.91)
        PPSYMBOLS :=-D PPS_LIBVTE_2_91
endif
ifeq ($(libvte_version),2.90)
        PPSYMBOLS :=-D PPS_LIBVTE_2_91
endif

ifeq ($(json_glib_version), 1.2)
        PPSYMBOLS :=-D JSON_PRETTY_PRINT
endif

ifneq ($(TRAVIS), true)
        PPSYMBOLS :=-D NOT_ON_TRAVIS
endif

SOURCES=$(shell find src/ -name *.vala)
TSOURCES=$(shell find src/ -name *.vala |grep -v "main.vala" |grep -v "ApplicationListener.vala" |grep -v "MainContainer.vala" |grep -v "StackHubListener.vala")

DESKTOP_DIR_PATH := $(shell if [ -d "/usr/local/share/applications" ]; then echo "/usr/local/share/applications"; else echo "/usr/share/applications"; fi)
DESKTOP_PATH :=$(DESKTOP_DIR_PATH)/dockery.desktop
ICONS_DIR_PATH := $(shell if [ -d "/usr/local/share/icons" ]; then echo "/usr/local/share/icons"; else echo "/usr/share/icons"; fi)

EXEC=compile

.PHONY: all clean compile compile-resources install install-desktop-entry debug

all: $(EXEC)

compile: compile-resources
	valac $(PPSYMBOLS) $(DEBUG) --thread \
        -X -w -X -lm -v \
        --target-glib 2.32 \
        --pkg gtk+-3.0 --pkg gio-2.0 --pkg libsoup-2.4 \
        --pkg gio-unix-2.0 --pkg gee-0.8 --pkg json-glib-1.0 --pkg vte-$(libvte_version) \
        $(SOURCES) resources.c --gresources gresource.xml \
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
	@echo "Cleaning Dockery workspace..."
	rm -f dockery
	find . -type f -name '*.c' -delete
	find . -type f -name '*.o' -delete
	find . -type f -name '*.gcno' -delete
	find . -type f -name '*.gcda' -delete
	find . -type f -name '*.gcov' -delete

debug: clean compile

T_SOURCES:=$(shell find tests/ -name '*.vala')

test:
	@echo "Compiling... It can take a while."
	@valac $(PPSYMBOLS) --disable-warnings --thread -X -w -X -lm --target-glib 2.32 \
	--pkg gtk+-3.0 --pkg gio-2.0 --pkg libsoup-2.4 \
        --pkg gio-unix-2.0 --pkg gee-0.8 --pkg json-glib-1.0 --pkg vte-$(libvte_version) \
        $(TSOURCES) $(T_SOURCES) -o dockery-tests
	@echo "Executing tests suites :"
	@echo
	@./dockery-tests && rm ./dockery-tests

TCSOURCES=$(shell find src/ tests/ -name '*.c' |grep -v "main.c" |grep -v "ApplicationListener.c" |grep -v "MainContainer.c" |grep -v "StackHubListener.c")
TOBJECTS=$(TCSOURCES:.c=.o)

test-coverage: clean generate-ccode
	@echo "Compiling C files to object files..."
	$(foreach file,$(TCSOURCES),$(shell gcc -W -g -O0 -pthread -I/usr/include/libsoup-2.4 -I/usr/include/libxml2 -I/usr/include/gee-0.8 -I/usr/include/json-glib-1.0 -I/usr/include/vte-2.91 -I/usr/include/gtk-3.0 -I/usr/include/at-spi2-atk/2.0 -I/usr/include/at-spi-2.0 -I/usr/include/dbus-1.0 -I/usr/lib/x86_64-linux-gnu/dbus-1.0/include -I/usr/include/gtk-3.0 -I/usr/include/mirclient -I/usr/include/mircore -I/usr/include/mircookie -I/usr/include/cairo -I/usr/include/pango-1.0 -I/usr/include/harfbuzz -I/usr/include/pango-1.0 -I/usr/include/atk-1.0 -I/usr/include/cairo -I/usr/include/pixman-1 -I/usr/include/freetype2 -I/usr/include/libpng16 -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/libpng16 -I/usr/include/gio-unix-2.0/ -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -I/usr/include/p11-kit-1 -lsoup-2.4 -lgee-0.8 -ljson-glib-1.0 -lvte-2.91 -lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lz -lgnutls \
	-ftest-coverage -fprofile-arcs -c $(file) -o $(file:.c=.o)))
	
	@echo "Linking..."
	gcc -ftest-coverage -fprofile-arcs $(TOBJECTS) -W -g -O0 -o dockery-tests -lm -lsoup-2.4 -lgee-0.8 -ljson-glib-1.0 -lvte-2.91 -lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lz -lgnutls
	./dockery-tests

	@echo "Running GCOV..."
	for file in $(shell find src/ -name *.vala); do gcov $$file; done
	hash gcovr && gcovr -g -r . --exclude='^.*.c$$' --html --html-details -o coverage/codecoverage.html
	
generate-ccode :
	@echo "Transpiling vala files C files..."
	valac $(PPSYMBOLS) -q --debug --thread --target-glib 2.32 \
	--pkg gtk+-3.0 --pkg gio-2.0 --pkg libsoup-2.4 \
        --pkg gio-unix-2.0 --pkg gee-0.8 --pkg json-glib-1.0 --pkg vte-$(libvte_version) \
        $(TSOURCES) $(T_SOURCES) --ccode