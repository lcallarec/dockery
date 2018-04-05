namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class ContainerStatDeserializer : DeserializerInterface<Model.ContainerStat>, Object {

        public Model.ContainerStat deserializeList(string json) throws DeserializationError {

             try {
                var parser = new Json.Parser();
                parser.load_from_data(json);

                var node_object = parser.get_root().get_object();
                var memory_stats_object = node_object.get_object_member("memory_stats");

                return new Model.ContainerStat.from(
                    node_object.get_string_member("read"),
                    new Model.Stat.ContainerMemoryStat.from(
                        memory_stats_object.get_int_member("max_usage"),
                        memory_stats_object.get_int_member("usage"),
                        memory_stats_object.get_int_member("limit")
                    )
                );
       
            } catch (Error e) {
                throw new DeserializationError.CONTAINER("Error while deserializing container stat : %s".printf(e.message));
            }
        }
    }
}