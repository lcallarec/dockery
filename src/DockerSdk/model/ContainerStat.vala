namespace Dockery.DockerSdk.Model {

    using Stat;
    
    public class ContainerStat : BaseModel {

        public DateTime read_at {get; construct set;}
        public ContainerMemoryStat memory_stats {get; construct set;}

        public ContainerStat.from(DateTime read_at, ContainerMemoryStat memory_stats) {
            this.read_at = read_at;
            this.memory_stats = memory_stats;
        }
    }
}
