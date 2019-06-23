namespace Dockery.DockerSdk.Dto.Events {
    
    public class NotYetHandledEvent : Event {
        public override string event_type { get { return "Other";}}
        public NotYetHandledEvent(string event, string action, string scope, int64 timeNano) {
            base(event, action, scope, timeNano);
        }
    }
}