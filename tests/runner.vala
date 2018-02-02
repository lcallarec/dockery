void main (string[] args) {
    Test.init (ref args);
    register_image_deserializer_test();
    register_container_deserializer_test();

    //DockerSdk/Io
    register_http_response_factory_test();

    //
    Test.run();
}