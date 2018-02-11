using Dockery.DockerSdk.Model;

namespace Dockery.DockerSdk.Model.Remote {

    public class PullStep : BaseModel {

        public PullStepStatus status {get; construct set;}
        public PullStepProgress? progress {get; construct set;}

        public PullStep.from(PullStepStatus status, string id, PullStepProgress? progress) {
            this.full_id = id;
            this.status = status;
            this.progress = progress;
        }

        public static PullStepStatus get_status_from_raw_status(string raw_status) {

            if(raw_status.index_of("Downloading") == 0) return PullStepStatus.DOWNLOADING;
            if(raw_status.index_of("Extracting") == 0)   return PullStepStatus.EXTRACTING;
            if(raw_status.index_of("Verifying Checksum") == 0) return PullStepStatus.VERIFYING_CHECKSUM;
            if(raw_status.index_of("Waiting") == 0) return PullStepStatus.WAITING;
            if(raw_status.index_of("Pulling from") == 0) return PullStepStatus.PULLING_FROM;
            if(raw_status.index_of("Pulling fs layer") == 0) return PullStepStatus.PULLING_FS_LAYER;
            if(raw_status.index_of("Download complete") == 0) return PullStepStatus.DOWNLOAD_COMPLETE;

            return PullStepStatus.UNKOWN;
        }
    }
}    