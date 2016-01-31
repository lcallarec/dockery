namespace Ui.Docker {
    
    using global::Docker.Model;
    
    public interface ContainerActionable {
        public signal void container_status_change_request(ContainerStatus status, Container container);
        public signal void container_remove_request(Container container);
        public signal void container_start_request(Container container);
        public signal void container_stop_request(Container container);
    }

    public interface Flushable : Gtk.Container {
        /**
         * Remove all child widgets from the container
         */
        public virtual void flush() {
            this.@foreach((widget) => {
                this.remove(widget);
            });
        }
    }

    public interface ImageViewable : Gtk.Widget {

        /**
         * Flush all child widgets from the view
         * Add new rows from images array
         */
        public abstract int refresh(Image[] images, bool show_after_refresh = false);
    }

    public interface ContainerViewable : Gtk.Widget {

        /**
         * Flush all child widgets from the view
         * Add new rows from containers array
         */
        public abstract int refresh(Containers containers, bool show_after_refresh = false);
    }
    
    public interface IconMessageBoxBuilder {
        
        public static Gtk.Box create_icon_message_box(string message, string icon_name) {
            
            var image = new Gtk.Image.from_icon_name(icon_name, Gtk.IconSize.DIALOG);
            
            image.pixel_size = 164;
            image.opacity = 0.2;
            
            var label = new Gtk.Label(message);
            label.attributes = Fonts.get_panel_empty_major();
            
            var box = new Gtk.VBox(false, 0);

            box.valign = Gtk.Align.CENTER;
            box.pack_start(image, true, false, 0);
            box.pack_start(label, false, false, 0);
            
            return box;
        }
        
    }
}
