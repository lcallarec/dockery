namespace View {

    public class HeaderBar : Gtk.Box {
        
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

        /** Signal sent when a docker request is performed from headerbar */
        public signal void docker_daemon_lookup_request(string docker_path);
        
        public HeaderBar(string docker_host) {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

            this.entry_label = new Gtk.Label("Docker unix socket");

            this.entry = new Gtk.Entry();
            this.entry.text = docker_host;
            this.entry.width_chars = 30;
            this.entry.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-find-symbolic");
 
            this.docker_status_icon = new Gtk.Image.from_icon_name(HeaderBar.disconnected_icon_name, Gtk.IconSize.MENU);
            
            this.pack_start(entry_label, false, true, 3);
            this.pack_start(entry, false, true, 3);
            this.pack_end(docker_status_icon, false, true, 3);
            
            entry.icon_press.connect ((pos, event) => {
                if (pos == Gtk.EntryIconPosition.SECONDARY) {
                    this.docker_daemon_lookup_request(entry.text);
                }
            });

            entry.activate.connect (() => {
                this.docker_daemon_lookup_request(entry.text);
            });
        }
        
        /**
         * Change the docker icon according to status
         * true  : conencted
         * false : disconnected
         */ 
        public void connected_to_docker_daemon(bool status) {
            if (true == status) {
                this.docker_status_icon.icon_name = HeaderBar.connected_icon_name;
            } else {
                this.docker_status_icon.icon_name = HeaderBar.disconnected_icon_name;
            }
        }
    }
}
