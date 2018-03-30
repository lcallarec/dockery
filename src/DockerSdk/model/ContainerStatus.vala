namespace Dockery.DockerSdk.Model {
    public enum ContainerStatus {
        CREATED,
        RESTARTING,
        RUNNING,
        PAUSED,
        EXITED;

        public static ContainerStatus[] all() {
            return {RUNNING, PAUSED, EXITED, CREATED, RESTARTING};
        }

        public static ContainerStatus[] active() {
            return {RUNNING, PAUSED};
        }

        public static bool is_active(ContainerStatus status) {
            return status in ContainerStatus.active();
        }
    }
}