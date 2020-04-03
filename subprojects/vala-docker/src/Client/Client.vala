using Dockery.DockerSdk;
using Dockery.DockerSdk.Io;

namespace Dockery.DockerSdk.Client {

    public interface Client : GLib.Object {
        
        public abstract Io.Response send(string method, string endpoint, string? body = null) throws RequestError;
        public abstract Io.FutureResponse future_send(Io.FutureResponse future_response, string method, string endpoint, string? body = null) throws RequestError;
        public abstract bool supportUri();
                
        /**
         * This signal is emitted just after a valid and handled response has been created
         */
        public signal void response_success(Io.Response response);

        /**
         * This signal is emitted just after a request error
         */
        public signal void request_error(string data);

    }

    public abstract class RestClient : Client, GLib.Object {
        
        public string uri { get; protected set;}
        
        public abstract Io.Response send(string method, string endpoint, string? body = null) throws RequestError;
        public abstract Io.FutureResponse future_send(Io.FutureResponse future_response, string method, string endpoint, string? body = null);
        public abstract bool supportUri();
    }

    public class ClientFactory : GLib.Object {

        public static Client? create_from_uri(string uri) {
            
            var registered_clients = get_registered_clients();
            
            for (int i = 0; i < registered_clients.length; i++) {
                RestClient client = (RestClient) Object.new(registered_clients[i], "uri", uri);
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
    
            return types;
        }

    }
}
