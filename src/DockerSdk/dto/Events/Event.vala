namespace Dockery.Sdk.Dto {
    
    public abstract class Event : GLib.Object {
    
        public string event_type { get; construct set;}
        public string action { get; construct set;}
        public string actor { get; construct set;}
        public string scope { get; construct set;}
        public int32 time { get; construct set;}
        public int64 timeNano { get; construct set;}
    }
}
