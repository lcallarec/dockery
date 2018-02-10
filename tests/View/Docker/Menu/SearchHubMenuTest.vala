using Dockery.DockerSdk;
using Dockery.View.Hub;

private void register_view_menu_search_hub_menu_test() {

    Test.add_func("/Dockery/View/Menu/SearchHubMenu#Activate", () => {

        var hub_image = new Model.HubImage.from("a description", false, false, "dockery/dockery", 1);

        var menu = SearchHubMenuFactory.create(hub_image, new Model.ImageTagCollection());
        
        bool connect_was_called = false;
        menu.foreach((widget) => {
            menu.pull_image_from_docker_hub.connect((target, image) => {
                connect_was_called = true;
                assert(image.name == "dockery/dockery");
            });
            widget.activate();
        });

        assert(connect_was_called == true);
               
    });
}