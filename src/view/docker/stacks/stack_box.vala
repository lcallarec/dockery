namespace View.Docker.Stacks {

    class Stack : Gtk.Box {

        public Stack(SettingsBox settings_box) {
            Object(orientation: Gtk.Orientation.HORIZONTAL);

            this.set_border_width(3);

            this.pack_start(new Gtk.Label("Local Docker stack settings"), false, false, 5);
            this.pack_end(settings_box, false, false);
        }

    }

}
