namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class ImageDeserializer : DeserializerInterface<Model.ImageCollection>, Object {

        public Model.ImageCollection deserialize(string json) throws DeserializationError {
            var images = new Model.ImageCollection();
            try {
                var parser = new Json.Parser();
                parser.load_from_data(json);

                var nodes = parser.get_root().get_array().get_elements();

                foreach (unowned Json.Node node in nodes) {
                    var first_repo_tag = "";
                    if (node.get_object().get_null_member("RepoTags") == false) {
                        var repo_tags = node.get_object().get_array_member("RepoTags");
                        if (repo_tags.get_length() > 0) {
                            first_repo_tag = repo_tags.get_string_element(0);
                        }
                    }
                    images.add(new Model.Image.from(
                        node.get_object().get_string_member("Id"),
                        node.get_object().get_int_member("Created"),
                        first_repo_tag,
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