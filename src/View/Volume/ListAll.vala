using Dockery.DockerSdk;
using Dockery.View;

namespace Dockery.View.Volume {


    public class ListAll : Flushable, VolumeViewable, Gtk.Box {

        protected Gtk.Box empty_box;

        protected Gtk.ListStore liststore;

        protected Model.VolumeCollection volumes;

        /**
         * Init the volumes view from a given collection of volumes
         */
        public ListAll init(Model.VolumeCollection volumes, bool show_after_refresh = true) {

            liststore = new Gtk.ListStore(3, typeof (string),  typeof (string), typeof (string));

            this.volumes = volumes;

            this.flush();

            if (volumes.size > 0) {
                this.hydrate();
            } else {
                var empty_box = IconMessageBoxBuilder.create_icon_message_box("No volumes found", "docker-symbolic");
                this.pack_start(empty_box, true, true, 0);
            }

            if (show_after_refresh == true) {
                this.show_all();
            }
            
            return this;
        }

        private Gtk.TreeView get_treeview(Gtk.ListStore liststore) {

            var treeview = new Gtk.TreeView();
            treeview.set_name("volumes-treeview");
            treeview.set_model(liststore);

            treeview.vexpand = true;
            treeview.hexpand = true;

            treeview.insert_column_with_attributes(-1, "Name", new Gtk.CellRendererText(), "text", 0);
            treeview.insert_column_with_attributes(-1, "Driver", new Gtk.CellRendererText(), "text", 1);
            treeview.insert_column_with_attributes(-1, "MountPoint", new Gtk.CellRendererText(), "text", 2);

            treeview.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);

            return treeview;

        }

        /**
         * Add new rows from volumes array
         */
        private int hydrate() {
            int volumes_count = 0;

            Gtk.TreeIter iter;

            liststore.clear();

            foreach(Model.Volume volume in this.volumes.values) {
                liststore.append(out iter);
                liststore.set(iter, 0, volume.short_name, 1, volume.driver, 2, volume.mount_point);
                volumes_count += 1;
            }

            var tv = get_treeview(liststore);

            Gtk.ScrolledWindow volumes_scrolled = new Gtk.ScrolledWindow(null, null);
            volumes_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            volumes_scrolled.add(tv);

            this.pack_start(volumes_scrolled, true, true, 0);

            return volumes_count;
        }
    }
}
