namespace Dockery.DockerSdk.Model {

    using Stat;

    public class ContainerStat : BaseModel {

        public DateTime read_at {get; construct set;}
        public ContainerMemoryStat memory {get; construct set;}
        public ContainerCpuStat cpu {get; construct set;}        

        public ContainerStat.from(DateTime read_at, ContainerMemoryStat memory, ContainerCpuStat cpu) {
            this.read_at = read_at;
            this.memory = memory;
            this.cpu = cpu;
        }
    }
}
