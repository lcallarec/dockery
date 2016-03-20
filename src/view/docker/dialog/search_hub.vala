namespace View.Docker.Dialog {
    
    using global::Sdk.Docker.Model;
    
    /**
     * This Dialog is displayed when an image is being removed.
     */ 
    public class SearchHubDialog : View.Dialog, Signals.DockerHubImageRequestAction {

        private Gtk.ListStore liststore = new Gtk.ListStore(5, typeof (string),  typeof (string), typeof (string), typeof (string), typeof (string));
        private Gtk.TreeView treeview   = null;
        
        public SearchHubDialog(Gtk.Window parent) {
            
            base(600, 500, "Search image in Docker hub", parent, false, 0);
            
            var body = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            
            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.add(get_treeview());
            
            var search_entry = new Gtk.Entry();
            this.on_search(search_entry);
            search_entry.width_chars = 30;
            search_entry.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-find-symbolic");
 
            body.pack_start(search_entry, false, false, 5);
            body.pack_start(scrolled_window, false, true, 5);

            this.add_body(body);
        }
       
        /** Set images collecyion to the view */       
        public void set_images(Sdk.Docker.Model.HubImage[] images) {

            Gtk.TreeIter iter;
            liststore.clear();
            foreach(Sdk.Docker.Model.HubImage image in images) {
                liststore.append (out iter);    
                liststore.set(iter, 0, image.name, 1, image.description, 2, image.is_official.to_string(), 3, image.is_automated.to_string(), 4, image.star_count.to_string());
            }
        }
       
        /** Search signals */
        private void on_search(Gtk.Entry entry) {
            
            entry.icon_press.connect ((pos, event) => {
                if (pos == Gtk.EntryIconPosition.SECONDARY) {
                    this.search_image_in_docker_hub(this, entry.text);
                }
            });

            entry.activate.connect (() => {
                this.search_image_in_docker_hub(this, entry.text);
            });
        }
        
        /** Treeview singleton factory */
        private Gtk.TreeView get_treeview() {
            if (null == treeview) {
                
                treeview = new Gtk.TreeView();
                treeview.set_model(liststore);
                
                treeview.vexpand = true;
                treeview.hexpand = true;
        
                treeview.insert_column_with_attributes(-1, "Name", new Gtk.CellRendererText(), "text", 0);
                treeview.insert_column_with_attributes(-1, "Description", new Gtk.CellRendererText(), "text", 1);
                treeview.insert_column_with_attributes(-1, "Official ?", new Gtk.CellRendererText(), "text", 2);
                treeview.insert_column_with_attributes(-1, "Automated ?", new Gtk.CellRendererText(), "text", 3);
                treeview.insert_column_with_attributes(-1, "Stars", new Gtk.CellRendererText(), "text", 4);
            
                return treeview;
            }
            
            return treeview;
        }
    }
}
