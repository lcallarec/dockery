using global::Dockery.DockerSdk;

private void register_container_stat_deserializer_test() {
    Test.add_func ("/Dockery/DockerSdk/Serializer/ContainerStatDeserializer/Deserialize", () => {

      //Given
      var deserializer = new Serializer.ContainerStatDeserializer();
      
      //When
      var stat = deserializer.deserializeList(one_stat());

      //Then
      assert(stat.memory_stats.max_usage == 6651904);
      assert(stat.memory_stats.usage == 6537216);
      assert(stat.memory_stats.limit == 67108864);
    });
}

internal string one_stat() {
  return """
          {
            "read": "2015-01-08T22:57:31.547920715Z",
            "memory_stats": {
              "max_usage": 6651904,
              "usage": 6537216,
              "failcnt": 0,
              "limit": 67108864
            },
            "blkio_stats": {}
          }""";
}
