using Dockery.DockerSdk;
using Dockery.DockerSdk.Model;

namespace Dockery.DockerSdk.Serializer {

    public class PullStepDeserializer : Object {

        public Model.Remote.PullStep? deserialize(string json) throws DeserializationError {

            Model.Remote.PullStep pull_step;

            try {
                var parser = new Json.Parser();

                parser.load_from_data(json);

                var node = parser.get_root();

                string id;
                
                if (node.get_object().has_member("id")) {
                    id = node.get_object().get_string_member("id");
                } else {
                    //Digest status case
                    id = "NA";
                }
                
                string status = node.get_object().get_string_member("status");
                
                Remote.PullStepProgress? progress = null;

                if (node.get_object().has_member("progressDetail")) {
                    var progress_details = node.get_object().get_object_member("progressDetail");
                    if (progress_details.has_member("current") && progress_details.has_member("total")) {
                        progress = new Remote.PullStepProgress(
                            progress_details.get_int_member("current"),
                            progress_details.get_int_member("total")
                        );
                    }
                }

                return new Model.Remote.PullStep.from(
                    Remote.PullStep.get_status_from_raw_status(status),
                    id,
                    progress
                );

            } catch (Error e) {
                throw new DeserializationError.PULL_PROCESS_DATA("Error while deserializing pull step : %s".printf(e.message));
            }
        }
    }
}