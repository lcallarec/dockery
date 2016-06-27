namespace View.Docker.Dialog {

    using global::Sdk.Docker.Model;

    /**
     * This Dialog is displayed when an image is being removed.
     */
    public class RemoveImageDialog : View.Dialog {

        private Gtk.ListStore liststore = new Gtk.ListStore(2, typeof (string),  typeof (string));
        private Gtk.TreeView tv         = null;

        public RemoveImageDialog(Sdk.Docker.Model.ContainerCollection linked_containers, Sdk.Docker.Model.Image image, Gtk.Window parent) {

            base(350, 100, "Really remove docker image ?", parent);

            this.add_button("No !", Gtk.ResponseType.CLOSE);
            Gtk.Widget yes_button = this.add_button("Yes !", Gtk.ResponseType.APPLY);
            yes_button.get_style_context().add_class("destructive-action");

            int number_of_linked_containers = linked_containers.size;

            var body = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
            var empty_box = View.Docker.IconMessageBoxBuilder.create_icon_message_box(("Really remove image %s ?".printf(image.tag)), "media-optical-symbolic");

            if (number_of_linked_containers == 0) {
                Gtk.Label text = new Gtk.Label("This image is no more used by any known containers. Removing the image will be straight forward.");

                body.pack_start(text, false, false, 0);
                body.pack_start(empty_box, true, true, 0);

            } else if (number_of_linked_containers > 0) {
                populate_liststore_from_containers(linked_containers);

                tv = create_treeview();

                Gtk.Label text = new Gtk.Label("This image is linked to %d containers. Removing the image will also destroy these containers :".printf(linked_containers.size));

                body.pack_start(text, false, false, 0);
                body.pack_start(tv, true, true, 0);
                body.pack_start(empty_box, true, true, 0);
            }

            this.add_body(body);
        }

        private void populate_liststore_from_containers(Sdk.Docker.Model.ContainerCollection linked_containers) {

            Gtk.TreeIter iter;
            foreach(Sdk.Docker.Model.ContainerStatus status in Sdk.Docker.Model.ContainerStatus.all()) {
                foreach(Sdk.Docker.Model.Container container in linked_containers.get_by_status(status)) {
                    liststore.append (out iter);
                    liststore.set(iter, 0, container.name, 1, container.get_status_string());
                }
            }
        }

        private Gtk.TreeView create_treeview() {

            tv = new Gtk.TreeView();
            tv.set_model(liststore);

            tv.vexpand = true;
            tv.hexpand = true;

            tv.insert_column_with_attributes(-1, "Id", new Gtk.CellRendererText(), "text", 0);
            tv.insert_column_with_attributes(-1, "Status", new Gtk.CellRendererText(), "text", 1);

            return tv;
        }
    }
}
