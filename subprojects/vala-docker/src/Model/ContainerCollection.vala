namespace Dockery.DockerSdk.Model {

    public class ContainerCollection : Collection<Container> {

        public new void add_collection(ContainerCollection containers) {
            foreach (Container container in containers.values) {
                this.add(container);
            }
        }

        public ContainerCollection get_by_status(ContainerStatus status) {
            var containers = new ContainerCollection();
            foreach (Container container in this.values) {
               if (container.status == status) {
                   containers.add(container);
               }
            }

            return containers;
        }
    }

}
