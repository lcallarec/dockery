namespace Dockery.DockerSdk.Dto.Events {
    
    public class ContainerEvent : Event {
    
        public override string event_type { get { return "container";}}
        public string status { get; construct set;}
        public string id { get; construct set;}
        public string from { get; construct set;}

        public ContainerEvent(string event, EventActor actor, string action, string scope, int64 timeNano, string status, string id, string from) {
            base(event, actor, action, scope, timeNano);
            this.status = status;
            this.id = id;
            this.from = from;
        }
    }
}
