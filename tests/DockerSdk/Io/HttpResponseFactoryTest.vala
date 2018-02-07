using global::Dockery.DockerSdk;

private void register_http_response_factory_test() {
    Test.add_func ("/Dockery/DockerSdk/Io/HttpResponseFactory/Create#NominalCase", () => {

        Soup.Message msg = new Soup.Message("HEAD", "http://lcallarec.github/dockery");
    
        msg.set_status(301);
        
        var response_headers = new Soup.MessageHeaders(Soup.MessageHeadersType.RESPONSE);
        msg.response_headers = response_headers;
        
        response_headers.append("X-Dockery-Version", "1.76");

        var body = new Soup.MessageBody();
        body.data = "This is a response body".data;
        msg.response_body = body;

        var response = Io.HttpResponseFactory.create(msg);

        assert(response.payload == "This is a response body");
        assert(response.status == 301);
        assert(response.headers.size == 1);
        assert(response.headers.has_key("X-Dockery-Version"));
        assert(response.headers.get("X-Dockery-Version") == "1.76");
    });

    Test.add_func ("/Dockery/DockerSdk/Io/HttpResponseFactory/FutureCreate#NominalCase", () => {

        Soup.Message msg = new Soup.Message("GET", "https://www.google.com");
        
        msg.set_status(301);
        
        var response_headers = new Soup.MessageHeaders(Soup.MessageHeadersType.RESPONSE);
        msg.response_headers = response_headers;
        
        response_headers.append("X-Dockery-Version", "1.76");

        var body = new Soup.MessageBody();
        body.data = "This is a response body".data;
        msg.response_body = body;

        var response = Io.HttpResponseFactory.future_create(msg, new Io.FutureResponse());

        assert(response is Io.FutureResponse);
        stdout.printf("RP : %s\n", response.payload);
        assert(response.payload == "This is a response body");
        assert(response.status == 301);
        assert(response.headers.size == 1);
        assert(response.headers.has_key("X-Dockery-Version"));
        assert(response.headers.get("X-Dockery-Version") == "1.76");
    });
}