namespace View.Docker.Dialog {

    using global::Sdk.Docker.Model;

    /**
     * This Dialog is used to ask information about the container to create
     */
    public class CreateContainerWith : View.Dialog {


        private Gtk.Grid grid_layout = new Gtk.Grid();

        private Gtk.Label label_image_id = new Gtk.Label("Image");
        private Gtk.Entry entry_image_id = new Gtk.Entry();

        private Gtk.Label label_command = new Gtk.Label("Command");
        private Gtk.Entry entry_command = new Gtk.Entry();


        public CreateContainerWith(Sdk.Docker.Model.Image from_image, Gtk.Window parent_window) {

            base(350, 100, "Create container from image %s with...".printf(from_image.id), parent_window);

            this.add_button("Cancel", Gtk.ResponseType.CLOSE);
            Gtk.Widget yes_button = this.add_button("Create container", Gtk.ResponseType.APPLY);
            yes_button.get_style_context().add_class("suggested-action");

            var body = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);

            this.configure_layouts();
            this.configure_widgets();

            this.add_inputs(body);

            this.add_body(body);
        }

        private void add_inputs(Gtk.Box body) {

            //                 (Widget child, int left, int top, int width = 1, int height = 1)
            grid_layout.attach(label_image_id,    0, 0, 1, 1);
            grid_layout.attach(entry_image_id,    1, 0, 1, 1);
            grid_layout.attach(label_command,     0, 1, 1, 1);
            grid_layout.attach(entry_command,     1, 1, 1, 1);

            body.pack_start(grid_layout, true, true, 0);

        }

        private void configure_layouts() {
            grid_layout.column_spacing = 5;
            grid_layout.row_spacing = 5;
        }

        private void configure_widgets() {
            label_image_id.halign = Gtk.Align.END;
            label_image_id.halign = Gtk.Align.END;
        }
    }
}
