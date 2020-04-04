.PHONY: run build test

run: build
	./build/src/dockery

build:
	meson build
	ninja -C build

build-wipe:
	meson --wipe build
	ninja -C build

test: build
	./build/tests/dockery-test

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