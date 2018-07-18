namespace Dockery.View {

    /**
     * ActiveRule delegate is used by toggle or switch mechanism to determine the active state at runtime
     */
    public delegate bool ActiveRule();
    
    /**
     * Generic ToggleButton with icons
     */ 
    public class IconToggleButton : Gtk.ToggleButton {
 
        public string active_icon_name    {get; construct set; default = ""; }
        public string inactive_icon_name  {get; construct set; default = ""; }
        protected Gtk.IconSize icon_size  = Gtk.IconSize.BUTTON;
        protected Gtk.Image icon_image    = new Gtk.Image();
        
        public IconToggleButton(string inactive_icon_name, string active_icon_name) {
            this.inactive_icon_name = inactive_icon_name;
            this.active_icon_name = active_icon_name;
            
            this.image = icon_image;
            this.set_new_icon_by_name(guess_icon_from_state(active));
            this.notify["active"].connect(() => {
                this.set_new_icon_by_name(guess_icon_from_state(active));
            });
        }
        
        protected void set_active_from_rule(ActiveRule rule) {
            active = rule();
        }
        
        protected string guess_icon_from_state(bool state) {
            if (true == state) {
                return active_icon_name;
            } else {
                return inactive_icon_name;
            }  
        }
        
        protected void set_new_icon_by_name(string icon_name) {
            icon_image.set_from_icon_name(icon_name, icon_size);
        }
    }

    public class PauseButton : IconToggleButton {
        
        public PauseButton() {
            base("media-playback-start-symbolic", "media-playback-start-symbolic");
        }
        
        public PauseButton.from_active_rule(ActiveRule rule) {
            base("media-playback-start-symbolic", "media-playback-start-symbolic");
            this.set_active_from_rule(rule);
        }
    }
    
    public class StartStopButton : IconToggleButton {

        public StartStopButton() {
            base("media-playback-stop-symbolic", "media-playback-start-symbolic");
        }
        
        public StartStopButton.from_active_rule(ActiveRule rule) {
            base("media-playback-stop-symbolic", "media-playback-start-symbolic");            
            this.set_active_from_rule(rule);
        }
    }
}
