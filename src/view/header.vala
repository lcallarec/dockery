namespace View {

    public class HeaderBar : Gtk.HeaderBar {

        /** Interact with Docker Hub **/
        private Gtk.Button action_hub_button;

        /** Gtk entry where user can fill the docker connection info */
        private Gtk.Entry  entry;

        public HeaderBar(string? title, string? subtitle) {

            this.show_close_button = true;
            this.title = title;

            if (null != subtitle) {
                this.subtitle = subtitle;
            }
        }
    }
}
