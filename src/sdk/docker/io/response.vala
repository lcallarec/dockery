namespace Sdk.Docker.Io {

    /**
     * Generic response
     */
    public class Response : GLib.Object {

        public string? payload { get; set;}

        public int status { get; set;}

        public Gee.HashMap<string, string> headers { get; set;}
    }
}
