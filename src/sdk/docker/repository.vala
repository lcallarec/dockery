namespace Sdk.Docker {
    
    public interface EndpointAware {
        
        public abstract ImageEndpoint images();
        
        public abstract ContainerEndpoint containers();
    }

    public class Repository : EndpointAware, GLib.Object {
        
        public Response response     { get; protected set;}

        public ImageEndpoint images() {
            return this._images;
        }
        
        public ContainerEndpoint containers() {
            return this._containers;
        }

        private Client        client     { get; private set;}

        private ImageEndpoint _images;

        private ContainerEndpoint _containers;
        
        public Repository(Client client) {
            this.client     = client;
            this._images     = new ImageEndpoint(client);
            this._containers = new ContainerEndpoint(client);
        }
    }
}
