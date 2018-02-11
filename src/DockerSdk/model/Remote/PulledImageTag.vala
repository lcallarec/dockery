/*namespace Dockery.DockerSdk.Model {

    public class PulledImageTag : BaseModel {

        private PulledImageTagCollection layer_collection = new PulledImageTagCollection();

        public PulledImageTag(string tag) {
            this.full_id = tag;
        }

        public void add_layer_from(string id) {
            layer_collection.add(new PullImageTag(id));
        }

        public PullImageTag get_layer(string id) {
            return layer_collection.get_by_id(id);
        }
    }
}*/