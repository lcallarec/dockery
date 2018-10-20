using Dockery;
using Dockery.View;
using View.Docker;

namespace Dockery.View.Stat {

    public class StatDialog : View.Dialog {

        private Gtk.Box body = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        private Gtk.Box action_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        private Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
        private Gtk.Widget view;
        private Gtk.Label refresh_status = new Gtk.Label("");

        construct {
            this.view = this.build_loader();
            action_box.pack_start(refresh_status, false, false, 5);
            refresh_status.label = "Loading...";
            var auto_refresh_button = new Gtk.Switch();
            auto_refresh_button.notify["active"].connect(() => {
				SignalDispatcher.dispatcher().container_auto_refresh_toggle_request(auto_refresh_button.state);
            });
            action_box.pack_end(auto_refresh_button, false, false, 0);
            action_box.pack_end(new Gtk.Label("auto-refresh"), false, false, 0);
        }

        public StatDialog(Gtk.Window parent_window) {

            base(550, 200, "Get container stat", parent_window, false);

            scrolled.vexpand = true;
            scrolled.add(this.view);
            body.pack_start(action_box, false, false, 0);
            body.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, false, 0);
            body.pack_start(scrolled, true, true, 0);
            this.add_body(body);
        }

        public void set_message(string message) {
            refresh_status.label = message;
        }

        public void getset() {
            this.clear();
            this.view = this.build_loader();
            this.view.show_all();
            scrolled.add(this.view);
        }

        public void ready(DockerSdk.Model.ContainerStat stats) {
            this.clear();
            this.view = new StatSimpleTable(stats);
            this.view.show_all();
            scrolled.add(this.view);
        }

        private void clear() {
            if (this.view != null) {
                this.view.unparent();
                scrolled.remove(this.view);
            }
        }

        private Gtk.Spinner build_loader() {
            Gtk.Spinner spinner = new Gtk.Spinner();
            spinner.active = true;
            return spinner;
        }
    }
}
