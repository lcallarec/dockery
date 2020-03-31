using Dockery.Common;
using Dockery.DockerSdk;
using Model;
using Model.Stat;

namespace Dockery.DockerSdk.Serializer {

    public class ContainerStatDeserializer : DeserializerInterface<Model.ContainerStat>, Object {

        public ContainerStat deserialize(string json) throws DeserializationError {
             try {
                var parser = new Json.Parser();
                parser.load_from_data(json);

                var node_object = parser.get_root().get_object();

                var memory_stats_object = node_object.get_object_member("memory_stats");

                var cpu_stats_root = node_object.get_object_member("cpu_stats");
                var cpu_stats_usage = cpu_stats_root.get_object_member("cpu_usage");
                var online_cpus = cpu_stats_root.get_int_member("online_cpus");

                Unit.Bytes[] cpu_percpu_usage = new Unit.Bytes[online_cpus];
                cpu_stats_usage.get_array_member("percpu_usage").foreach_element((array, i, node) => {
                    cpu_percpu_usage[i] = Unit.Bytes(array.get_int_element(i));
                });

                var precpu_stats_root = node_object.get_object_member("precpu_stats");
                var precpu_stats_usage = precpu_stats_root.get_object_member("cpu_usage");
                var preonline_cpus = precpu_stats_root.get_int_member("online_cpus");

                Unit.Bytes[] precpu_percpu_usage = new Unit.Bytes[preonline_cpus];
                precpu_stats_usage.get_array_member("percpu_usage").foreach_element((array, i, node) => {
                    precpu_percpu_usage[i] = Unit.Bytes(array.get_int_element(i));
                });

                return new ContainerStat.from(
                    new DateTime.from_iso8601(node_object.get_string_member("read"), new TimeZone.utc()),
                    new ContainerMemoryStat.from_int64(
                        memory_stats_object.get_int_member("max_usage"),
                        memory_stats_object.get_int_member("usage"),
                        memory_stats_object.get_int_member("limit")
                    ),
                    new ContainerCpuStat.from(
                        CpuStat() {
                            total_usage = Unit.Bytes(cpu_stats_usage.get_int_member("total_usage")),
                            percpu_usage = cpu_percpu_usage,            
                            system_cpu_usage = Unit.Bytes(cpu_stats_root.get_int_member("system_cpu_usage")),
                            online_cpus = online_cpus
                        },
                        CpuStat() {
                            total_usage = Unit.Bytes(precpu_stats_usage.get_int_member("total_usage")),
                            percpu_usage = precpu_percpu_usage,            
                            system_cpu_usage = Unit.Bytes(precpu_stats_root.get_int_member("system_cpu_usage")),
                            online_cpus = preonline_cpus
                        }
                    )
                );
       
            } catch (Error e) {
                throw new DeserializationError.CONTAINER("Error while deserializing container stat : %s".printf(e.message));
            }
        }
    }
}