using global::Dockery.DockerSdk;

private void register_container_stat_deserializer_test() {
    Test.add_func ("/Dockery/DockerSdk/Serializer/ContainerStatDeserializer/Deserialize", () => {

      //Given
      var deserializer = new Serializer.ContainerStatDeserializer();

      try {
        //When
        var stat = deserializer.deserialize(one_stat());
  
        //Then
        assert(stat.read_at.compare(new DateTime.from_iso8601("2015-01-08T22:57:31.547920715Z", new TimeZone.utc())) == 0);
        assert(stat.memory.max_usage.bytes == 6651904);
        assert(stat.memory.usage.bytes == 6537216);
        assert(stat.memory.limit.bytes == 67108864);

        assert(stat.cpu.cpu.total_usage.bytes == 102000);
        assert(stat.cpu.cpu.system_cpu_usage.bytes == 150000000);
        assert(stat.cpu.cpu.online_cpus == 4);
        assert(stat.cpu.cpu.percpu_usage.length == 4);

        assert(stat.cpu.precpu.total_usage.bytes == 100000);
        assert(stat.cpu.precpu.system_cpu_usage.bytes == 140000000);
        assert(stat.cpu.precpu.online_cpus == 4);
        assert(stat.cpu.precpu.percpu_usage.length == 4);
        assert(stat.cpu.percent == 0.08);

        assert(stat.networks.interfaces.get("eth0").rx.bytes == 93134);
        assert(stat.networks.interfaces.get("eth0").tx.bytes == 785);
        assert(stat.networks.interfaces.get("eth1").rx.bytes == 73986);
        assert(stat.networks.interfaces.get("eth1").tx.bytes == 475);

        assert(stat.networks.rx.bytes == 167120);
        assert(stat.networks.tx.bytes == 1260);

      } catch (Error e) {
          stdout.printf("ERROR : %s\n", e.message);
          assert_not_reached();
      }      
    });
}

internal string one_stat() {
  return """
          {
            "read": "2015-01-08T22:57:31.547920715Z",
            "memory_stats": {
              "max_usage": 6651904,
              "usage": 6537216,
              "limit": 67108864
            },
            "cpu_stats": {
              "cpu_usage": {
                "total_usage": 102000,
                "percpu_usage": [
                  57354405009,
                  56293330622,
                  57374307637,
                  60718441149
                ]
              },
              "system_cpu_usage": 150000000,
              "online_cpus": 4
            },
            "precpu_stats": {
              "cpu_usage": {
                "total_usage": 100000,
                "percpu_usage": [
                  57353537288,
                  56293330622,
                  57374307637,
                  60718441149
                ]
              },
              "system_cpu_usage": 140000000,
              "online_cpus": 4
            },
            "networks": {
              "eth0": {
                "rx_bytes": 93134,
                "tx_bytes": 785
              },
              "eth1": {
                "rx_bytes": 73986,
                "tx_bytes": 475
              }
            }
          }""";
}
