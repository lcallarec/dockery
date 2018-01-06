namespace Dockery.DockerSdk {

    public interface EndpointDiscovery : GLib.Object {
        public abstract string? discover();
    }
}
