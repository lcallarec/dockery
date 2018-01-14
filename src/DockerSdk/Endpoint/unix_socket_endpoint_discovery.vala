namespace Dockery.DockerSdk.Endpoint {

    public class UnixSocketEndpointDiscovery : EndpointDiscovery, GLib.Object {

        private const string[] UNIX_SOCKETS = {"/var/run/docker.sock"};

        public string? discover() {

            foreach (string unix_socket in UnixSocketEndpointDiscovery.UNIX_SOCKETS) {
                var file = File.new_for_path(unix_socket);
                if (file.query_exists()) {
                    return "unix://" + unix_socket;
                }
            }

            return null;
        }
    }
}