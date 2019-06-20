namespace Dockery.DockerSdk.Dto.Events {
    
    public class ImageEventActor : EventActor {

        public ImageEventActorAttributes attributes { get; construct set; }

        public ImageEventActor(string ID, ImageEventActorAttributes attributes) {
            base(ID);
            this.attributes = attributes;
        }
    }
}