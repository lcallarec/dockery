namespace Dockery.DockerSdk.Endpoint {

    using global::Dockery.DockerSdk.Serializer;

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
     * - Restart a container
     * - Remove a container
     * - Attach to a container
     * - Create a container
     * - Inspect a container
     * - Get container stats based on resource usage (partial)

     * Missing features :
     * - List processes running inside a container
     * - Export a container
     * - Resize a container TTY
     * - Attach to a container (WS)
     * - Wait a container
     * - Copy from a container
     * - Retrieve information about container files & folders
     * - Get an archive of a filesystem resource in a container
     * - Extract an archive of files or folders to a directory in a container
     */
    public class ContainerEndpoint : Endpoint {

        protected DeserializerInterface<Model.ContainerCollection> container_deserializer;
        protected DeserializerInterface<Model.ContainerStat> stat_deserializer;
        
        public ContainerEndpoint(Client.Client client, DeserializerInterface<Model.ContainerCollection> container_deserializer, DeserializerInterface<Model.ContainerStat> stat_deserializer) {
            base(client);
            this.container_deserializer = container_deserializer;
            this.stat_deserializer = stat_deserializer;
        }


        /**
         * Retrieve a list of containers
         *
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers]]
         */
        public Model.ContainerCollection list(Model.ContainerStatus status) throws Io.RequestError {

            try {

                string _status = Model.ContainerStatusConverter.convert_from_enum(status);

                var filters = new Gee.HashMap<string, Gee.ArrayList<string>>();
                var statuses = new Gee.ArrayList<string>();
                statuses.add(_status);
                filters.set("status", statuses);

                filter_builder.add_json_filter("filters", filters);

                var message_builder = new StringBuilder("/containers/json");
                message_builder.append(filter_builder.build());
                return deserializeContainers(this.client.send("GET", message_builder.str).payload);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while fetching container list from docker daemon : %s".printf(e.message));
            }
        }

        /**
         * Pause a single container
         *
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#pause-a-container]]
         */
        public void pause(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/%s/pause".printf(container.id));

                var error_messages = create_error_messages();
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while pausing container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Unpause a single container
         *
         * Se See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#unpause-a-container]]
         */
        public void unpause(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/%s/unpause".printf(container.id));

                var error_messages = create_error_messages();
                error_messages.set(304, "Container already started");
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while unpausing container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Restart a single container
         *
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#/restart-a-container]]
         */
        public void restart(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/%s/restart".printf(container.id));

                var error_messages = create_error_messages();
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while restarting container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Remove a single container
         * Force option : when set to true, will force the removal of running containers
         */
        public void remove(Model.Container container, bool force = false) throws Io.RequestError {

            try {

                StringBuilder message = new StringBuilder("/containers/%s".printf(container.id));

                if (force == true) {
                    message.append("?force=true");
                }

                var response = this.client.send("DELETE", message.str);

                var error_messages = create_error_messages();
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while killing container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Start a single container
         *
         * See See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#start-a-container]]
         */
        public void start(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/%s/start".printf(container.id));

                var error_messages = create_error_messages();
                error_messages.set(304, "Container already started");
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while starting container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Start a single container
         *
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#stop-a-container]]
         */
        public void stop(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/%s/stop".printf(container.id));

                var error_messages = create_error_messages();
                error_messages.set(304, "Container already stopped");
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while killing container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Kill a single container
         *
         * See See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#kill-a-container]]
         */
        public void kill(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/%s/kill".printf(container.id));

                var error_messages = create_error_messages();
                error_messages.set(304, "Container already stopped");
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while stoping container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Rename a single container
         *
         * See See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#rename-a-container]]
         */
        public void rename(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/%s/rename?name=%s".printf(container.id, container.name));

                var error_messages = create_error_messages();
                error_messages.set(404, "No such container");
                error_messages.set(409, "Name already assigned to another container");

                this.throw_error_from_status_code(204, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while renaming container %s : %s".printf(container.id, e.message));
            }
        }

        /**
         * Get containers that were created from the given image
         *
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers]]
         */
        public Model.ContainerCollection find_by_image(Model.Image image) throws Io.RequestError {

            try {

                var container_collection = new Model.ContainerCollection();

                foreach(Model.ContainerStatus status in Model.ContainerStatus.all()) {

                    Model.ContainerCollection containers = list(status);

                    foreach(Model.Container container in containers) {
                        if (image.full_id == container.image_id) {
                            container_collection.add(container);
                        }
                    }
                }

                return container_collection;

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while fetching containers by image (%s)".printf(e.message));
            }
        }
        
        /**
         * Get containers that were created from the given images
         *
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers]]
         */
        public Model.ContainerCollection find_by_images(Model.ImageCollection images) throws Io.RequestError {

            Model.ContainerCollection containers = new Model.ContainerCollection();
            
            try {
                foreach(Model.Image image in images) {
                    containers.add_collection(this.find_by_image(image));
                }

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while fetching containers for images [%s](%s)".printf(string.join(", ", containers.get_ids()), e.message));
            }
            
            return containers;
        }

        /**
         * Create a container from a given Image
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#/create-a-container]]
         */
        public void create(Model.ContainerCreate container_create) throws Io.RequestError {

            try {
                var response = this.client.send("POST", "/containers/create", container_create.serialize());

                var error_messages = create_error_messages();
                error_messages.set(400, "Bad parameter");
                error_messages.set(404, "No such container");
                error_messages.set(409, "Conflict");

                this.throw_error_from_status_code(201, response, error_messages);

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while creating container from image %s".printf(container_create.image.id));
            }
        }

        /**
         * Inspect a container
         * See [[https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#/inspect-a-container]]
         */
        public string inspect(Model.Container container) throws Io.RequestError {

            try {
                var response = this.client.send("GET", "/containers/%s/json".printf(container.id));

                var error_messages = create_error_messages();
                error_messages.set(404, "No such container");

                this.throw_error_from_status_code(200, response, error_messages);

                return response.payload;

            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while inspecting container %s".printf(container.id));
            }
        }

        /**
         * Inspect a container
         * See [[https://docs.docker.com/engine/api/v1.29/#operation/ContainerStats]]
         */
        public Io.FutureResponse<Model.ContainerStat> stats(Model.Container container) throws Io.RequestError {

            try {
                var future_response = new Io.FutureResponse<Model.ContainerStat>(this.stat_deserializer);
                return this.client.future_send(future_response, "GET", "/containers/%s/stats?stream=false".printf(container.id));
            } catch (Io.RequestError e) {
                throw new Io.RequestError.FATAL("Error while getting stats of container %s".printf(container.id));
            }
        }

        private Model.ContainerCollection deserializeContainers(string payload) {
            try {
                return this.container_deserializer.deserialize(payload);
            } catch (Error e) {
                return new Model.ContainerCollection();
            }
        }
    }
}
