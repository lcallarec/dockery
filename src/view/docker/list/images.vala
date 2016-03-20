namespace View.Docker.List {

    using global::Sdk.Docker.Model;

    public class Images : Flushable, ImageViewable, Signals.ImageRequestAction, Gtk.Box {
        
        protected Gtk.Box empty_box;
        
        /**
         * Init the images view from a given (nullable) list of images 
         */
        public Images init(Image[]? images, bool show_after_refresh = true) {
            
            this.flush();   
            
            if (null != images && images.length > 0) {
                
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

        /**
         * Add new rows from images array
         */
        private int hydrate(Image[] images) {
            int images_count = 0;
            Gtk.ListBox list_box = new Gtk.ListBox();
            
            foreach(Image image in images) {

                Gtk.ListBoxRow row = new Gtk.ListBoxRow();

                //For Gtk 3.14+ only
                //row.set_selectable(false);

                Gtk.Grid row_layout = new Gtk.Grid();
                row.add(row_layout);

                var label_repotag       = create_repotag_label(image);
                var label_id            = create_id_label(image);
                var label_creation_date = create_creation_date_label(image);
                var label_size          = create_virtual_size_label(image);

                //attach (Widget child, int left, int top, int width = 1, int height = 1)
                row_layout.attach(label_repotag,       0, 0, 1, 1);
                row_layout.attach(label_id,            0, 1, 1, 1);
                row_layout.attach(label_size,          1, 0, 1, 1);
                row_layout.attach(label_creation_date, 1, 1, 1, 1);

                View.Docker.Menu.ImageMenu menu = View.Docker.Menu.ImageMenuFactory.create(image);

                Gtk.MenuButton mb = new Gtk.MenuButton();
                
                menu.show_all();
                mb.popup = menu;

                menu.image_remove_request.connect(() => {
                    this.image_remove_request(image);
                });

                row_layout.attach(mb,        2, 0, 1, 1);

                Gtk.Separator separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
                row_layout.attach(separator, 0, 2, 3, 2);

                images_count += 1;

                list_box.insert(row, images_count);
            }

            this.pack_start(list_box, true, true, 0);

            return images_count;
        }

        /**
         * Create a repo:tab label
         */
        private Gtk.Label create_repotag_label(Image image) {

            StringBuilder sb = new StringBuilder();
            sb.printf("from: <b>%s:%s</b>", GLib.Markup.escape_text(image.repository), GLib.Markup.escape_text(image.tag));

            var label = new Gtk.Label(null);
            label.set_markup(sb.str);
            label.halign = Gtk.Align.START;
            label.valign = Gtk.Align.START;
            label.set_selectable(true);
            label.set_hexpand(true);

            return label;
        }

        /**
         * Create a id label
         */
        private Gtk.Label create_id_label(Image image) {

            var label = new Gtk.Label(image.id);
            label.halign = Gtk.Align.START;
            label.set_selectable(true);

            return label;
        }

        /**
         * Create a creation date label
         */
        private Gtk.Label create_creation_date_label(Image image) {

            var label = new Gtk.Label("%s: %s".printf("created at", image.created_at.to_string()));
            label.attributes = Fonts.get_minor();
            label.halign = Gtk.Align.START;
            label.set_selectable(true);

            return label;
        }

        /**
         * Create a virtual size label
         */
        private Gtk.Label create_virtual_size_label(Image image) {

            var label = new Gtk.Label(image.size);
            label.halign = Gtk.Align.START;

            return label;
        }
    }
}
