using Dockery.View;
using Dockery.DockerSdk;

namespace View.Docker.Menu {

    public class ImageMenuFactory {
        public static ImageMenu create_single(Model.Image image) {
            return new SingleSelectedImageMenu(image);
        }
        
        public static ImageMenu create_multi(Model.ImageCollection images) {
            return new MultiSelectedImageMenu(images);
        }
    }

    public class ImageMenu : Menu {
        
    }
    
    public class SingleSelectedImageMenu : ImageMenu {
        
        protected Model.Image image;

        public SingleSelectedImageMenu(Model.Image image) {

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
            this.append_menu_item("_Remove image", () => {
                SignalDispatcher.dispatcher().images_remove_request(new Model.ImageCollection.from_model(image));
            });
        }

        /**
         * Simple create container from image menu
         */
        protected void append_create_container_menu_item() {
            this.append_menu_item("_Create container", () => {
                SignalDispatcher.dispatcher().image_create_container_request(image);
            });
        }

        /**
         * Create (with...) container from image menu
         */
        protected void append_create_container_with_menu_item() {
            this.append_menu_item("_Create container with...", () => {
                SignalDispatcher.dispatcher().image_create_container_with_request(image);
            });
        }
    }
    
    public class MultiSelectedImageMenu : ImageMenu {
        
        protected Model.ImageCollection images;
        
        public MultiSelectedImageMenu(Model.ImageCollection images) {
            this.images = images;
            this.append_remove_menu_items();
        }
        
         /**
         * Remove images menu
         */
        protected void append_remove_menu_items() {
            this.append_menu_item("_Remove selected images", () => {
                SignalDispatcher.dispatcher().images_remove_request(images);
            });
        }
    }
}
