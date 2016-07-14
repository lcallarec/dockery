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
            
            this.append_remove_menu_item();
        }

        protected void append_remove_menu_item() {
            this.append_menu_item("_Remove image", "user-trash-symbolic", () => {
                this.image_remove_request(image);
            });
        }
    }
}