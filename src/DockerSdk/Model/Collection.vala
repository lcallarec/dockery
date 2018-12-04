namespace Dockery.DockerSdk.Model {
    
    using global::Dockery.DockerSdk.Model;
    
    public class Collection<T> : Gee.HashMap<string, T> {

        public new void add (BaseModel item) {
            this.set(item.id, item);
        }

        public T get_by_id(string id) {
            return this.get(id);
        }

        public bool has_id(string id) {
            return this.has_key(id);
        }
        
        /**
         * Get an array of id 
         */ 
        public string[] get_ids() {
            string[] ids = new string[0];
            foreach (string id in this.keys) {
                ids += id;
            }
            
            return ids;
        }
    }
}
