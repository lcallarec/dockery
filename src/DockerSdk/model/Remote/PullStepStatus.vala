namespace Dockery.DockerSdk.Model.Remote {
    public enum PullStepStatus {
        PULLING_FROM,
        ALREADY_EXISTS,
        PULLING_FS_LAYER,
        PULL_COMPLETE,
        WAITING,
        DOWNLOADING,
        DOWNLOAD_COMPLETE,
        VERIFYING_CHECKSUM,
        EXTRACTING,
        DIGEST,
        DOWNLOADED_NEWER_IMAGE_FOR,
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
                case ALREADY_EXISTS:
                    return "Already exists";
                case PULL_COMPLETE:
                    return "Pull complete";
                case DOWNLOAD_COMPLETE:
                    return "Download complete";
                case DIGEST:
                    return "Digest";
                case DOWNLOADED_NEWER_IMAGE_FOR:
                    return "Downloaded newer image for";
                default:
                    return "Unkown";
            }
        }
    }
}