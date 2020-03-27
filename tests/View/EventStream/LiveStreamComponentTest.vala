using Dockery.View;
using Dockery.DockerSdk;

private void register_view_event_streams_live_component_test() {

    Test.add_func("/Dockery/View/EventsStream/LiveStreamComponent#MaxItems", () => {
        var deserializer = new Serializer.EventDeserializer();
        // Given
        var live = new EventStream.LiveStreamComponent(5);

        try {
            var event = (Dto.Events.ContainerEvent) deserializer.deserialize(one_event_container_nominal_case());
            
            //Then
            assert(live.get_buffer().size == 0);

            //When
            live.append(event);
        
            //Then
            assert(live.get_buffer().size == 1);
            
            //When
            live.append(event);
            live.append(event);
            live.append(event);
            live.append(event);
            
            //Then
            assert(live.get_buffer().size == 5);
            
            //When
            live.append(event);

            //Then
            assert(live.get_buffer().size == 5);
        } catch(Error e) {
            assert_not_reached();
        }
    });
}