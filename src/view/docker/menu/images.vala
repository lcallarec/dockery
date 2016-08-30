namespace View.Docker.Menu {

    using global::Sdk.Docker.Model;

    public class ImageMenuFactory {
        public static ImageMenu create(Image image) {
            return new ImageMenu(image);
        }
    }

    public class ImageMenu : Signals.ImageRequestAction, Menu {

        protected Image image;

        public ImageMenu(Image image) {

            this.image = image;

            this.append_create_container_menu_item();
            this.append_create_container_with_menu_item();
            this.append_separator_menu_item();
            this.append_remove_menu_item();
        }

        /**
         * Remove image menu
         */
        protected void append_remove_menu_item() {
            this.append_menu_item("_Remove image", null, () => {
                this.image_remove_request(image);
            });
        }

        /**
         * Simple create container from image menu
         */
        protected void append_create_container_menu_item() {
            this.append_menu_item("_Create container", null, () => {
                this.image_create_container_request(image);
            });
        }

        /**
         * Create (with...) container from image menu
         */
        protected void append_create_container_with_menu_item() {
            this.append_menu_item("_Create container with...", null, () => {
                this.image_create_container_with_request(image);
            });
        }
    }
}
