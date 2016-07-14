namespace Sdk.Docker.Io {

    /**
     * Generic response
     */
    public abstract class Response : GLib.Object {

        public string? payload { get; protected set;}

        public int status { get; protected set;}

        public Gee.HashMap<string, string> headers { get; protected set;}

    }
}
