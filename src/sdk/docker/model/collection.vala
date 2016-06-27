namespace Sdk.Docker.Model {

    public class Collection<T> : Gee.ArrayList<T> {

        private Gee.HashMap<string, T> id_idx = new  Gee.HashMap<string, T>();

        public Collection() {

        }

        public new void add(Model item) {
            id_idx.set(item.id, item);
            base.add(item);
        }

        public T get_by_id(string id) {
            return id_idx.get(id);
        }

        public bool has_id(string id) {
            return id_idx.has_key(id);
        }

    }
}
