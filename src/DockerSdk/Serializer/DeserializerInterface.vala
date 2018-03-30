namespace Dockery.DockerSdk.Serializer {
    using global::Dockery.DockerSdk;

    public interface DeserializerInterface<T> : Object { 
        public abstract T deserializeList(string json) throws DeserializationError;
    }
}    