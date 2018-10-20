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
}
