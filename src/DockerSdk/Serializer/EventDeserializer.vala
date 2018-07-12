namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class EventDeserializer : DeserializerInterface<Dto.Events.Event>, Object { 

        public Dto.Events.Event deserialize(string event) throws DeserializationError {

            Dto.Events.Event eventDTO;

            try {
                var parser = new Json.Parser();
                parser.load_from_data(event);

                Json.Object rootObject = parser.get_root().get_object();

                string type = rootObject.get_string_member("Type");
                string action = rootObject.get_string_member("Action");
                string scope = rootObject.get_string_member("scope");
                int64 timeNano = rootObject.get_int_member("timeNano");

                Json.Object actorMember = rootObject.get_object_member("Actor");

                switch(type) {
                    case "container":
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
                    case "image":
                        return eventDTO = new Dto.Events.ImageEvent(
                            event,
                            new Dto.Events.ImageEventActor(
                                actorMember.get_string_member("ID"),
                                new Dto.Events.ImageEventActorAttributes(
                                    actorMember.get_object_member("Attributes").get_string_member("name")
                                )
                            ),
                            action,
                            scope,
                            timeNano,
                            rootObject.get_string_member("status"),
                            rootObject.get_string_member("id")
                        );
                    case "network":
                        return eventDTO = new Dto.Events.NetworkEvent(
                            event,
                            new Dto.Events.NetworkEventActor(
                                actorMember.get_string_member("ID"),
                                new Dto.Events.NetworkEventActorAttributes(
                                    actorMember.get_object_member("Attributes").get_string_member("container"),
                                    actorMember.get_object_member("Attributes").get_string_member("name"),
                                    actorMember.get_object_member("Attributes").get_string_member("type")
                                )
                            ),
                            action,
                            scope,
                            timeNano
                        );
                    case "volume":
                        return eventDTO = new Dto.Events.VolumeEvent(
                            event,
                            new Dto.Events.VolumeEventActor(
                                actorMember.get_string_member("ID"),
                                new Dto.Events.VolumeEventActorAttributes(
                                    actorMember.get_object_member("Attributes").get_string_member("driver")
                                )
                            ),
                            action,
                            scope,
                            timeNano
                        );                    
                    default:
                        return new Dto.Events.OtherEvent(event, action, scope, timeNano);
                }
            } catch (Error e) {
                throw new DeserializationError.EVENT("Unable to parse event : %s".printf(event));
            }
        }
    }
}