using global::Dockery.DockerSdk;

private void register_dockersdk_model_container_status_converter_test() {
    Test.add_func ("/Dockery/DockerSdk/Model/ContainerStatusConverter#convert_to_enum:lowercase", () => {
        assert(Model.ContainerStatusConverter.convert_to_enum("running") == Model.ContainerStatus.RUNNING);
        assert(Model.ContainerStatusConverter.convert_to_enum("pause") == Model.ContainerStatus.PAUSED);
        assert(Model.ContainerStatusConverter.convert_to_enum("exited") == Model.ContainerStatus.EXITED);
        assert(Model.ContainerStatusConverter.convert_to_enum("created") == Model.ContainerStatus.CREATED);
        assert(Model.ContainerStatusConverter.convert_to_enum("restarting") == Model.ContainerStatus.RESTARTING);
    });

    Test.add_func ("/Dockery/DockerSdk/Model/ContainerStatusConverter#convert_to_enum:first_letter_uppercase", () => {
        assert(Model.ContainerStatusConverter.convert_to_enum("Running") == Model.ContainerStatus.RUNNING);
        assert(Model.ContainerStatusConverter.convert_to_enum("Pause") == Model.ContainerStatus.PAUSED);
        assert(Model.ContainerStatusConverter.convert_to_enum("Exited") == Model.ContainerStatus.EXITED);
        assert(Model.ContainerStatusConverter.convert_to_enum("Created") == Model.ContainerStatus.CREATED);
        assert(Model.ContainerStatusConverter.convert_to_enum("Restarting") == Model.ContainerStatus.RESTARTING);
    });

    Test.add_func ("/Dockery/DockerSdk/Model/ContainerStatusConverter#convert_to_enum:uppercase", () => {
        assert(Model.ContainerStatusConverter.convert_to_enum("RUNNING") == Model.ContainerStatus.RUNNING);
        assert(Model.ContainerStatusConverter.convert_to_enum("PAUSE") == Model.ContainerStatus.PAUSED);
        assert(Model.ContainerStatusConverter.convert_to_enum("EXITED") == Model.ContainerStatus.EXITED);
        assert(Model.ContainerStatusConverter.convert_to_enum("CREATED") == Model.ContainerStatus.CREATED);
        assert(Model.ContainerStatusConverter.convert_to_enum("RESTARTING") == Model.ContainerStatus.RESTARTING);
    });
}
