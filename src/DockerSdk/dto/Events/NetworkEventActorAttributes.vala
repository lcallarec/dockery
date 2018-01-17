namespace Dockery.DockerSdk.Dto.Events {
    
    public class NetworkEventActorAttributes : Object {
        public string container { get; construct set; }
        public string name { get; construct set; }
        public string network_type { get; construct set; }

        public NetworkEventActorAttributes(string container, string name, string network_type) {
            this.container = container;
            this.name = name;
            this.network_type = network_type;
        }
    }
}