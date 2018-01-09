namespace Dockery.DockerSdk.Model {
    /**
    * Convert container status from a type / to another type
    */
    public class ContainerStatusConverter {

        /**
         * Convert a container status from enum to string (according to remote docker api)
         */
        public static string convert_from_enum(ContainerStatus status) {
            string s_status;
            switch(status) {
                case ContainerStatus.RUNNING:
                    s_status = "running";
                    break;
                case ContainerStatus.PAUSED:
                    s_status = "paused";
                    break;
                case ContainerStatus.EXITED:
                    s_status = "exited";
                    break;
                case ContainerStatus.CREATED:
                    s_status = "created";
                    break;
                case ContainerStatus.RESTARTING:
                    s_status = "restarting";
                    break;
                default:
                    assert_not_reached();
            }

            return s_status;
        }

        /**
         * Convert a container status from string to enum (according to remote docker api)
         */
        public static ContainerStatus convert_to_enum(string s_status) {
            ContainerStatus status;
            switch(s_status) {
                case "running":
                    status = ContainerStatus.RUNNING;
                    break;
                case "pause":
                    status = ContainerStatus.PAUSED;
                    break;
                case "exited" :
                    status = ContainerStatus.EXITED;
                    break;
                case "created":
                    status = ContainerStatus.CREATED;
                    break;
                case "restarting":
                    status = ContainerStatus.RESTARTING;
                    break;
                default:
                    assert_not_reached();
            }

            return status;
        }
    }
}