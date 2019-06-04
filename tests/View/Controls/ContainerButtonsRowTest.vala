using Dockery.View.Controls;
using Dockery.DockerSdk.Model;

private void register_view_controls_container_buttons_row() {

    Test.add_func("/Dockery/View/Controls/ContainerButtonsRow#ButtonsForCreatedContainers", () => {
        // given
        var controls = new ContainerButtonsRow();
        var container = create_container_from("created", "1");

        // When
        controls.select(container);

        // Then
        assert(controls.btn_inspect.sensitive == false);
        assert(controls.btn_remove.sensitive == true);
        assert(controls.btn_rename.sensitive == false);
        assert(controls.btn_restart.sensitive == false);
        assert(controls.btn_start.sensitive == true);
        assert(controls.btn_pause.sensitive == false);
    });

    Test.add_func("/Dockery/View/Controls/ContainerButtonsRow#ButtonsForStoppedContainers", () => {
        // given
        var controls = new ContainerButtonsRow();
        var container = create_container_from("stopped", "1");

        // When
        controls.select(container);

        // Then
        assert(controls.btn_inspect.sensitive == false);
        assert(controls.btn_remove.sensitive == true);
        assert(controls.btn_rename.sensitive == false);
        assert(controls.btn_restart.sensitive == false);
        assert(controls.btn_start.sensitive == false);
        assert(controls.btn_pause.sensitive == false);
    });

    Test.add_func("/Dockery/View/Controls/ContainerButtonsRow#ButtonsForPausedContainers", () => {
        // given
        var controls = new ContainerButtonsRow();
        var container = create_container_from("paused", "1");

        // When
        controls.select(container);

        // Then
        assert(controls.btn_inspect.sensitive == true);
        assert(controls.btn_remove.sensitive == true);
        assert(controls.btn_rename.sensitive == true);
        assert(controls.btn_restart.sensitive == true);
        assert(controls.btn_start.sensitive == true);
        assert(controls.btn_pause.sensitive == false);
    });


    Test.add_func("/Dockery/View/Controls/ContainerButtonsRow#ButtonsForExitedContainers", () => {
        // given
        var controls = new ContainerButtonsRow();
        var container = create_container_from("exited", "1");

        // When
        controls.select(container);

        // Then
        assert(controls.btn_inspect.sensitive == true);
        assert(controls.btn_remove.sensitive == true);
        assert(controls.btn_rename.sensitive == false);
        assert(controls.btn_restart.sensitive == true);
        assert(controls.btn_start.sensitive == true);
        assert(controls.btn_pause.sensitive == false);
    });

    Test.add_func("/Dockery/View/Controls/ContainerButtonsRow#ButtonsForRunningContainers", () => {
        // given
        var controls = new ContainerButtonsRow();
        var container = create_container_from("running", "1");

        // When
        controls.select(container);

        // Then
        assert(controls.btn_inspect.sensitive == true);
        assert(controls.btn_remove.sensitive == true);
        assert(controls.btn_rename.sensitive == true);
        assert(controls.btn_restart.sensitive == true);
        assert(controls.btn_start.sensitive == false);
        assert(controls.btn_pause.sensitive == false);
    });    
}