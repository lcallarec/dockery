namespace Dockery.DockerSdk.Dto.Events {
    
    public class OtherEvent : Event {
        public override string event_type { get { return "Other";}}
        public OtherEvent(string event) {
            this.event = event;
        }
    }
}