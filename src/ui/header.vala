namespace Ui {

    public class HeaderBar : Gtk.Box {
        
        private Gtk.Entry  entry;
        private Gtk.Button search_button;
        
        public signal void docker_daemon_lookup_request(string docker_path);
        
        public HeaderBar(string docker_host) {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

            this.entry = new Gtk.Entry();
            this.entry.text = docker_host;
            this.entry.width_chars = 30;
            
            this.search_button = new Gtk.Button.from_icon_name("edit-find-symbolic", Gtk.IconSize.BUTTON);
            this.search_button.expand = false;

            this.pack_start(entry, false, true, 3);
            this.pack_start(search_button, false, true, 0);
            
            this.search_button.clicked.connect(() => {
                this.docker_daemon_lookup_request(entry.text);
            });
        }
    }
}
