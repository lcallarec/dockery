using Dockery.Common;

namespace Dockery.DockerSdk.Model.Stat {

    public class ContainerBlockIOStat : Object {

        public Unit.Bytes read {get; private set; }
        public Unit.Bytes write {get; private set; }

        public ContainerBlockIOStat.from(Unit.Bytes  read, Unit.Bytes  write) {
            this.read = read;
            this.write = write;
        }
    }
}
