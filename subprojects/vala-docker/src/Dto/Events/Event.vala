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

    public class EventActor : Object {

        public string ID { get; construct set; }
        public Gee.HashMap<string, string> attributes { get; construct set; }        

        public EventActor(string ID) {
            this.ID = ID;
            this.attributes = new Gee.HashMap<string, string>();
        }
    }

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

    public class NetworkEvent : Event {
    
        public override string event_type { get { return "network";}}

        public NetworkEvent(string event, EventActor actor, string action, string scope, int64 timeNano) {
            base(event, actor, action, scope, timeNano);
        }
    }

    public class NotYetHandledEvent : Event {
        public override string event_type { get { return "Other";}}
        public NotYetHandledEvent(string event, EventActor actor, string action, string scope, int64 timeNano) {
            base(event, actor, action, scope, timeNano);
        }
    }

    public class VolumeEvent : Event {
    
        public override string event_type { get { return "volume";}}

        public VolumeEvent(string event, EventActor actor, string action, string scope, int64 timeNano) {
            base(event, actor, action, scope, timeNano);
        }
    }    
}
