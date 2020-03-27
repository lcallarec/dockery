using Dockery.DockerSdk.Model;

namespace Dockery.DockerSdk.Model.Remote {

    public class PullingImageTag : BaseModel {
        public PullingImageTag(ImageTag image) {
            this.full_id = image.name;
        }
    }
}