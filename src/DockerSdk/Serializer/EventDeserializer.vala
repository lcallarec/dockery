namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class EventDeserializer {

        public Dto.Events.Event? deserialize(string event) throws Error {

            Dto.Events.Event eventDTO;

            var parser = new Json.Parser();
            parser.load_from_data(event);

            Json.Object rootObject = parser.get_root().get_object();

            string type = rootObject.get_string_member("Type");
            string action = rootObject.get_string_member("Action");
            string scope = rootObject.get_string_member("scope");
            int32 time = (int32) rootObject.get_int_member("time");
            int64 timeNano = rootObject.get_int_member("timeNano");
            
            switch(type) {
                case "container":
                    Json.Object actorMember = rootObject.get_object_member("Actor");
                    return eventDTO = new Dto.Events.ContainerEvent(
                        event,
                        new Dto.Events.ContainerEventActor(
                            actorMember.get_string_member("ID"),
                            new Dto.Events.ContainerEventActorAttributes(
                                actorMember.get_object_member("Attributes").get_string_member("image"),
                                actorMember.get_object_member("Attributes").get_string_member("name")
                            )
                        ),
                        action,
                        scope,
                        timeNano,
                        rootObject.get_string_member("status"),
                        rootObject.get_string_member("id"),
                        rootObject.get_string_member("from")
                    );
                default:
                    return new Dto.Events.OtherEvent(event);
            }

            return null;

        }
    }
}