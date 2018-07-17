using Dockery.DockerSdk.Serializer;

namespace Dockery.DockerSdk.Io {

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
