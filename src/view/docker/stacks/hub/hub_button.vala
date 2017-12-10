namespace View.Docker.Stacks.Hub {

    class HubButton : Gtk.Button, Signals.DockerServiceAware {

        public HubButton() {
            Object(label: "hub");
            this.set_sensitive(false);
        }
    }
}
