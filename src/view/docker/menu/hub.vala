namespace View.Docker.Menu {

    using global::Sdk.Docker.Model;

    public class SearchHubMenuFactory {
        public static SearchHubMenu create(HubImage image) {
            return new SearchHubMenu(image);
        }
    }

    public class SearchHubMenu : Signals.DockerHubImageRequestAction, Menu {

        private HubImage image;

        public SearchHubMenu(HubImage image) {
            this.image = image;
            append_pull_menu_item();
        }

        protected void append_pull_menu_item() {
            this.append_menu_item("_Pull %s from Docker Hub".printf(image.name), null, () => {
                this.pull_image_from_docker_hub(image);
            });
        }
    }
}
