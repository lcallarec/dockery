namespace Dockery.DockerSdk.Io {

    public class SocketResponseFactory : GLib.Object {

        public static Response create(DataInputStream stream) throws IOError {

            Response response = new Response();

            extract_response_metadata(stream, response);

            string line;
            string payload = "";

            while (stream.get_available() > 2) {
                stdout.printf("Enter stream loop\n");
                if (response.headers.has("Transfer-Encoding", "chunked")) {
                    stream.read_line(null);
                }

                line = stream.read_line(null).strip();

                //End of chunks
                if (line == "0") {
                    break;
                }

                payload += line;
            }

            response.payload = payload;

            response.on_finished();

            stream.close();
            stdout.printf("Socket closed\n");

            return response;
        }

        public static FutureResponse future_create(DataInputStream stream, FutureResponse response) throws IOError {

            FutureResponse _response = (FutureResponse) extract_response_metadata(stream, (Response) response);
            response = _response;
            
            string line;
            while (true) {

                if (response.headers.has("Transfer-Encoding", "chunked")) {
                    //Reads the next chunk size. As I'm a bit lazy,I don't use them.
                    if (stream.read_line(null) == "0") {
                        break;
                    }
                }

                line = stream.read_line(null);
                if (null != line) {
                    line = line.strip();
                }

                if (response.headers.has("Transfer-Encoding", "chunked")) {
                    stream.read_line(null);
                }

                response.payload += line;

                GLib.Thread.usleep(10000);
                response.on_payload_line_received(line);
            }

            response.on_finished();

            stream.close();
            stdout.printf("Socket closed\n");

            return response;
        }

        protected static Response extract_response_metadata(DataInputStream stream, Response response) {

            extract_response_status_code(stream, response);
            response.on_status_received(response.status);
            stdout.printf("Response status : %d\n", response.status);

            extract_response_headers(stream, response);
            response.on_headers_received(response.headers);
            foreach (Gee.Map.Entry<string, string> header in response.headers.entries) {
                stdout.printf("Response header : %s : %s\n", header.key, header.value);
            }
    
            return response;
        }

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
    }

    public class HttpResponseFactory: GLib.Object {

        public static Response create(Soup.Message message) {
            return HttpResponseFactory.buildResponseFrom(message, new Response());
        }

        public static FutureResponse future_create(Soup.Message message, FutureResponse response) {
            return (HttpResponseFactory.buildResponseFrom(message, response) as FutureResponse);
        }

        private static Response buildResponseFrom(Soup.Message message, Response response) {
            
            response.status = (int) message.status_code;

            var headers = new Gee.HashMap<string, string>();
            message.response_headers.foreach((name, value) => {
                headers.set(name, value);
            });

            response.headers = headers;
            
            response.payload = (string) message.response_body.data;

            return response;
        }
    }   
}
