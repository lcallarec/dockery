
namespace Dockery {

    public class AppWindow : Gtk.Window {

        public const string APPLICATION_NAME = "Dockery";

        public const string APPLICATION_SUBNAME = "A graphical Docker client";

        public View.MainContainer main_container = new View.MainContainer();

        private ApplicationListener application_listener;
        
        public AppWindow () {

            Object(window_position: Gtk.WindowPosition.CENTER);

            this.set_default_size(1000, 650);
            this.destroy.connect(Gtk.main_quit);

            //Css provider
            var provider = this.create_css_provider("css/main.css");

            var screen = Gdk.Screen.get_default();
            Gtk.StyleContext.add_provider_for_screen(screen, provider, 600);

            //Add application icons to degault icon theme
            this.set_icon_theme("icons/");

            //Window Application name & Icon
            this.set_wmclass(Config.APPLICATION_NAME, Config.APPLICATION_NAME);
            this.set_icon_name("docker-icon");

            //View container
            this.add(main_container);

            //// START
            this.set_titlebar(main_container.headerbar);

            //ApplicationListener
            this.application_listener = new ApplicationListener(this, new View.MessageDispatcher(main_container.infobar));
            application_listener.listen();
        }

        protected Gtk.CssProvider create_css_provider(string css_path) {

            var provider = new Gtk.CssProvider();

            #if NOT_ON_TRAVIS
            provider.load_from_resource("/org/lcallarec/dockery/" + css_path);
            #else
            provider.load_from_path(css_path);
            #endif

            return provider;
        }

        protected void set_icon_theme(string icon_path) {
            #if NOT_ON_TRAVIS
            new Gtk.IconTheme().get_default().add_resource_path("/org/lcallarec/dockery/" + icon_path);
            #endif
        }
    }
}
