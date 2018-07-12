using global::Dockery.DockerSdk.Serializer;

public class MockDeserializer : DeserializerInterface<string>, Object {

    public string deserialize(string json) throws DeserializationError {
        return json;
    }
}
