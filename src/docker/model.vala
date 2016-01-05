namespace Docker.Model {
        
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
    public class Container : Model {
        private string[] _names;
        
        public string command {get; set;}
        
        public string[] names {
            get {
                return _names;
            }
            
            set {
                _names = value;
                name   = value[0];
            }
        }
        
        public string name {get; set;}
        
        public ContainerStatus status {get; set;}
        
        public string get_status_string() {
            return ContainerStatusConverter.convert_from_enum(status);
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

   /**
    * Static helper class for size formatting     
    */
    public class SizeFormatter {
        
        const string[] SIZE_UNITS   = {"B", "KB", "MB", "GB", "TB"};
        const double KFACTOR = 1000;

       /**
        * format a string of bytes to an human readable format with units
        */
        public static string string_bytes_to_human(string bytes) {
            double current_size = double.parse(bytes);
            string current_size_formatted = bytes.to_string() + SizeFormatter.SIZE_UNITS[0];  

            for (int i = 1; i<= SizeFormatter.SIZE_UNITS.length; i++) {
                if (current_size < SizeFormatter.KFACTOR) {
                     return GLib.Math.round(current_size).to_string() + SizeFormatter.SIZE_UNITS[i];
                }                
                current_size = current_size / SizeFormatter.KFACTOR;
            }

            return current_size_formatted;
        }
    }
    
    /**
     * Create model object from raw values
     */
    public class ModelFactory {
        
        public Image create_image(string id, int64 created_at, string repotags, uint size) {
            
            string[0] _repotags = repotags.split(":", 2);
            
            Image image = new Image();
            image.full_id    = id;
            image.created_at = new DateTime.from_unix_local(created_at);
            image.repository = _repotags[0];
            image.tag         = _repotags[1];
            image.raw_size   = size;             

            return image;
        }
        
        public Container create_container(string id, int64 created_at, string command, string[] names, ContainerStatus status) {
            
            Container container  = new Container();
            container.full_id    = id;
            container.created_at = new DateTime.from_unix_local(created_at);
            container.command    = command;
            container.names      = names;
            container.status     = status;
           
            return container;
        }
    }
}
