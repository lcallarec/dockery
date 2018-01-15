namespace Dockery.Listener {

    using global::Dockery;

    public class DaemonEventListener : GLib.Object {
    
        private DockerSdk.Repository repository;
        private View.EventStream.LiveStreamComponent live_stream_component;
        private DockerSdk.Io.FutureResponse future_response;
        private DockerSdk.Serializer.EventDeserializer builder = new DockerSdk.Serializer.EventDeserializer();

        public DaemonEventListener(DockerSdk.Repository repository, View.EventStream.LiveStreamComponent live_stream_component) {
            this.repository = repository;
            this.live_stream_component = live_stream_component;
            this.future_response = this.repository.daemon().events();
        }

        public void listen() {
            
            this.future_response.on_payload_line_received.connect((event) => {
                var eventDTO = builder.deserialize(event);
                if (eventDTO != null) {
                    this.live_stream_component.append(eventDTO);
                }
            });
        }
    }
}
