using global::Dockery.DockerSdk;

private void register_sdk_http_endpoint_discovery_test() {

    Test.add_func("/Dockery/DockerSdk/Endpoint/HttpEndpointDiscovery/#EnpointIsTheFirstOfKnownEndpoints", () => {
        //Given
        var server = create_mock_server(2380);
        new GLib.Thread<int>("mock_server_start", () => {
            server.run();
            return 0;
        });

        Thread.usleep(2000);
        
        string[] endpoints = {"http://127.0.0.1:2380", "http://127.0.0.1:2381", "http://127.0.0.1:2382"};

        //When
        var http_discoverer = new Endpoint.HttpEndpointDiscovery.from_endpoints(endpoints);
        var uri = http_discoverer.discover();
 
        //Then
        assert(uri == "http://127.0.0.1:2380");
        server.quit();
    });


    Test.add_func("/Dockery/DockerSdk/Endpoint/HttpEndpointDiscovery/#EnpointIsTheLastOfKnownEndpoints", () => {
        // Given
        var server = create_mock_server(2382);
        new GLib.Thread<int>("mock_server_start", () => {
            server.run();
            return 0;
        });

        Thread.usleep(2000);

        string[] endpoints = { "http://127.0.0.1:2380", "http://127.0.0.1:2381", "http://127.0.0.1:2382" };

        // When
        var http_discoverer = new Endpoint.HttpEndpointDiscovery.from_endpoints(endpoints);
        var uri = http_discoverer.discover();

        // Then
        assert(uri == "http://127.0.0.1:2382");
        server.quit();
    });

    Test.add_func("/Dockery/DockerSdk/Endpoint/HttpEndpointDiscovery/#NoEndpointsExist", () => {
        // Given
        string[] endpoints = { "http://127.0.0.1:2380", "http://127.0.0.1:2381", "http://127.0.0.1:2382" };

        // When
        var http_discoverer = new Endpoint.HttpEndpointDiscovery.from_endpoints(endpoints);
        var uri = http_discoverer.discover();

        // Then
        assert(uri == null);
    });
}
