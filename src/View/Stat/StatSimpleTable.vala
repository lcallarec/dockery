using Dockery.DockerSdk;
using Dockery.Common;

namespace Dockery.View.Stat {


    public class StatSimpleTable : Object {
        private Gtk.TreeView treeview = new Gtk.TreeView();
        private Gtk.ListStore liststore = new Gtk.ListStore(2, typeof (string),  typeof (string));
        private Mutex mutex = new Mutex();

        public StatSimpleTable() {
            this.treeview = this.create_treeview();
        }

        public void update(DockerSdk.Model.ContainerStat stats) {
            mutex.lock();
            liststore.clear();
            Gtk.TreeIter iter;

            liststore.append(out iter);
            liststore.set(iter, 0, "Memory limit", 1, stats.memory_stats.limit.to_human().to_string());
            liststore.append(out iter);
            liststore.set(iter, 0, "Memory max usage", 1, stats.memory_stats.max_usage.to_human().to_string());
            liststore.append(out iter);
            liststore.set(iter, 0, "Memory usage", 1, stats.memory_stats.usage.to_human().to_string());
            liststore.append(out iter);
            liststore.set(iter, 0, "Memory used %", 1, stats.memory_stats.percent.to_string() + "%");

            treeview.set_model(liststore);
            mutex.unlock();            
        }

        public Gtk.TreeView get_treeview() {
            return this.treeview;
        }

        private Gtk.TreeView create_treeview() {

            var treeview = new Gtk.TreeView();
            treeview.set_model(this.liststore);
            treeview.width_request = 200;

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
