namespace Dockery.DockerSdk.Endpoint {

    public interface EndpointDiscoveryInterface : GLib.Object {
        public abstract string? discover();
    }
}
