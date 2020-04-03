namespace Dockery.DockerSdk.Model.Remote {

    public class PullingLayer : BaseModel {

        public Progress progress {get; set;}

        public PullingLayer(string id, Progress progress) {
            this.full_id = id;
            this.progress = progress;
        }
    }
}