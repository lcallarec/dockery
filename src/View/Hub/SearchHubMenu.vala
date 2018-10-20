using Dockery.View;

namespace Dockery.View.Hub {

    using global::Dockery.DockerSdk.Model;

    public class SearchHubMenuFactory {
        public static SearchHubMenu create(HubImage image, ImageTagCollection tags) {
            return new SearchHubMenu(image, tags);
        }
    }

    public class SearchHubMenu : global::View.Docker.Menu.Menu {

        private HubImage image;
        private ImageTagCollection tags;

        public SearchHubMenu(HubImage image, ImageTagCollection tags) {
            this.image = image;
            this.tags = tags;
            append_pull_menu_item();
        }

        protected void append_pull_menu_item() {
            this.append_menu_item("_Pull all tags of %s image".printf(image.name), null, () => {
                SignalDispatcher.dispatcher().pull_image_from_docker_hub(null, image);
            });
            this.append_menu_item("_Pull specific tags of %s image".printf(image.name), null, () => {
                SignalDispatcher.dispatcher().pull_image_from_docker_hub(null, image);
            });
        }
    }
}
