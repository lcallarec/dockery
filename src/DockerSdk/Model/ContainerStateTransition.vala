cd ..namespace Dockery.DockerSdk.Model {

    public class ContainerStateTransition : Object {
        
        public static bool can_be_removed(Container container) {
            return true;
        }

        public static bool can_be_restarted(Container container) {
            if (container.status.is_active(container.status)) {
                return true;
            }

            return false;
        }

        public static bool can_be_stopped(Container container) {
            if (container.status.is_active(container.status)) {
                return true;
            }

            return false;
        }

        public static bool can_be_paused(Container container) {
            if (container.status == ContainerStatus.RUNNING) {
                return true;
            }

            return false;
        }

        public static bool can_be_started(Container container) {
            if (!container.status.is_active(container.status)) {
                return true;
            }

            return false;
        }

        public static bool can_be_renamed(Container container) {
            if (container.status.is_active(container.status)) {
                return true;
            }

            return false;
        }

        public static bool can_be_inspected(Container container) {
            if (container.status.is_active(container.status)) {
                return true;
            }

            return false;
        }

    }
}
