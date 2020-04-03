using global::Dockery.DockerSdk;

private void register_dockersdk_model_container_allowed_actions_test() {
    
    Test.add_func ("/Dockery/DockerSdk/Model/AllowedActions#Paused", () => {
        
        var container = create_container_from("paused", "1");
        var allowed_actions = new Model.ContainerAllowedActions(container);

        assert(allowed_actions.can_be_renamed() == true);
        assert(allowed_actions.can_be_paused() == false);
        assert(allowed_actions.can_be_unpaused() == true);        
        assert(allowed_actions.can_be_started() == false);
        assert(allowed_actions.can_be_restarted() == true);
        assert(allowed_actions.can_be_stopped() == false);
        assert(allowed_actions.can_be_removed() == true);
        assert(allowed_actions.can_be_inspected() == true);    
        assert(allowed_actions.can_be_stated() == false);
        assert(allowed_actions.can_be_connected() == false);
    });
    
    Test.add_func ("/Dockery/DockerSdk/Model/AllowedActions#Exited", () => {
        
        var container = create_container_from("exited", "1");
        var allowed_actions = new Model.ContainerAllowedActions(container);

        assert(allowed_actions.can_be_renamed() == true);
        assert(allowed_actions.can_be_started() == true);
        assert(allowed_actions.can_be_restarted() == false);
        assert(allowed_actions.can_be_paused() == false);
        assert(allowed_actions.can_be_unpaused() == false);          
        assert(allowed_actions.can_be_stopped() == false);
        assert(allowed_actions.can_be_removed() == true);
        assert(allowed_actions.can_be_inspected() == true);
        assert(allowed_actions.can_be_stated() == false);
        assert(allowed_actions.can_be_connected() == false);        
    });

    Test.add_func ("/Dockery/DockerSdk/Model/AllowedActions#Created", () => {
        
        var container = create_container_from("created", "1");
        var allowed_actions = new Model.ContainerAllowedActions(container);

        assert(allowed_actions.can_be_renamed() == false);
        assert(allowed_actions.can_be_started() == true);
        assert(allowed_actions.can_be_stopped() == false);
        assert(allowed_actions.can_be_restarted() == false);
        assert(allowed_actions.can_be_paused() == false);
        assert(allowed_actions.can_be_unpaused() == false);
        assert(allowed_actions.can_be_removed() == true);
        assert(allowed_actions.can_be_inspected() == true);
        assert(allowed_actions.can_be_stated() == false);
        assert(allowed_actions.can_be_connected() == false);
    });

    Test.add_func ("/Dockery/DockerSdk/Model/AllowedActions#Running", () => {
        
        var container = create_container_from("running", "1");
        var allowed_actions = new Model.ContainerAllowedActions(container);
                
        assert(allowed_actions.can_be_renamed() == true);
        assert(allowed_actions.can_be_started() == false);
        assert(allowed_actions.can_be_restarted() == true);
        assert(allowed_actions.can_be_paused() == true);
        assert(allowed_actions.can_be_unpaused() == false);
        assert(allowed_actions.can_be_stopped() == true);
        assert(allowed_actions.can_be_removed() == true);
        assert(allowed_actions.can_be_killed() == true);
        assert(allowed_actions.can_be_inspected() == true);
        assert(allowed_actions.can_be_stated() == true);
        assert(allowed_actions.can_be_connected() == true);        
    });
}
