namespace Sdk.Docker {
    
    public errordomain RequestError {
        FATAL
    }
    
    public abstract class Response : GLib.Object {
        
        public string? payload { get; protected set;}

        public int status { get; protected set;}

        public Gee.HashMap<string, string> headers { get; protected set;}
        
    }
    
    /**
     * Response from a socket request to a docker remote api
     */ 
    public class SocketResponse : Response {
        
        public SocketResponse(DataInputStream stream) {

        try {
                status  = extract_response_status_code(stream);
                headers = extract_response_headers(stream);
                
                if (stream.get_available() > 0) {

                    if (headers.has("Transfer-Encoding", "chunked")) {
                        stream.read_line(null);
                    }
                    
                    payload = stream.read_line(null).strip();
                }
                
                stdout.printf("Response status : %d\n", status);
                
                foreach (var header in headers.entries) {
                    stdout.printf("Response header : %s : %s\n", header.key, header.value);
                }    
                
                stdout.printf("Response payload : %s\n", payload);
                
            } catch (IOError e) {
                stdout.printf("IO error : %s", e.message);
            }
            
            stream.close();
        }

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
        
        private Gee.HashMap<string, string>? extract_response_headers(DataInputStream stream) {
            
            var headers = new Gee.HashMap<string, string>();
            string header_line;

            try {
                while ((header_line = stream.read_line(null)).strip() != "") {
                    string[] _header = header_line.split(":", 2);                        
                    headers.set(_header[0], _header[1].strip());
                }
                
            } catch (RegexError e) {
                return null;
            } catch (IOError e) {
                return null;
            }
            
            return headers;
        }
    }
    
    protected class RequestQueryStringBuilder {
        
        Json.Builder builder = new Json.Builder();
        Json.Generator generator = new Json.Generator();
            
        StringBuilder filter_builder = new StringBuilder("?");
            
        public void add_json_filter(string filter_name, Gee.HashMap<string, Gee.ArrayList<string>> filter_value) {
            
            filter_builder.append(filter_name);
            filter_builder.append("=");
           
            filter_builder.append(build_json_request_filter(filter_value));
            
            //filter_builder.append("&");
        } 
        
        public string build() {
            
            string _filter = filter_builder.str;
            
            //Restore
            builder = new Json.Builder();
            generator = new Json.Generator();
            filter_builder = new StringBuilder("?");
            
            return _filter;
        }
        
        private string build_json_request_filter(Gee.HashMap<string, Gee.ArrayList<string>> data) {

            builder.begin_object();

            foreach (var entry in data.entries) {
            
                builder.set_member_name(entry.key);
            
                builder.begin_array ();
                foreach (string subentry in entry.value) {
                    builder.add_string_value(subentry);
                }
                builder.end_array ();
                
            }
            
            builder.end_object();
        
            Json.Node root = builder.get_root();
            generator.set_root(root);

            return generator.to_data(null);
        }
    }
}
