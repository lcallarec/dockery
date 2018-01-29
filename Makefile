SHELL=/bin/bash

GTK_VERSION:=$(shell pkg-config --modversion gtk+-3.0 | cut -d'.' -f1,2)

ifdef ($(TRAVIS))
	LIBVTE_VERSION:=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-([0-9].[0-9][0-9])-dev.*/$1/g')
	JSON_GLIB_VERSION:=$(shell dpkg-query -l| grep 'libjson-glib-1.0-common' | awk '{print $3}' | sed 's/^\([0-9]\.[0-9]\).*/$1/g')
else
    	LIBVTE_VERSION:=$(shell dpkg-query -l|grep 'libvte-2.9[0-9]-dev' | sed 's/^.*libvte-\([0-9].[0-9][0-9]\)-dev.*$$/\1/g')
    	JSON_GLIB_VERSION:=$(shell dpkg-query -l| grep 'libjson-glib-1.0-common' | awk '{print $$3}' | sed 's/^\([0-9]\.[0-9]\).*$$/\1/g')
endif

ifdef DEBUG
	DEBUG= -g
endif

PPSYMBOLS=

ifeq ($(LIBVTE_VERSION),2.91)
        PPSYMBOLS :=-D PPS_LIBVTE_2_91
endif
ifeq ($(LIBVTE_VERSION),2.90)
        PPSYMBOLS :=-D PPS_LIBVTE_2_90
endif

ifeq ($(JSON_GLIB_VERSION), 1.2)
        PPSYMBOLS :=-D JSON_PRETTY_PRINT
endif

ifneq ($(TRAVIS), true)
        PPSYMBOLS :=-D NOT_ON_TRAVIS
endif

LIBVTE:=vte-$(LIBVTE_VERSION)
LIBS:=gobject-2.0 gio-2.0 gio-unix-2.0 gtk+-3.0 libsoup-2.4 json-glib-1.0 gee-0.8 $(LIBVTE)
VALALIBS:=$(foreach lib,$(LIBS), --pkg $(lib))
CLIBS:=$(shell pkg-config --cflags $(LIBS))
LDLIBS:=$(shell pkg-config --libs $(LIBS)) -lm

TARGET_GLIB_FLAG=--target-glib 2.32

SOURCES:=$(shell find src/ -name *.vala)
TSOURCES:=$(shell find src/ -name *.vala |grep -v "main.vala" |grep -v "ApplicationListener.vala" |grep -v "MainContainer.vala" |grep -v "StackHubListener.vala")

DESKTOP_DIR_PATH := $(shell if [ -d "/usr/local/share/applications" ]; then echo "/usr/local/share/applications"; else echo "/usr/share/applications"; fi)
DESKTOP_PATH :=$(DESKTOP_DIR_PATH)/dockery.desktop
ICONS_DIR_PATH := $(shell if [ -d "/usr/local/share/icons" ]; then echo "/usr/local/share/icons"; else echo "/usr/share/icons"; fi)

EXEC=compile

.PHONY: all clean compile compile-resources install install-desktop-entry debug

all: $(EXEC)

compile: compile-resources
	valac $(PPSYMBOLS) $(DEBUG) --thread -X -w -X -lm -v \
        $(TARGET_GLIB_FLAG) $(VALALIBS) \
        $(SOURCES) resources.c --gresources gresource.xml \
        -o dockery

compile-resources:
	glib-compile-resources gresource.xml --target=resources.c --generate-source

install: install-desktop-entry
	cp -f dockery /usr/bin/dockery

install-desktop-entry:
	rm -rf $(DESKTOP_PATH)$(LIBVTE)
	cp -f desktop/dockery.desktop $(DESKTOP_PATH)
	chmod 0644 $(DESKTOP_PATH)
	cp desktop/icons/dockeryx256.png $(ICONS_DIR_PATH)/hicolor/256x256/apps/dockery.png
	cp desktop/icons/dockery.svg $(ICONS_DIR_PATH)/hicolor/scalable/apps/dockery.png
	cp desktop/icons/dockeryx48.png $(ICONS_DIR_PATH)/hicolor/48x48/apps/dockery.png
	gtk-update-icon-cache $(ICONS_DIR_PATH)/hicolor

clean:
	@echo "Cleaning Dockery workspace..."
	@rm -f dockery
	@find . -type f -name '*.c' -delete
	@find . -type f -name '*.o' -delete
	@find . -type f -name '*.gcno' -delete
	@find . -type f -name '*.gcda' -delete
	@find . -type f -name '*.gcov' -delete

debug: clean compile

T_SOURCES:=$(shell find tests/ -name '*.vala')

test:
	@echo "Compiling... It can take a while."
	@valac $(PPSYMBOLS) --disable-warnings -q --thread -X -w -X -lm $(TARGET_GLIB_FLAG) $(VALALIBS) \
        $(TSOURCES) $(T_SOURCES) -o dockery-tests
	@echo "Executing tests suites :"
	@echo
	@./dockery-tests && rm ./dockery-tests

TCSOURCES=$(shell find src/ tests/ -name '*.c' |grep -v "main.c" |grep -v "ApplicationListener.c" |grep -v "MainContainer.c" |grep -v "StackHubListener.c")
TOBJECTS=$(TCSOURCES:.c=.o)

test-coverage: clean generate-ccode
	@echo "Compiling C files to object files..."
	$(foreach file,$(TCSOURCES),$(shell gcc -w -g -O0 $(CLIBS) \
	-ftest-coverage -fprofile-arcs -c $(file) -o $(file:.c=.o)))
	
	@echo "Linking..."
	gcc -ftest-coverage -fprofile-arcs $(TOBJECTS) -w -g -O0 -o dockery-tests $(LDLIBS)
	./dockery-tests

	@echo "Running GCOV..."
	for file in $(shell find src/ -name *.vala); do gcov $$file; done
	hash gcovr && gcovr -g -r . --exclude='^.*.c$$' --html --html-details -o coverage/codecoverage.html
	
generate-ccode :
	echo $(VALA_PKG)
	@echo "Transpiling vala files C files..."
	@valac $(PPSYMBOLS) -q --ccode --debug --thread $(TARGET_GLIB_FLAG) $(VALALIBS) \
        $(TSOURCES) $(T_SOURCES) 