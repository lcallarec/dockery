namespace Sdk.Docker.Io {

    /**
     * AsyncResponse
     */
    public class AsyncResponse : Response {
        public signal void on_status_code_received(int status_code);
        public signal void on_headers_received(Gee.HashMap<string, string> headers);
        public signal void on_payload_received(string payload);
        public signal void on_payload_chunk_received(string part);
        public signal void on_response_reading_error(IOError error);
    }
}
