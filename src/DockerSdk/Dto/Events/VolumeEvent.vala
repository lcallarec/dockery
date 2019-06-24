namespace Dockery.DockerSdk.Dto.Events {
    
    public class VolumeEvent : Event {
    
        public override string event_type { get { return "volume";}}

        public VolumeEvent(string event, EventActor actor, string action, string scope, int64 timeNano) {
            base(event, actor, action, scope, timeNano);
        }
    }
}
