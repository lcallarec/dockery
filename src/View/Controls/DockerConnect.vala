using Dockery.View;

namespace Dockery.View.Controls {

    class DockerConnect : Gtk.Box {

        public DockerConnect() {

            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
            this.set_border_width(3);

            var connect_actions = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            connect_actions.get_style_context().add_class("linked");

            var entry = create_entrypoint_entry();

            connect_actions.pack_start(create_disconnect_button());
            connect_actions.pack_start(entry);
            connect_actions.pack_start(create_connect_button(entry));
            connect_actions.pack_start(create_run_options_menu());

            this.pack_end(create_hub_button(), false, false, 5);
            this.pack_end(connect_actions, false, false, 0);
        }

        private Gtk.Button create_connect_button(Gtk.Entry entry) {
            var image = new Gtk.Image();
            image.set_from_icon_name("media-playback-start-symbolic", Gtk.IconSize.BUTTON);
            
            var connect_button = new Gtk.Button();
            connect_button.image = image;

            connect_button.clicked.connect(() => {
                SignalDispatcher.dispatcher().on_docker_daemon_connect_request(entry.text);
            });

            return connect_button;
        }

        private Gtk.Button create_disconnect_button() {
            var image = new Gtk.Image();
            image.set_from_icon_name("media-playback-stop-symbolic", Gtk.IconSize.BUTTON);
            
            var disconnect_button = new Gtk.Button();
            disconnect_button.image = image;
            disconnect_button.set_sensitive(false);
            disconnect_button.hide();         

            disconnect_button.clicked.connect(() => {
                SignalDispatcher.dispatcher().on_docker_daemon_disconnect_request();
            });

            SignalDispatcher.dispatcher().on_docker_daemon_connect_failure.connect((docker_entrypoint, e) => {
                disconnect_button.set_sensitive(false);
                disconnect_button.hide();
            });

            SignalDispatcher.dispatcher().on_docker_daemon_connect_success.connect((docker_entrypoint) => {
                disconnect_button.set_sensitive(true);
                disconnect_button.show();
            });

            SignalDispatcher.dispatcher().on_docker_daemon_disconnected.connect(() => {
                disconnect_button.set_sensitive(false);
                disconnect_button.hide();
            });

            return disconnect_button;
        }

        private HubButton create_hub_button() {
            var hub_button = new HubButton();
            hub_button.clicked.connect (() => {
                SignalDispatcher.dispatcher().on_docker_public_registry_open_request();
            });
            SignalDispatcher.dispatcher().on_docker_daemon_connect_success.connect((docker_entrypoint) => {
               hub_button.set_sensitive(true);
            });
            SignalDispatcher.dispatcher().on_docker_daemon_connect_failure.connect((docker_entrypoint, e) => {
                hub_button.set_sensitive(false);
            });
            SignalDispatcher.dispatcher().on_docker_daemon_disconnected.connect(() => {
                hub_button.set_sensitive(false);
            });

            return hub_button;
        }

        private Gtk.Entry create_entrypoint_entry() {
            var entry = new Gtk.Entry();
            entry.set_icon_from_icon_name(Gtk.EntryIconPosition.PRIMARY, "edit-find-symbolic");
            entry.width_chars = 30;

            //Uglish hack to avoid GTK init focus
            entry.can_focus = false;
            entry.enter_notify_event.connect(() => {
                entry.set_can_focus(true);
                return true;
            });

            entry.activate.connect(() => {
                SignalDispatcher.dispatcher().on_docker_daemon_connect_request(entry.text);
            });

            SignalDispatcher.dispatcher().on_docker_daemon_connect_success.connect((docker_entrypoint) => {
                entry.text = docker_entrypoint;
            });

            SignalDispatcher.dispatcher().on_docker_daemon_connect_failure.connect((docker_entrypoint, e) => {
                entry.text = docker_entrypoint;
            });

            return entry;
        }
           
        private Gtk.MenuButton create_run_options_menu() {
            var image = new Gtk.Image();
            image.set_from_icon_name("pan-down-symbolic", Gtk.IconSize.BUTTON);
            
            var open_menu_button = new Gtk.MenuButton();
            open_menu_button.get_style_context().add_class("no-padding");
            open_menu_button.image = image;

            var discover_button = new Gtk.ModelButton();
            discover_button.label = "Try to auto-connect";

            discover_button.clicked.connect(() => {
                SignalDispatcher.dispatcher().on_docker_daemon_discover_request();
            });

            var content = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
            content.margin = 10;
            content.pack_start(discover_button, false, false, 0);
            content.show_all();

            var popover = new Gtk.Popover(open_menu_button);
            popover.add(content);

            open_menu_button.popover = popover;

            return open_menu_button;
        }        
    }
} 
