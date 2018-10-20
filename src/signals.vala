namespace Signals {

    using Dockery.DockerSdk.Model;

    /** Signals emitted on container request actions */
    public interface ContainerRequestAction : GLib.Object {
        public signal void container_status_change_request(ContainerStatus status, Container container);
        public signal void container_remove_request(Container container);
        public signal void container_start_request(Container container);
        public signal void container_stop_request(Container container);
        public signal void container_rename_request(Container container, Gtk.Widget? relative_to, Gdk.Rectangle? pointing_to);
        public signal void container_kill_request(Container container);
        public signal void container_restart_request(Container container);
        public signal void container_bash_in_request(Container container);
        public signal void container_inspect_request(Container container);
        public signal void container_stats_request(Container container);
        public signal void container_auto_refresh_toggle_request(bool active);
    }

    /** Signals emitted on docker hub image request actions */
    public interface DockerHubImageRequestAction : GLib.Object {

        public signal void on_docker_public_registry_open_request();

        /** This signal should be emitted when an image is searched in docker hub */
        public signal void search_image_in_docker_hub(Dockery.View.Hub.SearchDialog target, string term);

        /** This signal should be emitted as a request to pull an image from docker hub */
        public signal void pull_image_from_docker_hub(Dockery.View.Hub.SearchDialog? target, HubImage image);

        public signal void hub_display_image_menu_request(Gdk.EventButton event_button, HubImage image);

        public virtual void set_images(Dockery.DockerSdk.Model.HubImage[] images) {}
    }

    public interface DockerServiceAware : GLib.Object {

        public signal void on_docker_daemon_connect_request(string docker_entrypoint);
        public signal void on_docker_daemon_disconnect_request();
        public signal void on_docker_daemon_discover_request();
        public signal void on_docker_daemon_disconnected();
        public signal void on_docker_daemon_connect_success(string docker_entrypoint);
        public signal void on_docker_daemon_connect_failure(string docker_entrypoint, Error e);
    }
}
