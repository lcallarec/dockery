namespace Sdk.Docker.Io {

    /**
     * Response from a socket request to a docker remote api
     */
    public class SocketResponseFactory : GLib.Object {

        public static Response create(DataInputStream stream) {
            Response response = new Response();

            try {
                extract_response_status_code(stream, response);
                stdout.printf("Response status : %d\n", response.status);

                extract_response_headers(stream, response);
                foreach (Gee.Map.Entry<string, string> header in response.headers.entries) {
                    stdout.printf("Response header : %s : %s\n", header.key, header.value);
                }

                if (stream.get_available() > 2) {
                    if (response.headers.has("Transfer-Encoding", "chunked")) {
                        extract_chunked_response_body(stream, response);
                    } else {
                        extract_known_content_lenght_response_body(stream, response);
                    }
                }

                stream.close();
                stdout.printf("Socket closed\n");

            } catch (IOError e) {
                throw e;
            }

            return response;
        }

        /**
         * Extract the response status code from the response stream
         */
        protected static void extract_response_status_code(DataInputStream stream, Response response) {

            try {
                string header_line = stream.read_line(null);

                Regex regex = new Regex("HTTP/(\\d.\\d) (\\d{3}) [a-zAZ]*");
                MatchInfo info;
                if (regex.match(header_line, 0, out info)){
                    response.status = int.parse(info.fetch(2));
                }

            } catch (RegexError e) {

            } catch (IOError e) {

            }

        }

        /**
         * Extract the response headers as a Hash table from the response stream
         */
        protected static void extract_response_headers(DataInputStream stream, Response response) {

            var headers = new Gee.HashMap<string, string>();
            string header_line;

            try {
                while ((header_line = stream.read_line(null)).strip() != "") {
                    string[] _header = header_line.split(":", 2);
                    headers.set(_header[0], _header[1].strip());
                }
            } catch (IOError e) {

            }

            response.headers = headers;
        }

        /**
         * Sync - Return the payload from response having a defined content-lenght header
         */
        private static void extract_known_content_lenght_response_body(DataInputStream stream, Response response)
        {
            string line = "";
            string payload = "";

            while (stream.get_available() > 0) {
                line = stream.read_line(null);
                payload += line.strip();
            }

            stdout.printf("Response payload : %s\n", payload);
            response.payload = payload;
        }

        /**
         * Sync - Return the payload from a chunked response
         */
        private static void extract_chunked_response_body(DataInputStream stream, Response response)
        {
            string line = "";
            string payload = "";

            int line_number = 0;
            while (true) {

                line = stream.read_line(null).strip();
            stdout.printf("LINE : %s\n", line);
                //In chunked transfer, don't considerer empty lines'
                if (line == "") {
                    continue;
                }

                //EOS
                if (line == "0") {
                    break;
                }

                line_number++;

                //This line bear the next line byte size (hex) ; it's not part of the payload
                if (1 == line_number % 2) {
                    continue;
                }

                payload += line;
            }

            stdout.printf("Response payload : %s\n", payload);
            response.payload = payload;
        }
    }
}
