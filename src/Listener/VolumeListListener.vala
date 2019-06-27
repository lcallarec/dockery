using View;
using Dockery;
namespace Dockery.Listener {
   
    class VolumeListListener : GLib.Object {

        public signal void container_states_changed();
        public signal void feedback(Gtk.MessageType type, string message);
        
        private Gtk.Window parent_window;
        private View.Volume.ListAll volume_list;
        private DockerSdk.Repository repository;

        public VolumeListListener(Gtk.Window parent_window, DockerSdk.Repository repository, View.Volume.ListAll volume_list) {
            this.parent_window = parent_window;
            this.repository = repository;
            this.volume_list = volume_list;
        }
        
        public void listen() {
        }
    }
}
