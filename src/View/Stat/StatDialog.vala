using Dockery;
using Dockery.View;
using View.Docker;

namespace Dockery.View.Stat {

    public class StatDialog : View.Dialog, Signals.ContainerRequestAction {

        Gtk.Box body = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        Gtk.Box action_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
        Gtk.Widget view;

        construct {
            this.view = this.build_loader();
            
            var auto_refresh_button = new AutoRefreshButton();
            auto_refresh_button.set_mode(true);
            auto_refresh_button.clicked.connect(() => {
				this.container_auto_refresh_toggle_request(auto_refresh_button.active);
            });
            action_box.pack_end(auto_refresh_button, false, false, 0);
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

        private Gtk.Box build_loader() {
            return IconMessageBoxBuilder.create_icon_message_box(
                "Please wait while fetching stats...",
                "view-refresh-symbolic"
            );
        }
    }
}
