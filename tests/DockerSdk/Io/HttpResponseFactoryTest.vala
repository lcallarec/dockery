using global::Dockery.DockerSdk;

private void register_http_response_factory_test() {
    Test.add_func ("/Dockery/DockerSdk/Io/HttpResponseFactory/Create#NominalCase", () => {

        //Given

        // The whole Soup.Message mocking process is tricky part
        // msg.response_body = body MUST remains in the same code scope
        // because msg.response_body doesn't own the body object        
        Soup.Message msg = new Soup.Message("GET", "https://www.dumb.dumb");

        var body = new Soup.MessageBody();
        body.append_take("abc\0".data);
        body.complete();
        body.flatten();

        msg.response_body = body;
        msg.set_status(301);
        
        var response_headers = new Soup.MessageHeaders(Soup.MessageHeadersType.RESPONSE);
        msg.response_headers = response_headers;
        
        response_headers.append("X-Dockery-Version", "1.76");
        
        //When
        var response = Io.HttpResponseFactory.create(msg);
        
        //Then
        assert(response.payload == "abc");
        assert(response.status == 301);
        assert(response.headers.size == 1);
        assert(response.headers.has_key("X-Dockery-Version"));
        assert(response.headers.get("X-Dockery-Version") == "1.76");
    });

    Test.add_func ("/Dockery/DockerSdk/Io/HttpResponseFactory/FutureCreate#NominalCase", () => {

        //Given

        // The whole Soup.Message mocking process is tricky part
        // msg.response_body = body MUST remains in the same code scope 
        // because msg.response_body doesn't own the body object
        Soup.Message msg = new Soup.Message("GET", "https://www.dumb.dumb");

        var body = new Soup.MessageBody();
        body.append_take("abc\0".data);
        body.complete();
        body.flatten();
        
        msg.response_body = body;        
        msg.set_status(301);
        
        var response_headers = new Soup.MessageHeaders(Soup.MessageHeadersType.RESPONSE);
        msg.response_headers = response_headers;
        
        response_headers.append("X-Dockery-Version", "1.76");

        //When
        Io.FutureResponse<string> response = Io.HttpResponseFactory.future_create(msg, new Io.FutureResponse<string>(new MockDeserializer()));

        //Then
        assert(response is Io.FutureResponse);
        assert(response.payload == "abc");
        assert(response.status == 301);
        assert(response.headers.size == 1);
        assert(response.headers.has_key("X-Dockery-Version"));
        assert(response.headers.get("X-Dockery-Version") == "1.76");
    });

    Test.add_func ("/Dockery/DockerSdk/Io/HttpResponseFactory/FutureCreate#Signals:Partial", () => {

        //Given
        var msg = build_dumb_message();

        var response_in = new Io.FutureResponse<string>(new MockDeserializer());
        
        bool was_called = false;
        response_in.on_response_ready.connect((deserializedObject) => {
            was_called = true;
        });

        response_in.on_payload_line_received("abc");

        //When
        Io.HttpResponseFactory.future_create(msg, response_in);

        //Then
        assert(was_called == true);
    });
}

private Soup.Message build_dumb_message() {
    Soup.Message msg = new Soup.Message("GET", "https://www.dumb.dumb");

    var body = new Soup.MessageBody();
    body.append_take("abc\0".data);
    body.complete();

    msg.response_body = body;

    return msg;
}