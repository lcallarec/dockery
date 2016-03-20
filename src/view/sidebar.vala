namespace View {
    
    using View.Docker.Dialog;
    
    public class SideBar : Gtk.ListBox, Signals.DockerHubImageRequestAction {
        
        private const int8 ROW_HEIGHT = 30;
        
        private Gtk.Window parent_window;
        
        public SideBar(Gtk.Window parent_window, Gtk.Stack stack) {
            this.parent_window = parent_window;
            width_request = 150;
            row_activated.connect((row) => {
                stack.set_visible_child_name(row.name);
            });
            
            set_header_func(add_row_header);
            
            add_containers_row();
            add_images_row();
        }

        public void add_row_header(Gtk.ListBoxRow row, Gtk.ListBoxRow? before) {
            if (before != null) {
                row.set_header(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));    
            }
        }
        
        private void add_containers_row() {
            Gtk.ListBoxRow containers_row = new Gtk.ListBoxRow();
            containers_row.height_request = SideBar.ROW_HEIGHT;
            containers_row.name = "containers"; 

            var containers_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            containers_box.height_request = SideBar.ROW_HEIGHT;
            
            var container_row_label = new Gtk.Label("Containers");
            container_row_label.halign = Gtk.Align.START;
            containers_row.add(containers_box);
            
            var icon = new Gtk.Image.from_icon_name("docker-symbolic", Gtk.IconSize.BUTTON);
            icon.opacity = 1;

            containers_box.pack_start(icon, false, true, 5);
            containers_box.pack_start(container_row_label);
        
            add(containers_row);
            select_row(containers_row);
        }
        
        private void add_images_row() {
            Gtk.ListBoxRow images_row = new Gtk.ListBoxRow();
            images_row.height_request = SideBar.ROW_HEIGHT;
            images_row.name = "images"; 

            var images_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            images_box.height_request = SideBar.ROW_HEIGHT;

            var images_row_label = new Gtk.Label("Images");
            images_row_label.halign = Gtk.Align.START;
        
            Gtk.EventBox eb = new Gtk.EventBox();
            eb.add(images_box);
        
            images_row.add(eb);
            
            var icon = new Gtk.Image();
            icon.set_from_icon_name("media-optical-symbolic", Gtk.IconSize.BUTTON);
            icon.opacity = 0.7;
            
            images_box.pack_start(icon, false, true, 5);
            images_box.pack_start(images_row_label);
        
            add(images_row);
            
            add_menu_to_images_row(eb);
        }
        
        public void set_images(Sdk.Docker.Model.HubImage[] images) {
            
        }
        
        private void add_menu_to_images_row(Gtk.EventBox eb) {
            #if GTK_GTE_3_16
            Gtk.Popover popover = new Gtk.Popover(eb);
            popover.position = Gtk.PositionType.BOTTOM;
            
            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
            
            var search_button = new Gtk.Button.from_icon_name("edit-find-symbolic", Gtk.IconSize.BUTTON);
            search_button.set_tooltip_text("Search image on Docker hub");
            
            search_button.clicked.connect (() => {

                var dialog = new SearchHubDialog(parent_window);
                dialog.search_image_in_docker_hub.connect((target, term) => {
                    this.search_image_in_docker_hub(dialog, term);
                });
                
                dialog.show_all();

            });
        
            box.pack_start(search_button, false, true, 0);
            
            popover.add(box);
            
            eb.button_press_event.connect((e) => {
                if (3 == e.button) {
                    Gdk.Rectangle t = {
                        (int) e.x, (int) e.y, 10, 10
                    };
                    popover.pointing_to = t;
                    popover.show_all();
                    return true;    
                }
                
                return false;
                
            });
            #endif
        }
    }
}
