namespace Dockery.DockerSdk.Model {

    /**
     * Container model
     */
    public class Container : BaseModel, Validatable {

        public string command {get; construct set;}

        public string image_id {get; construct set;}

        public Array<string> names {get; construct set;}

        public string name {get; construct set;}

        public ContainerStatus status {get; construct set;}

        public Container.from(string id, int64 created_at, string command, string image_id, Array<string> names, ContainerStatus status) {
            this.full_id    = id;
            this.created_at = new DateTime.from_unix_local(created_at);
            this.command    = command;
            this.image_id   = image_id;
            this.names      = names;
            if (names.length > 0) {
                this.name = names.index(0).replace("/", "");
            }
            this.status     = status;
        }

        public string get_status_string() {
            return ContainerStatusConverter.convert_from_enum(status);
        }

        /** @inherit */
        public ValidationFailures? validate() {

            ValidationFailures failures = new ValidationFailures();

            if (false == Regex.match_simple("^[a-zA-Z0-9][a-zA-Z0-9_.-]+$", name)) {
                failures.add("name", "Container name must match [a-zA-Z0-9][a-zA-Z0-9_.-]");
            }

            if (failures.size > 0) {
                return failures;
            }

            return null;
        }
    }
}
