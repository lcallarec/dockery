namespace Dockery.DockerSdk {

    public class Repository : EndpointAware, GLib.Object {

        private ImageEndpoint     _images;
        private ContainerEndpoint _containers;
        private ServerEndpoint    _server;

        /**
         * Event emitted on connection
         */
        public signal void connected(Repository repository);

        public Io.Response response { get; protected set;}

        private Client.Client client { get; private set;}

        public ImageEndpoint images() {
            return this._images;
        }

        public ContainerEndpoint containers() {
            return this._containers;
        }

        public ServerEndpoint daemon() {
            return this._server;
        }

        public new void connect() throws Error {
            this._server.ping();
            this.connected(this);
        }

        public Repository(Client.Client client) {
            this.client     = client;
            this._images     = new ImageEndpoint(client);
            this._containers = new ContainerEndpoint(client);
            this._server     = new ServerEndpoint(client);
        }
    }
}
