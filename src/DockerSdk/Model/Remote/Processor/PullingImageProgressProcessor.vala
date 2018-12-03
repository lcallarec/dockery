using Dockery.DockerSdk.Model.Remote;

namespace Dockery.DockerSdk.Model.Remote.Processor {

    public class PullingImageProgressProcessor : GLib.Object {

        private Gee.HashMap<string, PullingLayer> layers = new Gee.HashMap<string, PullingLayer>();

        public Progress progress { get; private set; }

        private PullingImageTag image_tag;

        public PullingImageProgressProcessor(ImageTag image) {
            this.progress = new Progress(0, 0);
            this.image_tag = new PullingImageTag(image);
        }

        public void process(PullStep step) {

            if (step.status == PullStepStatus.PULLING_FS_LAYER) {
                this.layers.set(step.id, new PullingLayer(step.id, new Progress(0, 0)));
            } else if (step.status == PullStepStatus.DOWNLOADING) {
                if (this.layers.has_key(step.id)) {
                    var layer = this.layers.get(step.id);
                    layer.progress = new Progress(step.progress.current, step.progress.total);
                    this.progress  = new Progress(step.progress.current, step.progress.total);
                }
            }

            this.recomputeProgress();
        }

        public void recomputeProgress() {
            int current = 0;
            int total = 0;
            foreach(var layer in this.layers.entries) {
                current += layer.value.progress.current;
                total   += layer.value.progress.total;
            };
            this.progress = new Progress(current, total);
        }
     }
}
