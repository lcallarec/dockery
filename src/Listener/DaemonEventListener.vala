namespace Dockery.Listener {

    public class DaemonEventListener : GLib.Object {
    
        private global::Sdk.Docker.Repository repository;
        private Dockery.View.EventStream.LiveStreamComponent live_stream_component;
        private global::Sdk.Docker.Io.FutureResponse future_response;

        public DaemonEventListener(global::Sdk.Docker.Repository repository, Dockery.View.EventStream.LiveStreamComponent live_stream_component) {
            this.repository = repository;
            this.live_stream_component = live_stream_component;
            this.future_response = this.repository.daemon().events();
        }

        public void listen() {
            this.future_response.on_payload_line_received.connect((event) => {
                this.live_stream_component.append(event);
            });
        }
    }
}
