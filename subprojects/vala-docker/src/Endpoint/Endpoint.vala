using Dockery.DockerSdk.Io;

namespace Dockery.DockerSdk.Endpoint {

    using global::Dockery.DockerSdk.Serializer;

    /**
     * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21
     */
    public abstract class Endpoint {

        protected Client.Client client;

        protected Io.QueryStringBuilder filter_builder = new Io.QueryStringBuilder();

        public Endpoint(Client.Client client) {
            this.client = client;
        }

        protected void throw_error_from_status_code(
            int ok_status_code,
            Io.Response response,
            Gee.HashMap<int, string> map
        ) throws RequestError {

            if (response.status != ok_status_code) {
                string? message = map.get(response.status);
                if (null == message) {
                    message = response.payload;
                }

                if (null == message && response.status < 100) {
                    message = "Unable to reach the service. Aborting.";
                }

                if (null == message) {
                    message = "Unkown error while requesting the docker deamon";
                }

                throw new RequestError.FATAL(message);
            }
        }

        /**
         * Create and return a base HashMap of status code => messages, compatible with all container requests
         */
        protected Gee.HashMap<int, string> create_error_messages() {

            var error_messages = new Gee.HashMap<int, string>();
            error_messages.set(500, "Docker daemon fatal error");

            return error_messages;
        }
    }
}
