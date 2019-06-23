namespace Dockery.DockerSdk.Dto.Events {
    
    public class EventActor : Object {

        public string ID { get; construct set; }
        public Gee.HashMap<string, string> attributes { get; construct set; }        

        public EventActor(string ID) {
            this.ID = ID;
            this.attributes = new Gee.HashMap<string, string>();
        }
    }
}