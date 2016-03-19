namespace Sdk.Docker.Model {

    /**
     * Base model
     */
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
    
    /**
     * Image model
     */
    public class Image : Model {

        private uint _raw_size;
        private string _size;

        public string repository {get; set;}
        public string tag {get; set;}

        public Image.from(string id, int64 created_at, string repotags, uint size) {
            
            string[] _repotags = repotags.split(":", 2);
            
            this.full_id    = id;
            this.created_at = new DateTime.from_unix_local(created_at);
            this.repository = _repotags[0];
            this.tag        = _repotags[1];
            this.raw_size   = size;             
        }
        
        public uint raw_size { 
            get { return _raw_size; }
            set { _raw_size = value; size = value.to_string();}
        }

        public string size { 
            get { return _size; }
            set { _size = SizeFormatter.string_bytes_to_human(value); }
        }
        
        
    }
    
    /**
     * Container model
     */
    public class Container : Model, Validatable {

        /** attribute for name properties */
        private string[] _names;
        
        public string command {get; set;}

        public Container.from(string id, int64 created_at, string command, string image_id, string[] names, ContainerStatus status) {
            this.full_id    = id;
            this.created_at = new DateTime.from_unix_local(created_at);
            this.command    = command;
            this.image_id   = image_id;
            this.names      = names;
            this.status     = status;
        }
        
        /** 
         * Container names property
         */         
        public string[] names {
            get {
                return _names;
            }
            
            set {
                _names = value;
                name   = value[0].replace("/", "");
            }
        }
        
        public string image_id {get; set;}
        
        /** 
         * Container name property
         */ 
        public string name {get; set;}
                
        public ContainerStatus status {get; set;}
        

        public string get_status_string() {
            return ContainerStatusConverter.convert_from_enum(status);
        }
        
        /** @inherit */
        public ValidationFailures? validate() {
            
            ValidationFailures failures = new ValidationFailures();
            
            if (false == Regex.match_simple("^[a-zA-Z0-9][a-zA-Z0-9_.-]+$", name)) {
                failures.add("name", "Container name must match [a-zA-Z0-9][a-zA-Z0-9_.-]");
            }
            
            if (failures.size > 0) {
                return failures;
            }
            
            return null;
        }
    }
    
    public class HubImage : GLib.Object {
        
        public string description  { get; set;}
        public bool   is_official  { get; set;}
        public bool   is_automated { get; set;}
        public string name         { get; set;}
        public int    star_count   { get; set;}
        
        public HubImage.from(string description, bool is_official, bool is_automated, string name, int star_count) {
            this.description  = description;
            this.is_official  = is_official;
            this.is_automated = is_automated;
            this.name         = name;
            this.star_count   = star_count;
        }
    }
    
    /**
     * Represent a list of containers, sorted by status
     */
    public class Containers {
        
        private Gee.ArrayList<Container> _running    = new Gee.ArrayList<Container>();
        private Gee.ArrayList<Container> _paused     = new Gee.ArrayList<Container>();
        private Gee.ArrayList<Container> _created    = new Gee.ArrayList<Container>();
        private Gee.ArrayList<Container> _restarting = new Gee.ArrayList<Container>();
        private Gee.ArrayList<Container> _exited     = new Gee.ArrayList<Container>();        

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
        
        public Gee.ArrayList<Container> created {
            get {
                return _created;
            }
        }

        public Gee.ArrayList<Container> restarting {
            get {
                return _restarting;
            }
        }

        public Gee.ArrayList<Container> exited {
            get {
                return _exited;
            }
        }
        
        public int length {
            get {
                return running.size + paused.size + restarting.size + exited.size;
            }
        }
        
       /**
        * Add an array of containers to the given status stack
        */
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
                case ContainerStatus.CREATED:
                    foreach (Container container in containers) {
                        created.add(container);        
                    }
                    break;
                case ContainerStatus.RESTARTING:
                    foreach (Container container in containers) {
                        restarting.add(container);        
                    }
                    break;
                case ContainerStatus.EXITED:
                    foreach (Container container in containers) {
                        exited.add(container);        
                    }
                    break;
            }
        }
        
       /**
        * Get the list of container according to given status
        */
        public Gee.ArrayList<Container> get_by_status(ContainerStatus status) {
            switch(status) {
                case ContainerStatus.RUNNING:
                    return running;
                case ContainerStatus.PAUSED:
                    return paused;
                case ContainerStatus.CREATED:
                    return created;
                case ContainerStatus.RESTARTING:
                    return restarting;
                case ContainerStatus.EXITED:
                    return exited;
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
        
        public static ContainerStatus[] active() {
            return {RUNNING, PAUSED};
        }
        
        public static bool is_active(ContainerStatus status) {
            return status in ContainerStatus.active();
        }
    }

   /**
    * Convert container status from a type / to another type
    */ 
    public class ContainerStatusConverter {
        
        /**
         * Convert a container status from enum to string (according to remote docker api)
         */ 
        public static string convert_from_enum(ContainerStatus status) {
            string s_status;                
            switch(status) {
                case ContainerStatus.RUNNING:
                    s_status = "running";
                    break;
                case ContainerStatus.PAUSED:
                    s_status = "paused";
                    break;
                case ContainerStatus.EXITED:
                    s_status = "exited";
                    break;
                case ContainerStatus.CREATED:
                    s_status = "created";
                    break;
                case ContainerStatus.RESTARTING:
                    s_status = "restarting";
                    break;
                default:
                    assert_not_reached();
            }

            return s_status;
        }
        
        /**
         * Convert a container status from string to enum (according to remote docker api)
         */ 
        public static ContainerStatus convert_to_enum(string s_status) {
            ContainerStatus status;                
            switch(s_status) {
                case "running":
                    status = ContainerStatus.RUNNING;
                    break;
                case "pause":
                    status = ContainerStatus.PAUSED;
                    break;
                case "exited" :
                    status = ContainerStatus.EXITED;
                    break;
                case "created":
                    status = ContainerStatus.CREATED;
                    break;
                case "restarting":
                    status = ContainerStatus.RESTARTING;
                    break;
                default:
                    assert_not_reached();
            }

            return status;
        }   
    }
}
