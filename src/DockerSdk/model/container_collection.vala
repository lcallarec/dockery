namespace Sdk.Docker.Model {

    public class ContainerCollection : Collection<Container> {

        private Gee.HashMap<ContainerStatus, ContainerCollection> status_idx = new Gee.HashMap<ContainerStatus, ContainerCollection>();

        public new void add(Container item, bool is_parent_container = true) {

            //If the container is a parent, create a child ContainerColelction.
            //Else, don't do that to avoid infinite loop
            if (true == is_parent_container) {
                var containers = get_by_status(item.status);
                containers.add(item, false);
                status_idx.set(item.status, containers);
            }

            base.add(item);
        }

        public new void add_collection(ContainerCollection containers) {

            foreach (Container container in containers) {
                add(container);
            }
        }

        /**
        * Get a ContainerColelction having a given status
        */
        public ContainerCollection get_by_status(ContainerStatus status) {

            ContainerCollection containers;
            if (status_idx.has_key(status)) {
                containers = status_idx.get(status);
            } else {
                containers = new ContainerCollection();
            }

            return containers;
        }
    }

}
