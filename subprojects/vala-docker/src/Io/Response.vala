using Dockery.DockerSdk.Serializer;

namespace Dockery.DockerSdk.Io {

    public errordomain RequestError {
        FATAL
    }

    public class Response : GLib.Object {

        public signal void on_headers_received(Gee.HashMap<string, string> headers);
        public signal void on_payload_line_received(string line_payload);
        public signal void on_finished();

        public string? payload { get; set;}

        public int status { get; set;}

        public Gee.HashMap<string, string> headers { get; set;}
    }

    public class FutureResponse<T> : Response {

        public signal void on_response_ready(T object);

        protected DeserializerInterface<T> deserializer;

        public FutureResponse(DeserializerInterface deserializer) {
            this.deserializer = deserializer;
            this.on_payload_line_received.connect((line) => {
                T deserializedObject = this.deserialize(line);
                this.on_response_ready(deserializedObject);
            });
        }

        private T deserialize(string json) {
            return deserializer.deserialize(json);
        }
    }
}
