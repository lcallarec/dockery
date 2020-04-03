using global::Dockery.DockerSdk;

private void register_sdk_unix_socket_endpoint_discovery_test() {

    Test.add_func("/Dockery/DockerSdk/Endpoint/UnixSocketEndpointDiscovery/#EnpointIsTheFirstOfKnownEndpoints", () => {

        //Given
        File file = File.new_for_path ("mock-docker.sock");
        
        try {
            if(file.query_exists()) {
                file.delete();
            }
            FileOutputStream os = file.create(FileCreateFlags.PRIVATE);
            os.write("\n".data);
    
            string[] unix_sockets = { "mock-docker.sock", "does-not-exists.sock", "does-not-exists-bis.sock" };
    
            //When
            var unix_discoverer = new Endpoint.UnixSocketEndpointDiscovery.from_unix_sockets(unix_sockets);
            var uri = unix_discoverer.discover();

            //Then
            assert(uri == "unix://mock-docker.sock");

            //Clean
            if (file.query_exists()) {
                file.delete ();
            }

        } catch (Error e) {
            assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Endpoint/UnixSocketEndpointDiscovery/#EnpointIsTheLastOfKnownEndpoints", () => {

        // Given
        File file = File.new_for_path ("mock-docker.sock");
        if (file.query_exists()) {
            try {
                file.delete();
            } catch (Error e) {
                assert_not_reached();
            }
        }
        try {
            FileOutputStream os = file.create(FileCreateFlags.PRIVATE);
            os.write("\n".data);
        } catch (Error e) {
            assert_not_reached();
        }

        string[] unix_sockets = { "does-not-exists.sock", "does-not-exists-bis.sock", "mock-docker.sock" };

        // When
        var unix_discoverer = new Endpoint.UnixSocketEndpointDiscovery.from_unix_sockets(unix_sockets);
        var uri = unix_discoverer.discover();

        // Then
        assert(uri == "unix://mock-docker.sock");

        //Clean
        if (file.query_exists()) {
            try {
                file.delete();
            } catch (Error e) {
                assert_not_reached();
            }
        }
    });

    Test.add_func("/Dockery/DockerSdk/Endpoint/UnixSocketEndpointDiscovery/#NoEndpointsExist", () => {

        // Given
        string[] unix_sockets = { "does-not-exists.sock", "does-not-exists-bis.sock" };

        // When
        var unix_discoverer = new Endpoint.UnixSocketEndpointDiscovery.from_unix_sockets(unix_sockets);
        var uri = unix_discoverer.discover();

        // Then
        assert(uri == null);
    });
}
