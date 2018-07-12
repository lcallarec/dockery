using global::Dockery.DockerSdk;

private void register_image_tag_deserializer_test() {
    Test.add_func ("/Dockery/DockerSdk/Serializer/ImageTagDeserializer/deserialize#ManyTags", () => {

        var deserializer = new Serializer.ImageTagDeserializer();
        var tags = deserializer.deserialize(many_complete_json_image_tag());

        assert(tags.size == 2);
        assert(tags.get(0).name == "latest");
        assert(tags.get(0).layer == "a");
        assert(tags.get(1).name == "2.4.12-2");
        assert(tags.get(1).layer == "e");
    });

    Test.add_func ("/Dockery/DockerSdk/Serializer/ImageTagsDeserializer/deserialize#BadFormattedPayload", () => {

        var deserializer = new Serializer.ImageTagDeserializer();

        try {
          deserializer.deserialize(image_tag_malformatted_json());
          assert_not_reached();
        } catch(Error e) {
          assert(e is Serializer.DeserializationError.IMAGE_TAG);
        }
    });
}

internal string many_complete_json_image_tag() {
  return """
       [{"layer": "a", "name": "latest"}, {"layer": "e", "name": "2.4.12-2"}]
        """;
}

internal string image_tag_malformatted_json() {
  return "[{]";
}