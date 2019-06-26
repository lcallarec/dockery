namespace Dockery.View {

    public class HeaderBar : Gtk.HeaderBar {

        public HeaderBar(string title, string subtitle) {

            this.show_close_button = true;
            this.title = title;
            this.subtitle = subtitle;

            this.pack_start(build_app_menu());
        }

        private Gtk.MenuButton build_app_menu() {
            var menu_button = new Gtk.MenuButton();
            
            var menu_content =  new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
            menu_content.margin = 10;

            var about_btn = new Gtk.ModelButton();
            about_btn.text = "About " + Config.APPLICATION_NAME;
            about_btn.clicked.connect(() => {
                SignalDispatcher.dispatcher().on_about_dialog();
            });
            
            menu_content.pack_start(about_btn, false, false, 0);

            var popover = new Gtk.Popover(menu_button);
            popover.add(menu_content);

            menu_button.popover = popover;
            menu_button.image = new Gtk.Image.from_icon_name("open-menu-symbolic", Gtk.IconSize.BUTTON);

            menu_content.show_all();

            return menu_button;
        }
    }
}
