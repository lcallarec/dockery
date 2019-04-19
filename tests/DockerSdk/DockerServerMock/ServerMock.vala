void ping_handler(Soup.Server server, Soup.Message msg, string path, GLib.HashTable? query, Soup.ClientContext client) {
    string response_text = "OK";
    msg.set_response ("application/json", Soup.MemoryUse.COPY, response_text.data);
}

private Soup.Server create_mock_server(int port) {
    var server = new Soup.Server(Soup.SERVER_PORT, port);
    server.add_handler("/_ping", ping_handler);
    return server;
}