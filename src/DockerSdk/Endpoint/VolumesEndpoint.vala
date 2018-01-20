namespace Dockery.DockerSdk.Endpoint {

    public class VolumeEndpoint : Endpoint {

         public VolumeEndpoint(Client.Client client) {
             base(client);
         }

         /**
          * Get a list of all images
          * https://docs.docker.com/engine/reference/api/docker_remote_api_v1.21/#list-containers
          */
         public Model.VolumeCollection list() throws Io.RequestError {

            try {
                return parse_volume_list_payload(this.client.send("GET", "/volumes").payload);
            } catch (Io.RequestError e) {
                 throw new Io.RequestError.FATAL("Error while fetching volumes list from docker daemon : %s".printf(e.message));
            }
        }
       
        /**
         * Parse volume list response payload
         */
        private Model.VolumeCollection parse_volume_list_payload(string payload) {

            var volumes = new Model.VolumeCollection();

            try {
                var parser = new Json.Parser();
                parser.load_from_data(payload);

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
                return volumes;
            }

            return volumes;
        }
    }
}
