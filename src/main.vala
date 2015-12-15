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

        this.set_size_request(1000, 400);
        this.destroy.connect(Gtk.main_quit);

        //Titlebar
        var titlebar = create_titlebar();
        this.set_titlebar(titlebar);
        
        //Main box
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 1);
        this.add(box);
        
        //ScrolledWindow
        Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(null, null);
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);

        //Headerbar
        var headerbar = create_headerbar(docker_host);
        box.pack_start(headerbar, false, true, 0);

        //InfoBar
        var infobar = create_infobar();
        box.add(infobar);

        //MessageDispatcher
        var md = new MessageDispatcher(infobar);
        
        //Images : Treview and ListStore
        var images_list_store = Store.Images.create_list_store ();
        headerbar.on_click_search_button (images_list_store, md);    
		
		//Images treeview
        var images_tv = new View.ImagesTreeView(images_list_store);

        scrolled.add(images_tv);

        box.pack_start(scrolled, true, true, 0);
    }

    private Gtk.InfoBar infobar { get; set;}

    public static void main (string[] args) {
        Gtk.init(ref args);

        if (Environment.get_variable("RTL") != null) {
            Gtk.Widget.set_default_direction(Gtk.TextDirection.RTL);
        }
        else {
            Gtk.Widget.set_default_direction(Gtk.TextDirection.LTR);
        }

        var dm = new DockerManager();
        dm.show_all(); 
        
        Gtk.main();        
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
	
	public void on_click_search_button(Gtk.ListStore store, MessageDispatcher md) {
        
        this.search_button.clicked.connect(() => {
            
            try {
                var repository = new Docker.UnixSocketRepository (entry.text);

                Docker.Image[]? images = repository.get_images();

                Gtk.TreeIter iter;
                store.clear();
                store.append(out iter);

                foreach(Docker.Image image in images) {
					
                    store.set(iter, 
                        0, image.id.substring(0, 12), 
                        1, image.repository, 
                        2, image.tag,
                        3, new DateTime.from_unix_utc(image.created_at).to_string()
                    );
					
                    store.append(out iter);
                }

                md.dispatch(Gtk.MessageType.INFO, "Connected to docker daemon");
                
            } catch (Docker.RequestError e) {
                md.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });
    }
}

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

