using Dockery.View;
using Dockery.DockerSdk;
using Dockery.DockerSdk.Model;

namespace Dockery.View.Controls {

    public class ContainerButtonsRow : Gtk.Box {

        public Gtk.Button btn_inspect { 
            get; default = new Gtk.Button.with_label("inspect"); 
        }

        public Gtk.Button btn_remove = new Gtk.Button.with_label("remove");
        public Gtk.Button btn_rename = new Gtk.Button.with_label("rename");
        public Gtk.Button btn_restart = new Gtk.Button.with_label("restart");
        public Gtk.Button btn_start = new Gtk.Button.with_label("start");
        public Gtk.Button btn_pause = new Gtk.Button.with_label("pause");
        public Model.Container container;

        public void select(Model.Container container) {
            this.container = container;
            this.update_btn_state_from(container);
        }

        public ContainerButtonsRow() {
            this.listen();
            off();

            this.pack_end(btn_inspect, false, false, 0);
            this.pack_end(btn_remove, false, false, 5);
            this.pack_end(btn_rename, false, false, 5);
            this.pack_end(btn_restart, false, false, 5);
            this.pack_end(btn_start, false, false, 5);
            this.pack_end(btn_pause, false, false, 5);
            btn_inspect.active = false;
        }

        public void update_btn_state_from(Model.Container container) {
            if (container == null) {
                stdout.printf("NULL CONTAINER !!! WARNING !!! : %s\n", container.id);    
            }

            btn_remove.set_sensitive(ContainerStateTransition.can_be_removed(container));
            btn_inspect.set_sensitive(ContainerStateTransition.can_be_inspected(container));
            btn_rename.set_sensitive(ContainerStateTransition.can_be_renamed(container));
            btn_restart.set_sensitive(ContainerStateTransition.can_be_restarted(container));
            btn_start.set_sensitive(ContainerStateTransition.can_be_started(container));
            btn_pause.set_sensitive(ContainerStateTransition.can_be_paused(container));            
        }

        private void off() {
            btn_inspect.set_sensitive(false);
            btn_remove.set_sensitive(false);
            btn_rename.set_sensitive(false);
            btn_restart.set_sensitive(false);
            btn_start.set_sensitive(false);
            btn_pause.set_sensitive(false);
        }

        private void listen() {
            btn_inspect.clicked.connect(() => {
               SignalDispatcher.dispatcher().container_inspect_request(container);
            });
            btn_remove.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_remove_request(container);
            });
            btn_restart.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_restart_request(container);
            });
            btn_start.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_status_change_request(Model.ContainerStatus.RUNNING, container);
            });
            btn_pause.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_status_change_request(Model.ContainerStatus.PAUSED, container);
            });
            btn_rename.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_rename_request(container, this, null);
            });
        }
    }
}
