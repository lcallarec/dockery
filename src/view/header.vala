namespace View {

    public class HeaderBar : Gtk.HeaderBar, Signals.DockerHubImageRequestAction {

        /** Interact with Docker connection **/
        private Gtk.Button action_connect_button;

        /** Interact with Docker Hub **/
        private Gtk.Button action_hub_button;

        private Gtk.Button discover_connect_button;
        private Gtk.Button disconnect_button;

        /** Gtk entry where user can fill the docker connection info */
        private Gtk.Entry  entry;

        /** Placeholder to display messages inside connect panel popover*/
        private Gtk.InfoBar connect_panel_messagebar;

        /** Label to display messages inside connect_panel_messagebar */
        private Gtk.Label connect_panel_messagebar_label;

        /** Signal sent when a docker disconnection request is performed */
        public signal void docker_daemon_disconnect_request();

        /** Signal sent when a docker connection request is performed */
        public signal void docker_daemon_connect_request(string docker_path);

        /** Signal sent when a docker auto-connection request is performed */
        public signal void docker_daemon_autoconnect_request();

        public HeaderBar(Gtk.Window parent_window, string? title, string? subtitle) {

            this.action_connect_button = new Gtk.Button.with_label("connecting...");
            this.pack_end(action_connect_button);

            this.action_hub_button = new Gtk.Button.with_label("hub");
            this.action_hub_button.set_sensitive(false);
            this.pack_end(action_hub_button);

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

            this.action_hub_button.clicked.connect (() => {

                var dialog = new View.Docker.Dialog.SearchHubDialog(parent_window);
                dialog.search_image_in_docker_hub.connect((target, term) => {
                    this.search_image_in_docker_hub(dialog, term);
                });

                dialog.show_all();

            });

            create_connect_button();

            this.show_close_button = true;
            this.title = title;

            if (null != subtitle) {
                this.subtitle = subtitle;
            }
        }

        /**
         * Callback to invoke on connect event
         *
         * true  : connected
         * false : disconnected
         */
        public void on_docker_daemon_connect(string? docker_host, bool status, Notification.Message? message = null) {

            if (true == status) {

                this.entry.text = docker_host;
                this.action_connect_button.label = "connected";

                this.disconnect_button.label = "disconnect";
                this.disconnect_button.set_sensitive(true);

                this.discover_connect_button.set_sensitive(false);
                this.action_hub_button.set_sensitive(true);

            } else {

                this.action_connect_button.label = "not connected";

                this.disconnect_button.set_sensitive(false);
                this.disconnect_button.label = "not connected";

                this.discover_connect_button.set_sensitive(true);

                this.action_hub_button.set_sensitive(false);


                if (null != message) {
                    connect_panel_messagebar.set_message_type(message.message_type);
                    connect_panel_messagebar_label.label = message.message;
                    connect_panel_messagebar_label.show();
                    connect_panel_messagebar.show();
                }
            }
        }

        private void create_connect_button() {

            #if GTK_GTE_3_16
            Gtk.Popover connect_button_popover = new Gtk.Popover(action_connect_button);

            connect_button_popover.position = Gtk.PositionType.BOTTOM;

            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);

            this.action_connect_button.clicked.connect (() => {
                connect_button_popover.show_all();
            });

            var row1 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
            var row2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

            row1.pack_start(entry, false, true, 0);

            row1.pack_start(this.discover_connect_button, false, true, 0);
            row1.pack_start(this.disconnect_button, false, true, 0);

            connect_panel_messagebar = new Gtk.InfoBar();
            connect_panel_messagebar.set_no_show_all(true);
            connect_panel_messagebar.show_close_button = true;

            this.connect_panel_messagebar_label = new Gtk.Label(null);
            connect_panel_messagebar.get_content_area().add(connect_panel_messagebar_label);

            connect_panel_messagebar.response.connect((id) => {
                connect_panel_messagebar.hide();
            });

            row2.pack_start(this.connect_panel_messagebar, true, true, 5);

            box.pack_start(row1, true, true, 0);
            box.pack_start(row2, true, true, 0);

            connect_button_popover.add(box);

            #endif
        }
    }
}
