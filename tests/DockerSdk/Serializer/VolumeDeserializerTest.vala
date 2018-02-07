using global::Dockery.DockerSdk;

private void register_volume_deserializer_test() {
    Test.add_func ("/Dockery/DockerSdk/Serializer/VolumeDeserializer/DeserializeList#OneVolumeWellFormattedPayload", () => {

        var deserializer = new Serializer.VolumeDeserializer();
        var volumes = deserializer.deserializeList(one_complete_json_volume());

        var firstVolume = volumes.get(0);

        assert(firstVolume.full_id == "tardis");
        assert(firstVolume.name == "tardis");
        assert(firstVolume.short_name == "tardis");        
        assert(firstVolume.driver == "local");
        assert(firstVolume.mount_point == "/var/lib/docker/volumes/tardis");

        assert(firstVolume.labels.size == 2);
        assert(firstVolume.labels.has_key("com.example.some-label"));
        assert(firstVolume.labels.has_key("com.example.some-other-label"));
        assert(firstVolume.labels.get("com.example.some-label") == "some-value");
        assert(firstVolume.labels.get("com.example.some-other-label") == "some-other-value");

        assert(firstVolume.options.size == 3);
        assert(firstVolume.options.has_key("device"));
        assert(firstVolume.options.has_key("o"));
        assert(firstVolume.options.has_key("type"));
        assert(firstVolume.options.get("device") == "tmpfs");
        assert(firstVolume.options.get("o") == "size=100m,uid=1000");
        assert(firstVolume.options.get("type") == "tmpfs");
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/VolumeDeserializer/DeserializeList#ShortName#ManyVolumesWellFormattedPayload", () => {
        var deserializer = new Serializer.VolumeDeserializer();
        var volumes = deserializer.deserializeList(one_complete_json_volume());

        var firstVolume = volumes.get(0);

        assert(firstVolume.name == "thisisaverylongvolumename,tooloongtofit");
        assert(firstVolume.short_name == "thisisaverylongvolumename,");
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/VolumeDeserializer/DeserializeList#ManyVolumesWellFormattedPayload", () => {
        var deserializer = new Serializer.VolumeDeserializer();
        var volumes = deserializer.deserializeList(many_complete_json_volumes());

        assert(volumes.size == 2);
        assert(volumes.get(0).name == "tardis");
        assert(volumes.get(1).id == "yeepo");

    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/VolumeDeserializer/DeserializeList#BadFormattedPayload", () => {

        var deserializer = new Serializer.VolumeDeserializer();

        try {
          deserializer.deserializeList(volume_malformatted_json());
          assert_not_reached();
        } catch(Error e) {
          assert(e is Serializer.DeserializationError.VOLUME);
        }
    });
}

internal string one_complete_json_volume() {
  return """
        {
          "Volumes": [
            {
              "Name": "tardis",
              "Driver": "local",
              "Mountpoint": "/var/lib/docker/volumes/tardis",
              "Labels": {},
              "Scope": "local",
              "Options": {}
            }
          ],
          "Warnings": []
        }
        """;
}

internal string one_complete_json_volumes_with_very_long_name() {
  return """
        {
          "Volumes": [
            {
              "Name": "thisisaverylongvolumename,tooloongtofit",
              "Driver": "local",
              "Mountpoint": "/var/lib/docker/volumes/tardis",
              "Labels": {
                "com.example.some-label": "some-value",
                "com.example.some-other-label": "some-other-value"
              },
              "Scope": "local",
              "Options": {
                "device": "tmpfs",
                "o": "size=100m,uid=1000",
                "type": "tmpfs"
              }
            }
          ],
          "Warnings": []
        }
        """;
}


internal string many_complete_json_volumes() {
  return """
    {
      "Volumes": [
        {
          "Name": "tardis",
          "Driver": "local",
          "Mountpoint": "/var/lib/docker/volumes/tardis",
          "Labels": {
            "com.example.some-label": "some-value",
            "com.example.some-other-label": "some-other-value"
          },
          "Scope": "local",
          "Options": {
            "device": "tmpfs",
            "o": "size=100m,uid=1000",
            "type": "tmpfs"
          }
        },
        {
        "Name": "yeepo",
        "Driver": "local",
        "Mountpoint": "/var/lib/docker/volumes/yeepo",
        "Labels": {
          "com.example.some-label": "some-value",
          "com.example.some-other-label": "some-other-value"
        },
        "Scope": "local",
        "Options": {
          "device": "tmpfs",
          "o": "size=100m,uid=1000",
          "type": "tmpfs"
        }
        }
      ],
      "Warnings": []
    }
  """;
}

internal string volume_malformatted_json() {
  return "[{]";
}