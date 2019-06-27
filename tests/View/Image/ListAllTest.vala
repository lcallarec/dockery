using Dockery.View;
using Dockery.DockerSdk;

private void register_view_image_listall_test() {

    Test.add_func("/Dockery/View/Image/ListAll#NoImages", () => {
        //given
        var view = new Image.ListAll();
        var images = new Model.ImageCollection();

        //When
        view.init(images);
        
        //Then
        var empty = ChildWidgetFinder.find_by_name(view, "empty-box-docker-symbolic");
        assert(empty != null);
    });
}