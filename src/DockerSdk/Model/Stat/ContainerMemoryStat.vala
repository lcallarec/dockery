using Dockery.Common;

namespace Dockery.DockerSdk.Model.Stat {
   
    public class ContainerMemoryStat : Object {

        public Unit.Bytes max_usage {get; private set;}
        public Unit.Bytes usage {get; private set;}
        public Unit.Bytes limit {get; private set;}

        public ContainerMemoryStat.from_int64(int64 max_usage, int64 usage, int64 limit) {
            this.max_usage = Unit.Bytes(max_usage);
            this.usage = Unit.Bytes(usage);
            this.limit = Unit.Bytes(limit);
        }
    }
}
