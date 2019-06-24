namespace Dockery.DockerSdk.Dto.Events {
    
    public abstract class Event : GLib.Object {

        public string event { get; construct set; }
        public abstract string event_type  { get; }
        public EventActor actor { get; construct set;}        
        public string action { get; construct set; }
        public string scope { get; construct set; }
        public int64 timeNano { get; construct set; }
        public int64 time { get; construct set; }

        public Event(string event, EventActor actor, string action, string scope, int64 timeNano) {
            this.event = event;
            this.actor = actor;            
            this.action = action;
            this.scope = scope;
            this.timeNano = timeNano;
            this.time = timeNano / 1000000000;
        }

        public virtual string to_string() {
            return @"$event";
        }
    }
}
