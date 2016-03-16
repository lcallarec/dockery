namespace Sdk.Docker {
    
    /**
     * Containers related endpoints
     * 
     * Available features :
     * - List containers
     * - Start a container
     * - Stop a container
     * - Rename a container
     * - Kill a container
     * - Pause a container
     * - Unpause a container 
     * - Remove a container
     * 
     * Missing features :
     * - Create a container
     * - Inspect a container
     * - List processes running inside a container
     * - Export a container
     * - Get container stats based on resource usage
     * - Resize a container TTY
     * - Attach to a container
     * - Attach to a container (WS)
     * - Wait a container
     * - Copy from a container
     * - Retrieve information about container files & folders
     * - Get an archive of a filesystem resource in a container
     * - Extract an archive of files or folders to a directory in a container
     */ 
    public class ContainerEndpoint : Endpoint {
        
        public ContainerEndpoint(Client client) {
            base(client);
        }
         
        /**
         * Retrieve a list of containers
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers
         */
        public Model.Container[]? list(Model.ContainerStatus status) throws RequestError {
        
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

            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while fetching container list from docker daemon : %s".printf(e.message));
            }
        }
        
        /**
         * Pause a single container
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#pause-a-container
         */
        public void pause(Sdk.Docker.Model.Container container) throws RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/pause".printf(container.id));
                
                var error_messages = create_error_messages();
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while pausing container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Unpause a single container
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#unpause-a-container
         */
        public void unpause(Sdk.Docker.Model.Container container) throws RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/unpause".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already started");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while unpausing container %s : %s".printf(container.id, e.message));
            }
        }
        
        /**
         * Remove a single container
         * Force option : when set to true, will force the removal of running containers
         */
        public void remove(Sdk.Docker.Model.Container container, bool force = false) throws RequestError {
        
            try {
                
                StringBuilder message = new StringBuilder("DELETE /containers/%s".printf(container.id));
                
                if (force == true) {
                    message.append("?force=true");
                }

                var response = this.client.send(message.str);
                
                var error_messages = create_error_messages();
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while killing container %s : %s".printf(container.id, e.message));
            }
        }
        
        /**
         * Start a single container
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#start-a-container
         */
        public void start(Sdk.Docker.Model.Container container) throws RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/start".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already started");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while starting container %s : %s".printf(container.id, e.message));
            }
        }
        
        /**
         * Start a single container
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#stop-a-container
         */
        public void stop(Sdk.Docker.Model.Container container) throws RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/stop".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already stopped");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while killing container %s : %s".printf(container.id, e.message));
            }
        }        
        
        /**
         * Kill a single container
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#kill-a-container
         */
        public void kill(Sdk.Docker.Model.Container container) throws RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/kill".printf(container.id));
                
                var error_messages = create_error_messages();
                error_messages.set(304, "Container already stopped");
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while stoping container %s : %s".printf(container.id, e.message));
            }
        }
        
        /**
         * Rename a single container
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#rename-a-container
         */
        public void rename(Sdk.Docker.Model.Container container) throws RequestError {
        
            try {
                var response = this.client.send("POST /containers/%s/rename?name=%s".printf(container.id, container.name));
                
                var error_messages = create_error_messages();
                error_messages.set(409, "Name already assigned to another container");                
                 
                this.throw_error_from_status_code(204, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while renaming container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Rename a single container
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers
         */
        public Sdk.Docker.Model.Containers find_by_image(Sdk.Docker.Model.Image image) throws RequestError {
        
            try {

                var container_collections = new Sdk.Docker.Model.Containers();

                foreach(Sdk.Docker.Model.ContainerStatus status in Sdk.Docker.Model.ContainerStatus.all()) {
                  
                    Sdk.Docker.Model.Container[]? containers = list(status);
                   
                    foreach(Sdk.Docker.Model.Container container in containers) {
                        if (image.full_id == container.image_id) {
                            container_collections.add(status, {container});
                        }
                    }
                }
                
                return container_collections;
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while fetching containers by image %s (%s)".printf(image.id, e.message));
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
                        node.get_object().get_string_member("ImageID"),
                        names,
                        status
                    );
                }
            } catch (Error e) {
                return containers;
            }

            return containers;
        }
    }
}
