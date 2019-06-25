using Dockery;
using Dockery.View;

namespace Dockery.Listener {
    
    class AppWindowListener : GLib.Object {

        private Gtk.Window window;

        public AppWindowListener(Gtk.Window window) {
            this.window = window;
        }
        
        public void listen() {
            SignalDispatcher.dispatcher().on_about_dialog.connect(() => {
                var dialog = new AboutDialog(this.window);
                dialog.present();
            });
        }
    }
}
