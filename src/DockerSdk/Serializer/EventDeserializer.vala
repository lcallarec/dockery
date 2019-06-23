using Dockery.DockerSdk;
using Dockery.DockerSdk.Dto.Events;

namespace Dockery.DockerSdk.Serializer {

    public class EventDeserializer : DeserializerInterface<Event>, Object { 

        public Event deserialize(string event) throws DeserializationError {

            Event eventDTO;

            try {
                var parser = new Json.Parser();
                parser.load_from_data(event);

                Json.Object rootObject = parser.get_root().get_object();

                string type = rootObject.get_string_member("Type");
                string action = rootObject.get_string_member("Action");
                string scope = rootObject.get_string_member("scope");
                int64 timeNano = rootObject.get_int_member("timeNano");

                Json.Object actorMember = rootObject.get_object_member("Actor");
                
                var actor = new EventActor(actorMember.get_string_member("ID"));
                switch(type) {
                    case "container":
                        this.fill_attributes_if_member_exists(actorMember, actor, "image");
                        this.fill_attributes_if_member_exists(actorMember, actor, "name");
           
                        return eventDTO = new ContainerEvent(
                            event,
                            actor,
                            action,
                            scope,
                            timeNano,
                            rootObject.get_string_member("status"),
                            rootObject.get_string_member("id"),
                            rootObject.get_string_member("from")
                        );
                    case "image":
                        if (actorMember.get_object_member("Attributes").has_member("name")) {
                            actor.attributes.set("name", actorMember.get_object_member("Attributes").get_string_member("name"));
                        }    

                        return eventDTO = new ImageEvent(
                            event,
                            actor,
                            action,
                            scope,
                            timeNano,
                            rootObject.get_string_member("status"),
                            rootObject.get_string_member("id")
                        );
                    case "network":
                        if (actorMember.get_object_member("Attributes").has_member("container")) {
                            actor.attributes.set("container", actorMember.get_object_member("Attributes").get_string_member("container"));
                        }
                        if (actorMember.get_object_member("Attributes").has_member("name")) {
                            actor.attributes.set("name", actorMember.get_object_member("Attributes").get_string_member("name"));
                        }    
                        if (actorMember.get_object_member("Attributes").has_member("type")) {
                            actor.attributes.set("type", actorMember.get_object_member("Attributes").get_string_member("type"));
                        }    

                        return eventDTO = new NetworkEvent(
                            event,
                            actor,
                            action,
                            scope,
                            timeNano
                        );
                    case "volume":
                        if (actorMember.get_object_member("Attributes").has_member("container")) {
                            actor.attributes.set("container", actorMember.get_object_member("Attributes").get_string_member("container"));
                        }
                        if (actorMember.get_object_member("Attributes").has_member("driver")) {
                            actor.attributes.set("driver", actorMember.get_object_member("Attributes").get_string_member("driver"));
                        }
                        if (actorMember.get_object_member("Attributes").has_member("destination")) {
                            actor.attributes.set("destination", actorMember.get_object_member("Attributes").get_string_member("destination"));
                        }                            
                        if (actorMember.get_object_member("Attributes").has_member("propagation")) {
                            actor.attributes.set("propagation", actorMember.get_object_member("Attributes").get_string_member("propagation"));
                        }                            
                        if (actorMember.get_object_member("Attributes").has_member("read/write")) {
                            actor.attributes.set("read/write", actorMember.get_object_member("Attributes").get_string_member("read/write"));
                        }                            

                        return eventDTO = new VolumeEvent(
                            event,
                            actor,
                            action,
                            scope,
                            timeNano
                        );                    
                    default:
                        return new NotYetHandledEvent(event, action, scope, timeNano);
                }
            } catch (Error e) {
                throw new DeserializationError.EVENT("Unable to parse event : %s".printf(event));
            }
        }

        private void fill_attributes_if_member_exists(Json.Object actorMember, EventActor actor, string member) {
            if (actorMember.get_object_member("Attributes").has_member(member)) {
                actor.attributes.set(member, actorMember.get_object_member("Attributes").get_string_member(member));
            }
        }
    }
}