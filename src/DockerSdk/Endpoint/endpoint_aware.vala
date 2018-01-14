namespace Dockery.DockerSdk.Endpoint {
    public interface EndpointAware {

        public abstract ImageEndpoint images();
        public abstract ContainerEndpoint containers();
        public abstract void connect() throws Error;
    }
}