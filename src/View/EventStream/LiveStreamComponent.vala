using Dockery.DockerSdk;

namespace Dockery.View.EventStream {

     /**
     * Display live stream event
     */
    public class LiveStreamComponent : Gtk.Box {

        private Gtk.Expander expander = new Gtk.Expander("Docker events");
        private Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
        private Gtk.Box view = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
        private Gee.ArrayList<Gtk.Widget> buffer = new Gee.ArrayList<Gtk.Widget>();
        private int max_items;

        construct {
            scrolled.set_size_request(100, 200);
            view.expand = true;
            expander.resize_toplevel = true;
        }

        public LiveStreamComponent(int max_items = 100) {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

            this.max_items = max_items;

            this.expander.add(this.scrolled);
            this.scrolled.add(this.view);

            this.pack_start(this.expander, true, true, 0);
        }

        public void append(Dto.Events.Event event) {
            var adjustment = scrolled.get_vadjustment();

            var widget = EventWidgetFactory.create(event);
            buffer.add(widget);
            if (buffer.size > this.max_items) {
                buffer.get(0).destroy();
                buffer.remove_at(0);
            }

            this.view.pack_start(widget, true, true, 5);

            GLib.Idle.add(() => {
                adjustment.set_value(scrolled.get_vadjustment().get_upper() - scrolled.get_vadjustment().get_page_size());
                scrolled.set_vadjustment(adjustment);         
                return false;
            });

            view.show_all();
        }

        public  Gee.ArrayList<Gtk.Widget> get_buffer() {
            return this.buffer;
        }
    }
}
