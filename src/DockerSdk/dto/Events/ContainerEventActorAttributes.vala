namespace Dockery.DockerSdk.Dto.Events {
    
    public class ContainerEventActorAttributes : Object {
        public string image { get; construct set; }
        public string name { get; construct set; }

        public ContainerEventActorAttributes(string image, string name) {
            this.image = image;
            this.name = name;
        }
    }
}