namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class ContainerDeserializer : ContainerDeserializerInterface, Object {

        public Model.ContainerCollection deserializeList(string json, Model.ContainerStatus status) throws DeserializationError {

            var containers = new Model.ContainerCollection();

            try {
                var parser = new Json.Parser();
                parser.load_from_data(json);

                var nodes = parser.get_root().get_array().get_elements();

                foreach (unowned Json.Node node in nodes) {

                    var names_node = node.get_object().get_array_member("Names");
                    uint len       = names_node.get_length();
                    Array<string> names = new Array<string>();

                    for (int i = 0; i < len; i++) {
                        names.append_val(names_node.get_string_element(i));
                    }

                    containers.add(new Model.Container.from(
                        node.get_object().get_string_member("Id"),
                        node.get_object().get_int_member("Created"),
                        node.get_object().get_string_member("Command"),
                        node.get_object().get_string_member("ImageID"),
                        names,
                        status
                    ));
                }
            } catch (Error e) {
                throw new DeserializationError.CONTAINER("Error while deserializing container : %s".printf(e.message));
            }

            return containers;
        }
    }
}