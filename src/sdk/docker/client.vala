namespace Sdk.Docker {

    public interface Client : GLib.Object {

        public abstract Io.Response send(string message) throws Io.RequestError;

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

        public string path { get; protected set;}

        public abstract Io.Response send(string message) throws Io.RequestError;
    }

    public class UnixSocketClient : RestClient {

        const string HTTP_METHOD_HEADER_SUFFIX = " HTTP/1.1\r\nHost: localhost\r\n\r\n";

        private SocketClient client = new SocketClient();

        public UnixSocketClient(string socket_path) {
            this.path = socket_path;
        }

        /**
         * Send a message to docker daemon and return the response
         */
        public override Io.Response send(string message) throws Io.RequestError {

            StringBuilder request_builder = new StringBuilder(message);
            request_builder.append(UnixSocketClient.HTTP_METHOD_HEADER_SUFFIX);

            string query = request_builder.str;

            var conn = this.create_connection();

            try {
                stdout.printf("Request : %s", query);
                conn.output_stream.write(query.data);
            } catch(GLib.IOError e) {
                this.request_error(query);
                string err_message = "IO error : %s".printf(e.message);
                throw new Io.RequestError.FATAL(err_message);
            }

            var response = new Io.SocketResponse(new DataInputStream(conn.input_stream));

            this.response_success(response);

            return response;
        }

        /**
         * Create the connection to docker daemon
         */
        private SocketConnection? create_connection() throws Io.RequestError {
            try {
                return this.client.connect(new UnixSocketAddress(this.path));
            } catch (GLib.Error e) {
                this.request_error(e.message);
                string err_message = "%s :\n(%s)".printf(this.path, e.message);
                throw new Io.RequestError.FATAL(err_message);
            }
        }
    }
}
