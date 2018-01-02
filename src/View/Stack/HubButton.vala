namespace View.Docker.Stacks {

    class HubButton : Gtk.Button, Signals.DockerServiceAware {

        public HubButton() {
            Object(label: "hub");
            this.set_sensitive(false);
        }
    }
}
