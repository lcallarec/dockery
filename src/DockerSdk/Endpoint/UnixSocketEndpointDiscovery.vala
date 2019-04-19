namespace Dockery.DockerSdk.Endpoint {

    public class UnixSocketEndpointDiscovery : EndpointDiscoveryInterface, GLib.Object {

        private const string[] DEFAULT_UNIX_SOCKETS = { "/var/run/docker.sock" };

        private string[] unix_sockets;

        public UnixSocketEndpointDiscovery() {
            this.unix_sockets = UnixSocketEndpointDiscovery.DEFAULT_UNIX_SOCKETS;
        }

        public UnixSocketEndpointDiscovery.from_unix_sockets(string[] unix_sockets) {
            this.unix_sockets = unix_sockets;
        }

        public string? discover() {

            foreach (string unix_socket in this.unix_sockets) {
                var file = File.new_for_path(unix_socket);
                if (file.query_exists()) {
                    return "unix://" + unix_socket;
                }
            }

            return null;
        }
    }
}