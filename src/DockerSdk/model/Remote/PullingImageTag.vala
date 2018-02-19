using Dockery.DockerSdk.Model;

namespace Dockery.DockerSdk.Model.Remote {

    public class PullingImageTag : BaseModel {

        private new Gee.HashMap<string, PullingLayer> layers = new Gee.HashMap<string, PullingLayer>();

        public PullingImageTag(ImageTag image) {
            this.full_id = image.name;
        }
    }
}