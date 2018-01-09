namespace Dockery.DockerSdk.Model {

    /**
     * Container model
     */
    public class Container : BaseModel, Validatable {

        /** attribute for name properties */
        private string[] _names;

        public string command {get; set;}

        public Container.from(string id, int64 created_at, string command, string image_id, string[] names, ContainerStatus status) {
            this.full_id    = id;
            this.created_at = new DateTime.from_unix_local(created_at);
            this.command    = command;
            this.image_id   = image_id;
            this.names      = names;
            this.status     = status;
        }

        /**
         * Container names property
         */
        public string[] names {
            get {
                return _names;
            }

            set {
                _names = value;
                name   = value[0].replace("/", "");
            }
        }

        public string image_id {get; set;}

        /**
         * Container name property
         */
        public string name {get; set;}

        public ContainerStatus status {get; set;}


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
