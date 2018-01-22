namespace Dockery.DockerSdk.Serializer {
    using global::Dockery.DockerSdk;

    public interface ImageDeserializerInterface : Object { 
        public abstract Model.ImageCollection deserializeList(string json) throws DeserializationError;
    }
}    