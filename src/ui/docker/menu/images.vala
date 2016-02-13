namespace Ui.Docker.Menu {
    
    using global::Docker.Model;
    
    public class ImageMenuFactory {
        public static ImageMenu create(Image image) {
            return new ImageMenu(image);
        }
    }

    public class ImageMenu : Ui.Docker.ImageActionable, Menu {

        protected Image image;

        public ImageMenu(Image image) {
            this.image = image;
            
            this.append_remove_menu_item();
        }

        protected void append_remove_menu_item() {
            this.append_menu_item("_Remove image", "user-trash-symbolic", () => {
                stdout.puts("menu\n");
                this.image_remove_request(image);
            });
        }
    }
}
