using Dockery.DockerSdk;

namespace Dockery.View.EventStream {

    public class EventWidgetFactory {

        public static Gtk.Widget create(Dto.Events.Event event) {
            switch (event.event_type) {
                case "container":
                    return EventWidgetFactory.build_container_event((Dto.Events.ContainerEvent) event);
                case "network":
                    return EventWidgetFactory.build_network_event((Dto.Events.NetworkEvent) event);
                case "volume":
                    return EventWidgetFactory.build_volume_event((Dto.Events.VolumeEvent) event);                      
                case "image":
                    return EventWidgetFactory.build_image_event((Dto.Events.VolumeEvent) event);                      
            default:
                return new Gtk.Label("default:" + event.to_string());
            }
        }

        private static Gtk.Widget build_container_event(Dto.Events.ContainerEvent event) {
            var name = event.actor.attributes.get("name");

            var widget = new EventWidget(event);
            EventWidgetFactory.add_event_attribute_to_title(event, widget, "name");
                
            return widget.pack();
        }

        private static Gtk.Widget build_network_event(Dto.Events.NetworkEvent event) {

            var widget = new EventWidget(event);
            EventWidgetFactory.add_event_attribute_to_title(event, widget, "container");
            EventWidgetFactory.add_event_attribute_to_title(event, widget, "name");

            return widget.pack();
        }

        private static Gtk.Widget build_volume_event(Dto.Events.VolumeEvent event) {

            var widget = new EventWidget(event);

            EventWidgetFactory.add_event_attribute_to_title(event, widget, "container");            
            EventWidgetFactory.add_event_attribute_to_title(event, widget, "name");

            return widget.pack();
        }    

        private static Gtk.Widget build_image_event(Dto.Events.VolumeEvent event) {

            var widget = new EventWidget(event);

            EventWidgetFactory.add_event_attribute_to_title(event, widget, "name");            
            EventWidgetFactory.add_event_attribute_to_title(event, widget, "status");

            return widget.pack();
        }    

        private static void add_event_attribute_to_title(Dto.Events.Event event, EventWidget widget, string attribute) {
            if (event.actor.attributes.has_key(attribute)) {
                widget.add_to_title(new Gtk.Label(event.actor.attributes.get(attribute)));
            }
        }
    }
}
