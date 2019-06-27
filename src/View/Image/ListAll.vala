using Dockery.DockerSdk;
using Dockery.View;
using global::View.Docker;

namespace Dockery.View.Image {

    public class ListAll : Flushable, ImageViewable, Gtk.Box {

        protected Gtk.Box empty_box;

        protected Gtk.ListStore liststore;

        protected Model.ImageCollection images;

        /**
         * Init the images view from a given collection of images
         */
        public ListAll init(Model.ImageCollection images, bool show_after_refresh = true) {

            liststore = new Gtk.ListStore(4, typeof (string),  typeof (string), typeof (string), typeof (string));

            this.images = images;

            this.flush();

            if (images.size > 0) {
                this.hydrate();
            } else {
                var empty_box = IconMessageBoxBuilder.create_icon_message_box("No image found", "docker-symbolic");
                this.pack_start(empty_box, true, true, 0);
            }

            if (show_after_refresh == true) {
                this.show_all();
            }
            
            return this;
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
        private int hydrate() {
            int images_count = 0;

            Gtk.TreeIter iter;

            liststore.clear();

            foreach(Model.Image image in this.images.values) {

                liststore.append(out iter);

                StringBuilder sb = new StringBuilder();
                sb.printf("%s:%s",image.repository, image.tag);

                liststore.set(iter, 0, sb.str, 1, image.id, 2, image.size, 3, image.created_at.to_string());

                images_count += 1;

            }

            var tv = get_treeview(liststore);

            register_on_row_right_click(tv);

            Gtk.ScrolledWindow images_scrolled = new Gtk.ScrolledWindow(null, null);
            images_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            images_scrolled.add(tv);

            this.pack_start(images_scrolled, true, true, 0);

            return images_count;
        }
        
        private void register_on_row_right_click(Gtk.TreeView tv) {
            
            var selection = tv.get_selection();
            selection.set_mode(Gtk.SelectionMode.MULTIPLE);

            tv.button_press_event.connect((e) => {
                if (e.button == 3) {
                   
                    Gtk.TreeModel model;
                    
                    GLib.List<Gtk.TreePath> rows = selection.get_selected_rows(out model);

                    if (rows.length() == 1) {
                        
                        Model.Image? image = get_image_from_row(model, rows.nth_data(0));
                        
                        if (null != image) {
                            var menu = global::View.Docker.Menu.ImageMenuFactory.create_single(image);
                            menu.show_all();
                            menu.popup(null, null, null, e.button, e.time);
                        }

                    } else {
                        var selected_images = new Model.ImageCollection();
                        for (int i = 0; i < rows.length(); i++) {
                            Model.Image? selected_image = get_image_from_row(model, rows.nth_data(i));
                            if (null != selected_image) {
                                selected_images.add(selected_image);
                            }
                        }

                        var menu = global::View.Docker.Menu.ImageMenuFactory.create_multi(selected_images);
                        menu.show_all();
                        menu.popup_at_pointer(e);
                    }

                    return true;
                }

                return false;
            });
        }
        
        private Model.Image? get_image_from_row(Gtk.TreeModel model, Gtk.TreePath tree_path) {
            Gtk.TreeIter iter;
            Value value;
            
            model.get_iter(out iter, tree_path) ;
            model.get_value(iter, 1, out value);

            string id = value as string;
            
            if (this.images.has_id(id)) {
                return this.images.get_by_id(id);            
            }
            
            return null;
        }
    }
}
