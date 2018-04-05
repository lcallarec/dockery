namespace Dockery.DockerSdk.Model.Stat {
   
    public class ContainerMemoryStat : Object {

        public int64 max_usage {get; construct set;}

        public int64 usage {get; construct set;}
        
        public int64 limit {get; construct set;}

        public ContainerMemoryStat.from(int64 max_usage, int64 usage, int64 limit) {
            this.max_usage = max_usage;
            this.usage = usage;
            this.limit = limit;
        }
    }
}
