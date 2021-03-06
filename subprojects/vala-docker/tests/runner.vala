void main (string[] args) {

    Test.init(ref args);

    //DockerSdk/Deserializer
    register_image_deserializer_test();
    register_container_deserializer_test();
    register_image_tag_deserializer_test();
    register_container_stat_deserializer_test();
    register_container_event_deserializer_test();

    //DockerSdk/Endpoint
    register_sdk_http_endpoint_discovery_test();
    register_sdk_unix_socket_endpoint_discovery_test();
    register_sdk_endpoint_discovery_test();

    //DockerSdk/Io
    register_http_response_factory_test();

    //DockerSdk/Endpoint
    register_sdk_endpoint_server_test();

    //DockerSdk/Model
    register_dockersdk_model_container_status_converter_test();
    register_dockersdk_model_container_collection();
    register_dockersdk_model_container_allowed_actions_test();
    register_dockersdk_model_image_collection();
    
    //DockerSdk/Model/Remote
    register_dockersdk_serializer_pull_step_deserializer_test();
    register_dockersdk_remote_processor_pulling_image_progress_processor_test();
    
    //Common
    register_unit_bytes_test();

    Test.run();
}