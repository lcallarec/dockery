namespace Dockery.DockerSdk.Io {

    public class HttpResponseFactory: GLib.Object {

        public static Response create(Soup.Message message) {
            return HttpResponseFactory.buildResponseFrom(message, new Response());
        }

        public static FutureResponse future_create(Soup.Message message, FutureResponse response) {
            return (HttpResponseFactory.buildResponseFrom(message, response) as FutureResponse);
        }

        private static Response buildResponseFrom(Soup.Message message, Response response) {
            
            response.status = (int) message.status_code;

            var headers = new Gee.HashMap<string, string>();
            message.response_headers.foreach((name, value) => {
                headers.set(name, value);
            });

            response.headers = headers;
            
            response.payload = (string) message.response_body.data;

            return response;
        }
    }
}
