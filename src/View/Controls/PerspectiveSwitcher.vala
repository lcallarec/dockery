namespace Dockery.View.Controls {

    public class PerspectiveSwitcher : Gtk.StackSwitcher {
        
        public Gtk.Stack perspectives {
            get; construct set;
        }
        
        public PerspectiveSwitcher(Gtk.Stack perspectives) {
            set_halign(Gtk.Align.CENTER);
            set_stack(perspectives);
            this.perspectives = perspectives;
        }

    }

}