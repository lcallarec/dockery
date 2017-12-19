namespace Dockery.View {
     /**
     * Dispatch messages to given infobar
     */
    public class MessageDispatcher : GLib.Object {

        private Gtk.InfoBar infobar;

        private Gtk.Label label;

        public MessageDispatcher(Gtk.InfoBar bar) {
            infobar = bar;
            label   = new Gtk.Label(null);
            label.wrap = true;
            label.wrap_mode = Pango.WrapMode.WORD_CHAR;
            infobar.get_content_area().add(label);
        }

        public void dispatch(Gtk.MessageType type, string message) {
            infobar.set_message_type(type);
            label.label = message;
            infobar.show();
            label.show();
        }
    }
}
