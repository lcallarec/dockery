using Dockery.View;
using Dockery.DockerSdk;

private void register_view_menu_search_hub_menu_test() {
    var deserializer = new Serializer.EventDeserializer();
    Test.add_func("/Dockery/View/EventsStream/LiveStreamComponent#MaxItems", () => {

        // Given
        var live = new LiveStreamComponent(5);

        var e1 = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());
        var e2 = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());
        var e3 = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());
        var e4 = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());
        var e5 = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());
        var e6 = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());

        //Then
        assert(live.get_buffer.size()) == 0);

        //When
        live.append(e1);
       
        //Then
        assert(live.get_buffer.size() == 1);
        
        //When
        live.append(e2);
        live.append(e3);
        live.append(e4);
        live.append(e5);
        
        //Then
        assert(live.get_buffer.size() == 5);
        
        //When
        live.append(e6);

        //Then
        assert(live.get_buffer.size() == 5);
        assert(live.get_buffer().contains(e1) == false);
               
    });
}