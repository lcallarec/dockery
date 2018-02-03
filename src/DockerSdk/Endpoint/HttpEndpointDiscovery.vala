namespace Dockery.DockerSdk.Endpoint {

    public class HttpEndpointDiscovery : EndpointDiscoveryInterface, GLib.Object {

        private const string[] ENDPOINTS = {"http://localhost:2375", "http://127.0.0.1:2375"};

        public string? discover() {

            foreach (string endpoint in HttpEndpointDiscovery.ENDPOINTS) {
                try {
                    var message = new Soup.Message("GET", endpoint);
                    var session = new Soup.Session();
                    session.send(message);
                    return endpoint;
                } catch (Error e) {
                    return null;
                }
            }

            return null;
        }
    }
}