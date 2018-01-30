namespace Dockery.DockerSdk {

    using global::Dockery.DockerSdk.Serializer;

    public class Repository : Endpoint.EndpointAware, GLib.Object {

        private Endpoint.ImageEndpoint     _images;
        private Endpoint.ContainerEndpoint _containers;
        private Endpoint.ServerEndpoint    _server;
        private Endpoint.VolumeEndpoint    _volumes;

        /**
         * Event emitted on connection
         */
        public signal void connected(Repository repository);

        public Io.Response response { get; protected set;}

        private Client.Client client { get; private set;}

        public Endpoint.ImageEndpoint images() {
            return this._images;
        }

        public Endpoint.ContainerEndpoint containers() {
            return this._containers;
        }

        public Endpoint.ServerEndpoint daemon() {
            return this._server;
        }

        public Endpoint.VolumeEndpoint volumes() {
            return this._volumes;
        }

        public new void connect() throws Error {
            this._server.ping();
            this.connected(this);
        }

        public Repository(Client.Client client) {
            this.client     = client;
            this._images     = new Endpoint.ImageEndpoint(client, new ImageDeserializer());
            this._containers = new Endpoint.ContainerEndpoint(client, new ContainerDeserializer());
            this._server     = new Endpoint.ServerEndpoint(client);
            this._volumes    = new Endpoint.VolumeEndpoint(client);
        }
    }
}
