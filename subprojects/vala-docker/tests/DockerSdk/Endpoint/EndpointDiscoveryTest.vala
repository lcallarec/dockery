using global::Dockery.DockerSdk;

class EndpointDiscoveryMock : Endpoint.EndpointDiscoveryInterface, GLib.Object {

    private string? endpoint_found = null;

    public EndpointDiscoveryMock(string? endpoint_found = null) {
        this.endpoint_found = endpoint_found;
    }

    public string? discover() {
        return this.endpoint_found;
    }
}

private void register_sdk_endpoint_discovery_test() {

    Test.add_func("/Dockery/DockerSdk/Endpoint/EndpointDiscovery#HttpEndpointFoundFirst", () => {

        //Given
        var http_discoverer = new EndpointDiscoveryMock("http://found");

        var unix_discoverer = new EndpointDiscoveryMock();

        var discoverer = new Endpoint.EndpointDiscovery.from_discoverers({http_discoverer, unix_discoverer});

        //When
        string endpoint = discoverer.discover();

        //Then
        assert(endpoint == "http://found");
    });

    Test.add_func("/Dockery/DockerSdk/Endpoint/EndpointDiscovery#UnixSocketEndpointFoundFirst", () => {

        // Given
        var http_discoverer = new EndpointDiscoveryMock();

        var unix_discoverer = new EndpointDiscoveryMock("unix:///found");

        var discoverer = new Endpoint.EndpointDiscovery.from_discoverers({ http_discoverer, unix_discoverer });

        // When
        string endpoint = discoverer.discover();

        // Then
        assert(endpoint == "unix:///found");
    });

    Test.add_func("/Dockery/DockerSdk/Endpoint/EndpointDiscovery#NoEndpointsFound", () => {

        // Given
        var http_discoverer = new EndpointDiscoveryMock();

        var unix_discoverer = new EndpointDiscoveryMock();

        var discoverer = new Endpoint.EndpointDiscovery.from_discoverers({ http_discoverer, unix_discoverer });

        // When
        string endpoint = discoverer.discover();

        // Then
        assert(endpoint == null);
    });    
}
