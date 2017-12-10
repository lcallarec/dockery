namespace View {

    /**
     * ActiveRule delegate is used by toggle or switch mechanism to determine the active state at runtime
     */
    public delegate bool ActiveRule();
    
    /**
     * Generic ToggleButton with icons
     */ 
    public class IconToggleButton : Gtk.ToggleButton {
 
        protected string active_icon_name    {get; protected set; default = ""; }
        protected string inactive_icon_name  {get; protected set; default = ""; }
        protected Gtk.IconSize icon_size  = Gtk.IconSize.BUTTON;
        protected Gtk.Image icon_image    = new Gtk.Image();
                       
        public IconToggleButton() {
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
        
        construct {
            active_icon_name    = "media-playback-start-symbolic";
            inactive_icon_name  = "media-playback-pause-symbolic";
        }
        
        public PauseButton() {
            base();
        }
        
        public PauseButton.from_active_rule(ActiveRule rule) {
            this.set_active_from_rule(rule);
        }
    }
    
    public class StartStopButton : IconToggleButton {
        
        construct {
            active_icon_name    = "media-playback-stop-symbolic";
            inactive_icon_name  = "media-playback-start-symbolic";
        }
        
        public StartStopButton() {
            base();
        }
        
        public StartStopButton.from_active_rule(ActiveRule rule) {
            this.set_active_from_rule(rule);
        }
    }
}
