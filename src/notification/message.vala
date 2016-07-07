namespace Notification {

    /**
     * Notification message
     */
    public class Message : GLib.Object {

        public Message(Gtk.MessageType message_type, string message) {
            this.message_type = message_type;
            this.message = message;
        }

        public Gtk.MessageType message_type {
            get; construct set;
        }

        public string message {
            get; construct set;
        }
    }
}
