    
using Dockery.View;
using Dockery.View.Stat;
using View;
using Dockery;
using Dockery.Common;
using Dockery.View.Controls;

namespace Dockery.Listener {
 
    class ContainerListListener : GLib.Object {

        public signal void container_states_changed();
        public signal void feedback(Gtk.MessageType type, string message);
        
        private Gtk.Window parent_window;
        private global::Dockery.View.Container.ListAll container_list;
        private global::Dockery.DockerSdk.Repository repository;
        private ContainerButtonsRow container_actions;

        public ContainerListListener(Gtk.Window parent_window, global::Dockery.DockerSdk.Repository repository, global::Dockery.View.Container.ListAll container_list) {
            this.parent_window = parent_window;
            this.repository = repository;
            this.container_list = container_list;
            this.container_actions = container_list.header_controls;
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

            SignalDispatcher.dispatcher().container_status_change_request.connect((requested_status, container) => {

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

                } catch (RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }

        private void container_remove_request() {
            
            SignalDispatcher.dispatcher().container_remove_request.connect((container) => {

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
                            } catch (RequestError e) {
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
            SignalDispatcher.dispatcher().container_start_request.connect((container) => {

                try {
                    repository.containers().start(container);
                    string message = "Container %s successfully started".printf(container.id);
                    feedback(Gtk.MessageType.INFO, message);

                } catch (RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                } finally {
                    container_states_changed();
                }
            });
        }

        private void container_bash_in_request() {
            
            SignalDispatcher.dispatcher().container_bash_in_request.connect((container) => {
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

            SignalDispatcher.dispatcher().container_stop_request.connect((container) => {
                try {
                    repository.containers().stop(container);
                    string message = "Container %s successfully stopped".printf(container.id);
                    container_states_changed();
                    feedback(Gtk.MessageType.INFO, message);

                } catch (RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }
        
        private void container_kill_request() {

            SignalDispatcher.dispatcher().container_kill_request.connect((container) => {
                try {
                    repository.containers().kill(container);
                    string message = "Container %s successfully killed".printf(container.id);
                    container_states_changed();
                    feedback(Gtk.MessageType.INFO, message);

                } catch (RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }
        
        private void container_restart_request() {
            SignalDispatcher.dispatcher().container_restart_request.connect((container) => {
                try {
                    repository.containers().restart(container);
                    string message = "Container %s successfully restarted".printf(container.id);
                    container_states_changed();
                    feedback(Gtk.MessageType.INFO, message);

                } catch (RequestError e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }        
        
        private void container_inspect_request() {
            SignalDispatcher.dispatcher().container_inspect_request.connect((container) => {
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
            SignalDispatcher.dispatcher().container_stats_request.connect((container) => {
                try {
                    uint source_timeout = 0;
                    var window = new View.Dialog(850, 300, "Stats for container %s".printf(container.name), null, true);
                    
                    var table = new StatSimpleTable();
                    var serie_usage = new LiveChart.Serie("Memory usage", new LiveChart.SmoothLineArea());
                    serie_usage.set_main_color({1.0, 0.5, 0.0, 1.0});

                    var serie_limit = new LiveChart.Serie("Memory limit", new LiveChart.SmoothLine());                    
                    serie_limit.set_main_color({1.0, 0.0, 0.0, 1.0});

                    var config = new LiveChart.Config();
 
                    var chart = new LiveChart.Chart(config);
                    chart.add_serie(serie_usage);
                    chart.add_serie(serie_limit);                    
                    
                    var future_response = repository.containers().stats(container);
                    future_response.on_response_ready.connect((stats) => {
                        Unit.Bytes limit = stats.memory_stats.limit.to_human();

                        config.y_axis.fixed_max = limit.unit_value;
                        config.y_axis.tick_interval = (int) (limit.unit_value / 4);
                        config.y_axis.tick_length = (int) (300 / 4);
                        
                        config.y_axis.unit = limit.unit.to_string();

                        chart.add_value(serie_limit, limit.unit_value);
                        chart.add_value(serie_usage, stats.memory_stats.usage.to(limit.unit).unit_value);

                        GLib.Idle.add(() => {
                            table.update(stats);
                            return false;
                        });
                    });

                    var body = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

                    body.pack_start(table.get_treeview(), false, false, 0);
                    body.pack_start(chart, true, true, 0);
                    window.add_body(body);
                    window.show_all();

                    Mutex m = new Mutex();
                    source_timeout = GLib.Timeout.add(1000, () => {
                        if (m.trylock()) {
                            future_response = repository.containers().stats(container);
                            future_response.on_response_ready.connect((stats) => {
                                
                                Unit.Bytes limit = stats.memory_stats.limit.to_human();
                                
                                chart.add_value(serie_limit, limit.unit_value);
                                stdout.printf("stats.memory_stats.limit.to(limit.unit).unit_value %f", stats.memory_stats.limit.to(limit.unit).unit_value);
                                chart.add_value(serie_usage, stats.memory_stats.usage.to(limit.unit).unit_value);

                                GLib.Idle.add(() => {
                                    table.update(stats);
                                    return false;
                                });
                            });
                            m.unlock();
                        }
                      
                        return true;
                    });
                       
                    window.destroy.connect(() => {
                        if (source_timeout != 0) {
                           GLib.Source.remove(source_timeout); 
                        }
                    });

          
                    

                } catch (Error e) {
                    feedback(Gtk.MessageType.ERROR, (string) e.message);
                }
            });
        }       

        private void container_rename_request() {
            SignalDispatcher.dispatcher().container_rename_request.connect((container, relative_to, pointing_to) => {
                
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

                    } catch (RequestError e) {
                        feedback(Gtk.MessageType.ERROR, (string) e.message);
                    }
                });

                pop.show_all();
                #endif
            });
        }
    }
}
