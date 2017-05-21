namespace Sdk.Docker.Io {

    /**
     * Future Response
     */
    public class FutureResponse : GLib.Object {

		public signal void on_status_received(int status);
		public signal void on_header_received(string hearder_name, string header_value);
		public signal void on_payload_line_received(string line);

        public string? payload { get; set;}

        public int status { get; set;}

        public Gee.HashMap<string, string> headers { get; set;}
    }
}
