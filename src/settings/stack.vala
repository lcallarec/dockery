namespace Dockery.Settings {

    public class Stack {

        private string id;
        private string name;
        private string uri;

        public Stack(string id, string name, string uri) {
            this.id   = id;
            this.name = name;
            this.uri  = uri;
        }

        public string get_name() {
            return name;
        }

        public string get_uri() {
            return uri;
        }

        public string get_id() {
            return id;
        }
    }
}
