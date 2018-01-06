namespace Dockery.View.Docker.Dialog {

    using global::Dockery;

    public class InspectContainer : View.Dialog {

        public InspectContainer(Gtk.Window parent_window, DockerSdk.Model.Container container, string inspection_data) {

            base(550, 550, "Inspect Low-level information of container %s".printf(container.id), parent_window, false);

            var body = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

            Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
            scrolled.vexpand = true;
            body.pack_start(scrolled, true, true, 0);
            
            Gtk.TextView view = new Gtk.TextView();
            view.set_wrap_mode(Gtk.WrapMode.WORD);
            view.buffer.text = inspection_data;
            scrolled.add(view);

            this.add_body(body);
        }
    }
}
