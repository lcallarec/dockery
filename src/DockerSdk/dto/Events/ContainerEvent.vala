namespace Dockery.DockerSdk.Dto.Events {
    
    public class ContainerEvent : Event {
    
        public override string event_type { get { return "Container";}}
        public string status { get; construct set;}
        public string id { get; construct set;}
        public string from { get; construct set;}

        public ContainerEvent(string event, string action, string scope, int64 timeNano, string status, string id, string from) {
            this.event = event;
            this.action = action;
            this.scope = scope;            
            this.timeNano = timeNano;
            this.status = status;
            this.id = id;
            this.from = from;
        }
    }
}
