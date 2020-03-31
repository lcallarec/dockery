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
            cpu_chart_config.y_axis.smart_ratio = true;

            cpu_chart.add_serie(cpu_serie_percent);

            container.pack_start(mem_chart, true, true, 0);
            container.pack_start(cpu_chart, true, true, 0);
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
        }

        public Gtk.Widget get_widget() {
            return container;
        }
    }
}
