namespace Dockery.DockerSdk.Endpoint {

    /**
     * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21
     */
    public abstract class Endpoint {

        protected Client.Client client;

        protected Io.QueryStringBuilder filter_builder = new Io.QueryStringBuilder();

        public Endpoint(Client.Client client) {
            this.client = client;
        }

        /**
         * Throw error with the right message or do nothing if actual code == ok_status_code
         * If paylod is not empty, then the message is fetched from the response payload
         */
        protected void throw_error_from_status_code(
            int ok_status_code,
            Io.Response response,
            Gee.HashMap<int, string> map
        ) throws Io.RequestError {

            if (response.status != ok_status_code) {
                string? message = map.get(response.status);
                if (null != message) {
                    message = response.payload;
                }

                throw new Io.RequestError.FATAL(message);
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
