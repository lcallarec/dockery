using Dockery.DockerSdk;

namespace Dockery.View.EventStream {

    public class EventWidget {

        public Gtk.Box title_row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        public Gtk.Box desc_row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        private Gtk.Expander expander = new Gtk.Expander("json event");
        
        public EventWidget(Dto.Events.Event event) {
            
            var pill = new Gtk.Label(null);
            pill.get_style_context().add_class("event_pill");
            pill.get_style_context().add_class("event_type");
            pill.label = event.event_type;
            pill.halign = Gtk.Align.START;

            var action = new Gtk.Label(null);
            action.get_style_context().add_class("event_pill");
            action.get_style_context().add_class("event_action");
            action.label = event.action;
            action.halign = Gtk.Align.START;

            this.title_row.pack_start(pill, false, false, 0);
            this.title_row.pack_start(action, false, false, 5);

            this.desc_row.get_style_context().add_class("event_description");
            this.desc_row.pack_start(new Gtk.Label(new DateTime.from_unix_local(event.time).format("%Y-%m-%d %H:%M:%S")), false, false, 0);

            this.expander.get_style_context().add_class("event_raw_json");
            var raw_event = new Gtk.Label(event.to_string());
            raw_event.selectable = true;
            this.expander.add(raw_event);
        }

        public EventWidget add_to_title(Gtk.Widget widget) {
            this.title_row.pack_start(widget, false, false, 2);
            return this;
        }

        public EventWidget add_to_descr(Gtk.Widget widget) {
            this.title_row.pack_start(widget, false, false, 2);
            return this;            
        }

        public Gtk.Widget pack() {
 
            var event_row = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

            event_row.pack_start(title_row, false, false, 0);
            event_row.pack_start(desc_row, false, false, 0);
            event_row.pack_start(expander, false, false, 1);            

            return event_row;
        }
    }
}
