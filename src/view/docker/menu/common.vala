namespace View.Docker.Menu {


    public abstract class Menu : Gtk.Menu {

        protected void append_separator_menu_item() {
            this.add(new Gtk.SeparatorMenuItem());
        }

        protected void append_menu_item(string mnemonic_label, string? icon_name, onMenuActivate? action) {

            var menu_item  = new Gtk.ImageMenuItem.with_mnemonic(mnemonic_label);

            if (null != icon_name) {
                var menu_image = new Gtk.Image();
                menu_image.set_from_icon_name(icon_name, Gtk.IconSize.MENU);
                menu_item.always_show_image = true;
                menu_item.set_image(menu_image);
            }

            //if (null != action) {
                menu_item.activate.connect(() => action());
            //}

            this.add(menu_item);
        }

        /**
         * Delegate for menu activate signal
         */
        public delegate void onMenuActivate();
    }
}
