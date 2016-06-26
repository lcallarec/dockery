namespace Sdk.Docker.Model {

    public class HubImage : GLib.Object {

        public string description  { get; set;}
        public bool   is_official  { get; set;}
        public bool   is_automated { get; set;}
        public string name         { get; set;}
        public int    star_count   { get; set;}

        public HubImage.from(string description, bool is_official, bool is_automated, string name, int star_count) {
            this.description  = description;
            this.is_official  = is_official;
            this.is_automated = is_automated;
            this.name         = name;
            this.star_count   = star_count;
        }
    }
}
