namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class ImageTagDeserializer : DeserializerInterface<Model.ImageTagCollection>, Object {

        public Model.ImageTagCollection deserialize(string json) throws DeserializationError {

            var tags = new Model.ImageTagCollection();
            try {
                var parser = new Json.Parser();
                parser.load_from_data(json);

                var nodes = parser.get_root().get_array();
                
                nodes.foreach_element((array, index, node) => {
                    tags.add(new Model.ImageTag.from(
                        node.get_object().get_string_member("name"),
                        node.get_object().get_string_member("layer")
                    ));
                });
            } catch (Error e) {
                throw new DeserializationError.IMAGE_TAG("Error while deserializing image tags : %s".printf(e.message));
            }

            return tags;
        }
    }
}