SHELL=/bin/bash

PPSYMBOLS:=-D PPS_LIBVTE_2_91
PPSYMBOLS :=$(PPSYMBOLS) -D JSON_PRETTY_PRINT

LIBS:=gobject-2.0 gio-2.0 gio-unix-2.0 gtk+-3.0 libsoup-2.4 json-glib-1.0 gee-0.8 vte-2.91

VALALIBS:=$(foreach lib,$(LIBS), --pkg $(lib))
CLIBS:=$(shell pkg-config --cflags $(LIBS))
LDLIBS:=$(shell pkg-config --libs $(LIBS)) -lm

TARGET_GLIB_FLAG=--target-glib 2.32

.PHONY: install-desktop-entry clean generate-ccode test-coverage coverage-report flatpak-build

VALA_SOURCES:=$(shell find src/ -name *.vala |grep -v "main.vala")
VALA_TEST_SOURCES:=$(shell find tests/ -name '*.vala')
C_TEST_SOURCES=$(shell find src/ tests/ -name '*.c' |grep -v "main.c")
TOBJECTS=$(C_TEST_SOURCES:.c=.o)

coverage: clean generate-ccode
	@echo "Compiling C files to object files..."
	$(foreach file,$(C_TEST_SOURCES),$(shell gcc -w -g -O0 $(CLIBS) \
	-ftest-coverage -fprofile-arcs -c $(file) -o $(file:.c=.o)))
	
	@echo "Linking..."
	gcc -ftest-coverage -fprofile-arcs $(TOBJECTS) -w -g -O0 -o dockery-tests $(LDLIBS)
	xvfb-run ./dockery-tests

generate-ccode:
	@echo "Transpiling vala files C files..."
	@valac $(PPSYMBOLS) -q --ccode --debug --thread $(TARGET_GLIB_FLAG) $(VALALIBS) \
    $(VALA_SOURCES) $(VALA_TEST_SOURCES) 

coverage-report: coverage
	hash gcovr && gcovr -g -r . --exclude='^.*.c$$' --html --html-details -o coverage/codecoverage.html

flatpak-build:
	@flatpak-builder flatpak/build org.lcallarec.Dockery.json --force-clean

DESKTOP_DIR_PATH := $(shell if [ -d "/usr/local/share/applications" ]; then echo "/usr/local/share/applications"; else echo "/usr/share/applications"; fi)
DESKTOP_PATH :=$(DESKTOP_DIR_PATH)/dockery.desktop
ICONS_DIR_PATH := $(shell if [ -d "/usr/local/share/icons" ]; then echo "/usr/local/share/icons"; else echo "/usr/share/icons"; fi)

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
	@rm -f dockery
	@find . -type f -name '*.c' -delete
	@find . -type f -name '*.o' -delete
	@find . -type f -name '*.gcno' -delete
	@find . -type f -name '*.gcda' -delete
	@find . -type f -name '*.gcov' -delete	