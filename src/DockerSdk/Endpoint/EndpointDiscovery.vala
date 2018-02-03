namespace Dockery.DockerSdk.Endpoint {

    public interface EndpointDiscovery : GLib.Object {
        public abstract string? discover();
    }
}
