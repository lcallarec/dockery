using Dockery.View;

errordomain ConnectionError {
    WRONG_PROTOCOL,
    UNREACHABLE_HOST
}

/**
 * ApplicationListener is listening to all signals emitted by the view layer
 */
public class ApplicationListener : GLib.Object {

    private Dockery.DockerSdk.Repository? repository;
    private DockerManager window;
    private Dockery.View.MessageDispatcher message_dispatcher;
    private Dockery.View.MainContainer view;
    private Dockery.Listener.ContainerListListener container_list_listener;
    private Dockery.Listener.ImageListListener image_list_listener;
    private Dockery.Listener.VolumeListListener volume_list_listener;
    private Dockery.Listener.DaemonEventListener daemon_event_listener;
    private Dockery.Listener.StackHubListener stack_hub_listener;

    public ApplicationListener(DockerManager window, Dockery.View.MessageDispatcher message_dispatcher) {
        this.window             = window;
        this.view               = window.main_container;
        this.message_dispatcher = message_dispatcher;
    }

    public void listen() {
        
        string? docker_endpoint = discover_connection();
        if (null != docker_endpoint) {
            __connect(docker_endpoint);
        } else {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, "Can't locate docker daemon");
        }
        
        this.listen_daemon_events();
        this.listen_headerbar();
        this.listen_stack_hub();
        this.listen_container_view();
        this.listen_image_view();
        this.listen_volumes_view();
    }

    private void listen_daemon_events() {
        daemon_event_listener = new Dockery.Listener.DaemonEventListener(repository, this.view.live_stream_component);
        daemon_event_listener.listen();
    }

    private void listen_container_view() {
        container_list_listener = new Dockery.Listener.ContainerListListener(window, repository, view.containers);
        container_list_listener.container_states_changed.connect(() => this.init_container_list());
        container_list_listener.feedback.connect((type, message) =>  message_dispatcher.dispatch(type, message));
        container_list_listener.listen();
    }

    private void listen_stack_hub() {
        stack_hub_listener = new Dockery.Listener.StackHubListener(window, repository, view);
        stack_hub_listener.feedback.connect((type, message) =>  message_dispatcher.dispatch(type, message));
        stack_hub_listener.listen();
    }

    private void listen_image_view() {
        image_list_listener = new Dockery.Listener.ImageListListener(window, repository);
        image_list_listener.container_states_changed.connect(() => this.init_container_list());
        image_list_listener.image_states_changed.connect(() => this.init_image_list());
        image_list_listener.feedback.connect((type, message) =>  message_dispatcher.dispatch(type, message));
        image_list_listener.listen();
    }

    private void listen_volumes_view() {
        volume_list_listener = new Dockery.Listener.VolumeListListener(window, repository, view.volumes);
        volume_list_listener.listen();
    }

    private void listen_headerbar() {

        SignalDispatcher.dispatcher().on_docker_daemon_connect_request.connect((docker_endpoint) => {
            __connect(docker_endpoint);
        });

        SignalDispatcher.dispatcher().on_docker_daemon_disconnect_request.connect(() => {
            __disconnect();
        });

         SignalDispatcher.dispatcher().on_docker_daemon_connect_failure.connect((docker_endpoint, e) => {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, "Can't connect docker daemon at %s. Reason: %s".printf(docker_endpoint, e.message));
            this.view.images.init(new Dockery.DockerSdk.Model.ImageCollection());
            this.view.containers.init(new Dockery.DockerSdk.Model.ContainerCollection());
            this.view.volumes.init(new Dockery.DockerSdk.Model.VolumeCollection());
            SignalDispatcher.dispatcher().on_docker_daemon_connect_failure(docker_endpoint, e);
        });

        SignalDispatcher.dispatcher().on_docker_daemon_discover_request.connect(() => {
            string? docker_endpoint = discover_connection();
            if (null != docker_endpoint) {
                __connect(docker_endpoint);
            } else {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, "Can't locate docker daemon");
            }
        });
    }

    protected void init_image_list() {
        Dockery.DockerSdk.Model.ImageCollection images = new Dockery.DockerSdk.Model.ImageCollection();
        try {
            images = repository.images().list();
        } catch (Dockery.DockerSdk.Io.RequestError e) {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
        } finally {
            this.view.images.init(images);
        }
    }

    protected void init_volume_list() {
        Dockery.DockerSdk.Model.VolumeCollection volumes = new Dockery.DockerSdk.Model.VolumeCollection();
        try {
            volumes = repository.volumes().list();
        } catch (Dockery.DockerSdk.Io.RequestError e) {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
        } finally {
            this.view.volumes.init(volumes);
        }
    }

    protected void init_container_list() {
        try {
            var container_collection = new Dockery.DockerSdk.Model.ContainerCollection();

            foreach(Dockery.DockerSdk.Model.ContainerStatus status in Dockery.DockerSdk.Model.ContainerStatus.all()) {
                var containers = repository.containers().list(status);
                container_collection.add_collection(containers);
            }

            this.view.containers.init(container_collection);
        } catch (Dockery.DockerSdk.Io.RequestError e) {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
        }
    }

    protected void __connect(string docker_endpoint) throws Error {

        repository = create_repository(docker_endpoint);
        
        if (repository == null) {
            SignalDispatcher.dispatcher().on_docker_daemon_connect_failure(docker_endpoint, new ConnectionError.WRONG_PROTOCOL("Unkown protocol in %s. Supported protocols are http:// and unix://".printf(docker_endpoint)));
            return;
        }

        repository.connected.connect((repository) => {
            docker_daemon_post_connect(docker_endpoint);
        });

        try {
            repository.connect();
        } catch (Error e) {
            SignalDispatcher.dispatcher().on_docker_daemon_connect_failure(docker_endpoint, new ConnectionError.UNREACHABLE_HOST(e.message));
        }
    }

     protected void __disconnect() {

        SignalDispatcher.dispatcher().on_docker_daemon_disconnected();

        repository = null;

        message_dispatcher.dispatch(Gtk.MessageType.INFO, "Disconnected from Docker daemon");

        this.view.images.init(new Dockery.DockerSdk.Model.ImageCollection());
        this.view.containers.init(new Dockery.DockerSdk.Model.ContainerCollection());
        this.view.volumes.init(new Dockery.DockerSdk.Model.VolumeCollection());
    }

    protected string? discover_connection() {

        var endpoint_discovery = new Dockery.DockerSdk.Endpoint.EndpointDiscovery();

        return endpoint_discovery.discover();
    }


    protected Dockery.DockerSdk.Repository? create_repository(string uri) {

        Dockery.DockerSdk.Client.Client? client = Dockery.DockerSdk.Client.ClientFactory.create_from_uri(uri);

        if (client != null) {
            return new Dockery.DockerSdk.Repository(client, new Dockery.DockerSdk.Client.HttpClient("https://registry.hub.docker.com/v1"));
        }

        return null;
    }

    protected void docker_daemon_post_connect(string docker_endpoint) {
        SignalDispatcher.dispatcher().on_docker_daemon_connect_success(docker_endpoint);
        this.init_image_list();
        this.init_container_list();
        this.init_volume_list();
        message_dispatcher.dispatch(Gtk.MessageType.INFO, "Connected to docker daemon at %s".printf(docker_endpoint));
    }
}
