namespace Dockery.DockerSdk.Model.Remote {
    public enum PullStepStatus {
        PULLING_FROM,
        PULLING_FS_LAYER,
        WAITING,
        DOWNLOADING,
        DOWNLOAD_COMPLETE,
        VERIFYING_CHECKSUM,
        EXTRACTING,
        UNKOWN;

        public string to_string() {
            switch (this) {
                case DOWNLOADING:
                    return "Downloading";
                case EXTRACTING:
                    return "Extracting";
                case VERIFYING_CHECKSUM:
                    return "Verifying Checksum";
                case WAITING:
                    return "Waiting";
                case PULLING_FROM:
                    return "Pulling from image tag";
                case PULLING_FS_LAYER:
                    return "Pulling fs layer";
                case DOWNLOAD_COMPLETE:
                    return "Download complete";
                default:
                    return "Unkown";
            }
        }
    }
}