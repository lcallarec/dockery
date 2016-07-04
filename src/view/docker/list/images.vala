namespace View.Docker.List {

    using global::Sdk.Docker.Model;

    public class Images : Flushable, ImageViewable, Signals.ImageRequestAction, Gtk.Box {

        protected Gtk.Box empty_box;

        protected Gtk.ListStore liststore = new Gtk.ListStore(4, typeof (string),  typeof (string), typeof (string), typeof (string));

        /**
         * Init the images view from a given (nullable) list of images
         */
        public Images init(ImageCollection? images, bool show_after_refresh = true) {

            this.flush();

            if (null != images && images.size > 0) {

                this.hydrate(images);

                if (show_after_refresh == true) {
                    this.show_all();
                }

                return this;

            } else {

                var empty_box = IconMessageBoxBuilder.create_icon_message_box("No image found", "docker-symbolic");
                this.pack_start(empty_box, true, true, 0);

                if (show_after_refresh == true) {
                    this.show_all();
                }

                return this;
            }
        }

        private Gtk.TreeView get_treeview(Gtk.ListStore liststore) {

            var treeview = new Gtk.TreeView();
            treeview.set_model(liststore);

            treeview.vexpand = true;
            treeview.hexpand = true;

            treeview.insert_column_with_attributes(-1, "From",       new Gtk.CellRendererText(), "text", 0);
            treeview.insert_column_with_attributes(-1, "ID",         new Gtk.CellRendererText(), "text", 1);
            treeview.insert_column_with_attributes(-1, "Size",       new Gtk.CellRendererText(), "text", 2);
            treeview.insert_column_with_attributes(-1, "Created at", new Gtk.CellRendererText(), "text", 3);

            treeview.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);

            return treeview;

        }


        /**
         * Add new rows from images array
         */
        private int hydrate(ImageCollection images) {
            int images_count = 0;

            Gtk.TreeIter iter;

            liststore.clear();

            foreach(Image image in images) {

                liststore.append(out iter);

                StringBuilder sb = new StringBuilder();
                sb.printf("%s:%s",image.repository, image.tag);

                liststore.set(iter, 0, sb.str, 1, image.id, 2, image.size, 3, image.created_at.to_string());

                images_count += 1;

            }

            var tv = get_treeview(liststore);

            var selection = tv.get_selection();
            selection.set_mode(Gtk.SelectionMode.SINGLE);


            tv.button_press_event.connect((e) => {
                if (e.button == 3) {
                    Gtk.TreePath tp;
                    tv.get_path_at_pos((int) e.x, (int) e.y, out tp, null, null, null);

                    selection.select_path(tp);

                    Gtk.TreeModel m;
                    Gtk.TreeIter i;
                    selection.get_selected(out m, out i);

                    Value oid;
                    m.get_value(i, 1, out oid);

                    string id = oid as string;

                    if (images.has_id(id)) {

                        Image image = images.get_by_id(id);

                        View.Docker.Menu.ImageMenu menu = View.Docker.Menu.ImageMenuFactory.create(image);
                        menu.show_all();

                        menu.popup(null, null, null, e.button, e.time);

                        menu.image_remove_request.connect(() => {
                            this.image_remove_request(image);
                        });
                    }

                    return true;
                }

                return false;
            });

            this.pack_start(tv, true, true, 0);

            return images_count;
        }
    }
}
