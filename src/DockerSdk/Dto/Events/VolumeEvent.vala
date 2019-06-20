namespace Dockery.DockerSdk.Dto.Events {
    
    public class VolumeEvent : Event {
    
        public override string event_type { get { return "Volume";}}
        public VolumeEventActor actor { get; construct set;}

        public VolumeEvent(string event, VolumeEventActor actor, string action, string scope, int64 timeNano) {
            base(event, action, scope, timeNano);
            this.actor = actor;
        }
    }
}
