using global::Dockery.DockerSdk;

private void register_sdk_endpoint_server_test() {

    Test.add_func("/Dockery/DockerSdk/Endpoint/ServerEndpoint/Ping#NominalCase", () => {

        var client = new ClientMock();
        var endpoint = new Endpoint.ServerEndpoint(client);

        var response = new Io.Response();
        response.status = 200;
 
        client.response = response;

        try {
            endpoint.ping();
        } catch (Error e) {
            assert_not_reached();
        }
    });

    Test.add_func("/Dockery/DockerSdk/Endpoint/ServerEndpoint/Ping#NonOkStatus", () => {

        var client = new ClientMock();
        var endpoint = new Endpoint.ServerEndpoint(client);

        var response = new Io.Response();
        response.status = 500;
 
        client.response = response;

        try {
            endpoint.ping();
            assert_not_reached();
        } catch(Error e) {
            assert(e is RequestError.FATAL);
        }
    });

    Test.add_func("/Dockery/DockerSdk/Endpoint/ServerEndpoint/Ping#ServerUnreachable", () => {

        var client = new ClientMock();
        var endpoint = new Endpoint.ServerEndpoint(client);

        var response = new Io.Response();
        response.status = 0;
 
        client.response = response;

        try {
            endpoint.ping();
            assert_not_reached();
        } catch(Error e) {
            assert(e is RequestError.FATAL);
        }
    });
}
