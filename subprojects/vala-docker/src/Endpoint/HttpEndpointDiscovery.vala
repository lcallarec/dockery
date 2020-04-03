namespace Dockery.DockerSdk.Endpoint {

    public class HttpEndpointDiscovery : EndpointDiscoveryInterface, GLib.Object {
    
        private const string[] DEFAULT_ENDPOINTS = {
            "http://127.0.0.1:2375",
            "http://127.0.0.1:2376"
        };
        
        private string[] endpoints;

        public HttpEndpointDiscovery() {
            this.endpoints = HttpEndpointDiscovery.DEFAULT_ENDPOINTS;
        }

        public HttpEndpointDiscovery.from_endpoints(string[] endpoints) {
            this.endpoints = endpoints;
        }

        public string? discover() {

            string endpoint_found = null;
            foreach (string endpoint in this.endpoints) {
                try {
                    var message = new Soup.Message("GET", endpoint + "/_ping");
                    var session = new Soup.Session();
                    session.send(message);
                    endpoint_found = endpoint;
                    break;
                } catch (Error e) {
                    endpoint_found = null;
                }
            }

            return endpoint_found;
        }
    }
}