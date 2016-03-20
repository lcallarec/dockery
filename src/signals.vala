namespace Signals {
    
    using Sdk.Docker.Model;
    
    /** Signals emitted on container request actions */ 
    public interface ContainerRequestAction : GLib.Object {
        public signal void container_status_change_request(ContainerStatus status, Container container);
        public signal void container_remove_request(Container container);
        public signal void container_start_request(Container container);
        public signal void container_stop_request(Container container);
        public signal void container_rename_request(Container container, Gtk.Label? label = null);
        public signal void container_kill_request(Container container);
    }
    
    /** Signals emitted on image request actions */ 
    public interface ImageRequestAction : GLib.Object {
        public signal void image_remove_request(Image image);
    }
    
    /** Signals emitted on docker hub image request actions */     
    public interface DockerHubImageRequestAction : GLib.Object {
        
        /** This signal should be emitted when an image is searched in docker hub */
        public signal void search_image_in_docker_hub(DockerHubImageRequestAction target, string term);
        
        public abstract void set_images(Sdk.Docker.Model.HubImage[] images);
    }
}
