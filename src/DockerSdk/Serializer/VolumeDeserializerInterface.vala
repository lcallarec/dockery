namespace Dockery.DockerSdk.Serializer {
    using global::Dockery.DockerSdk;

    public interface VolumeDeserializerInterface : Object { 
        public abstract Model.VolumeCollection deserializeList(string json) throws DeserializationError;
    }
}    