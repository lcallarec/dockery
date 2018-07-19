namespace Dockery.View.Controls {

    class HubButton : Gtk.Button, Signals.DockerHubImageRequestAction {

        public HubButton() {
            Object(label: "hub");
            this.set_sensitive(false);
        }
    }
}
