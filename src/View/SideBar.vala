namespace Dockery.View {

    public class SideBar : Gtk.ListBox {

        private const int8 ROW_HEIGHT = 30;

        public SideBar(Gtk.Stack stack) {
            width_request = 150;
            row_activated.connect((row) => {
                stack.set_visible_child_name(row.name);
            });

            set_header_func(add_row_header);

            add_containers_row();
            add_images_row();
            add_volumes_row();
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

            images_row.add(images_box);

            var icon = new Gtk.Image();
            icon.set_from_icon_name("media-optical-symbolic", Gtk.IconSize.BUTTON);
            icon.opacity = 0.7;

            images_box.pack_start(icon, false, true, 5);
            images_box.pack_start(images_row_label);

            add(images_row);
        }

        private void add_volumes_row() {
            Gtk.ListBoxRow volumes_row = new Gtk.ListBoxRow();
            volumes_row.height_request = SideBar.ROW_HEIGHT;
            volumes_row.name = "volumes";

            var volumes_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            volumes_box.height_request = SideBar.ROW_HEIGHT;

            var volumes_row_label = new Gtk.Label("Volumes");
            volumes_row_label.halign = Gtk.Align.START;

            volumes_row.add(volumes_box);

            var icon = new Gtk.Image();
            icon.set_from_icon_name("drive-multidisk-symbolic", Gtk.IconSize.BUTTON);
            icon.opacity = 0.7;

            volumes_box.pack_start(icon, false, true, 5);
            volumes_box.pack_start(volumes_row_label);

            add(volumes_row);
        }        
    }
}
