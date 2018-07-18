    
using Dockery.View;
using Dockery.View.Stat;
using View;
using Dockery;

namespace Dockery.Listener {
 
    class ContainerListListener : GLib.Object {

        public signal void container_states_changed();
        public signal void feedback(Gtk.MessageType type, string message);
        
        private Gtk.Window parent_window;
        private global::Dockery.View.Container.ListAll container_list;
        private global::Dockery.DockerSdk.Repository repository;

        public ContainerListListener(Gtk.Window parent_window, global::Dockery.DockerSdk.Repository repository, global::Dockery.View.Container.ListAll container_list) {
            this.parent_window = parent_window;
            this.repository = repository;
            this.container_list = container_list;
        }
        
        public void listen() {
            this.container_status_change_request();
            this.container_remove_request();
            this.container_start_request();
            this.container_bash_in_request();
            this.container_stop_request();
            this.container_kill_request();
            this.container_restart_request();
            this.container_rename_request();
            this.container_inspect_request();
            this.container_stats_request();
        }
        
        private void container_status_change_request() {

            this.container_list.container_status_change_request.connect((requested_status, container) => {

                try {
                    string message = "";
                    if (requested_status == DockerSdk.Model.ContainerStatus.PAUSED) {
                        repository.containers().pause(container);
                        message = "Container %s successfully unpaused".printf(container.id);
                    } else if (requested_status == DockerSdk.Model.ContainerStatus.RUNNING) {
                        repository.containers().unpause(container);
                        message = "Container %s successfully paused".printf(container.id);
                    }

                    container_states_changed();
                    feedback(Gtk.MessageType.INFO, message);

                } catch (DockerSdk.Io.RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }

        private void container_remove_request() {
            
            this.container_list.container_remove_request.connect((container) => {

                Gtk.MessageDialog msg = new Gtk.MessageDialog(
                    parent_window, Gtk.DialogFlags.MODAL,
                    Gtk.MessageType.WARNING,
                    Gtk.ButtonsType.OK_CANCEL,
                    "Really remove the container %s (%s)?".printf(container.name, container.id)
                );

                msg.response.connect((response_id) => {
                    switch (response_id) {
                        case Gtk.ResponseType.OK:

                            try {
                                repository.containers().remove(container);
                                container_states_changed();
                            } catch (DockerSdk.Io.RequestError e) {
                                feedback(Gtk.MessageType.ERROR, (string) e.message);
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
        }

        
        private void container_start_request() {
            this.container_list.container_start_request.connect((container) => {

                try {
                    repository.containers().start(container);
                    string message = "Container %s successfully started".printf(container.id);
                    feedback(Gtk.MessageType.INFO, message);

                } catch (DockerSdk.Io.RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                } finally {
                    container_states_changed();
                }
            });
        }

        private void container_bash_in_request() {
            
            this.container_list.container_bash_in_request.connect((container) => {
                var term_window = new Gtk.Window();

                var titlebar = new Gtk.HeaderBar();
                titlebar.title = "Bash-in %s".printf(container.name);
                titlebar.show_close_button = true;

                term_window.set_titlebar(titlebar);

                var term = new View.Terminal.BashIn(container);
                term.parent_container_widget = term_window;

                try {
                    term.start();
                } catch (Error e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }

                term_window.window_position = Gtk.WindowPosition.MOUSE;
                term_window.transient_for = parent_window;
                term_window.add(term);
                term_window.show_all();
            });
        }

        private void container_stop_request() {

            this.container_list.container_stop_request.connect((container) => {
                try {
                    repository.containers().stop(container);
                    string message = "Container %s successfully stopped".printf(container.id);
                    container_states_changed();
                    feedback(Gtk.MessageType.INFO, message);

                } catch (DockerSdk.Io.RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }
        
        private void container_kill_request() {

            this.container_list.container_kill_request.connect((container) => {
                try {
                    repository.containers().kill(container);
                    string message = "Container %s successfully killed".printf(container.id);
                    container_states_changed();
                    feedback(Gtk.MessageType.INFO, message);

                } catch (DockerSdk.Io.RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }
        
        private void container_restart_request() {
            this.container_list.container_restart_request.connect((container) => {
                try {
                    repository.containers().restart(container);
                    string message = "Container %s successfully restarted".printf(container.id);
                    container_states_changed();
                    feedback(Gtk.MessageType.INFO, message);

                } catch (DockerSdk.Io.RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }        
        
        private void container_inspect_request() {
            this.container_list.container_inspect_request.connect((container) => {
                try {

                    var inspection_data = repository.containers().inspect(container);
                    Json.Parser parser = new Json.Parser();
                    parser.load_from_data(inspection_data);

                    #if JSON_PRETTY_PRINT
                    Json.Node node = parser.get_root();
                    var pretty_inspection_data = Json.to_string(node, true);
                    #else
                    var pretty_inspection_data = inspection_data;
                    #endif

                    string message = "Low-level information successfully fetched for container %s".printf(container.id);
                    feedback(Gtk.MessageType.INFO, message);

                    var dialog = new View.Docker.Dialog.InspectContainer(parent_window, container, pretty_inspection_data);
                    dialog.show_all();

                } catch (Error e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }       
        
        private void container_stats_request() {
            this.container_list.container_stats_request.connect((container) => {
                try {
                    var dialog = new StatDialog(parent_window);
                    uint source_timeout = 0;
                    dialog.container_auto_refresh_toggle_request.connect((active) => {
                        if (active) {
                            source_timeout = GLib.Timeout.add(5000, () => {
                                var future_response = repository.containers().stats(container);
                                future_response.on_response_ready.connect((stats) => {
                                      
                                      GLib.Idle.add(() => {
                                        dialog.getset();    
                                        dialog.ready(stats);    
                                          return false;
                                      });
                                });
                                return true;
                            });
                        } else if (source_timeout != 0) {
                           GLib.Source.remove(source_timeout); 
                        }
                    });

                    dialog.show_all();
                    
                    var future_response = repository.containers().stats(container);
                    future_response.on_response_ready.connect((stats) => {
                        GLib.Idle.add(() => {
                            dialog.ready(stats);    
                            return false;
                        });
                    });

                } catch (Error e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }       

        private void container_rename_request() {
            this.container_list.container_rename_request.connect((container, relative_to, pointing_to) => {
                
                #if NOT_ON_TRAVIS
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
                        container_states_changed();

                    } catch (DockerSdk.Io.RequestError e) {
                        feedback(Gtk.MessageType.ERROR, (string) e.message);
                    }
                });

                pop.show_all();
                #endif
            });
        }
    }
}
