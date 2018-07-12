namespace Dockery.DockerSdk.Io {

    using global::Dockery.DockerSdk.Serializer;
    /**
     * Future Response
     */
    public class FutureResponse<T> : Response {
        
        protected DeserializerInterface<T> stat_deserializer;
        
        public DeserializerInterface<T> deserializer { 
            get {
                return this.stat_deserializer;
            }

            construct set {
                this.stat_deserializer = value;
            }
        }

        public FutureResponse(DeserializerInterface deserializer) {
            this.deserializer = deserializer;
        }
    }
}
