namespace Dockery.DockerSdk.Dto.Events {
    
    public class VolumeEventActor : EventActor {

        public VolumeEventActorAttributes attributes { get; construct set; }

        public VolumeEventActor(string ID, VolumeEventActorAttributes attributes) {
            base(ID);
            this.attributes = attributes;
        }
    }
}