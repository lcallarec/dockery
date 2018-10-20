using Dockery.DockerSdk;
using Dockery.View;

namespace Dockery.View {

    public interface ContainerSignalDispatcher : GLib.Object {
        public signal void container_status_change_request(Model.ContainerStatus status, Model.Container container);
        public signal void container_remove_request(Model.Container container);
        public signal void container_start_request(Model.Container container);
        public signal void container_stop_request(Model.Container container);
        public signal void container_rename_request(Model.Container container, Gtk.Widget? relative_to, Gdk.Rectangle? pointing_to);
        public signal void container_kill_request(Model.Container container);
        public signal void container_restart_request(Model.Container container);
        public signal void container_bash_in_request(Model.Container container);
        public signal void container_inspect_request(Model.Container container);
        public signal void container_stats_request(Model.Container container);
        public signal void container_auto_refresh_toggle_request(bool active);
    }

    public interface ImageSignalDispatcher : GLib.Object {
        public signal void images_remove_request(Model.ImageCollection images);
        public signal void image_create_container_request(Model.Image image);
        public signal void image_create_container_with_request(Model.Image image);
    }

    public interface DockerHubSignalDispatcher : GLib.Object {
        public signal void on_docker_public_registry_open_request();
        public signal void search_image_in_docker_hub(Hub.SearchDialog target, string term);
        public signal void pull_image_from_docker_hub(Hub.SearchDialog? target, Model.HubImage image);
        public signal void hub_display_image_menu_request(Gdk.EventButton event_button, Model.HubImage image);
    }


    public interface DockerServiceSignalDispatcher : GLib.Object {
        public signal void on_docker_daemon_connect_request(string docker_entrypoint);
        public signal void on_docker_daemon_disconnect_request();
        public signal void on_docker_daemon_discover_request();
        public signal void on_docker_daemon_disconnected();
        public signal void on_docker_daemon_connect_success(string docker_entrypoint);
        public signal void on_docker_daemon_connect_failure(string docker_entrypoint, Error e);
    }

    public class SignalDispatcher : GLib.Object, ImageSignalDispatcher, DockerServiceSignalDispatcher, DockerHubSignalDispatcher, ContainerSignalDispatcher {
        private static SignalDispatcher instance;

        public static SignalDispatcher dispatcher() {
            if (instance == null) {
                instance = new SignalDispatcher();
            }
            return instance;
        }
    }
}