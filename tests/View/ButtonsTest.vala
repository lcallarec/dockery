using Dockery.View;

private void register_view_buttons_test() {

    Test.add_func("/Dockery/View/Buttons#IconToggleButton", () => {
        //given
        var button = new IconToggleButton("view-refresh-symbolic", "media-playback-start-symbolic");
        
        //when the button is displayed for the first time
        //Then
        assert(button.active == false);
        Gtk.Image image = button.image as Gtk.Image;
        stdout.printf("icon name : %s\n", image.icon_name);
        assert(image.icon_name == "view-refresh-symbolic");

        //when
        button.clicked();
        //Then
        assert(button.active == true);
        image = button.image as Gtk.Image;
        stdout.printf("icon name : %s\n", image.icon_name);
        assert(image.icon_name == "media-playback-start-symbolic");
    });    
}