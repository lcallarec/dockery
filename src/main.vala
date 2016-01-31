/*
 * DockerManager.vala
 *
 * Laurent Callarec <l.callarec@gmail.com>
 *
 */
public class DockerManager : Gtk.Window {

    private string docker_host = "/var/run/docker.sock";

    private Docker.Repository repository;

    private Gtk.InfoBar infobar { get; set;}

    private ApplicationController ac;

    private Ui.MainApplicationView views;

    public static void main (string[] args) {
        Gtk.init(ref args);

        if (Environment.get_variable("RTL") != null) {
            Gtk.Widget.set_default_direction(Gtk.TextDirection.RTL);
        }
        else {
            Gtk.Widget.set_default_direction(Gtk.TextDirection.LTR);
        }

        if (args[1] == "--dark-theme") {
            Gtk.Settings.get_default().set("gtk-application-prefer-dark-theme", true);
        }

        var dm = new DockerManager();
        dm.show_all();

        Gtk.main();
    }

    public DockerManager () {

        Object(window_position: Gtk.WindowPosition.CENTER);

        this.set_default_size(700, 600);
        this.destroy.connect(Gtk.main_quit);

        //Css provider
        var provider = new Gtk.CssProvider();
        provider.load_from_path("resources/css/main.css");

        var screen = Gdk.Screen.get_default();
        Gtk.StyleContext context = new Gtk.StyleContext();
        context.add_provider_for_screen(screen, provider, 1);

        //Add application icons to degault icon theme
        new Gtk.IconTheme().get_default().add_resource_path("/org/lcallarec/gnome-docker-manager/resources/icons");

        //Repository
        this.repository = new Docker.Repository(new Docker.UnixSocketClient("d"));

        //Titlebar
        var titlebar = create_titlebar();
        this.set_titlebar(titlebar);

        //Main box
        Gtk.Box main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        this.add(main_box);

        //Headerbar
        var headerbar = create_headerbar(docker_host);
        main_box.pack_start(headerbar, false, true, 5);
        main_box.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), false, true, 0);

        //InfoBar
        var infobar = create_infobar();
        main_box.pack_start(infobar, false, true, 1);

        //// START
        //Main Views
        Ui.MainApplicationView views = new Ui.MainApplicationView();

        //Workspace
        main_box.pack_start(views.workspace, true, true, 0);

        //ApplicationController
        this.ac = new ApplicationController(this, views, new MessageDispatcher(infobar));
        ac.listen_headerbar(headerbar);
        ac.listen_container_view();
    }

    private Gtk.HeaderBar create_titlebar() {

        Gtk.HeaderBar titlebar = new Gtk.HeaderBar();
        titlebar.show_close_button = true;
        titlebar.title = "Gnome Docker Manager";

        return titlebar;
    }

    private Ui.HeaderBar create_headerbar(string docker_host) {

        Ui.HeaderBar headerbar = new Ui.HeaderBar(docker_host);
        return headerbar;
    }

    private Gtk.InfoBar create_infobar() {

        Gtk.InfoBar infobar = new Gtk.InfoBar();
        infobar.set_no_show_all(true);
        return infobar;
    }
}

/**
 * Dispatch messages
 */
public class MessageDispatcher : GLib.Object {

    private Gtk.InfoBar dialog;

    private Gtk.Label label;

    public MessageDispatcher(Gtk.InfoBar infobar) {
        dialog = infobar;
        label  = new Gtk.Label(null);
        dialog.get_content_area().add(label);
    }

    public void dispatch(Gtk.MessageType type, string message) {
        dialog.set_message_type(type);
        label.label = message;
        dialog.show();
        label.show();
    }
}
