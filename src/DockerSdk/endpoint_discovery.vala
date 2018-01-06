namespace Sdk.Docker {

    public interface EndpointDiscovery : GLib.Object {
        public abstract string? discover();
    }
}
