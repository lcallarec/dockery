namespace Dockery.Listener {

    using global::Dockery.DockerSdk;

    public class DaemonEventListener : GLib.Object {
    
        private Repository repository;
        private View.EventStream.LiveStreamComponent live_stream_component;
        private Io.FutureResponse<Dto.Events.Event> future_response;
        public signal void feedback(Gtk.MessageType type, string message);

        public DaemonEventListener(Repository repository, View.EventStream.LiveStreamComponent live_stream_component) {
            this.repository = repository;
            this.live_stream_component = live_stream_component;
            try {
                this.future_response = this.repository.daemon().events();
            } catch (Error e) {
                 feedback(Gtk.MessageType.ERROR, (string) e.message);
            }
        }

        public void listen() {
            this.future_response.on_response_ready.connect((event) => {
                this.live_stream_component.append(event);
            });
        }
    }
}
