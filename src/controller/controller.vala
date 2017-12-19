/**
 * ApplicationController is listening to all signals emitted by the view layer
 */
public class ApplicationController : GLib.Object, Signals.DockerServiceAware, Signals.DockerHubImageRequestAction {

    protected Sdk.Docker.Repository? repository;
    protected DockerManager window;
    protected Dockery.View.MessageDispatcher message_dispatcher;
    protected Dockery.View.MainContainer view;

    public ApplicationController(DockerManager window, Dockery.View.MessageDispatcher message_dispatcher) {
        this.window             = window;
        this.view               = window.main_container;
        this.message_dispatcher = message_dispatcher;
    }

    public void boot() {
        this.listen_headerbar();
        this.listen_docker_hub();
        this.listen_container_view();
        this.listen_image_view();

        string? docker_endpoint = discover_connection();
        if (null != docker_endpoint) {
            try {
                __connect(docker_endpoint);
            } catch(GLib.Error e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, e.message);
            }
        } else {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, "Can't locate docker daemon");
        }
    }

    public void listen_container_view() {

        view.containers.container_status_change_request.connect((requested_status, container) => {

            try {
                string message = "";
                if (requested_status == Sdk.Docker.Model.ContainerStatus.PAUSED) {
                    repository.containers().pause(container);
                    message = "Container %s successfully unpaused".printf(container.id);
                } else if (requested_status == Sdk.Docker.Model.ContainerStatus.RUNNING) {
                    repository.containers().unpause(container);
                    message = "Container %s successfully paused".printf(container.id);
                }
                this.init_container_list();
                message_dispatcher.dispatch(Gtk.MessageType.INFO, message);

            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });

        view.containers.container_remove_request.connect((container) => {

            Gtk.MessageDialog msg = new Gtk.MessageDialog(
                window, Gtk.DialogFlags.MODAL,
                Gtk.MessageType.WARNING,
                Gtk.ButtonsType.OK_CANCEL,
                "Really remove the container %s (%s)?".printf(container.name, container.id)
            );

            msg.response.connect((response_id) => {
                switch (response_id) {
                    case Gtk.ResponseType.OK:

                        try {
                            repository.containers().remove(container);
                            this.init_container_list();
                        } catch (Sdk.Docker.Io.RequestError e) {
                            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                        }

                        break;
                    case Gtk.ResponseType.CANCEL:
                        break;
                    case Gtk.ResponseType.DELETE_EVENT:
                        break;
                }

                msg.destroy();

            });

            msg.show();
        });

        view.containers.container_start_request.connect((container) => {

            try {
                repository.containers().start(container);
                string message = "Container %s successfully started".printf(container.id);
                this.init_container_list();
                message_dispatcher.dispatch(Gtk.MessageType.INFO, message);

            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                this.init_container_list();
            }
        });

        view.containers.container_bash_in_request.connect((container) => {
            var term_window = new Gtk.Window();

            var titlebar = new Gtk.HeaderBar();
            titlebar.title = "Bash-in %s".printf(container.name);
            titlebar.show_close_button = true;

            term_window.set_titlebar(titlebar);

            var term = new View.Docker.Terminal.from_bash_in_container(container);
            term.parent_container_widget = term_window;

            try {
                term.start();
            } catch (Error e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }

            term_window.window_position = Gtk.WindowPosition.MOUSE;
            term_window.transient_for = window;
            term_window.add(term);
            term_window.show_all();
        });

        view.containers.container_stop_request.connect((container) => {
            try {
                repository.containers().stop(container);
                string message = "Container %s successfully stopped".printf(container.id);
                this.init_container_list();
                message_dispatcher.dispatch(Gtk.MessageType.INFO, message);

            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });

        view.containers.container_kill_request.connect((container) => {

            try {
                repository.containers().kill(container);
                string message = "Container %s successfully killed".printf(container.id);
                this.init_container_list();
                message_dispatcher.dispatch(Gtk.MessageType.INFO, message);

            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });

        view.containers.container_restart_request.connect((container) => {

            try {
                repository.containers().restart(container);
                string message = "Container %s successfully restarted".printf(container.id);
                this.init_container_list();
                message_dispatcher.dispatch(Gtk.MessageType.INFO, message);

            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });

        view.containers.container_rename_request.connect((container, relative_to, pointing_to) => {
            this.handle_container_rename(container, relative_to, pointing_to);
        });
    }

    public void listen_image_view() {

         view.images.images_remove_request.connect((images) => {

            try {
                /** Find containers created from the images we want to remove */
                Sdk.Docker.Model.ContainerCollection containers = this.repository.containers().find_by_images(images);
                var dialog = new View.Docker.Dialog.RemoveImagesDialog(images, containers, window);

                dialog.response.connect((source, response_id) => {

                    switch (response_id) {
                        case Gtk.ResponseType.APPLY:
                            try {
                                if (containers.size > 0) {
                                    foreach(Sdk.Docker.Model.ContainerStatus status in Sdk.Docker.Model.ContainerStatus.all()) {
                                        foreach(Sdk.Docker.Model.Container container in containers.get_by_status(status)) {
                                            this.repository.containers().remove(container, true);
                                            message_dispatcher.dispatch(Gtk.MessageType.INFO, "Container %s successfully removed".printf(container.name));
                                        }
                                    }
                                }

                                foreach (Sdk.Docker.Model.Image image in images) {
                                    this.repository.images().remove(image, true);
                                    message_dispatcher.dispatch(Gtk.MessageType.INFO, "Image %s successfully removed".printf(image.name));
                                }

                                message_dispatcher.dispatch(Gtk.MessageType.INFO, "All images and containers being used successfully removed");

                            } catch (Sdk.Docker.Io.RequestError e) {
                                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                            }

                            this.init_container_list();
                            this.init_image_list();

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

            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });

        view.images.image_create_container_request.connect((image) => {

            try {
                this.repository.containers().create(new Sdk.Docker.Model.ContainerCreate.from_image(image));
                this.init_container_list();
            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }

        });

        view.images.image_create_container_with_request.connect((image) => {

            var dialog = new View.Docker.Dialog.CreateContainerWith(image, window);

            dialog.response.connect((source, response_id) => {

                switch (response_id) {
                    case Gtk.ResponseType.APPLY:

                        Gee.HashMap<string, string> data = dialog.get_view_data();

                        try {
                            this.repository.containers().create(new Sdk.Docker.Model.ContainerCreate.from_hash_map(image, data));
                        } catch (Error e) {
                            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                        }

                        dialog.destroy();

                        this.init_container_list();

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

    public void listen_headerbar() {

        this.view.on_docker_service_connect_request.connect((docker_entrypoint) => {
            try {
                __connect(docker_entrypoint);
            } catch (Error e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, "Can't connect  docker daemon at %s".printf(docker_entrypoint));
            }
        });

        this.view.on_docker_service_disconnect_request.connect(() => {
            __disconnect();
        });

        this.on_docker_service_connect_success.connect((docker_entrypoint) => {
            this.view.on_docker_service_connect_success(docker_entrypoint);
        });

        this.on_docker_service_connect_failure.connect((docker_entrypoint) => {
            this.view.on_docker_service_connect_failure(docker_entrypoint);
        });

        this.view.on_docker_service_discover_request.connect(() => {
            string? docker_endpoint = discover_connection();
            if (null != docker_endpoint) {
                try {
                    __connect(docker_endpoint);
                } catch(GLib.Error e) {
                    message_dispatcher.dispatch(Gtk.MessageType.ERROR, e.message);
                }
            } else {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, "Can't locate docker daemon");
            }
        });
    }

    public void listen_docker_hub() {

        this.view.on_docker_public_registry_open_request.connect(() => {
            var dialog = new View.Docker.Dialog.SearchHubDialog();
            dialog.search_image_in_docker_hub.connect((target, term) => {
                try {
                    Sdk.Docker.Model.HubImage[] images =  repository.images().search(term);
                    target.set_images(images);
                } catch (Sdk.Docker.Io.RequestError e) {
                    message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                }
            });

            dialog.show_all();

            dialog.pull_image_from_docker_hub.connect((target, image) => {

                var decorator = new View.Docker.Decorator.CreateImageDecorator(target.message_box_label);

                try {

                    var future_response = repository.images().future_pull(image);
                    future_response.on_payload_line_received.connect((line) => {
                        if (null != line) {
                            try {
                                decorator.update(line);
                            } catch (Error e) {
                                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                            }
                        }
                    });

                    future_response.on_finished.connect(() => {
                        try {
                            decorator.update(null);
                        } catch (Error e) {
                            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                        }
                    });

                } catch (Error e) {
                    message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        });
    }

    protected void init_image_list() {
        Sdk.Docker.Model.ImageCollection images = new Sdk.Docker.Model.ImageCollection();
        try {
            images = repository.images().list();
        } catch (Sdk.Docker.Io.RequestError e) {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
        } finally {
            this.view.images.init(images);
        }
    }

    protected void init_container_list() {
        try {
            var container_collection = new Sdk.Docker.Model.ContainerCollection();

            foreach(Sdk.Docker.Model.ContainerStatus status in Sdk.Docker.Model.ContainerStatus.all()) {
                var containers = repository.containers().list(status);
                container_collection.add_collection(containers);
            }

            this.view.containers.init(container_collection);
        } catch (Sdk.Docker.Io.RequestError e) {
            message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
        }

    }

    protected bool __connect(string docker_endpoint) throws Error {

        repository = create_repository(docker_endpoint);
        if (repository != null) {
            
            repository.connected.connect((repository) => {
                docker_daemon_post_connect(docker_endpoint);
            });

            repository.connect();

            return true;
        }

        return false;
        
    }

     protected bool __disconnect() {

        this.view.on_docker_service_disconnected();

        repository = null;

        message_dispatcher.dispatch(Gtk.MessageType.INFO, "Disconnected from Docker daemon");

        this.view.images.init(new Sdk.Docker.Model.ImageCollection());
        this.view.containers.init(new Sdk.Docker.Model.ContainerCollection());

        return true;
    }

    protected string? discover_connection() {

        var endpoint_discovery = new Sdk.Docker.UnixSocketEndpointDiscovery();

        return endpoint_discovery.discover();
    }


    protected Sdk.Docker.Repository? create_repository(string uri) {

        Sdk.Docker.Client? client = Sdk.Docker.ClientFactory.create_from_uri(uri);
        
        if (client != null) {
            return new Sdk.Docker.Repository(client);
        }
        
        message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) "Failed to connect to %s".printf(uri));
        
        return null;
        
    }

    protected void handle_container_rename(Sdk.Docker.Model.Container container, Gtk.Widget relative_to, Gdk.Rectangle pointing_to) {

        #if GTK_GTE_3_16
        var pop = new Gtk.Popover(relative_to);
        pop.position = Gtk.PositionType.BOTTOM;
        pop.pointing_to = pointing_to;

        var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        box.margin = 5;
        box.pack_start(new Gtk.Label("New name"), false, true, 5);

        var entry = new Gtk.Entry();
        entry.set_text(container.name);

        box.pack_end(entry, false, true, 5);

        pop.add(box);

        entry.activate.connect (() => {
            try {
                container.name = entry.text;

                repository.containers().rename(container);

                this.init_container_list();

            } catch (Sdk.Docker.Io.RequestError e) {
                message_dispatcher.dispatch(Gtk.MessageType.ERROR, (string) e.message);
            }
        });

        pop.show_all();
        #endif
    }

    protected void docker_daemon_post_connect(string docker_entrypoint) {
        this.on_docker_service_connect_success(docker_entrypoint);
        this.init_image_list();
        this.init_container_list();
        message_dispatcher.dispatch(Gtk.MessageType.INFO, "Connected to docker daemon");
    }
}
