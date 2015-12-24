namespace Docker.Model {
        
    public class Model : GLib.Object {
        private string _id;
        private string _full_id;
        
        public string id {
            get { return _id; }
            private set { _id = value.substring(0, 12); }
        }
        
        public string full_id { 
            get { return _full_id; }
            set { _full_id = value; id = value; }
        }
        
        public DateTime created_at {get; set;}
    } 
    
    public class Image : Model {
        public string repository {get; set;}
        public string tag {get; set;}
    }
    
    public class Container : Model {
        public string command {get; set;}
    }
    
    public class Containers {
        private Gee.ArrayList<Container> _running = new Gee.ArrayList<Container>();
        private Gee.ArrayList<Container> _paused  = new Gee.ArrayList<Container>();
        
        public Gee.ArrayList<Container> running {
            get {
                return _running;
            }
        }
        
        public Gee.ArrayList<Container> paused {
            get {
                return _paused;
            }
        }
        
        public void add(ContainerStatus status, Container[] containers) {
            switch(status) {
                case ContainerStatus.RUNNING:
                    foreach (Container container in containers) {
                        running.add(container);        
                    }
                    break;
                case ContainerStatus.PAUSED:
                    foreach (Container container in containers) {
                        paused.add(container);        
                    }
                    break;
            }
        }
        
         public Gee.ArrayList<Container> get_by_status(ContainerStatus status) {
            switch(status) {
                case ContainerStatus.RUNNING:
                    return running;
                case ContainerStatus.PAUSED:
                    return paused;
            }
            
            return new Gee.ArrayList<Container>();
        }
    }
    
    public enum ContainerStatus {
        CREATED,
        RESTARTING,
        RUNNING,
        PAUSED,
        EXITED;
        
        public static ContainerStatus[] all() {
            return {RUNNING, PAUSED, EXITED, CREATED, RESTARTING};
        }
    }
}












