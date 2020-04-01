using global::Dockery.DockerSdk;

private void register_sdk_http_endpoint_discovery_test() {

    Test.add_func("/Dockery/DockerSdk/Endpoint/HttpEndpointDiscovery/#EnpointIsTheFirstOfKnownEndpoints", () => {
        //Given
        var server = create_mock_server();
        MainLoop loop = new MainLoop();
        new GLib.Thread<int>("mock_server_start", () => {
            try {
                server.listen_local(2380, Soup.ServerListenOptions.IPV4_ONLY);
                loop.run();
            } catch (Error e) {
                stdout.printf("ERROR : %s", e.message);
                assert_not_reached();
            }
            return 0;
        });

        Thread.usleep(2000);
        
        string[] endpoints = {"http://127.0.0.1:2380", "http://127.0.0.1:2381", "http://127.0.0.1:2382"};

        //When
        var http_discoverer = new Endpoint.HttpEndpointDiscovery.from_endpoints(endpoints);
        var uri = http_discoverer.discover();
 
        //Then
        assert(uri == "http://127.0.0.1:2380");
        loop.quit();
    });


    Test.add_func("/Dockery/DockerSdk/Endpoint/HttpEndpointDiscovery/#EnpointIsTheLastOfKnownEndpoints", () => {
        // Given
        var server = create_mock_server();
        MainLoop loop = new MainLoop();
        new GLib.Thread<int>("mock_server_start", () => {
            try {
                server.listen_local(2382, Soup.ServerListenOptions.IPV4_ONLY);
                loop.run();
            } catch (Error e) {
                stdout.printf("ERROR : %s", e.message);                
                assert_not_reached();
            }
            return 0;
        });

        Thread.usleep(2000);

        string[] endpoints = { "http://127.0.0.1:2380", "http://127.0.0.1:2381", "http://127.0.0.1:2382" };

        // When
        var http_discoverer = new Endpoint.HttpEndpointDiscovery.from_endpoints(endpoints);
        var uri = http_discoverer.discover();

        // Then
        assert(uri == "http://127.0.0.1:2382");
        loop.quit();
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
