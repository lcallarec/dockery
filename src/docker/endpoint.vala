namespace Docker {
    
    public class Endpoint {
        
        protected Client client;
        
        protected Model.ModelFactory model_factory = new Model.ModelFactory();
        
        protected IO.RequestQueryStringBuilder filter_builder = new IO.RequestQueryStringBuilder();
        
        public Endpoint(Client client) {
            this.client = client;
        }
    }
    
    public class ImageEndpoint : Endpoint {
         
         public ImageEndpoint(Client client) {
             base(client);
         }
         
         public Model.Image[]? list() throws IO.RequestError {
         
            try {
                
                string message = "GET /images/json";    
            
                return parse_images_list_payload(this.client.send(message).payload);

            } catch (IO.RequestError e) {
                 throw new IO.RequestError.FATAL("Error while fetching images list from docker daemon : %s".printf(e.message));
            }
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
                        node.get_object().get_array_member("RepoTags").get_string_element(0),
                        (uint) node.get_object().get_int_member("VirtualSize")
                    );
                }
            } catch (Error e) {
                return images;
            }

            return images;
        }

    }
    
    public class ContainerEndpoint : Endpoint {
        
        public ContainerEndpoint(Client client) {
            base(client);
        }
         
        /**
         * Retrieve a list of containers
         */
        public Model.Container[]? list(Model.ContainerStatus status) throws IO.RequestError {
        
            try {
                
                string _status = Model.ContainerStatusConverter.convert_from_enum(status);
                
                var filters = new Gee.HashMap<string, Gee.ArrayList<string>>();
                var statuses = new Gee.ArrayList<string>();
                statuses.add(_status);
                filters.set("status", statuses);
                
                filter_builder.add_json_filter("filters", filters);
                
                var message_builder = new StringBuilder("GET /containers/json");
                message_builder.append(filter_builder.build());        
                return parse_containers_list_payload(this.client.send(message_builder.str).payload, status);

            } catch (IO.RequestError e) {
                throw new IO.RequestError.FATAL("Error while fetching container list from docker daemon : %s".printf(e.message));
            }
        }
        
        /**
         * Pause a single container
         */
        public void pause(Docker.Model.Container container) throws IO.RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/pause".printf(container.id));
                
                var error_messages = create_error_messages();
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (IO.RequestError e) {
                throw new IO.RequestError.FATAL("Error while pausing container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Unpause a single container
         */
        public void unpause(Docker.Model.Container container) throws IO.RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/unpause".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already started");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (IO.RequestError e) {
                throw new IO.RequestError.FATAL("Error while unpausing container %s : %s".printf(container.id, e.message));
            }
        }
        
         /**
         * Remove a single container
         */
        public void remove(Docker.Model.Container container) throws IO.RequestError {
        
            try {
                var response = this.client.send("DELETE /containers/%s".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already started");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (IO.RequestError e) {
                throw new IO.RequestError.FATAL("Error while killing container %s : %s".printf(container.id, e.message));
            }
        }
        
         /**
         * Start a single container
         */
        public void start(Docker.Model.Container container) throws IO.RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/start".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(409, "Name already assigned to another container");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (IO.RequestError e) {
                throw new IO.RequestError.FATAL("Error while starting container %s : %s".printf(container.id, e.message));
            }
        }
        
        /**
         * Start a single container
         */
        public void stop(Docker.Model.Container container) throws IO.RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/stop".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already stopped");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (IO.RequestError e) {
                throw new IO.RequestError.FATAL("Error while stoping container %s : %s".printf(container.id, e.message));
            }
        }        
        
        /**
         * Rename a single container
         */
        public void rename(Docker.Model.Container container, string name) throws IO.RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/rename?name=%s".printf(container.id, name));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already stopped");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (IO.RequestError e) {
                throw new IO.RequestError.FATAL("Error while renaming container %s : %s".printf(container.id, e.message));
            }
        }       
        
        /**
         * Throw error with the right message or do nothing if actual code == ok_status_code
         * If paylod is not empty, then the message is fetched from the response payload
         */ 
        private void throw_error_from_status_code(
            int ok_status_code,
            IO.Response response,
            Gee.HashMap<int, string> map
        ) throws IO.RequestError {
            
            if (response.status != ok_status_code) {
                string? message = map.get(response.status);
                if (null != message) {
                    message = response.payload;
                }
                
                throw new IO.RequestError.FATAL(message);
            }    
        }
        
        /**
         * Parse containers payload
         */ 
        private Model.Container[] parse_containers_list_payload(string payload, Model.ContainerStatus status) {

            Model.Container[] containers = {};
            try {
                var parser = new Json.Parser();
                parser.load_from_data(payload);
                
                var nodes = parser.get_root().get_array().get_elements();
        
                foreach (unowned Json.Node node in nodes) {
                    
                    var names_node = node.get_object().get_array_member("Names");
                    uint len       = names_node.get_length();
                    string[] names = {};
                    
                    for (int i = 0; i <= len - 1; i++) {
                        names[i] = names_node.get_string_element(i);
                    }

                    containers += model_factory.create_container(
                        node.get_object().get_string_member("Id"),
                        node.get_object().get_int_member("Created"),
                        node.get_object().get_string_member("Command"),
                        names,
                        status
                    );
                }
            } catch (Error e) {
                return containers;
            }

            return containers;
        }
        
        /**
         * Create and return a base HashMap of status code => messages, compatible with all container requests 
         */ 
        private Gee.HashMap<int, string> create_error_messages() {
            
            var error_messages = new Gee.HashMap<int, string>();
            error_messages.set(404, "No such container");
            error_messages.set(500, "Docker daemon fatal error");
            
            return error_messages;
        }
    }
}
