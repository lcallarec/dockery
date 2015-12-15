namespace Docker {
	
    public errordomain RequestError {
        FATAL,
        NOT_FOUND
    }
	
    public interface RepositoryInterface : GLib.Object {
        public abstract Image[]? get_images() throws RequestError;
    }

    public class UnixSocketRepository : RepositoryInterface, GLib.Object {
		
        private string socket_path;
		
        public UnixSocketRepository(string socket_path) {
            this.socket_path = socket_path;
        }
		
        public Image[]? get_images() throws RequestError {
		
            try {
                SocketClient client = new SocketClient();
                SocketConnection conn = client.connect(new UnixSocketAddress(this.socket_path));

                string message = "GET /images/json HTTP/1.1\r\nHost: localhost\r\n\r\n";	

                conn.output_stream.write(message.data);

                DataInputStream _response = new DataInputStream(conn.input_stream);

                response = new RepositoryResponse(_response);
				
                return parse_image_payload(response.payload);

            } catch (Error e) {
                throw new RequestError.FATAL("erreur");
            }
        }
		
        public RepositoryResponse response { get; private set;}
		
        private Image[] parse_image_payload(string payload) {

            Image[] images = {};
           	
            try {
                var parser = new Json.Parser();
                parser.load_from_data(payload);
				
                var nodes = parser.get_root().get_array().get_elements();
		
                foreach (unowned Json.Node node in nodes) {
                    string[0] repotag = node.get_object().get_array_member("RepoTags").get_string_element(0).split(":", 2);

                    images += Image() {
                        id 		   = node.get_object().get_string_member("Id"),
                        created_at = (int64) node.get_object().get_int_member("Created"),
			repository = repotag[0],
                        tag        = repotag[1]
                    };
                }
            } catch (Error e) {
                return images;
            }

            return images;
        }
    }
	
    public class RepositoryResponse : Object {
		
        private int status;
        private Gee.HashMap<string, string> headers;

        public RepositoryResponse(DataInputStream stream) {

        try {
                status  = extract_response_status_code(stream);
                headers = extract_response_headers(stream);
                payload = stream.read_line(null).strip();
				
            } catch (IOError e) {
                stdout.printf(e.message);
            }
        }

        public string? payload { get; set;}
		
        private int? extract_response_status_code(DataInputStream stream) {
            
            try {
                string header_line = stream.read_line(null);
				
                Regex regex = new Regex("HTTP/(\\d.\\d) (\\d{3}) [a-zAZ]*");
                MatchInfo info;
                if (regex.match(header_line, 0, out info)){
                    return (int) info.fetch(2);
                }
            } catch (RegexError e) {
                return null;
            } catch (IOError e) {
                return null;
            }
			
            return null;
        }
		
        private Gee.HashMap<string, string>? extract_response_headers(DataInputStream stream) {
			
            var headers = new Gee.HashMap<string, string>();
            string header_line;

            try {
                Regex regex = new Regex("([a-zAZ]*):([a-zAZ]*)");			
				
                MatchInfo info;
                while ((header_line = stream.read_line(null)).strip() != "") {
                    if (regex.match(header_line, 0, out info)){
                        headers.set(info.fetch(1), info.fetch(2));
                    }
                }
                
                return headers;
                
            } catch (RegexError e) {
                return null;
            } catch (IOError e) {
                return null;
            }
        }
}
	
    public struct Image {
        public string id;
        public int64 created_at;
        public string repository;
        public string tag;
    }
}












