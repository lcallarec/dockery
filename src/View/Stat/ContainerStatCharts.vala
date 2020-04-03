using Dockery.DockerSdk;
using Dockery.Common;

namespace Dockery.View.Stat {


    public class ContainerStatCharts : Object {
        
        private Gtk.Box container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

        private LiveChart.Chart mem_chart;
        private LiveChart.Config mem_chart_config = new LiveChart.Config();
        private LiveChart.Serie mem_serie_usage = new LiveChart.Serie("Memory usage", new LiveChart.SmoothLineArea());
        private LiveChart.Serie mem_serie_limit = new LiveChart.Serie("Memory limit", new LiveChart.SmoothLine());  

        private LiveChart.Chart cpu_chart;
        private LiveChart.Config cpu_chart_config = new LiveChart.Config();
        private LiveChart.Serie cpu_serie_percent = new LiveChart.Serie("CPU %", new LiveChart.SmoothLineArea());

        private LiveChart.Chart network_chart;
        private LiveChart.Config network_chart_config = new LiveChart.Config();
        private LiveChart.Serie network_serie_rx = new LiveChart.Serie("Read", new LiveChart.SmoothLine());
        private LiveChart.Serie network_serie_tx = new LiveChart.Serie("Write", new LiveChart.SmoothLine());  


        public ContainerStatCharts() {
            
            mem_chart = new LiveChart.Chart(mem_chart_config);
            mem_serie_usage.set_main_color({1.0, 0.5, 0.0, 1.0});
            mem_serie_limit.set_main_color({1.0, 0.0, 0.0, 1.0});

            mem_chart_config.y_axis.tick_length = (int) (300 / 4);

            mem_chart.add_serie(mem_serie_usage);
            mem_chart.add_serie(mem_serie_limit);

            cpu_chart = new LiveChart.Chart(cpu_chart_config);            
            cpu_serie_percent.set_main_color({0.5, 0.7, 1.0, 1.0});

            cpu_chart_config.y_axis.unit = "%";
            cpu_chart_config.y_axis.tick_interval = 25;

            cpu_chart.add_serie(cpu_serie_percent);

            network_chart = new LiveChart.Chart(network_chart_config);            
            network_serie_rx.set_main_color({0.6, 0.6, 1.0, 1.0});
            network_serie_tx.set_main_color({0.0, 0.7, 0.3, 1.0});

            network_chart.add_serie(network_serie_rx);
            network_chart.add_serie(network_serie_tx);

            var memcpu = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            memcpu.pack_start(mem_chart, true, true, 0);
            memcpu.pack_start(cpu_chart, true, true, 0);

            container.pack_start(memcpu, true, true, 0);
            container.pack_start(network_chart, true, true, 0);            
        }

        public void init(DockerSdk.Model.ContainerStat stats) {
            Unit.Bytes mem_limit = stats.memory.limit.to_human();

            mem_chart_config.y_axis.fixed_max = mem_limit.unit_value;
            mem_chart_config.y_axis.tick_interval = (int) (mem_limit.unit_value / 4);
            mem_chart_config.y_axis.unit = mem_limit.unit.to_string();
            
            update(stats);
        }

        public void update(DockerSdk.Model.ContainerStat stats) {
            Unit.Bytes mem_limit = stats.memory.limit.to_human();
            mem_chart.add_value(mem_serie_limit, mem_limit.unit_value);
            mem_chart.add_value(mem_serie_usage, stats.memory.usage.to(mem_limit.unit).unit_value);

            cpu_chart.add_value(cpu_serie_percent, stats.cpu.percent);

            Unit.Bytes network_rx = stats.networks.rx.to_human();
            Unit.Bytes network_tx = stats.networks.tx.to(network_rx.unit);
            stdout.printf("network_rx %f\n", network_rx.unit_value);
            stdout.printf("network_tx %f\n", network_tx.unit_value);

            network_chart_config.y_axis.unit = network_rx.unit.to_string();

            network_chart.add_value(network_serie_rx, network_rx.unit_value);
            network_chart.add_value(network_serie_tx, network_tx.unit_value);
        }

        public Gtk.Widget get_widget() {
            return container;
        }
    }
}
