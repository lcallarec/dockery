namespace Dockery.DockerSdk.Dto.Events {
    
    public class ContainerEventActor : EventActor {

        public ContainerEventActorAttributes attributes { get; construct set; }

        public ContainerEventActor(string ID, ContainerEventActorAttributes attributes) {
            base(ID);
            this.attributes = attributes;
        }
    }
}