/*
 * ApplicationController is listening to all signals emitted by the view layer
 */ 
public class ApplicationController : GLib.Object {
    
    private Docker.Repository repository;
    private Gtk.Window window;
    private MessageDispatcher message_dispatcher;
    private Ui.DockerContainersList containers_list;
    private Ui.DockerImagesList images_list;
    
    public ApplicationController(Gtk.Window window, Ui.DockerContainersList containers_list, Ui.DockerImagesList images_list, MessageDispatcher message_dispatcher) {
        this.message_dispatcher = message_dispatcher;
        this.containers_list    = containers_list;
        this.images_list        = images_list;
        this.window             = window;
    }
    
    public void listen_container_view() {
        
        containers_list.container_status_change_request.connect((requested_status, container) => {
            
            try {
                string message = "";
                if (requested_status == Docker.Model.ContainerStatus.PAUSED) {
                    repository.containers().unpause(container);    
                    message = "Container %s successfully unpaused".printf(container.id);
                } else if (requested_status == Docker.Model.ContainerStatus.RUNNING) {
                    repository.containers().pause(container);
                    message = "Container %s successfully paused".printf(container.id);
                }

                this.refresh_container_list();                
                message_dispatcher.dispatch(Gtk.MessageType.INFO, message);
                
            } catch (Docker.IO.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });
        
        containers_list.container_remove_request.connect((container) => {
            
            Gtk.MessageDialog msg = new Gtk.MessageDialog(
                window, Gtk.DialogFlags.MODAL,
                Gtk.MessageType.WARNING,
                Gtk.ButtonsType.OK_CANCEL,
                "Really remove the container %s (%s)?".printf(container.name, container.id)
            );
            
            msg.response.connect ((response_id) => {
                switch (response_id) {
                    case Gtk.ResponseType.OK:
                        repository.containers().remove(container);
                        this.refresh_container_list();
                        break;
                    case Gtk.ResponseType.CANCEL:
                        break;
                    case Gtk.ResponseType.DELETE_EVENT:
                        break;
                }

                msg.destroy();
            
            });
            
            msg.show();  
        });
    }
    
    public void listen_headerbar(Ui.HeaderBar headerbar) {
        
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
    
    protected void refresh_image_list() throws Docker.IO.RequestError {
        Docker.Model.Image[]? images = repository.images().list();
        this.images_list.refresh(images, true);
    }
    
    protected void refresh_container_list() throws Docker.IO.RequestError {
        
        var container_collection = new Docker.Model.Containers();
        
        foreach(Docker.Model.ContainerStatus status in Docker.Model.ContainerStatus.all()) {
            var containers = repository.containers().list(status);
            container_collection.add(status, containers);                        
        }
        
        this.containers_list.refresh(container_collection, true);
    }
    
    protected Docker.Repository create_repository(string docker_path) {
        return new Docker.Repository(new Docker.UnixSocketClient(docker_path));
    }
}
