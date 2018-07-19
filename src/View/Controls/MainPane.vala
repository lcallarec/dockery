namespace Dockery.View.Controls {

    public class MainPane : Gtk.StackSwitcher {
        
        public Gtk.Stack perspectives {
            get; construct set;
        }
        
        public MainPane(Gtk.Stack perspectives) {
            set_halign(Gtk.Align.CENTER);
            set_stack(perspectives);
            this.perspectives = perspectives;
        }

    }

}