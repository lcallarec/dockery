using Dockery;
using Dockery.View;

namespace Dockery.Listener {

    class StackHubListener : GLib.Object {

        public signal void image_states_changed();
        public signal void feedback(Gtk.MessageType type, string message);
        
        private Gtk.Window parent_window;
        private View.MainContainer main_container;
        private DockerSdk.Repository repository;

        public StackHubListener(Gtk.Window parent_window, DockerSdk.Repository repository, View.MainContainer main_container) {
            this.parent_window = parent_window;
            this.repository = repository;
            this.main_container = main_container;
        }
        
        public void listen() {
            this.docker_public_registry_open_request();
        }
        
        private void docker_public_registry_open_request() {
            this.main_container.on_docker_public_registry_open_request.connect(() => {
                var dialog = new Hub.SearchDialog();
                dialog.search_image_in_docker_hub.connect((target, term) => {
                    try {
                        DockerSdk.Model.HubImage[] images = repository.images().search(term);
                        target.set_images(images);
                    } catch (DockerSdk.Io.RequestError e) {
                        feedback(Gtk.MessageType.ERROR, (string) e.message);
                    }
                });

                dialog.show_all();

                dialog.pull_image_from_docker_hub.connect((target, image) => {

                    var decorator = new global::View.Docker.Decorator.CreateImageDecorator(target.message_box_label);

                    try {

                        var future_response = repository.images().future_pull(image);
                        future_response.on_payload_line_received.connect((line) => {
                            if (null != line) {
                                try {
                                    decorator.update(line);
                                } catch (Error e) {
                                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                                }
                            }
                        });

                        future_response.on_finished.connect(() => {
                            try {
                                decorator.update(null);
                            } catch (Error e) {
                                feedback(Gtk.MessageType.ERROR, (string) e.message);
                            }
                        });

                    } catch (Error e) {
                        feedback(Gtk.MessageType.ERROR, (string) e.message);
                    }
                });
            });
        }
    }
}
