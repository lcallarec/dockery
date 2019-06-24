namespace Dockery.DockerSdk.Dto.Events {
    
    public class ImageEvent : Event {
    
        public override string event_type { get { return "image";}}
        public string status { get; construct set;}
        public string id { get; construct set;}

        public ImageEvent(string event, EventActor actor, string action, string scope, int64 timeNano, string status, string id) {
            
            base(event, actor, action, scope, timeNano);

            this.status = status;
            this.id = id;
        }
    }
}
