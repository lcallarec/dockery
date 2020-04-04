using Dockery.DockerSdk;
using Dockery.Common.Unit;

private void register_dockersdk_model_image_collection() {
    Test.add_func("/Dockery/DockerSdk/Model/ImageCollection", () => {

        var collection = new Model.ImageCollection();
        collection.add(create_image_from("1", "lcallarec/dockery", 780000000));
        collection.add(create_image_from("2", "lcallarec/dockery:0.85.3", 750000000));
        collection.add(create_image_from("3", "lcallarec/dockery:0.85.2", 720000000));

        assert(collection.size == 3);
        assert(collection.get_by_id("1").repository == "lcallarec/dockery");
        assert(collection.get_by_id("1").tag == "");
        assert(collection.get_by_id("1").size.to_human().to_string() == "780MB");
        //assert(collection.get_by_id("2").created_at.format("%Y-%m-%d %H:%M:%S") == "2019-06-27 18:06:10");
        assert(collection.get_by_id("3").repository == "lcallarec/dockery");
        assert(collection.get_by_id("3").tag == "0.85.2");
    });
}

private Model.Image create_image_from(string id, string repotags, uint size) {
    return new Model.Image.from(id, 1561651570, repotags, size);
}

