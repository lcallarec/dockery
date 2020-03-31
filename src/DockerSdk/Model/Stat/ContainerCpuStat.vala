using Dockery.Common;

namespace Dockery.DockerSdk.Model.Stat {
   
    public struct CpuStat {
        Unit.Bytes total_usage;
        Unit.Bytes[] percpu_usage;               
        Unit.Bytes system_cpu_usage;
        int64 online_cpus;
    }

    public class ContainerCpuStat : Object {

        public CpuStat cpu {get; private set;}
        public CpuStat precpu {get; private set;}
        public double percent {get; private set;}

        public ContainerCpuStat.from(CpuStat cpu, CpuStat precpu) {
            this.cpu = cpu;
            this.precpu = precpu;  
            this.percent = this.compute_percent();      
        }

        private double compute_percent() {
            double cpu_percent = 0.0;

            double cpu_delta = this.cpu.total_usage.bytes - this.precpu.total_usage.bytes;
            double system_delta = this.cpu.system_cpu_usage.bytes - this.precpu.system_cpu_usage.bytes;
            
            if (system_delta > 0 && cpu_delta > 0) {
                cpu_percent = (cpu_delta / system_delta) * cpu.online_cpus * 100.0;
            }
            return cpu_percent;
        }
    }
}
