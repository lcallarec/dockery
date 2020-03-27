using Dockery.DockerSdk;
using Dockery.View;
using global::View.Docker;

namespace Dockery.View.Image {

    public class ListAll : Flushable, ImageViewable, Gtk.Box {

        protected Gtk.Box empty_box;
        protected Model.ImageCollection images;

        /**
         * Init the images view from a given collection of images
         */
        public ListAll init(Model.ImageCollection images, bool show_after_refresh = true) {

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

        /**
         * Add new rows from images array
         */
        private int hydrate() {

            var search = new Gtk.SearchEntry();
            search.set_name("search-images");
            search.width_chars = 30;

            var treeview = create_treeview_from_images(images, search);

            register_on_row_right_click(treeview);

            Gtk.ScrolledWindow scrolled_window = new Gtk.ScrolledWindow(null, null);
            scrolled_window.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            scrolled_window.add(treeview);

            var search_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            search_box.margin = 5;
            search_box.pack_end(search, false, false, 0);
            
            var treeview_container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            treeview_container.pack_start(search_box, false, false, 2);
            treeview_container.pack_start(scrolled_window, true, true, 0);

            this.pack_start(treeview_container, true, true, 0);

            return images.size;
        }
        
        private void register_on_row_right_click(Gtk.TreeView treeview) {
            
            var selection = treeview.get_selection();
            selection.set_mode(Gtk.SelectionMode.MULTIPLE);

            treeview.button_press_event.connect((e) => {
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
        
        private Gtk.TreeView create_treeview_from_images(Model.ImageCollection images, Gtk.SearchEntry entry) {

            var model = create_model_from_images(images, entry);
            var treeview = new Gtk.TreeView();
            treeview.set_model(model);

            treeview.vexpand = true;
            treeview.hexpand = true;

            treeview.insert_column_with_attributes(-1, "From",       new Gtk.CellRendererText(), "text", 0);
            treeview.insert_column_with_attributes(-1, "ID",         new Gtk.CellRendererText(), "text", 1);
            treeview.insert_column_with_attributes(-1, "Size",       new Gtk.CellRendererText(), "text", 2);
            treeview.insert_column_with_attributes(-1, "Created at", new Gtk.CellRendererText(), "text", 3);

            treeview.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);

            return treeview;
        }


        private Gtk.TreeModelFilter create_model_from_images(Model.ImageCollection images, Gtk.SearchEntry entry) {
            
            Gtk.ListStore liststore = new Gtk.ListStore(4, typeof (string),  typeof (string), typeof (string), typeof (string));
            liststore.clear();
            
            Gtk.TreeIter iter;
            foreach(Model.Image image in this.images.values) {
                liststore.append(out iter);
                StringBuilder sb = new StringBuilder();
                sb.printf("%s:%s",image.repository, image.tag);
                liststore.set(iter, 0, sb.str, 1, image.id, 2, image.size.to_human(), 3, image.created_at.to_string());
            }

            int[] columns = { 0, 1 };
            var filter = new Gtk.TreeModelFilter(liststore, null);
            filter.set_visible_func((model, iter) => {
                var search_pattern = entry.text.chomp();
                if (search_pattern == "") {
                    return true;
                }
                foreach (int column in columns) {
                    Value v;
                    model.get_value(iter, column, out v);
                    if ((v as string).contains(search_pattern)) {
                        return true;
                    }
                }

                return false;
            });

            entry.search_changed.connect(() => {
                filter.refilter();
            });

            return filter;
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
