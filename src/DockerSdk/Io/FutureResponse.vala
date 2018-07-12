namespace Dockery.DockerSdk.Io {

    using global::Dockery.DockerSdk.Serializer;
    /**
     * Future Response
     */
    public class FutureResponse<T> : Response {
        
        protected DeserializerInterface<T> deserializer;

        public FutureResponse(DeserializerInterface deserializer) {
            this.deserializer = deserializer;
        }

        public T deserialize(string json) {
            return deserializer.deserialize(json);
        }
    }
}
