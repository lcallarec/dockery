namespace Dockery.DockerSdk.Dto.Events {
    
    public class VolumeEventActorAttributes : Object {
        
        public string driver { get; construct set; }

        public VolumeEventActorAttributes(string driver) {
            this.driver = driver;
        }
    }
}