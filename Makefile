EXEC=gnome-docker-file

all: $(EXEC)

gnome-docker-file:
	valac -g --save-temps \
		--pkg gtk+-3.0 --pkg libsoup-2.4 --pkg gio-2.0 \
		--pkg gio-unix-2.0 --pkg gee-0.8 --pkg json-glib-1.0 \
		src/main.vala src/*/*.vala \
		-o gdocker
		
install:
	cp gdocker /usr/local/bin
