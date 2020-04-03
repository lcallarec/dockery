void main (string[] args) {

    Test.init(ref args);
    Gtk.init(ref args);
    
    //Gtk tools
    register_view_child_widget_finder_test();

    //View/Container
    register_view_container_listall_test();

    //View/Image
    register_view_image_listall_test();
    
    //View/Menu/
    register_view_menu_search_hub_menu_test();
    register_dockery_view_objectlist_volumes_test();

    //View/Buttons
    register_view_buttons_test();

    //View/Controls
    register_view_controls_container_buttons_row();

    //View/EventStream
    register_view_event_streams_live_component_test();

    Test.run();
}