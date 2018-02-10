namespace Dockery.DockerSdk {

    using global::Dockery.DockerSdk.Serializer;

    public class Repository : Endpoint.EndpointAware, GLib.Object {

        private Endpoint.ImageEndpoint     _images;
        private Endpoint.ContainerEndpoint _containers;
        private Endpoint.ServerEndpoint    _server;
        private Endpoint.VolumeEndpoint    _volumes;
        private Endpoint.RegistryHubEndpoint _registry;

        /**
         * Event emitted on connection
         */
        public signal void connected(Repository repository);

        public Io.Response response { get; protected set;}

        public Client.Client docker_client { get; construct set;}
        public Client.HttpClient http_client { get; construct set;}

        public Endpoint.ImageEndpoint images() {
            return this._images;
        }

        public Endpoint.ContainerEndpoint containers() {
            return this._containers;
        }

        public Endpoint.ServerEndpoint daemon() {
            return this._server;
        }

        public Endpoint.RegistryHubEndpoint registry() {
            return this._registry;
        }

        public Endpoint.VolumeEndpoint volumes() {
            return this._volumes;
        }

        public new void connect() throws Error {
            this._server.ping();
            this.connected(this);
        }

        public Repository(Client.Client docker_client, Client.HttpClient http_client) {
            this.docker_client = docker_client;
            this.http_client = http_client;
            this._images     = new Endpoint.ImageEndpoint(docker_client, new ImageDeserializer());
            this._containers = new Endpoint.ContainerEndpoint(docker_client, new ContainerDeserializer());
            this._server     = new Endpoint.ServerEndpoint(docker_client);
            this._volumes    = new Endpoint.VolumeEndpoint(docker_client, new VolumeDeserializer());
            this._registry   = new Endpoint.RegistryHubEndpoint(http_client, new ImageTagDeserializer());
        }
    }
}
