namespace Dockery.DockerSdk.Serializer {
    using global::Dockery.DockerSdk;

    public interface ImageTagDeserializerInterface : Object { 
        public abstract Model.ImageTagCollection deserializeList(string json) throws DeserializationError;
    }
}    