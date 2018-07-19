namespace Dockery.View.Controls {

    public class MainInfoBar : Gtk.InfoBar {
        construct {
            this.set_no_show_all(true);
            this.show_close_button = true;
            this.response.connect((id) => {
                this.hide();
            });
        }
    }
}