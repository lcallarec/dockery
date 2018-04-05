namespace Dockery.DockerSdk.Serializer {
    using global::Dockery.DockerSdk;

    public interface DeserializerInterface<TCollection> : Object { 
        public abstract TCollection deserializeList(string json) throws DeserializationError;
    }
}    