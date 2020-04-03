namespace Dockery.DockerSdk.Client {
    public class HttpClient : RestClient {

        private Soup.Session session = new Soup.Session();

        public HttpClient(string http_uri) {
            this.uri = http_uri;
        }

        public override bool supportUri() {
            return uri.has_prefix("http://") || uri.has_prefix("https://");
        }

        public override Io.Response send(string method, string endpoint, string? body = null) {

            var message = new Soup.Message(method, this.uri + endpoint);
            if (body != null) {
                var request_body = new Soup.MessageBody();
                request_body.append_take(body.data);
            }

            session.send_message(message);

            var response = Io.HttpResponseFactory.create(message);

            return response;
        }

        public override Io.FutureResponse future_send(Io.FutureResponse future_response, string method, string endpoint, string? body = null) {
            var message = new Soup.Message(method, this.uri + endpoint);

            if (body != null) {
                var request_body = new Soup.MessageBody();
                request_body.append_take(body.data);
            }

            new GLib.Thread<int>("future_send", () => {

                //TODO: use send method
                session.send_message(message);

                Io.HttpResponseFactory.future_create(message, future_response);
                return 0;
            });

            return future_response;
        }
    }
}