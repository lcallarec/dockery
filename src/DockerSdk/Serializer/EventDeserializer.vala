namespace Dockery.DockerSdk.Serializer {
    
    using global::Dockery.DockerSdk;

    public class EventDeserializer {

        public Dto.Events.Event? deserialize(string event) throws Error {

            Dto.Events.Event eventDTO;

            var parser = new Json.Parser();
            parser.load_from_data(event);

            unowned Json.Node node = parser.get_root();

            string type = node.get_object().get_string_member("Type");
            string action = node.get_object().get_string_member("Action");
            string scope = node.get_object().get_string_member("scope");
            int32 time = (int32) node.get_object().get_int_member("time");
            int64 timeNano = node.get_object().get_int_member("timeNano");
            
            switch(type) {
                case "container":
                    return eventDTO = new Dto.Events.ContainerEvent(
                        event,
                        action,
                        scope,
                        timeNano,
                        node.get_object().get_string_member("status"),
                        node.get_object().get_string_member("id"),
                        node.get_object().get_string_member("from")
                    );
                default:
                    return new Dto.Events.OtherEvent(event);
            }

            return null;

        }
    }
}