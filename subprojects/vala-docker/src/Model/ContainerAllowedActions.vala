namespace Dockery.DockerSdk.Model {

    public class ContainerAllowedActions : Object {
        
        private Container container;

        public ContainerAllowedActions(Container container) {
            this.container = container;
        }

        public bool can_be_removed() {
            return true;
        }

        public bool can_be_restarted() {
            return container.status.is_active(container.status);
        }

        public bool can_be_stopped() {
            return container.status == ContainerStatus.RUNNING;
        }

        public bool can_be_paused() {
            return container.status == ContainerStatus.RUNNING;
        }

        public bool can_be_unpaused() {
            return container.status == ContainerStatus.PAUSED;
        }

        public bool can_be_started() {
            return !container.status.is_active(container.status);
        }

        public bool can_be_renamed() {
            return container.status.is_active(container.status) || container.status == ContainerStatus.EXITED;
        }

        public bool can_be_killed() {
            return container.status == ContainerStatus.RUNNING;
        }

        public bool can_be_inspected() {
            return true;
        }

        public bool can_be_stated() {
            return container.status == ContainerStatus.RUNNING;
        }

        public bool can_be_connected() {
            return container.status == ContainerStatus.RUNNING;
        }
    }
}
