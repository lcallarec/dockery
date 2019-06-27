namespace View.Docker {

    using global::Dockery.DockerSdk.Model;

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
         * Init the images view from a given collection of images
         */
        public abstract View.Docker.List.Images init(ImageCollection images, bool show_after_refresh = true);
    }

    public interface VolumeViewable : Gtk.Widget {

        /**
         * Init the volumes view from a given collection of volumes
         */
        public abstract Dockery.View.Volume.ListAll init(VolumeCollection volumes, bool show_after_refresh = true);
    }

    /**
     *
     */
    public interface ContainerViewable : Gtk.Widget {

        /**
         * Init the container view from a given collection of containers and return it
         */
        public abstract Dockery.View.Container.ListAll init(ContainerCollection containers, bool show_after_refresh = true);
    }

    /**
     * Return a box containing a big icon and a message
     */
    public interface IconMessageBoxBuilder {

        public static Gtk.Box create_icon_message_box(string message, string icon_name) {

            var image = new Gtk.Image.from_icon_name(icon_name, Gtk.IconSize.DIALOG);
            image.set_name("icon-image-box");

            image.pixel_size = 164;
            image.opacity = 0.2;

            var label = new Gtk.Label(message);
            label.attributes = Dockery.View.Fonts.get_panel_empty_major();

            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            box.set_name(@"empty-box-$icon_name");
            
            box.valign = Gtk.Align.CENTER;
            box.pack_start(image, true, false, 0);
            box.pack_start(label, false, false, 0);

            return box;
        }

        public static Gtk.Box create_icon_box(string icon_name) {

            var image = new Gtk.Image.from_icon_name(icon_name, Gtk.IconSize.DIALOG);

            image.pixel_size = 164;
            image.opacity = 0.2;

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

            box.valign = Gtk.Align.CENTER;
            box.pack_start(image, true, false, 0);

            return box;
        }
    }
}
