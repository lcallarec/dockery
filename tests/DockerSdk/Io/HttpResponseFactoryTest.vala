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

        Io.FutureResponse<string> response = Io.HttpResponseFactory.future_create(msg, new Io.FutureResponse<string>(new MockDeserializer()));

        assert(response is Io.FutureResponse);
         
        #if NOT_ON_TRAVIS
        assert(response.payload == "This is a response body");
        #endif

        assert(response.status == 301);
        assert(response.headers.size == 1);
        assert(response.headers.has_key("X-Dockery-Version"));
        assert(response.headers.get("X-Dockery-Version") == "1.76");
    });

    Test.add_func ("/Dockery/DockerSdk/Io/HttpResponseFactory/FutureCreate#Signals:Partial", () => {

        var msg = build_dumb_message();

        var response_in = new Io.FutureResponse<string>(new MockDeserializer());
        
        bool was_called = false;
        response_in.on_response_ready.connect((deserializedObject) => {
            was_called = true;
        });

        response_in.on_payload_line_received("This is a dumb response body");

        Io.FutureResponse<string> response = Io.HttpResponseFactory.future_create(msg, response_in);

        assert(was_called == true);
    });
}

private Soup.Message build_dumb_message() {
    Soup.Message msg = new Soup.Message("GET", "https://www.dumb.dumb");

    var body = new Soup.MessageBody();
    body.data = "This is a dumb response body".data;
    msg.response_body = body;

    return msg;
}