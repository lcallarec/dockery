using global::Dockery.DockerSdk;

private void register_dockersdk_model_container_collection() {
    Test.add_func("/Dockery/DockerSdk/Model/ContainerCollection", () => {

        var collection = new Model.ContainerCollection();
        collection.add(create_container_from("running", "1"));
        collection.add(create_container_from("running", "2"));

        assert(collection.size == 2);
        assert(collection.get_by_status(Model.ContainerStatus.RUNNING).size == 2);
        

    });
}

private Model.Container create_container_from(string status, string id) {
    var names = new Array<string>();
    names.append_val("Container name");
    return new Model.Container.from(
        id,
        1543876818,
        "/bin/bash",
        "ImageID",
        names,
        Model.ContainerStatusConverter.convert_to_enum(status)
    );
}
