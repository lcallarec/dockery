namespace View {

    public class HeaderBar : Gtk.HeaderBar {

        private Gtk.Button action_button;

        private Gtk.Button discover_connect_button;
        private Gtk.Button disconnect_button;

        /** Gtk entry where user can fill the docker connection info */
        private Gtk.Entry  entry;

        /** Signal sent when a docker disconnection request is performed */
        public signal void docker_daemon_disconnect_request();

        /** Signal sent when a docker connection request is performed */
        public signal void docker_daemon_connect_request(string docker_path);

        /** Signal sent when a docker auto-connection request is performed */
        public signal void docker_daemon_autoconnect_request();

        public HeaderBar(string? title, string? subtitle) {

            this.action_button = new Gtk.Button.with_label("connecting...");
            this.disconnect_button = new Gtk.Button.with_label("please wait...");
            this.disconnect_button.set_sensitive(false);

            this.discover_connect_button = new Gtk.Button.with_label("auto-connect");
            this.discover_connect_button.set_sensitive(false);

            this.entry = new Gtk.Entry();
            this.entry.width_chars = 30;
            this.entry.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-find-symbolic");

            entry.icon_press.connect ((pos, event) => {
                if (pos == Gtk.EntryIconPosition.SECONDARY) {
                    this.docker_daemon_connect_request(entry.text);
                }
            });

            entry.activate.connect (() => {
                this.docker_daemon_connect_request(entry.text);
            });

            this.disconnect_button.clicked.connect (() => {
                this.docker_daemon_disconnect_request();
            });

            this.discover_connect_button.clicked.connect(() => {
                this.docker_daemon_autoconnect_request();
            });

            create_connect_button();

            this.show_close_button = true;
            this.title = title;

            if (null != subtitle) {
                this.subtitle = subtitle;
            }

        }

        /**
         * Notify a connect event
         *
         * true  : connected
         * false : disconnected
         */
        public void on_docker_daemon_connect(string? docker_host, bool status) {

            if (true == status) {

                this.entry.text = docker_host;
                this.action_button.label = "connected";

                this.disconnect_button.label = "disconnect";
                this.disconnect_button.set_sensitive(true);

                this.discover_connect_button.set_sensitive(false);

            } else {

                this.action_button.label = "not connected";

                this.disconnect_button.set_sensitive(false);

                this.discover_connect_button.set_sensitive(true);
            }
        }

        private void create_connect_button() {

            #if GTK_GTE_3_16
            Gtk.Popover connect_button_popover = new Gtk.Popover(action_button);

            connect_button_popover.position = Gtk.PositionType.BOTTOM;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);

            this.action_button.clicked.connect (() => {
                connect_button_popover.show_all();
            });

            box.pack_start(entry, false, true, 0);

            box.pack_start(this.discover_connect_button, false, true, 0);
            box.pack_start(this.disconnect_button, false, true, 0);

            connect_button_popover.add(box);

            this.pack_end(action_button);
            #endif
        }

    }
}
