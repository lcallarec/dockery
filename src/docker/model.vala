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
        public string command {get; set;}
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
				case Docker.Model.ContainerStatus.RUNNING:
					s_status = "running";
                    break;
				case Docker.Model.ContainerStatus.PAUSED:
					s_status = "paused";
                    break;
                case Docker.Model.ContainerStatus.EXITED:
                    s_status = "exited";
                    break;
                case Docker.Model.ContainerStatus.CREATED:
                    s_status = "created";
                    break;
                case Docker.Model.ContainerStatus.RESTARTING:
                    s_status = "restarting";
                    break;
                default:
                    assert_not_reached();
			}

            return s_status;
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
            double current_size = bytes.to_double();
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
}












