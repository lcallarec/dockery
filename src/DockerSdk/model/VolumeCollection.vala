namespace Dockery.DockerSdk.Model {

    public class VolumeCollection : Collection<Volume> {
        public VolumeCollection.from_model(BaseModel item) {
            this.add(item);
        }
    }
}