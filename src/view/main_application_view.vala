namespace View {

   public class MainApplicationView : GLib.Object {

        private Gtk.Box                      main;
        public Gtk.InfoBar                   infobar;
        public Gtk.Box                       workspace;
        public SideBar                       sidebar;
        public View.Docker.List.Containers   containers;
        public View.Docker.List.Images       images;
        private ListBuilder                  docker_view;

        public MainApplicationView(Gtk.Box main) {

            this.main = main;

            this.workspace = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

            this.docker_view = new ListBuilder();

            Gtk.Stack stack = new Gtk.Stack();
            stack.set_transition_type(Gtk.StackTransitionType.CROSSFADE);

            this.sidebar = new View.SideBar(stack);
            workspace.pack_start(sidebar, false, true, 0);

            this.containers = this.docker_view.create_containers_view();
            this.containers.init(new Sdk.Docker.Model.ContainerCollection());

            Gtk.ScrolledWindow containers_scrolled = new Gtk.ScrolledWindow(null, null);
            containers_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            containers_scrolled.add(containers);

            this.images = this.docker_view.create_images_view();
            this.images.init(new Sdk.Docker.Model.ImageCollection());

            Gtk.ScrolledWindow images_scrolled = new Gtk.ScrolledWindow(null, null);
            images_scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
            images_scrolled.add(images);

            stack.add_named(containers_scrolled, "containers");
            stack.add_named(images_scrolled,     "images");

            workspace.pack_start(new Gtk.Separator(Gtk.Orientation.VERTICAL), false, true, 0);
            workspace.pack_start(stack, true, true, 0);


            this.infobar = new Gtk.InfoBar();
            infobar.set_no_show_all(true);
            infobar.show_close_button = true;

            infobar.response.connect((id) => {
                infobar.hide();
            });

            //Workspace
            main.pack_start(workspace, true, true, 0);
            main.pack_end(infobar, false, true, 0);

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
