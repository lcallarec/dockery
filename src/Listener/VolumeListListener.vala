namespace Dockery.Listener {
    
    using global::View;
    using global::Dockery;
    
    class VolumeListListener : GLib.Object {

        public signal void container_states_changed();
        public signal void feedback(Gtk.MessageType type, string message);
        
        private Gtk.Window parent_window;
        private global::Dockery.View.ObjectList.Volumes volume_list;
        private global::Dockery.DockerSdk.Repository repository;

        public VolumeListListener(Gtk.Window parent_window, global::Dockery.DockerSdk.Repository repository, global::Dockery.View.ObjectList.Volumes volume_list) {
            this.parent_window = parent_window;
            this.repository = repository;
            this.volume_list = volume_list;
        }
        
        public void listen() {
        }
    }
}
