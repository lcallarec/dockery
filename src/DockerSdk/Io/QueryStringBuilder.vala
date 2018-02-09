namespace Dockery.DockerSdk.Io {

    protected class QueryStringBuilder {

        Json.Builder builder = new Json.Builder();
        Json.Generator generator = new Json.Generator();

        StringBuilder filter_builder = new StringBuilder("?");

        public void add_json_filter(string filter_name, Gee.HashMap<string, Gee.ArrayList<string>> filter_value) {

            filter_builder.append(filter_name);
            filter_builder.append("=");

            filter_builder.append(build_json_request_filter(filter_value));
        }

        public string build() {

            string _filter = filter_builder.str;

            //Restore
            builder = new Json.Builder();
            generator = new Json.Generator();
            filter_builder = new StringBuilder("?");

            return _filter;
        }

        private string build_json_request_filter(Gee.HashMap<string, Gee.ArrayList<string>> data) {

            builder.begin_object();

            foreach (var entry in data.entries) {

                builder.set_member_name(entry.key);

                builder.begin_array ();
                foreach (string subentry in entry.value) {
                    builder.add_string_value(subentry);
                }
                builder.end_array ();

            }

            builder.end_object();

            Json.Node root = builder.get_root();
            generator.set_root(root);

            return generator.to_data(null);
        }
    }
}
