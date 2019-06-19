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
        public Gtk.Button btn_kill = new Gtk.Button.with_label("kill");
        public Gtk.Button btn_stop = new Gtk.Button.with_label("stop");        
        public Gtk.Button btn_stats = new Gtk.Button.with_label("stats");
        
        public Model.Container container;
        public Model.ContainerAllowedActions allowed_actions;

        public void select(Model.Container container) {
            this.container = container;
            this.allowed_actions = new ContainerAllowedActions(container);            
            this.update_btn_state_from(container);
        }

        public ContainerButtonsRow() {
            this.listen();
            off();

            Gtk.ButtonBox actions = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
            actions.set_layout(Gtk.ButtonBoxStyle.EXPAND);
            actions.add(btn_inspect);
            actions.add(btn_stats);

            Gtk.ButtonBox dangerous = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
            dangerous.set_layout(Gtk.ButtonBoxStyle.EXPAND);
            dangerous.add(btn_stop);
            dangerous.add(btn_kill);
            dangerous.add(btn_remove);

            Gtk.ButtonBox start = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
            start.set_layout(Gtk.ButtonBoxStyle.EXPAND);
            start.add(btn_start);
            start.add(btn_restart);

            this.pack_end(actions, false, false, 5);
            this.pack_end(dangerous, false, false, 5);
            this.pack_end(start, false, false, 5);
            this.pack_end(btn_rename, false, false, 5);
            this.pack_end(btn_pause, false, false, 5);
        }

        private void update_btn_state_from(Model.Container container) {
            if (container == null) {
                stdout.printf("NULL CONTAINER !!! WARNING !!! : %s\n", container.id);    
            }
            
            btn_remove.set_sensitive(this.allowed_actions.can_be_removed());
            btn_stop.set_sensitive(this.allowed_actions.can_be_stopped());            
            btn_rename.set_sensitive(this.allowed_actions.can_be_renamed());
            btn_restart.set_sensitive(this.allowed_actions.can_be_restarted());
            btn_start.set_sensitive(this.allowed_actions.can_be_started());
            btn_kill.set_sensitive(this.allowed_actions.can_be_killed());
            
            btn_inspect.set_sensitive(this.allowed_actions.can_be_inspected());
            btn_stats.set_sensitive(this.allowed_actions.can_be_stated());

            btn_pause.set_sensitive(false);
            if (this.allowed_actions.can_be_paused()) {
                btn_pause.label = "pause";
                btn_pause.set_sensitive(true);                 
            }

            if (this.allowed_actions.can_be_unpaused()) {
                btn_pause.label = "unpause";
                btn_pause.set_sensitive(true);
            }
        }

        private void off() {
            btn_inspect.set_sensitive(false);
            btn_remove.set_sensitive(false);
            btn_stop.set_sensitive(false);
            btn_rename.set_sensitive(false);
            btn_restart.set_sensitive(false);
            btn_start.set_sensitive(false);
            btn_pause.set_sensitive(false);
            btn_stats.set_sensitive(false);                        
        }

        private void listen() {
            btn_inspect.clicked.connect(() => {
               SignalDispatcher.dispatcher().container_inspect_request(container);
            });
            btn_stats.clicked.connect(() => {
               SignalDispatcher.dispatcher().container_stats_request(container);
            });
            btn_remove.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_remove_request(container);
            });
            btn_restart.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_restart_request(container);
            });
            btn_start.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_start_request(container);
            });
            btn_pause.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_status_change_request(this.allowed_actions.can_be_paused() ? Model.ContainerStatus.PAUSED : Model.ContainerStatus.RUNNING, container);
            });
            btn_rename.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_rename_request(container, this, null);
            });
        }
    }
}
