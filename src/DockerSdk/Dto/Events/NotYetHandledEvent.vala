namespace Dockery.DockerSdk.Dto.Events {
    
    public class NotYetHandledEvent : Event {
        public override string event_type { get { return "Other";}}
        public NotYetHandledEvent(string event, EventActor actor, string action, string scope, int64 timeNano) {
            base(event, actor, action, scope, timeNano);
        }
    }
}