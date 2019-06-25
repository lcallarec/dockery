namespace Dockery {

    public class AboutDialog: Gtk.AboutDialog {

        public AboutDialog(Gtk.Window parent) {
            Object();
            this.set_destroy_with_parent(true);
	        this.set_transient_for(parent);
            this.set_modal(true);

            this.set_logo_icon_name("docker-symbolic");
            
            this.authors = {"Laurent Callarec"};
            this.documenters = null;
            this.translator_credits = null;

            this.program_name = AppWindow.APPLICATION_NAME;
            this.comments = AppWindow.APPLICATION_SUBNAME;
            this.copyright = "Copyright © 2015-2019 Laurent Callarec";
            this.version = "0.82.0";

            this.license = null;
            this.wrap_license = true;

            this.website = "https://github.com/lcallarec/dockery";
            this.website_label = "Dockery on Github";

            this.response.connect((response_id) => {
                if (response_id == Gtk.ResponseType.CANCEL || response_id == Gtk.ResponseType.DELETE_EVENT) {
                    this.hide_on_delete();
                }
            });
        }
    }
}