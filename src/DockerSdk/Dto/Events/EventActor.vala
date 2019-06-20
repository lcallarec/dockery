namespace Dockery.DockerSdk.Dto.Events {
    
    public abstract class EventActor : Object {

        public string ID { get; construct set; }

        public EventActor(string ID) {
            this.ID = ID;
        }
    }
}