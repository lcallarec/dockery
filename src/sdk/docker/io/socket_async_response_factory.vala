namespace Sdk.Docker.Io {

    /**
     * Async Response factory from a socket request to a docker remote api
     */
    public class SocketAsyncResponseFactory : SocketResponseFactory {

        public static AsyncResponse create_async(DataInputStream stream) {

            AsyncResponse response = new AsyncResponse();

            try {
                extract_response_status_code(stream, response);
                stdout.printf("Response status : %d\n", response.status);

                extract_response_headers(stream, response);
                foreach (Gee.Map.Entry<string, string> header in response.headers.entries) {
                    stdout.printf("Response header : %s : %s\n", header.key, header.value);
                }

                if (stream.get_available() > 2) {
                    if (response.headers.has("Transfer-Encoding", "chunked")) {
                        extract_chunked_response_body_async.begin(stream, response, (obj, result) => {
                            try {
                                extract_chunked_response_body_async.end(result);
                                stream.close();
                                stdout.printf("Socket closed\n");
                            } catch (IOError e) {
                                response.on_response_reading_error(e);
                            }

                        });

                    } else {
                        extract_known_content_lenght_response_body_async.begin(stream, response, (obj, result) => {
                            try {
                                extract_known_content_lenght_response_body_async.end(result);
                                stream.close();
                                stdout.printf("Socket closed\n");
                            } catch (IOError e) {
                                response.on_response_reading_error(e);
                            }
                        });
                    }
                }

            } catch (IOError e) {
                response.on_response_reading_error(e);
            }

            return response;
        }

        /**
         * Async - Return the payload from response having a defined content-lenght header
         */
        private static async void extract_known_content_lenght_response_body_async(DataInputStream stream, AsyncResponse response) throws IOError
        {
            string line = "";
            string payload = "";

            while (stream.get_available() > 0) {
                line = yield stream.read_line_async(Priority.DEFAULT, null, null);
                payload += line.strip();
            }

            response.payload = payload;
            stdout.printf("Response payload : %s\n", payload);


        }

        /**
         * Async - Return the payload from a chunked response
         */
        private static async void extract_chunked_response_body_async(DataInputStream stream, AsyncResponse response) throws IOError
        {
            string line = "";
            string payload = "";

            int line_number = 0;
            while (true) {

                line = yield stream.read_line_async(Priority.DEFAULT, null, null);

                //In chunked transfer, don't consider empty lines
                if (line == "") {
                    continue;
                }

                //End of chnunked HTTP 1.1 transfert
                if (line == "0") {
                    break;
                }

                line_number++;

                //This line bear the next line size in bytes (in hex) ; it's not part of the payload
                if (1 == line_number % 2) {
                    continue;
                }

                payload += line.strip();
            }

            stdout.printf("Response payload : %s\n", payload);
            response.payload = payload;
        }
    }
}
