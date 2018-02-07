namespace Dockery.DockerSdk.Model {

    public class ImageTagCollection : Collection<ImageTag> {
        public ImageTagCollection.from_model(BaseModel item) {
            this.add(item);
        }
    }
}