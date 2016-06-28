namespace Sdk.Docker {

    public interface EndpointAware {

        public abstract ImageEndpoint     images();
        public abstract ContainerEndpoint containers();
        public abstract ServerEndpoint    server();
    }

    public class Repository : EndpointAware, GLib.Object {

        private ImageEndpoint     _images;
        private ContainerEndpoint _containers;
        private ServerEndpoint    _server;

        public Response response     { get; protected set;}

        private Client  client     { get; private set;}

        public ImageEndpoint images() {
            return this._images;
        }

        public ContainerEndpoint containers() {
            return this._containers;
        }

        public ServerEndpoint server() {
            return this._server;
        }

        public Repository(Client client) {
            this.client     = client;
            this._images     = new ImageEndpoint(client);
            this._containers = new ContainerEndpoint(client);
            this._server     = new ServerEndpoint(client);
        }
    }
}
