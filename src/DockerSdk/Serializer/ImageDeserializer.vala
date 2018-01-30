namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class ImageDeserializer : ImageDeserializerInterface, Object {

        public Model.ImageCollection deserializeList(string json) throws DeserializationError {
            var images = new Model.ImageCollection();
            try {
                var parser = new Json.Parser();
                parser.load_from_data(json);

                var nodes = parser.get_root().get_array().get_elements();

                foreach (unowned Json.Node node in nodes) {
                    images.add(new Model.Image.from(
                        node.get_object().get_string_member("Id"),
                        node.get_object().get_int_member("Created"),
                        node.get_object().get_array_member("RepoTags").get_string_element(0),
                        (uint) node.get_object().get_int_member("VirtualSize")
                    ));
                }
            } catch (Error e) {
                throw new DeserializationError.IMAGE("Error while deserializing images : %s".printf(e.message));
            }

            return images;
        }
    }
}