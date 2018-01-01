namespace Dockery.View.EventStream {
     /**
     * Display live stream event
     */
    public class LiveStreamComponent : Gtk.Box {

        private Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
        private Gtk.TextView view = new Gtk.TextView();

        construct {
            view.editable = true;
            view.set_wrap_mode(Gtk.WrapMode.WORD);
        }

        public LiveStreamComponent() {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

            this.pack_start(this.scrolled, true, true, 0);          
            this.scrolled.add(this.view);
        }
        
        public void append(string event) {
            Gtk.TextIter end_iter;
            view.get_buffer().get_end_iter(out end_iter);
            view.get_buffer().insert(ref end_iter, event, event.length);
        }
    }
}
