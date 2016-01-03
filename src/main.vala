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

        //Workspace
        Gtk.Box workspace = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        main_box.pack_start(workspace, true, true, 0);
        
        //Stack
        Gtk.Stack stack = new Gtk.Stack();
        stack.set_transition_type(Gtk.StackTransitionType.OVER_UP_DOWN);
                
        //Left view
        SideBar sidebar = new SideBar(stack);
        workspace.pack_start(sidebar, false, true, 0);

        //Container Page
        var containers_view = new View.ContainersView();
        
      
        
        Gtk.ScrolledWindow containers_view_scrolled = new Gtk.ScrolledWindow(null, null); 
        containers_view_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        containers_view_scrolled.add(containers_view);

        //Image Page
        var images_view = new View.ImagesView();
        Gtk.ScrolledWindow images_view_scrolled = new Gtk.ScrolledWindow(null, null); 
        images_view_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        images_view_scrolled.add(images_view);

        //Stack add children
        stack.add_named(containers_view_scrolled, "containers");
        stack.add_named(images_view_scrolled, "images");
    
        workspace.pack_start(new Gtk.Separator(Gtk.Orientation.VERTICAL), false, true, 0);
        workspace.pack_start(stack, true, true, 0);
        
        //ApplicationController
        this.ac = new ApplicationController(containers_view, images_view, new MessageDispatcher(infobar));
        ac.listen_headerbar(headerbar);
        ac.listen_container_view();
    }
    
    private Gtk.HeaderBar create_titlebar() {
        
        Gtk.HeaderBar titlebar = new Gtk.HeaderBar();
        titlebar.show_close_button = true;
        titlebar.title = "Gnome Docker Manager";

        return titlebar;
    }

    private HeaderBar create_headerbar(string docker_host) {

        HeaderBar headerbar = new HeaderBar(docker_host);
        return headerbar;
    }
    
    private Gtk.InfoBar create_infobar() {

        Gtk.InfoBar infobar = new Gtk.InfoBar();
        infobar.set_no_show_all(true);
        return infobar;
    }
}

private class SideBar : Gtk.ListBox {
    
    private const int8 ROW_HEIGHT = 30;
    
    public SideBar(Gtk.Stack stack) {
        width_request = 150;
        row_activated.connect((row) => {
            stack.set_visible_child_name(row.name);
        });
        
        set_header_func(add_row_header);
        
        add_containers_row();
        add_images_row();
    }

    public void add_row_header(Gtk.ListBoxRow row, Gtk.ListBoxRow? before) {
        if (before != null) {
            row.set_header(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));    
        }
    }
    
    private void add_containers_row() {
        Gtk.ListBoxRow containers_row = new Gtk.ListBoxRow();
        containers_row.height_request = SideBar.ROW_HEIGHT;
        containers_row.name = "containers"; 

        var containers_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        containers_box.height_request = SideBar.ROW_HEIGHT;
        
        var container_row_label = new Gtk.Label("Containers");
        container_row_label.halign = Gtk.Align.START;
        containers_row.add(containers_box);
        
        var icon = new Gtk.Image.from_icon_name("docker-symbolic", Gtk.IconSize.BUTTON);
        icon.opacity = 1;

        containers_box.pack_start(icon, false, true, 5);
        containers_box.pack_start(container_row_label);
    
        add(containers_row);
        select_row(containers_row);
    }
    
    private void add_images_row() {
        Gtk.ListBoxRow images_row = new Gtk.ListBoxRow();
        images_row.height_request = SideBar.ROW_HEIGHT;
        images_row.name = "images"; 

        var images_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        images_box.height_request = SideBar.ROW_HEIGHT;

        var images_row_label = new Gtk.Label("Images");
        images_row_label.halign = Gtk.Align.START;
    
        images_row.add(images_box);
        
        var icon = new Gtk.Image();
        icon.set_from_icon_name("media-optical-symbolic", Gtk.IconSize.BUTTON);
        icon.opacity = 0.7;
        
        images_box.pack_start(icon, false, true, 5);
        images_box.pack_start(images_row_label);
    
        add(images_row);
    }
}

public class HeaderBar : Gtk.Box {
    
    private Gtk.Entry  entry;
    private Gtk.Button search_button;
    
    public signal void docker_daemon_lookup_request(string docker_path);
    
    public HeaderBar(string docker_host) {
        Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

        this.entry = new Gtk.Entry();
        this.entry.text = docker_host;
        this.entry.width_chars = 30;
        
        this.search_button = new Gtk.Button.from_icon_name("edit-find-symbolic", Gtk.IconSize.BUTTON);
        this.search_button.expand = false;

        this.pack_start(entry, false, true, 3);
        this.pack_start(search_button, false, true, 0);
        
        this.search_button.clicked.connect(() => {
            this.docker_daemon_lookup_request(entry.text);
        });
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

/*
 * ApplicationController is listening to all signals emitted by the view layer
 */ 
public class ApplicationController : GLib.Object {
    
    private Docker.Repository repository;
    private MessageDispatcher message_dispatcher;
    private View.ContainersView containers_view;
    private View.ImagesView images_view;
    
    public ApplicationController(View.ContainersView containers_view, View.ImagesView images_view, MessageDispatcher message_dispatcher) {
        this.message_dispatcher = message_dispatcher;
        this.containers_view = containers_view;
        this.images_view = images_view;
           this.repository = create_repository("/var/run/docker.sock");
                
                this.refresh_image_list();
                this.refresh_container_list();
    }
    
    public void listen_container_view() {
        containers_view.container_status_change_request.connect((requested_status, container) => {
            
            try {
                if (requested_status == Docker.Model.ContainerStatus.PAUSED) {
                    repository.containers().unpause(container);    
                } else if (requested_status == Docker.Model.ContainerStatus.RUNNING) {
                    repository.containers().pause(container);
                }
                message_dispatcher.dispatch(Gtk.MessageType.INFO, "ok");
                
            } catch (Docker.IO.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
            
            this.refresh_container_list();
        });
    }
    
    public void listen_headerbar(HeaderBar headerbar) {
        headerbar.docker_daemon_lookup_request.connect((docker_path) => {
            try {
                
                this.repository = create_repository(docker_path);
                
                this.refresh_image_list();
                this.refresh_container_list();
                
                message_dispatcher.dispatch(Gtk.MessageType.INFO, "Connected to docker daemon");
                
            } catch (Docker.IO.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });
    }
    
    protected void refresh_image_list() {
        Docker.Model.Image[]? images = repository.images().list();
        this.images_view.refresh(images, true);
    }
    
    protected void refresh_container_list() {
        
        var container_collection = new Docker.Model.Containers();
         foreach(Docker.Model.ContainerStatus status in Docker.Model.ContainerStatus.all()) {
            var containers = repository.containers().list(status);
            container_collection.add(status, containers);                        
        }
        
        this.containers_view.refresh(container_collection, true);
    }
    
    protected Docker.Repository create_repository(string docker_path) {
        return new Docker.Repository(new Docker.UnixSocketClient(docker_path));
    }
}
