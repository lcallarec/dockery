using Dockery;
using View.Docker;

namespace Dockery.View.Stat {


    public class StatDialog : View.Dialog {

        Gtk.Box body = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
        Gtk.Box loader = IconMessageBoxBuilder.create_icon_message_box("Please wait while fetching stats...", "view-refresh-symbolic");

        public StatDialog(Gtk.Window parent_window) {

            base(550, 200, "Get container stat", parent_window, false);

            scrolled.vexpand = true;
            scrolled.add(loader);
            body.pack_start(scrolled, true, true, 0);
            this.add_body(body);
        }

        public void ready(DockerSdk.Model.ContainerStat stats) {
            var widget = new StatSimpleTable(stats);
            loader.unparent();
            scrolled.remove(loader);
            widget.show_all();
            scrolled.add(widget);
        }
    }
}
