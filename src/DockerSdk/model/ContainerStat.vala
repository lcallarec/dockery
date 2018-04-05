namespace Dockery.DockerSdk.Model {

    using Stat;
    
    public class ContainerStat : BaseModel {

        public ContainerMemoryStat memory_stats {get; construct set;}

        public ContainerStat.from(string read, ContainerMemoryStat memory_stats) {
            this.memory_stats = memory_stats;
        }
    }
}
