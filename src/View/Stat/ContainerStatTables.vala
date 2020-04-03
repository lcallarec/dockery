using Dockery.DockerSdk;
using Dockery.Common;

namespace Dockery.View.Stat {


    public class ContainerStatTables : Object {
        private Gtk.TreeView mem_treeview;
        private Gtk.ListStore mem_liststore = new Gtk.ListStore(2, typeof (string),  typeof (string));

        private Gtk.TreeView cpu_treeview;
        private Gtk.ListStore cpu_liststore = new Gtk.ListStore(2, typeof (string),  typeof (string));

        private Gtk.TreeView network_treeview;
        private Gtk.ListStore network_liststore = new Gtk.ListStore(2, typeof (string),  typeof (string));

        private Gtk.Box container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

        private Mutex mutex = new Mutex();

        public ContainerStatTables() {
            mem_treeview = create_treeview(mem_liststore);
            cpu_treeview = create_treeview(cpu_liststore);
            network_treeview = create_treeview(network_liststore);

            container.pack_start(new Gtk.Label("Memory"), false, false, 0);
            container.pack_start(mem_treeview, false, false, 0);
            container.pack_start(new Gtk.Label("CPU"), false, false, 0);
            container.pack_start(cpu_treeview, false, false, 0);
            container.pack_start(new Gtk.Label("Network"), false, false, 0);
            container.pack_start(network_treeview, false, false, 0);
        }

        public void update(DockerSdk.Model.ContainerStat stats) {
            mutex.lock();
            mem_liststore.clear();
            Gtk.TreeIter mem_iter;

            mem_liststore.append(out mem_iter);
            mem_liststore.set(mem_iter, 0, "Memory limit", 1, stats.memory.limit.to_human().to_string());
            mem_liststore.append(out mem_iter);
            mem_liststore.set(mem_iter, 0, "Memory max usage", 1, stats.memory.max_usage.to_human().to_string());
            mem_liststore.append(out mem_iter);
            mem_liststore.set(mem_iter, 0, "Memory usage", 1, stats.memory.usage.to_human().to_string());
            mem_liststore.append(out mem_iter);
            mem_liststore.set(mem_iter, 0, "Memory used %", 1, stats.memory.percent.to_string() + "%");

            cpu_liststore.clear();
            Gtk.TreeIter cpu_iter;

            cpu_liststore.append(out cpu_iter);
            cpu_liststore.set(cpu_iter, 0, "CPU % (%d cores)".printf(stats.cpu.cpu.online_cpus), 1, "%.2f".printf(stats.cpu.percent) + "%");

            network_liststore.clear();
            Gtk.TreeIter network_iter;

            network_liststore.append(out network_iter);
            network_liststore.set(network_iter, 0, "Read", 1, stats.networks.rx.to_human().to_string());
            network_liststore.append(out network_iter);            
            network_liststore.set(network_iter, 0, "Write", 1, stats.networks.tx.to_human().to_string());
            
            mutex.unlock();            
        }

        public Gtk.Widget get_widget() {
            return container;
        }

        private Gtk.TreeView create_treeview(Gtk.TreeModel model) {

            var treeview = new Gtk.TreeView();
            treeview.set_model(model);
            treeview.width_request = 200;

            var metric_cell_renderer = new Gtk.CellRendererText();
		    metric_cell_renderer.set("weight_set", true);
            metric_cell_renderer.set("weight", 700);
            metric_cell_renderer.set("width", 150);

            treeview.insert_column_with_attributes(-1, "Metric", metric_cell_renderer, "text", 0);
            treeview.insert_column_with_attributes(-1, "Value",  new Gtk.CellRendererText(), "text", 1);

            treeview.set_grid_lines(Gtk.TreeViewGridLines.HORIZONTAL);
            treeview.set_headers_visible(false);
            return treeview;
        }
    }
}
