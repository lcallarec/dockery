namespace Dockery.View.EventStream {

    using global::Dockery.DockerSdk;

     /**
     * Display live stream event
     */
    public class LiveStreamComponent : Gtk.Box {

        private Gtk.Expander expander = new Gtk.Expander("Docker events");
        private Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
        private Gtk.TextView view = new Gtk.TextView();

        construct {
            scrolled.set_size_request(100, 200);
            view.editable = false;
            view.can_focus = false;
            view.set_wrap_mode(Gtk.WrapMode.CHAR);
            view.expand = true;
        }

        public LiveStreamComponent() {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

            this.expander.add(this.scrolled);
            this.scrolled.add(this.view);
            this.pack_start(this.expander, true, true, 0);
        }

        public void append(Dto.Events.Event event) {

            string displayed_event = event.to_string() + "\n\n";
            
            Gtk.TextIter end_iter = this.get_end_iter();
            view.get_buffer().insert(ref end_iter, displayed_event, displayed_event.length);

            Gtk.TextMark mark = view.get_buffer().get_insert();
            view.scroll_mark_onscreen(mark);
        }

        private Gtk.TextIter get_end_iter() {
            Gtk.TextIter end_iter;
            view.get_buffer().get_end_iter(out end_iter);
            return end_iter;
        }
    }
}
