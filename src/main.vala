/*
 * DockerManager.vala
 *
 * Laurent Callarec <l.callarec@gmail.com>
 *
 */

public class DockerManager : Gtk.Window {

    private string docker_host = "/var/run/docker.sock";

    public DockerManager () {
        Object(window_position: Gtk.WindowPosition.CENTER);

        this.set_default_size(700, 600);
        this.destroy.connect(Gtk.main_quit);

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
        main_box.pack_start(infobar, false, true, 5);

        //MessageDispatcher
        var md = new MessageDispatcher(infobar);

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
	
		//Global listener	
		headerbar.on_click_search_button(images_view, containers_view, md);
	
    }

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

    private Gtk.InfoBar infobar { get; set;}
    
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
		
		var icon = new Gtk.Image();
		icon.set_from_icon_name("media-optical-symbolic", Gtk.IconSize.BUTTON);
		icon.opacity = 0.5;
		
		containers_box.pack_start(icon, false, true, 5);
		containers_box.pack_start(container_row_label);
	
        add(containers_row);
        select_row(containers_row);
	}
	
	private void add_images_row() {
		Gtk.ListBoxRow images_row = new Gtk.ListBoxRow();
        images_row.height_request = SideBar.ROW_HEIGHT;
		images_row.name = "images"; 

		var images_row_label = new Gtk.Label("Images");
		images_row_label.halign = Gtk.Align.START;
		images_row.add(images_row_label);

        add(images_row);
	}
}

private class HeaderBar : Gtk.Box {
	
	private Gtk.Entry  entry;
	private Gtk.Button search_button;
	
	public HeaderBar(string docker_host) {
		Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);

		this.entry = new Gtk.Entry();
		this.entry.text = docker_host;
		this.entry.width_chars = 30;
		
		this.search_button = new Gtk.Button.from_icon_name("edit-find-symbolic", Gtk.IconSize.BUTTON );
		this.search_button.expand = false;

		this.pack_start(entry, false, true, 3);
		this.pack_start(search_button, false, true, 0);
	}
	
	public void on_click_search_button(View.ImagesView images_view, View.ContainersView containers_view, MessageDispatcher md) {
        
        this.search_button.clicked.connect(() => {
            
            try {
				
                var repository = new Docker.UnixSocketRepository (entry.text);

                Docker.Model.Image[]? images = repository.get_images();
                
                var container_collection = new Docker.Model.Containers();
                
                foreach(Docker.Model.ContainerStatus status in Docker.Model.ContainerStatus.all()) {
					var containers = repository.get_containers(status);
					container_collection.add(status, containers);						
				}
                
                images_view.refresh(images, true);
                containers_view.refresh(container_collection, true);

                md.dispatch(Gtk.MessageType.INFO, "Connected to docker daemon");
                
            } catch (Docker.RequestError e) {
                md.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });
    }
}

/**
 * Dispatch messages 
 */
private class MessageDispatcher : GLib.Object {
    
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
