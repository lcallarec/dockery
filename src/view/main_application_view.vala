namespace View {

   public class MainApplicationView : GLib.Object, Signals.DockerServiceAware, Signals.DockerHubImageRequestAction {

        private Gtk.Box                      main;
        public Gtk.InfoBar                   infobar = new Gtk.InfoBar();
        public Gtk.Box                       local_docker_perspective = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        public SideBar                       sidebar;
        public View.Docker.List.Containers   containers;
        public View.Docker.List.Images       images;
        public Gtk.StackSwitcher             perspective_switcher = new Gtk.StackSwitcher();

        public MainApplicationView(Gtk.Box main) {

            this.main = main;

            //Perspectives
            var perspectives = new Gtk.Stack();

            //Perspective switcher
            perspective_switcher = new Gtk.StackSwitcher();
            this.perspective_switcher.set_halign(Gtk.Align.CENTER);
            perspective_switcher.set_stack(perspectives);

            //Perspective : Local Docker
            var docker_view = new ListBuilder();

            this.containers = docker_view.create_containers_view();
            this.containers.init(new Sdk.Docker.Model.ContainerCollection());

            this.images = docker_view.create_images_view();
            this.images.init(new Sdk.Docker.Model.ImageCollection());

            Gtk.Stack stack = new Gtk.Stack();
            this.sidebar = new View.SideBar(stack);

            //Perspectives
            this.setup_local_docker_perspective(stack);
            perspectives.add_titled(local_docker_perspective, "local-docker", "Local Docker stack");
            //main.pack_start(perspective_switcher, false, false, 5);
            main.pack_start(perspectives, true, true, 0);

            //Infobar
            this.setup_infobar();
            main.pack_end(infobar, false, true, 0);

        }

        private void setup_local_docker_perspective(Gtk.Stack stack) {

            var settings_box = new View.Docker.Stacks.SettingsBox();
            var perspective = new View.Docker.Stacks.Stack(settings_box);

            //Start connect signals
            settings_box.on_docker_service_connect_request.connect((docker_entrypoint) => {
                this.on_docker_service_connect_request(docker_entrypoint);
            });

            settings_box.on_docker_service_disconnect_request.connect(() => {
                this.on_docker_service_disconnect_request();
            });

            settings_box.on_docker_service_discover_request.connect(() => {
                this.on_docker_service_discover_request();
            });

            settings_box.on_docker_public_registry_open_request.connect(() => {
                this.on_docker_public_registry_open_request();
            });

            this.on_docker_service_discover_success.connect(() => {
                settings_box.on_docker_service_discover_success();
            });

            this.on_docker_service_discover_failure.connect(() => {
                settings_box.on_docker_service_discover_failure();
            });

            this.on_docker_service_connect_success.connect((docker_entrypoint) => {
                settings_box.on_docker_service_connect_success(docker_entrypoint);
            });

            this.on_docker_service_connect_failure.connect((docker_entrypoint) => {
                settings_box.on_docker_service_connect_failure(docker_entrypoint);
            });

            this.on_docker_service_disconnected.connect(() => {
                settings_box.on_docker_service_disconnected();
            });

            //End connect signals

            this.local_docker_perspective.pack_start(perspective, false, false);


            var container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

            stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE);

            container.pack_start(sidebar, false, true, 0);

            Gtk.ScrolledWindow containers_scrolled = new Gtk.ScrolledWindow(null, null);
            containers_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            containers_scrolled.add(containers);

            Gtk.ScrolledWindow images_scrolled = new Gtk.ScrolledWindow(null, null);
            images_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            images_scrolled.add(images);

            stack.add_named(containers_scrolled, "containers");
            stack.add_named(images_scrolled,     "images");

            container.pack_start(new Gtk.Separator(Gtk.Orientation.VERTICAL), false, true, 0);
            container.pack_start(stack, true, true, 0);

            this.local_docker_perspective.pack_start(container, true, true);

        }

        private void setup_infobar() {
            this.infobar.set_no_show_all(true);
            this.infobar.show_close_button = true;

            this.infobar.response.connect((id) => {
                infobar.hide();
            });
        }
   }

   public class ListBuilder : GLib.Object {

        public Docker.List.Images create_images_view() {
            return new Docker.List.Images();
        }

        public Docker.List.Containers create_containers_view() {
            return new Docker.List.Containers();
        }
   }

}
