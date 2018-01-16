namespace Dockery.DockerSdk.Dto.Events {
    
    public class UnkownEvent : Event {
        public override string event_type { get { return "Unkown";} }
        public UnkownEvent(string event, string action, string scope, int64 timeNano) {
            base(event, action, scope, timeNano);
        }
    }
}