namespace Sdk.Docker.Io {

    /**
     * Response from a socket request to a docker remote api
     */
    public class SocketResponse : Response {

        public SocketResponse(DataInputStream stream) {

        try {
                status  = extract_response_status_code(stream);
                headers = extract_response_headers(stream);

                if (stream.get_available() > 2) {
                    if (headers.has("Transfer-Encoding", "chunked")) {
                        payload = extract_chunked_response_body(stream);
                    } else {
                        payload = extract_known_content_lenght_response_body(stream);
                    }
                }

                stdout.printf("Response status : %d\n", status);
                stdout.printf("Response payload : %s\n", payload);

                foreach (Gee.Map.Entry<string, string> header in headers.entries) {
                    stdout.printf("Response header : %s : %s\n", header.key, header.value);
                }

            } catch (IOError e) {
                stdout.printf("IO error : %s", e.message);
            }

            try {
                stream.close();
            } catch (Error e) {
                stdout.printf("IO error : %s", e.message);
            }

        }

        /**
         * Extract the response status code from the response stream
         */
        private int? extract_response_status_code(DataInputStream stream) {

            try {
                string header_line = stream.read_line(null);

                Regex regex = new Regex("HTTP/(\\d.\\d) (\\d{3}) [a-zAZ]*");
                MatchInfo info;
                if (regex.match(header_line, 0, out info)){
                    return int.parse(info.fetch(2));
                }
            } catch (RegexError e) {
                return null;
            } catch (IOError e) {
                return null;
            }

            return null;
        }

        /**
         * Extract the response headers as a Hash table from the response stream
         */
        private Gee.HashMap<string, string>? extract_response_headers(DataInputStream stream) {

            var headers = new Gee.HashMap<string, string>();
            string header_line;

            try {
                while ((header_line = stream.read_line(null)).strip() != "") {
                    string[] _header = header_line.split(":", 2);
                    headers.set(_header[0], _header[1].strip());
                }
            } catch (IOError e) {
                return null;
            }

            return headers;
        }

        /**
         * Return the payload from response having a defined content-lenght header
         */
        private string extract_known_content_lenght_response_body(DataInputStream stream)
        {
            string _payload = "";

            while (stream.get_available() > 0) {
                _payload += stream.read_line(null).strip();
            }

            return _payload;
        }


        /**
         * Return the payload from a chunked response
         */
        private string extract_chunked_response_body(DataInputStream stream)
        {
            string line = "";
            string _payload = "";

            //First line is always empty in chunked transfer
            stream.read_line(null);

            while (stream.get_available() > 0) {
                line = stream.read_line(null).strip();
                if (line == "0" || line == "") {
                    break;
                }

                _payload += line;
            }

            return _payload;
        }

    }
}
