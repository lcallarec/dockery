namespace Dockery.DockerSdk.Model {

    /**
     * Volume model
     */
    public class Volume : BaseModel {

        public string name {get; construct set;}
        public string driver {get; construct set;}
        public string mount_point {get; construct set;}
        public Gee.HashMap<string, string> labels {get; construct set;}
        public Gee.HashMap<string, string> options {get; construct set;}
        public string short_name {get; construct set;} 

        private const int8 MAX_SORT_NAME_LENGTH = 26;

        public Volume.from(string name, string driver, string mount_point, Gee.HashMap<string, string> labels, Gee.HashMap<string, string> options) {
            this.full_id = name;
            this.name = name;
            this.driver = driver;
            this.mount_point = mount_point;
            this.labels = labels;
            this.options = options;

            if (name.length > Volume.MAX_SORT_NAME_LENGTH) {
                short_name = name.substring(0, Volume.MAX_SORT_NAME_LENGTH);
            } else {
                short_name = name;
            } 
        }
    }
}
