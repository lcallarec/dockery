namespace Dockery.DockerSdk.Dto.Events {
    
    public class NetworkEventActor : EventActor {

        public NetworkEventActorAttributes attributes { get; construct set; }

        public NetworkEventActor(string ID, NetworkEventActorAttributes attributes) {
            base(ID);
            this.attributes = attributes;
        }
    }
}