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

        this.set_size_request(600, 400);
        this.destroy.connect(Gtk.main_quit);

        //Titlebar
        var titlebar = create_titlebar();
        this.set_titlebar(titlebar);
                
        //Main box
        Gtk.Box main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 1);
        this.add(main_box);

        //Headerbar
        var headerbar = create_headerbar(docker_host);
        main_box.pack_start(headerbar, false, true, 0);
		
        //InfoBar
        var infobar = create_infobar();
        main_box.add(infobar);

        //MessageDispatcher
        var md = new MessageDispatcher(infobar);

        //Image Page box
        Gtk.Box workspace = new Gtk.Box(Gtk.Orientation.VERTICAL, 1);
        main_box.add(workspace);
        
        //Notebook:
        Gtk.Notebook notebook = new Gtk.Notebook();
        workspace.pack_start(notebook, false, true, 1);

        //Image Page box
        Gtk.Box image_page_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
        notebook.append_page(image_page_box, new Gtk.Label("Images"));
	
		var images_view = new View.ImagesView();
		image_page_box.pack_start(images_view, true, true, 0);
		
		headerbar.on_click_search_button(images_view, md);  
     
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
        return infobar;
    }

}

private class HeaderBar : Gtk.HeaderBar {
	
	private Gtk.Entry  entry;
	private Gtk.Button search_button;
	
	public HeaderBar(string docker_host) {
		
		this.search_button = new Gtk.Button.from_icon_name("edit-find", Gtk.IconSize.BUTTON);
		
		this.entry = new Gtk.Entry();
		this.entry.text = docker_host;
		this.entry.width_chars = 30;
		
		this.pack_start(entry);

		this.pack_start(search_button);

	}
	
	public void on_click_search_button(View.ImagesView images_view, MessageDispatcher md) {
        
        this.search_button.clicked.connect(() => {
            
            try {
				
                var repository = new Docker.UnixSocketRepository (entry.text);

                Docker.Image[]? images = repository.get_images();

                images_view.refresh(images, true);

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
    }
    
}

