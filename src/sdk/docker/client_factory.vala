namespace Sdk.Docker {

    public class ClientFactory : GLib.Object {

        public static Client? create_from_url(string url) {
			
			var registered_clients = get_registered_clients();
			
			for (int i = 0; i < registered_clients.length; i++) {
				RestClient client = (RestClient) Object.new(registered_clients[i], "url", url);
				if (client.supportUri()) {
					return client;
				}
			}
			
			return null;
		}
		
		private static Type[] get_registered_clients() {
			Type[] types = new Type[2];
			
			types[0] = typeof(UnixSocketClient);
			types[1] = typeof(HttpClient);
	
			return  types;
		}

    }
}
