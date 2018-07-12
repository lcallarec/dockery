namespace Dockery.DockerSdk.Client {

    public abstract class RestClient : Client, GLib.Object {
        
        public string uri { get; protected set;}
        
        public abstract Io.Response send(string method, string endpoint, string? body = null) throws Io.RequestError;
        public abstract Io.FutureResponse future_send(Io.FutureResponse future_response, string method, string endpoint, string? body = null);
        public abstract bool supportUri();
    }

}
