using Dockery.DockerSdk;
using Dockery.View;
using View;
using Dockery.DockerSdk.Io;

namespace Dockery.Listener {
        
    class ImageListListener : GLib.Object {

        public signal void container_states_changed();
        public signal void image_states_changed();
        public signal void feedback(Gtk.MessageType type, string message);
        
        private Gtk.Window parent_window;
        private Repository repository;

        public ImageListListener(Gtk.Window parent_window, Repository repository) {
            this.parent_window = parent_window;
            this.repository = repository;
        }
        
        public void listen() {
            this.images_remove_request();
            this.image_create_container_request();
            this.image_create_container_with_request();
        }
        
        private void images_remove_request() {
            
            SignalDispatcher.dispatcher().images_remove_request.connect((images) => {

                try {
                    /** Find containers created from the images we want to remove */
                    Model.ContainerCollection containers = this.repository.containers().find_by_images(images);
                    var dialog = new global::View.Docker.Dialog.RemoveImagesDialog(images, containers, parent_window);
                    dialog.response.connect((source, response_id) => {

                        switch (response_id) {
                            case Gtk.ResponseType.APPLY:
                                try {
                                    if (containers.size > 0) {
                                        foreach(Model.ContainerStatus status in Model.ContainerStatus.all()) {
                                            foreach(Model.Container container in containers.get_by_status(status).values) {
                                                this.repository.containers().remove(container, true);
                                                feedback(Gtk.MessageType.INFO, "Container %s successfully removed".printf(container.name));
                                            }
                                        }
                                    }

                                    foreach (Model.Image image in images.values) {
                                        this.repository.images().remove(image, true);
                                        feedback(Gtk.MessageType.INFO, "Image %s successfully removed".printf(image.name));
                                    }

                                    feedback(Gtk.MessageType.INFO, "All images and containers being used successfully removed");

                                } catch (RequestError e) {
                                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                                }

                                this.container_states_changed();
                                this.image_states_changed();

                                break;
                            case Gtk.ResponseType.CANCEL:
                                break;
                            case Gtk.ResponseType.DELETE_EVENT:
                                break;
                            case Gtk.ResponseType.CLOSE:
                                break;
                        }

                        dialog.destroy();

                    });

                    dialog.show_all();

                } catch (RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }

        private void image_create_container_request() {
            SignalDispatcher.dispatcher().image_create_container_request.connect((image) => {
                try {
                    this.repository.containers().create(new Model.ContainerCreate.from_image(image));
                    this.container_states_changed();
                } catch (RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }
        
        private void image_create_container_with_request() {
            SignalDispatcher.dispatcher().image_create_container_with_request.connect((image) => {

                var dialog = new global::View.Docker.Dialog.CreateContainerWith(image, parent_window);
                dialog.response.connect((source, response_id) => {

                    switch (response_id) {
                        case Gtk.ResponseType.APPLY:

                            Gee.HashMap<string, string> data = dialog.get_view_data();

                            try {
                                this.repository.containers().create(new Model.ContainerCreate.from_hash_map(image, data));
                            } catch (Error e) {
                                feedback(Gtk.MessageType.ERROR, (string) e.message);
                            }

                            dialog.destroy();

                            this.container_states_changed();

                            break;

                        case Gtk.ResponseType.DELETE_EVENT:
                        case Gtk.ResponseType.CLOSE:
                            dialog.destroy();
                            break;
                    }
                });

                dialog.show_all();
            });
        }
    }
}
