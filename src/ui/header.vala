namespace Ui {

    public class HeaderBar : Gtk.Box {
        
        private Gtk.Label  entry_label;        
        private Gtk.Entry  entry;
        
        public signal void docker_daemon_lookup_request(string docker_path);
        
        public HeaderBar(string docker_host) {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

            this.entry_label = new Gtk.Label("Docker unix socket");

            this.entry = new Gtk.Entry();
            this.entry.text = docker_host;
            this.entry.width_chars = 30;
            this.entry.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-find-symbolic");
            
            this.pack_start(entry_label, false, true, 3);
            this.pack_start(entry, false, true, 3);
            
            entry.icon_press.connect ((pos, event) => {
                if (pos == Gtk.EntryIconPosition.SECONDARY) {
                    this.docker_daemon_lookup_request(entry.text);
                }
            });

            entry.activate.connect (() => {
                this.docker_daemon_lookup_request(entry.text);
            });
        }
    }
}
