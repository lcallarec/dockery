namespace Dockery.DockerSdk.Model {

    /**
     * ImageTag model
     */
    public class ImageTag : BaseModel {

        public string name {get; construct set;}
        public string layer {get; construct set;}

        public ImageTag.from(string name, string layer) {
            this.full_id = name;
            this.name = name;
            this.layer = layer;
        }
    }
}
