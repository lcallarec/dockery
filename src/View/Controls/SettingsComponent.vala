namespace Dockery.View.Controls {

    class SettingsComponent : Gtk.Box, Signals.DockerServiceAware, Signals.DockerHubImageRequestAction {

        private Gtk.Button connect_button = new Gtk.Button();
        private Gtk.Image connect_button_image = new Gtk.Image();
        private bool is_connected = false;
        private Gtk.Button discover_button = new Gtk.Button.with_label("discover");
        private Gtk.Entry docker_entrypoint_entry = new Gtk.Entry();
        private Gtk.Button hub_open_button = new HubButton();

        construct {

            this.connect_button.image = connect_button_image;
            this.connect_button_image.set_from_icon_name("media-playback-start-symbolic", Gtk.IconSize.BUTTON);

            //Uglish hack to avoid GTK initi focus
            this.docker_entrypoint_entry.can_focus = false;
            this.docker_entrypoint_entry.enter_notify_event .connect(() => {
                this.docker_entrypoint_entry.set_can_focus(true);
            });
        }

        public SettingsComponent() {

            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
            this.set_border_width(3);

            this.pack_start(new Gtk.Label("Local Docker stack settings"), false, false, 5);
            
            Gtk.SizeGroup sizegroup = new Gtk.SizeGroup(Gtk.SizeGroupMode.VERTICAL);
            sizegroup.add_widget(connect_button);
            sizegroup.add_widget(discover_button);
            sizegroup.add_widget(hub_open_button);

            this.docker_entrypoint_entry.set_icon_from_icon_name(Gtk.EntryIconPosition.PRIMARY, "edit-find-symbolic");
            this.docker_entrypoint_entry.width_chars = 30;

            var entry_and_button = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            entry_and_button.get_style_context().add_class("linked");

            entry_and_button.pack_start(this.docker_entrypoint_entry);
            entry_and_button.pack_start(this.connect_button);

            this.pack_end(this.hub_open_button, false, false, 5);
            this.pack_end(this.discover_button, false, false, 5);
            this.pack_end(entry_and_button, false, false, 0);
        }

        public void connect_docker_daemon_signals(Signals.DockerServiceAware parent) {
            
            this.connect_button.clicked.connect(() => {
                if (this.is_connected == false) {
                    parent.on_docker_daemon_connect_request(docker_entrypoint_entry.text);
                       
                } else {
                    this.on_docker_daemon_disconnect_request();
                }
            });

            this.on_docker_daemon_disconnect_request.connect(() => {
                parent.on_docker_daemon_disconnect_request();
            });
            
            this.discover_button.clicked.connect(() => {
                parent.on_docker_daemon_discover_request();
            });

            parent.on_docker_daemon_connect_success.connect((docker_entrypoint) => {

                this.connect_button_image.set_from_icon_name("media-playback-stop-symbolic", Gtk.IconSize.BUTTON);
                this.is_connected = true;

                this.hub_open_button.set_sensitive(true);
                this.docker_entrypoint_entry.text = docker_entrypoint;
            });

            parent.on_docker_daemon_connect_failure.connect((docker_entrypoint) => {

                this.connect_button_image.set_from_icon_name("media-playback-start-symbolic", Gtk.IconSize.BUTTON);
                this.is_connected = false;

                this.hub_open_button.set_sensitive(false);
                this.docker_entrypoint_entry.text = docker_entrypoint;
            });

            parent.on_docker_daemon_disconnected.connect(() => {

                this.connect_button_image.set_from_icon_name("media-playback-start-symbolic", Gtk.IconSize.BUTTON);
                this.is_connected = false;

                this.hub_open_button.set_sensitive(false);
            });
        }
        
        public void connect_docker_hub_signals(Signals.DockerHubImageRequestAction parent) {
            this.hub_open_button.clicked.connect (() => {
                parent.on_docker_public_registry_open_request();
            });

        }
    }
} 
