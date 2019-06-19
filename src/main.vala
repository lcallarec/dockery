public static void main (string[] args) {
    Gtk.init(ref args);

    if (Environment.get_variable("RTL") != null) {
        Gtk.Widget.set_default_direction(Gtk.TextDirection.RTL);
    }
    else {
        Gtk.Widget.set_default_direction(Gtk.TextDirection.LTR);
    }

    if (args[1] == "--dark-theme" || args[2] == "--dark-theme") {
        Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
    }

    if (args[1] == "--experimental" || args[2] == "--experimental") {
        Dockery.Feature.CONTAINER_BUTTON_ROW = true;
    }


    var dm = new DockerManager();
    dm.show_all();

    Gtk.main();
}