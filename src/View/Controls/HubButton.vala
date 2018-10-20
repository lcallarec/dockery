namespace Dockery.View.Controls {

    class HubButton : Gtk.Button {
        public HubButton() {
            Object(label: "hub");
            this.set_sensitive(false);
        }
    }
}
