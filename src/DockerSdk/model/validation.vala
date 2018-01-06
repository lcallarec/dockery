namespace Sdk.Docker.Model {

    /*
     * Interface for model validation
     */ 
    public interface Validatable {

        /**
         * Validate object properties. Return null when no properties failed during validation.
         */ 
        public abstract ValidationFailures? validate();
    }

    /*
     * Represent a validation failure. Should always contains a non-empty failures object. 
     */
    public class ValidationFailures {
        /** Failures */
        private Gee.HashMap<string, Gee.ArrayList<string>> failures = new Gee.HashMap<string, Gee.ArrayList<string>>();
    
        /**
         * Add a failure message to a given property
         * */
        public void add(string property, string message) {
            
            Gee.ArrayList<string> property_failures;
            
            if(failures.has_key(property)) {
                property_failures = failures.get(property);
            } else {
                property_failures = new Gee.ArrayList<string>();
            }
            
            property_failures.add(message);
            
            failures.set(property, property_failures);
        }
        
        /**
         * Return the number of current failed fields
         */ 
        public int size {
            get {
                return failures.size;
            }
        }
        
        /**
         * Return the failures object
         */ 
        public Gee.HashMap<string, Gee.ArrayList<string>> get() {
            return failures;
        }
        
    }
}
