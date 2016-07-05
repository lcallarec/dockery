namespace View {

    public class HeaderBar : Gtk.HeaderBar {

        private Gtk.Button action_button;

        private Gtk.Button discover_connect_button;
        private Gtk.Button disconnect_button;

        private Gtk.Popover connect_button_popover;

        /** Gtk entry where user can fill the docker connection info */
        private Gtk.Entry  entry;

        /** Label related to previous entry*/
        private Gtk.Label  entry_label;

        /** Docker icon status */
        private Gtk.Image  docker_status_icon;

        /** Icon name to use when application is connected to docker daemon */
        private const string connected_icon_name    = "network-wireless-symbolic";

        /** Icon name to use when application is not connected to docker daemon */
        private const string disconnected_icon_name = "network-wireless-signal-none-symbolic";

        /** Signal sent when a docker disconnection request is performed */
        public signal void docker_daemon_disconnect_request();

        /** Signal sent when a docker connection request is performed */
        public signal void docker_daemon_connect_request(string docker_path);

        /** Signal sent when a docker auto-connection request is performed */
        public signal void docker_daemon_autoconnect_request();

        public HeaderBar(string? title, string? subtitle, string docker_host) {

            this.docker_status_icon = new Gtk.Image.from_icon_name(HeaderBar.disconnected_icon_name, Gtk.IconSize.MENU);

            this.action_button = new Gtk.Button.with_label("connecting...");
            this.disconnect_button = new Gtk.Button.with_label("please wait...");
            this.disconnect_button.set_sensitive(false);

            this.discover_connect_button = new Gtk.Button.with_label("auto-connect");
            this.discover_connect_button.set_sensitive(false);

            this.entry_label = new Gtk.Label("Docker unix socket");

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

                this.docker_status_icon.icon_name = HeaderBar.connected_icon_name;

                this.discover_connect_button.set_sensitive(false);
            } else {
                this.docker_status_icon.icon_name = HeaderBar.disconnected_icon_name;

                this.action_button.label = "not connected";

                this.disconnect_button.set_sensitive(false);

                this.discover_connect_button.set_sensitive(true);
            }
        }

        private void create_connect_button() {

            #if GTK_GTE_3_16
            this.connect_button_popover = new Gtk.Popover(action_button);
            this.connect_button_popover.position = Gtk.PositionType.BOTTOM;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);

            this.action_button.clicked.connect (() => {
                this.connect_button_popover.show_all();
            });

            box.pack_start(entry, false, true, 0);

            box.pack_start(this.discover_connect_button, false, true, 0);
            box.pack_start(this.disconnect_button, false, true, 0);

            this.connect_button_popover.add(box);

            this.pack_end(action_button);
            #endif
        }

    }
}
