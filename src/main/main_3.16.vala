/*
 * DockerManager.vala
 *
 * Laurent Callarec <l.callarec@gmail.com>
 *
 */
public class DockerManager : BaseDockerManager {

    protected override Gtk.CssProvider create_css_provider(string css_path) {
        var provider = new Gtk.CssProvider();
        provider.load_from_resource("/org/lcallarec/gnome-docker-manager/" + css_path);
        
        return provider;
    }
    
    protected override void set_icon_theme(string icon_path) {
        new Gtk.IconTheme().get_default().add_resource_path("/org/lcallarec/gnome-docker-manager/" + icon_path);
    }
}
