namespace Dockery.DockerSdk.Serializer {
    using global::Dockery.DockerSdk;

    public interface DeserializerInterface<T> : Object { 
        public abstract T deserialize(string json) throws DeserializationError;
    }
}    