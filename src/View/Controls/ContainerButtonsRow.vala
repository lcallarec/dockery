using Dockery.View;
using Dockery.DockerSdk;

namespace Dockery.View.Controls {

    public class ContainerButtonsRow : Gtk.Box {

        private Gtk.Button inspect = new Gtk.Button.with_label("inspect");
        private Gtk.Button remove = new Gtk.Button.with_label("remove");
        private Gtk.Button rename = new Gtk.Button.with_label("rename");
        private Gtk.Button restart = new Gtk.Button.with_label("restart");
        private Gtk.Button play_pause = new Gtk.Button.with_label("play_pause");
        private Model.Container container;

        public void set_container(Model.Container container) {
            this.container = container;
            this.update_button_state_from(container);
        }

        public ContainerButtonsRow() {
            this.listen();
            off();

            this.pack_end(inspect, false, false, 0);
            this.pack_end(remove, false, false, 5);
            this.pack_end(rename, false, false, 5);
            this.pack_end(restart, false, false, 5);
            this.pack_end(play_pause, false, false, 5);
        }

        public void update_button_state_from(Model.Container container) {
            if (container == null) {
                stdout.printf("NULL CONTAINER !!! WARNING !!! : %s\n", container.id);    
            }
            stdout.printf("update button states : %s\n", container.id);
            if (Model.ContainerStatus.is_active(container.status)) {
                on();
            } else {
                off();
            }
        }

        private void on() {
            inspect.set_sensitive(true);
            remove.set_sensitive(true);
            rename.set_sensitive(true);
            restart.set_sensitive(true);
            play_pause.set_sensitive(true);
        }

        private void off() {
            inspect.set_sensitive(false);
            remove.set_sensitive(false);
            rename.set_sensitive(false);
            restart.set_sensitive(false);
            play_pause.set_sensitive(false);
        }

        private void listen() {
            inspect.clicked.connect(() => {
               SignalDispatcher.dispatcher().container_inspect_request(container);
            });
            remove.clicked.connect(() => {
                SignalDispatcher.dispatcher().container_remove_request(container);
            });
        }
    }
}
