namespace Sdk.Docker {
    
    /**
     * Images related endpoints
     * 
     * Available features :
     * - List Images
     * 
     * Partial available features : 
     * - Remove an image
     * 
     * Missing features :
     * - Search images
     * - Build image from a Dockerfile
     * - Create an image
     * - Inspect an image
     * - Get the history of an image
     * - Push an image on the registry
     * - Tag an image into a repository
     */ 
    public class ImageEndpoint : Endpoint {
         
         public ImageEndpoint(Client client) {
             base(client);
         }
         
         /**
          * Get a list of all images
          * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers
          */ 
         public Model.Image[]? list() throws RequestError {
         
            try {
                
                string message = "GET /images/json";    
            
                return parse_images_list_payload(this.client.send(message).payload);

            } catch (RequestError e) {
                 throw new RequestError.FATAL("Error while fetching images list from docker daemon : %s".printf(e.message));
            }
        }
        
        /**
         * Remove a single image
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-images
         * 
         * Force option : when set to true, will force the removal
         */
        public void remove(Sdk.Docker.Model.Image image, bool force = false) throws RequestError {
        
            try {
                
                StringBuilder message = new StringBuilder("DELETE /images/%s".printf(image.id));
                
                if (force == true) {
                    message.append("?force=true");
                }
                
                var response = this.client.send(message.str);
                
                var error_messages = create_error_messages();
                error_messages.set(400, "No such image");
                error_messages.set(409, "Can't remove the image");
                 
                this.throw_error_from_status_code(200, response, error_messages);
                
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while removing image %s : %s".printf(image.id, e.message));
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
}
