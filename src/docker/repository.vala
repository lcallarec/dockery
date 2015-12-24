namespace Docker {
	
    public errordomain ContainerStatusError {
        UNKOWN_STATUS
    }
	
	public errordomain RequestError {
		FATAL
	}
	
    public interface Repository : GLib.Object {

        public abstract Model.Image[]? get_images() throws RequestError;

        public abstract Model.Container[]? get_containers(Model.ContainerStatus status) throws RequestError;
    }


	public abstract class BaseRepository :  GLib.Object {
		
		/**
		 * Retrieve a list of containers accordinbg to a ginve status
		 */
        public abstract Model.Container[]? get_containers(Model.ContainerStatus status) throws RequestError;
        
		/**
		 * Retrieve the list of all images
		 */
		public abstract Model.Image[]? get_images() throws RequestError;

 		public IO.Response response { get; protected set;}
 		
		protected IO.RequestQueryStringBuilder filter_builder = new IO.RequestQueryStringBuilder(); 		
	}


    public class UnixSocketRepository : BaseRepository {
		
		const string HTTP_METHOD_HEADER_SUFFIX = " HTTP/1.1\r\nHost: localhost\r\n\r\n";
		
        private string socket_path;
        
		private SocketClient client        = new SocketClient();
		
		private ModelFactory model_factory = new ModelFactory();
		
        public UnixSocketRepository(string socket_path) {
            this.socket_path = socket_path;
        }
		
        public override Model.Image[]? get_images() throws RequestError {
		
            try {
				
                string message = "GET /images/json";	
			
                return parse_images_list_payload(this.send(message).payload);

            } catch (RequestError e) {
                string err_message = "Error while fetching images list from docker daemon at %s (%s)".printf(
					this.socket_path,
					e.message
				);
                throw new RequestError.FATAL(err_message);
            }
        }

		/**
		 * Retrieve a list of containers
		 */
        public override Model.Container[]? get_containers(Model.ContainerStatus status) throws RequestError {
		
            try {
				
				string _status = ContainerStatusConverter.convert_from_enum(status);
				
				var filters = new Gee.HashMap<string, Gee.ArrayList<string>>();
				var statuses = new Gee.ArrayList<string>();
				statuses.add(_status);
				filters.set("status", statuses);
				
				filter_builder.add_json_filter("filters", filters);
				
                var message_builder = new StringBuilder("GET /containers/json");
                message_builder.append(filter_builder.build());
			
                return parse_containers_list_payload(this.send(message_builder.str).payload);

            } catch (RequestError e) {
				
                string err_message = "Error while fetching container list from docker daemon at %s (%s)".printf(
					this.socket_path,
					e.message
				);
                throw new RequestError.FATAL(err_message);
            } catch (ContainerStatusError e) {
				
				string err_message = "Internal client error : %s".printf(e.message);
			
				throw new RequestError.FATAL(err_message);
			}
        }
		
		/**
		 * Create the connection to docker daemon
		 */	
		private SocketConnection? create_connection() throws RequestError {
			try {
				return this.client.connect(new UnixSocketAddress(this.socket_path));	
			} catch (GLib.Error e) {
                string err_message = "Error while fetching images list from docker daemon at %s :\n(%s)".printf(
					this.socket_path,
					e.message
				);
                throw new RequestError.FATAL(err_message);
			}
		}
	
		/**
		 * Send a message to docker daemon and return the response
		 */ 
		private IO.Response send(string message) throws RequestError {
			
			StringBuilder request_builder = new StringBuilder(message); 
			request_builder.append(UnixSocketRepository.HTTP_METHOD_HEADER_SUFFIX);
			    
			var conn = this.create_connection();
			   
			try {
				conn.output_stream.write(request_builder.str.data);	
			} catch(GLib.IOError e) {

                string err_message = "Error while sending images list request to docker daemon at %s (%s)".printf(
					this.socket_path,
					e.message
				);
                throw new RequestError.FATAL(err_message);
			}

            return new IO.SocketResponse(new DataInputStream(conn.input_stream));
		}

		/**
		 * Parse images list response payload
		 */ 
        private Model.Image[] parse_images_list_payload(string payload) {

            Model.Image[] images = {};
            try {
                var parser = new Json.Parser();
                parser.load_from_data(payload);
				
                var nodes = parser.get_root().get_array().get_elements();
		
                foreach (unowned Json.Node node in nodes) {
					node.get_object().get_array_member("RepoTags").get_string_element(0);

                    images += model_factory.create_image(
						node.get_object().get_string_member("Id"),
                        node.get_object().get_int_member("Created"),
                        node.get_object().get_array_member("RepoTags").get_string_element(0)
                    );
                }
            } catch (Error e) {

                return images;
            }

            return images;
        }
        
		/**
		 * Parse containers payload
		 */ 
        private Model.Container[] parse_containers_list_payload(string payload) {

            Model.Container[] containers = {};
            try {
                var parser = new Json.Parser();
                parser.load_from_data(payload);
				
                var nodes = parser.get_root().get_array().get_elements();
		
                foreach (unowned Json.Node node in nodes) {
                    containers += model_factory.create_container(
                        node.get_object().get_string_member("Id"),
                        node.get_object().get_int_member("Created"),
						node.get_object().get_string_member("Command")
                    );
                }
            } catch (Error e) {
                return containers;
            }

            return containers;
        }
	}
	
	/**
	 * Create model object from raw values
	 */
	internal class ModelFactory {
		
		public Model.Image create_image(string id, int64 created_at, string repotags) {
			
			string[0] _repotags = repotags.split(":", 2);
			
			Model.Image image = new Model.Image();
			image.full_id    = id;
			image.created_at = new DateTime.from_unix_local(created_at);
            image.repository = _repotags[0];
            image.tag		 = _repotags[1];
            
            return image;
		}
		
		public Model.Container create_container(string id, int64 created_at, string command) {
			
			Model.Container container = new Model.Container();
			container.full_id = id;
			container.created_at = new DateTime.from_unix_local(created_at);
            container.command = command;
           
            return container;
		}
	}

	/**
	 * Convert container status from a type / to another type
	 */ 
	internal class ContainerStatusConverter {
		
		/**
		 * Convert a container from Model.ContainerStatus enum to string (according to remote docker api)
		 */ 
		public static string convert_from_enum(Model.ContainerStatus status) {
			switch(status) {
				case Model.ContainerStatus.RUNNING:
					return "running";
				case Model.ContainerStatus.PAUSED:
					return "paused";
			}
			
			return "r";
			//throw new ContainerStatusError.UNKOWN_STATUS("Unkown container status");
		}	
	}
}
