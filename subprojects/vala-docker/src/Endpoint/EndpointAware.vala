namespace Dockery.DockerSdk.Endpoint {
    public interface EndpointAware {

        public abstract ImageEndpoint images();
        public abstract ContainerEndpoint containers();
        public abstract ServerEndpoint daemon();
        public abstract VolumeEndpoint volumes();
        public abstract void connect() throws Error;
    }
}