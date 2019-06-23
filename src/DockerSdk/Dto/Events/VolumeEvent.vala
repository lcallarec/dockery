namespace Dockery.DockerSdk.Dto.Events {
    
    public class VolumeEvent : Event {
    
        public override string event_type { get { return "volume";}}
        public EventActor actor { get; construct set;}

        public VolumeEvent(string event, EventActor actor, string action, string scope, int64 timeNano) {
            base(event, action, scope, timeNano);
            this.actor = actor;
        }
    }
}
