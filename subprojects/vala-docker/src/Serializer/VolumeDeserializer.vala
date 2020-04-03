namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;
    
    public class VolumeDeserializer : DeserializerInterface<Model.VolumeCollection>, Object {

        public Model.VolumeCollection deserialize(string json) throws DeserializationError {

            var volumes = new Model.VolumeCollection();
            try {
                var parser = new Json.Parser();
                parser.load_from_data(json);

                var nodes = parser.get_root().get_object().get_array_member("Volumes").get_elements();
                
                foreach (unowned Json.Node node in nodes) {
                    var labels = new Gee.HashMap<string, string>();
                    var nodeLabels = node.get_object().get_object_member("Labels");
                    if (nodeLabels != null) {
                        nodeLabels.foreach_member((object, name, _node) => {
                            labels.set(name, _node.get_object().get_string_member(name));
                        });
                    }

                    var options = new Gee.HashMap<string, string>();
                    var nodeOptions = node.get_object().get_object_member("Options");
                    if (nodeOptions != null) {
                        nodeOptions.foreach_member((object, name, _node) => {
                            options.set(name, _node.get_object().get_string_member(name));
                        });
                    }
                    
                    volumes.add(new Model.Volume.from(
                        node.get_object().get_string_member("Name"),
                        node.get_object().get_string_member("Driver"),
                        node.get_object().get_string_member("Mountpoint"),
                        labels,
                        options
                    ));
                }
            } catch (Error e) {
                throw new DeserializationError.VOLUME("Error while deserializing volumes : %s".printf(e.message));
            }

            return volumes;
        }
    }
}