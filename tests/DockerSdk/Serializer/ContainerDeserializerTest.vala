using global::Dockery.DockerSdk;

private void register_container_deserializer_test() {
    Test.add_func ("/Dockery/DockerSdk/Serializer/ContainerDeserializer/deserialize#OneContainerWellFormattedPayload", () => {

        var deserializer = new Serializer.ContainerDeserializer();
        var containers = deserializer.deserialize(one_complete_json_container());

        var firstContainer = containers.get(0);

        assert(firstContainer.full_id == "8dfafdbcv3a40");
        assert(firstContainer.created_at.equal(new DateTime.utc(2013, 5, 6, 15, 29, 15)));
        assert(firstContainer.command == "echo 1");
        assert(firstContainer.image_id == "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82");
        assert(firstContainer.name == "boring_feynman");
        
        Array<string> expectedNames = new Array<string>();
        expectedNames.append_val("/boring_feynman");
        expectedNames.append_val("/test_name");

        assert(array_equals(expectedNames, firstContainer.names));
        assert(firstContainer.status == Model.ContainerStatus.EXITED);
        assert(firstContainer.get_status_string() == "exited");
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/ContainerDeserializer/deserialize#ManyContainersWellFormattedPayload", () => {

        var deserializer = new Serializer.ContainerDeserializer();
        var containers = deserializer.deserialize(many_complete_json_container());

        assert(containers.size == 2);
        assert(containers.get(0).id == "8dfafdbc3a40");
        assert(containers.get(0).image_id == "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82");
        assert(containers.get(1).id == "9cd87474be90");
        assert(containers.get(1).image_id == "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82");
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/ContainerDeserializer/deserialize#BadFormattedPayload", () => {

        var deserializer = new Serializer.ContainerDeserializer();

        try {
          deserializer.deserialize(container_malformatted_json());
          assert_not_reached();
        } catch(Error e) {
          assert(e is Serializer.DeserializationError.CONTAINER);
        }
    });
}

internal string one_complete_json_container() {
  return """
        [
          {
            "Id": "8dfafdbcv3a40",
            "Names":["/boring_feynman", "/test_name"],
            "Image": "ubuntu:latest",
            "ImageID": "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82",
            "Command": "echo 1",
            "Created": 1367854155,
            "State": "exited",
            "Status": "Exit 0"
          }
        ]
        """;
}

internal string many_complete_json_container() {
  return """
        [
          {
            "Id": "8dfafdbc3a40",
            "Names":["/boring_feynman"],
            "Image": "ubuntu:latest",
            "ImageID": "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82",
            "Command": "echo 1",
            "Created": 1367854155,
            "State": "exited",
            "Status": "Exit 0"
          },
          {
            "Id": "9cd87474be90",
            "Names":["/coolName"],
            "Image": "ubuntu:latest",
            "ImageID": "d74508fb6632491cea586a1fd7d748dfc5274cd6fdfedee309ecdcbc2bf5cb82",
            "Command": "echo 222222",
            "Created": 1367854155,
            "State": "exited",
            "Status": "Exit 0"
          }
        ]
        """;
}

internal string container_malformatted_json() {
  return "[{]";
}

bool array_equals(Array<string> array_one, Array<string> array_two){
    if(array_one.length != array_two.length) return false;
    for (int i=0; i< array_one.length; i++) {
        if(array_one.index(i) != array_two.index(i)) {
            return false;
        }
    }
    return true;
}