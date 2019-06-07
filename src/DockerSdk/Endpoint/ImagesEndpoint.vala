namespace Dockery.DockerSdk.Endpoint {

    using global::Dockery.DockerSdk.Serializer;

    /**
     * Images related endpoints
     *
     * Available features :
     * - List Images
     * - Remove an image
     * - Search images
     * - Pull imageq
     *
     * Missing features :
     * - Build image from a Dockerfile
     * - Create an image
     * - Inspect an image
     * - Get the history of an image
     * - Push an image on the registry
     * - Tag an image into a repository
     */
    public class ImageEndpoint : Endpoint {

        protected DeserializerInterface<Model.ImageCollection> deserializer;

        public ImageEndpoint(Client.Client client, DeserializerInterface<Model.ImageCollection> deserializer) {
            base(client);
            this.deserializer = deserializer;
        }

         /**
          * Get a list of all images
          * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers
          */
        public Model.ImageCollection list() throws RequestError {

            try {

                return deserializeImages(this.client.send("GET", "/images/json").payload);

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
        public void remove(Model.Image image, bool force = false) throws RequestError {

            try {

                StringBuilder message = new StringBuilder("/images/%s".printf(image.id));

                if (force == true) {
                    message.append("?force=true");
                }

                var response = this.client.send("DELETE", message.str);

                var error_messages = create_error_messages();
                error_messages.set(400, "No such image");
                error_messages.set(409, "Can't remove the image");

                this.throw_error_from_status_code(200, response, error_messages);

            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while removing image %s : %s".printf(image.id, e.message));
            }
        }

        /**
         * Search an image in Docker hub
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#search-images
         */
        public Model.HubImage[] search(string term) throws RequestError {

            try {

                string escaped_term = Uri.escape_string(term);

                var response = this.client.send("GET", "/images/search?term=%s".printf(escaped_term));

                var error_messages = create_error_messages();
                error_messages.set(400, "No such image");
                error_messages.set(409, "Can't remove the image");

                this.throw_error_from_status_code(200, response, error_messages);

                return parse_images_search_list_payload(response.payload);

            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while searching for \"%s\" in docker hub (%s)".printf(term, e.message));
            }
        }

        /**
         * Pull an image from Docker hub
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#/create-an-image
         */
        public void pull(Model.HubImage image) throws RequestError {

            try {

                var response = this.client.send("POST", "/images/create?fromImage=%s".printf(image.name));

                this.throw_error_from_status_code(200, response, create_error_messages());

            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while pull image %s from docker hub".printf(image.name));
            }
        }

        /**
         * Pull an image from Docker hub
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#/create-an-image
         */
        public Io.FutureResponse future_pull(Model.HubImage image) throws RequestError {

            try {
                var future_response = new Io.FutureResponse<Model.ContainerStat>(new PullStepDeserializer());
                return this.client.future_send(future_response, "POST","/images/create?fromImage=%s".printf(image.name));
            } catch (RequestError e) {
                throw new RequestError.FATAL("Error while pull image %s from docker hub".printf(image.name));
            }
        }

        /**
         * Deserialize images list response payload
         */
        private Model.ImageCollection deserializeImages(string payload) {
            try {
                return this.deserializer.deserialize(payload);
            } catch (Error e) {
                return new Model.ImageCollection();
            }
        }

        /**
         * Parse images search list response payload
         */
        private Model.HubImage[] parse_images_search_list_payload(string payload) {

            Model.HubImage[] hi = {};
            try {
                var parser = new Json.Parser();
                parser.load_from_data(payload);

                var nodes = parser.get_root().get_array().get_elements();

                foreach (unowned Json.Node node in nodes) {
                    hi += new Model.HubImage.from(
                        node.get_object().get_string_member("description"),
                        node.get_object().get_boolean_member("is_official"),
                        node.get_object().get_boolean_member("is_automated"),
                        node.get_object().get_string_member("name"),
                        (int) node.get_object().get_int_member("star_count")
                    );
                }
            } catch (Error e) {
                return hi;
            }

            return hi;
        }

    }
}
