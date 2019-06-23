namespace Dockery.DockerSdk.Dto.Events {
    
    public class NetworkEvent : Event {
    
        public override string event_type { get { return "network";}}
        public EventActor actor { get; construct set;}

        public NetworkEvent(string event, EventActor actor, string action, string scope, int64 timeNano) {
            base(event, action, scope, timeNano);
            this.actor = actor;
        }
    }
}
