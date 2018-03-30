void main (string[] args) {
    Test.init (ref args);
    
    Gtk.init(ref args);
register_view_child_widget_finder_test();
    //DockerSdk/Deserializer
    register_image_deserializer_test();
    register_container_deserializer_test();
    register_image_tag_deserializer_test();

    //DockerSdk/Io
    register_http_response_factory_test();

    //DockerSdk/Endpoint
    register_sdk_endpoint_server_test();

    //DockerSdk/Model
    register_dockersdk_model_container_status_converter_test();
    //DockerSdk/Model/Remote
    register_dockersdk_serializer_pull_step_deserializer_test();
    register_dockersdk_remote_processor_pulling_image_progress_processor_test();
    
    //View/Menu/
    register_view_menu_search_hub_menu_test();
    register_dockery_view_objectlist_volumes_test();
    
    //
    Test.run();
}