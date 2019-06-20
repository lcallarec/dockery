namespace Dockery.DockerSdk.Dto.Events {
    
    public class OtherEvent : Event {
        public override string event_type { get { return "Other";}}
        public OtherEvent(string event, string action, string scope, int64 timeNano) {
            base(event, action, scope, timeNano);
        }
    }
}