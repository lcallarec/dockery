using Dockery.DockerSdk.Io;

namespace Dockery.DockerSdk.Endpoint {

    using global::Dockery.DockerSdk.Serializer;

    /**
     * Docker service endpoint
     *
     * Available features :
     * - Ping
     * - Events
     */
    public class ServerEndpoint : Endpoint {

        public ServerEndpoint(Client.Client client) {
            base(client);
        }

        /**
         * Ping the server
         * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.2/#ping-the-docker-server
         */
        public void ping() throws RequestError {

            try {
                var response = this.client.send("GET", "/_ping");

                var error_messages = create_error_messages();
                error_messages.set(200, "Pong");
                error_messages.set(500, "Service unavailable");

                this.throw_error_from_status_code(200, response, error_messages);

            } catch (Error e) {
                throw new RequestError.FATAL("Error while pinging the docker service : %s".printf(e.message));
            }
        }
        
        /**
         * Get docker events stream
         * https://docs.docker.com/engine/api/v1.31/#operation/SystemEvents
         */
        public Io.FutureResponse events() throws RequestError {

            try {
                var future_response = new Io.FutureResponse<Model.ContainerStat>(new EventDeserializer());
                return this.client.future_send(future_response, "GET", "/events");
            } catch (Error e) {
                throw new RequestError.FATAL("Error while streaming Docker events");
            }
        }
    }
}
