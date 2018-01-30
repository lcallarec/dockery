namespace Dockery.DockerSdk.Serializer {
    using global::Dockery.DockerSdk;

    public interface ContainerDeserializerInterface : Object { 
        public abstract Model.ContainerCollection deserializeList(string json, Model.ContainerStatus status) throws DeserializationError;
    }
}    