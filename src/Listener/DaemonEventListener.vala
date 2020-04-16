namespace Dockery.Listener {

    using global::Dockery.DockerSdk;

    public class DaemonEventListener : GLib.Object {
    
        private Repository repository;
        private View.EventStream.LiveStreamComponent live_stream_component;
        private Io.FutureResponse<Dto.Events.Event> future_response;

        public DaemonEventListener(Repository repository, View.EventStream.LiveStreamComponent live_stream_component) {
            this.repository = repository;
            this.live_stream_component = live_stream_component;
            this.future_response = this.repository.daemon().events();
        }

        public void listen() {
            
            this.future_response.on_response_ready.connect((event) => {
                this.live_stream_component.append(event);
            });
        }
    }
}
