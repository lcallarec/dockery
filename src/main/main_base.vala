/*
 * DockerManager.vala
 *
 * Laurent Callarec <l.callarec@gmail.com>
 *
 */
public class DockerManager : BaseDockerManager {

    protected override Gtk.CssProvider create_css_provider(string css_path) {
        
        var provider = new Gtk.CssProvider();
        provider.load_from_path(css_path);
        
        return provider;
    }
    
    protected override void set_icon_theme(string icon_path) {
       
    }    
}
