/*
 * DockerManager.vala
 *
 * Laurent Callarec <l.callarec@gmail.com>
 *
 */
public class DockerManager : Gtk.Window {

    public const string APPLICATION_NAME = "Dockery";

    public const string APPLICATION_SUBNAME = "A graphical Docker client";

    private Gtk.InfoBar infobar { get; set;}

    private ApplicationController ac;

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
        var provider = this.create_css_provider("resources/css/main.css");

        var screen = Gdk.Screen.get_default();
        Gtk.StyleContext.add_provider_for_screen(screen, provider, 600);

        //Add application icons to degault icon theme
        this.set_icon_theme("resources/icons/");

        //Window Application name & Icon
        this.set_wmclass(DockerManager.APPLICATION_NAME, DockerManager.APPLICATION_NAME);
        this.set_icon_name("docker-icon");

        //Main box
        Gtk.Box main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        this.add(main_box);

        //// START
        //Main Views
        View.MainApplicationView views = new View.MainApplicationView(this);

        //Workspace
        main_box.pack_start(views.headerbar, false, true, 0);
        main_box.pack_start(views.workspace, true, true, 0);
        main_box.pack_end(views.infobar, false, true, 0);

        //ApplicationController
        this.ac = new ApplicationController(this, views, new MessageDispatcher(views.infobar));
        ac.listen_headerbar();
        ac.listen_docker_hub();
        ac.listen_container_view();
        ac.listen_image_view();
    }

    protected Gtk.CssProvider create_css_provider(string css_path) {

        var provider = new Gtk.CssProvider();

        #if GTK_LTE_3_14
        provider.load_from_path(css_path);
        #endif

        #if GTK_GTE_3_16
        provider.load_from_resource("/org/lcallarec/dockery/" + css_path);
        #endif

        return provider;
    }

    protected void set_icon_theme(string icon_path) {
        #if GTK_GTE_3_16
        new Gtk.IconTheme().get_default().add_resource_path("/org/lcallarec/dockery/" + icon_path);
        #endif
    }
}

/**
 * Dispatch messages
 */
public class MessageDispatcher : GLib.Object {

    private Gtk.InfoBar infobar;

    private Gtk.Label label;

    public MessageDispatcher(Gtk.InfoBar bar) {
        infobar = bar;
        label   = new Gtk.Label(null);
        label.wrap = true;
        label.wrap_mode = Pango.WrapMode.WORD_CHAR;
        infobar.get_content_area().add(label);
    }

    public void dispatch(Gtk.MessageType type, string message) {
        infobar.set_message_type(type);
        label.label = message;
        infobar.show();
        label.show();
    }
}
