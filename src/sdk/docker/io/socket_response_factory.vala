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

                string line;
                string payload = "";

                while (stream.get_available() > 2) {
					stdout.printf("Enter stream loop\n");
                    if (response.headers.has("Transfer-Encoding", "chunked")) {
                        //Reads the next chunk size. As I'm a bit lazy,I don't use them.
                        stdout.printf("Chunk\n");
                        stream.read_line(null);
                    }

                    line = stream.read_line(null).strip();
                    stdout.printf("Line : %s\n", line);
                    //End of chunks
                    if (line == "0") {
						stdout.printf("Line = 0\n");
                        break;
                    }

                    payload += line;
                }

                response.payload = payload;

                stream.close();
                stdout.printf("Socket closed\n");

            } catch (IOError e) {
                throw e;
            }

            return response;
        }

		public static void future_create(DataInputStream stream, FutureResponse future_response) {
            

				try {
					//extract_response_status_code(stream, response);
					//stdout.printf("Response status : %d\n", response.status);

					extract_response_headers(stream, null);
					//foreach (Gee.Map.Entry<string, string> header in response.headers.entries) {
					//	stdout.printf("Response header : %s : %s\n", header.key, header.value);
					//}

					string line;
					string payload = "";
					stdout.printf("Size : %d\n", (int) stream.get_available() );
					while (true) {
						line = stream.read_line(null).strip();
						stdout.printf("LINE : %s\n", line);
						//if (response.headers.has("Transfer-Encoding", "chunked")) {
							//Reads the next chunk size. As I'm a bit lazy,I don't use them.
				
							stream.read_line(null);
						//}

						//line = stream.read_line(null).strip();
						//End of chunks
						if (line == "0") {
							break;
						}

						future_response.on_payload_line_received(line);
						
						payload += line;
					}

					//response.payload = payload;

					stream.close();
					stdout.printf("Socket closed\n");
					

				} catch (IOError e) {
					throw e;
			
				}
				
		
	
			
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
        protected static void extract_response_headers(DataInputStream stream, Response? response) {

            var headers = new Gee.HashMap<string, string>();
            string header_line;

            try {
                while ((header_line = stream.read_line(null)).strip() != "") {
                    string[] _header = header_line.split(":", 2);
                    headers.set(_header[0], _header[1].strip());
                }
            } catch (IOError e) {

            }

			if (response == null) {
				return;
			}

            response.headers = headers;
        }
    }
    
    
	public class Rdesponse : Object {

		public int run () {


			return 0;
		}
	}
}
