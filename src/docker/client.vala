namespace Docker {

    public interface IClient : GLib.Object {

        public abstract IO.Response send(string message) throws IO.RequestError;

    }

    public abstract class Client : IClient, GLib.Object {
        
        public string path { get; protected set;}
        
        public abstract IO.Response send(string message) throws IO.RequestError;
    }

    public class UnixSocketClient : Client {
        
        const string HTTP_METHOD_HEADER_SUFFIX = " HTTP/1.1\r\nHost: localhost\r\n\r\n";
              
        private SocketClient client = new SocketClient();
        
        public UnixSocketClient(string socket_path) {
            this.path = socket_path;
        }

        /**
         * Send a message to docker daemon and return the response
         */ 
        public override IO.Response send(string message) throws IO.RequestError {
            
            StringBuilder request_builder = new StringBuilder(message); 
            request_builder.append(UnixSocketClient.HTTP_METHOD_HEADER_SUFFIX);
                
            var conn = this.create_connection();
               
            try {
                conn.output_stream.write(request_builder.str.data);    
            } catch(GLib.IOError e) {

                string err_message = "Error while sending images list request to docker daemon at %s (%s)".printf(
                    this.path,
                    e.message
                );
                throw new IO.RequestError.FATAL(err_message);
            }

            return new IO.SocketResponse(new DataInputStream(conn.input_stream));
        }        

        /**
         * Create the connection to docker daemon
         */    
        private SocketConnection? create_connection() throws IO.RequestError {
            try {
                return this.client.connect(new UnixSocketAddress(this.path));    
            } catch (GLib.Error e) {
                string err_message = "Error while fetching images list from docker daemon at %s :\n(%s)".printf(
                    this.path,
                    e.message
                );
                throw new IO.RequestError.FATAL(err_message);
            }
        }
    }
}
