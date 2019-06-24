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
                        this.fill_attributes_if_member_exists(actorMember, actor, "name");
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
                        this.fill_attributes_if_member_exists(actorMember, actor, "container");
                        this.fill_attributes_if_member_exists(actorMember, actor, "name");
                        this.fill_attributes_if_member_exists(actorMember, actor, "type");

                        return eventDTO = new NetworkEvent(
                            event,
                            actor,
                            action,
                            scope,
                            timeNano
                        );
                    case "volume":
                        this.fill_attributes_if_member_exists(actorMember, actor, "container");
                        this.fill_attributes_if_member_exists(actorMember, actor, "driver");
                        this.fill_attributes_if_member_exists(actorMember, actor, "destination");                         
                        this.fill_attributes_if_member_exists(actorMember, actor, "propagation");
                        this.fill_attributes_if_member_exists(actorMember, actor, "read/write");
                        return eventDTO = new VolumeEvent(
                            event,
                            actor,
                            action,
                            scope,
                            timeNano
                        );                    
                    default:
                        return new NotYetHandledEvent(event, actor, action, scope, timeNano);
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