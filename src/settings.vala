namespace Dockery {

    public class SettingsManager {

        private const string SCHEMA_ID="org.lcallarec.dockery";

        private GLib.Settings settings = new GLib.Settings(SettingsManager.SCHEMA_ID);

        public Gee.HashMap<string, Settings.Stack> get_docker_stacks() {

            GLib.Variant? raw_stacks_settings = this.settings.get_value("docker-stacks");

            var stacks = new Gee.HashMap<string, Settings.Stack>();

            if (raw_stacks_settings != null) {
                GLib.VariantIter iter = raw_stacks_settings.iterator();

                string raw_stack_setting = null;
                while (iter.next("s", &raw_stack_setting)) {

                    string[] settings_chunks = raw_stack_setting.split("::");

                    string stack_id   = settings_chunks[0];
                    string stack_name = settings_chunks[1];
                    string stack_uri  = settings_chunks[2];

                    stacks.set(stack_id, new Settings.Stack(stack_id, stack_name, stack_uri));
                }
            }

            return stacks;
        }

        public void update_docker_stack(string name, string uri) {

            string serialized_stack = "%s::%s::%s".printf("1", name, uri);

            string[] data = {serialized_stack};

            this.settings.set_strv("docker-stacks", data);
        }
    }
}
