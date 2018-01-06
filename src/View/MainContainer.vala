namespace Dockery.View {
    
    public class MainContainer : Gtk.Box, Signals.DockerServiceAware, Signals.DockerHubImageRequestAction {

        public Gtk.HeaderBar headerbar =  new HeaderBar(DockerManager.APPLICATION_NAME, DockerManager.APPLICATION_SUBNAME);
        public Gtk.InfoBar infobar = new Gtk.InfoBar();
        public Gtk.Box local_docker_perspective = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        public SideBar sidebar;
        public global::View.Docker.List.Containers containers;
        public global::View.Docker.List.Images images;
        public Gtk.StackSwitcher perspective_switcher = new Gtk.StackSwitcher();
        public Dockery.View.EventStream.LiveStreamComponent live_stream_component = new Dockery.View.EventStream.LiveStreamComponent();
        private Gtk.Paned local_perspective_paned = new Gtk.Paned(Gtk.Orientation.VERTICAL);
        
        construct {
            this.infobar.set_no_show_all(true);
            this.infobar.show_close_button = true;
            this.infobar.response.connect((id) => {
                infobar.hide();
            });
        }
        
        public MainContainer() {

            Object(orientation: Gtk.Orientation.VERTICAL, spacing: 0);

            //Perspectives
            var perspectives = new Gtk.Stack();

            //Perspective switcher
            this.perspective_switcher = new Gtk.StackSwitcher();
            this.perspective_switcher.set_halign(Gtk.Align.CENTER);
            this.perspective_switcher.set_stack(perspectives);

            this.headerbar.pack_start(this.perspective_switcher);

            //Perspective : Local Docker
            var docker_view = new ListBuilder();

            this.containers = docker_view.create_containers_view();
            this.containers.init(new global::Sdk.Docker.Model.ContainerCollection());

            this.images = docker_view.create_images_view();
            this.images.init(new global::Sdk.Docker.Model.ImageCollection());

            Gtk.Stack stack = new Gtk.Stack();
            stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE);

            this.sidebar = new SideBar(stack);

            //Perspectives
            this.setup_local_docker_perspective(stack);
            perspectives.add_titled(local_perspective_paned, "local-docker", "Local Docker stack");
            this.pack_start(perspectives, true, true, 0);

            //Infobar
            this.pack_end(infobar, false, true, 0);
        }

        private void setup_local_docker_perspective(Gtk.Stack stack) {

            var settings = new Dockery.View.Stacks.SettingsComponent();

            //Start connect signals
            settings.on_docker_service_connect_request.connect((docker_entrypoint) => {
                this.on_docker_service_connect_request(docker_entrypoint);
            });

            settings.on_docker_service_disconnect_request.connect(() => {
                this.on_docker_service_disconnect_request();
            });

            settings.on_docker_service_discover_request.connect(() => {
                this.on_docker_service_discover_request();
            });

            settings.on_docker_public_registry_open_request.connect(() => {
                this.on_docker_public_registry_open_request();
            });

            this.on_docker_service_discover_success.connect(() => {
                settings.on_docker_service_discover_success();
            });

            this.on_docker_service_discover_failure.connect(() => {
                settings.on_docker_service_discover_failure();
            });

            this.on_docker_service_connect_success.connect((docker_entrypoint) => {
                settings.on_docker_service_connect_success(docker_entrypoint);
            });

            this.on_docker_service_connect_failure.connect((docker_entrypoint) => {
                settings.on_docker_service_connect_failure(docker_entrypoint);
            });

            this.on_docker_service_disconnected.connect(() => {
                settings.on_docker_service_disconnected();
            });

            //End connect signals

            Gtk.ScrolledWindow containers_scrolled = new Gtk.ScrolledWindow(null, null);
            containers_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            containers_scrolled.add(containers);

            Gtk.ScrolledWindow images_scrolled = new Gtk.ScrolledWindow(null, null);
            images_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            images_scrolled.add(images);

            stack.add_named(containers_scrolled, "containers");
            stack.add_named(images_scrolled, "images");
            
            local_docker_perspective.pack_start(settings, false, false);
            
            var main_view = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            main_view.pack_start(sidebar, false, true, 0);
            main_view.pack_start(new Gtk.Separator(Gtk.Orientation.VERTICAL), false, true, 0);
            main_view.pack_start(stack, false, true, 0);

            local_docker_perspective.pack_start(main_view, false, true);

            this.local_perspective_paned.add1(local_docker_perspective);
            this.local_perspective_paned.add2(this.live_stream_component);
            
            //Compute paned positions and limits
            this.local_perspective_paned.realize.connect(() => {
                    int pos = this.local_perspective_paned.get_allocated_height() - 22;
                    this.local_perspective_paned.position = pos;
            });

        }
   }

   public class ListBuilder : GLib.Object {

        public global::View.Docker.List.Images create_images_view() {
            return new global::View.Docker.List.Images();
        }

        public global::View.Docker.List.Containers create_containers_view() {
            return new global::View.Docker.List.Containers();
        }
   }
}
