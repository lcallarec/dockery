namespace Dockery.DockerSdk.Endpoint {

    public class EndpointDiscovery: EndpointDiscoveryInterface, GLib.Object {

        private static EndpointDiscoveryInterface[] DEFAULT_DISCOVERERS = {
                new UnixSocketEndpointDiscovery(),
                new HttpEndpointDiscovery()
        };

        private EndpointDiscoveryInterface[] discoverers;

        public EndpointDiscovery() {
            this.discoverers = EndpointDiscovery.DEFAULT_DISCOVERERS;
        }

        public EndpointDiscovery.from_discoverers(EndpointDiscoveryInterface[] discoverers) {
            this.discoverers = discoverers;
        }

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
