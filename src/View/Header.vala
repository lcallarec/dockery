namespace Dockery.View {

    public class HeaderBar : Gtk.HeaderBar {

        public HeaderBar(string? title, string? subtitle) {

            this.show_close_button = true;
            this.title = title;

            if (null != subtitle) {
                this.subtitle = subtitle;
            }
        }
    }
}
