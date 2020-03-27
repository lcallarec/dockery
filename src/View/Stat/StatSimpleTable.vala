using Dockery.DockerSdk;
using Dockery.Common;

namespace Dockery.View.Stat {


     /**
     * Display live stream event
     */
    public class StatSimpleTable : Gtk.Box {

        public StatSimpleTable(DockerSdk.Model.ContainerStat stats) {
            Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
            
            var tree_view = this.build(stats);

            this.pack_start(tree_view, true, true, 0);
        }

        private Gtk.TreeView build(DockerSdk.Model.ContainerStat stats) {
            
            Gtk.TreeIter iter;
            
            Gtk.ListStore liststore = new Gtk.ListStore(2, typeof (string),  typeof (string));
            liststore.clear();
            liststore.append(out iter);
            liststore.set(iter, 0, "Read at", 1, stats.read_at.to_string());
            liststore.append(out iter);
            liststore.set(iter, 0, "Memory max usage", 1, stats.memory_stats.max_usage.to_human());
            liststore.append(out iter);
            liststore.set(iter, 0, "Memory usage", 1, stats.memory_stats.usage.to_human());
            liststore.append(out iter);
            liststore.set(iter, 0, "Memory limit", 1, stats.memory_stats.limit.to_human());
            
            return this.get_treeview(liststore);
        }

        private Gtk.TreeView get_treeview(Gtk.ListStore liststore) {

            var treeview = new Gtk.TreeView();
            treeview.set_model(liststore);

            treeview.vexpand = true;
            treeview.hexpand = true;

            var metric_cell_renderer = new Gtk.CellRendererText();
		    metric_cell_renderer.set ("weight_set", true);
		    metric_cell_renderer.set ("weight", 700);

            treeview.insert_column_with_attributes(-1, "Metric", metric_cell_renderer, "text", 0);
            treeview.insert_column_with_attributes(-1, "Value",  new Gtk.CellRendererText(), "text", 1);

            treeview.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);

            return treeview;
        }
    }
}
