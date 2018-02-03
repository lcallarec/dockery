namespace Dockery.DockerSdk.Endpoint {

    public class EndpointDiscovery: EndpointDiscoveryInterface, GLib.Object {

        private EndpointDiscoveryInterface[] discoverers = {
                new UnixSocketEndpointDiscovery(),
                new HttpEndpointDiscovery()
        };

        public string? discover() {
            foreach(EndpointDiscoveryInterface discoverer in this.discoverers) {
                var discovered = discoverer.discover();
                if (discovered != null) {
                    return discovered;
                }
            }

            return null;
        }
    }
}
