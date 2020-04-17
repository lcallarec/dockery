namespace View.Docker.Menu {


    public abstract class Menu : Gtk.Menu {

        protected void append_separator_menu_item() {
            this.add(new Gtk.SeparatorMenuItem());
        }

        protected void append_menu_item(string mnemonic_label, onMenuActivate? action) {

            var menu_item  = new Gtk.MenuItem.with_mnemonic(mnemonic_label);

            if (null != action) {
                menu_item.activate.connect(() => action());
            }

            this.add(menu_item);
        }

        /**
         * Delegate for menu activate signal
         */
        public delegate void onMenuActivate();
    }
}
